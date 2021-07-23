<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
//탭 클릭
function goCreateTy(no) {
    var actionUrl;
    if(no == '000') actionUrl = "<c:url value='/ems/seg/segToolAddP.ums'/>";    	// 추출도구이용
    if(no == '001') actionUrl = "<c:url value='/ems/seg/segOneClickAddP.ums'/>";    // One Click
    if(no == '002') actionUrl = "<c:url value='/ems/seg/segDirectSQLAddP.ums'/>";	// SQL 직접 입력
    if(no == '003') actionUrl = "<c:url value='/ems/seg/segFileAddP.ums'/>";   		// 파일그룹
    if(no == '004') actionUrl = "<c:url value='/ems/seg/segRemarketAddP.ums'/>";    // 연계 캠페인 지정
    
    $("#searchForm").attr("action", actionUrl).submit();
}

//사용자그룹 선택시 사용자 목록 설정
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#userId").append(option);
		});
	});
}

// 메일 리스트 팝업(메일 찾기)
function openInfo() {
    window.open("","mailInfo", "width=1090, height=588");
    $("#segInfoForm").attr("target","mailInfo").attr("action","<c:url value='/ems/seg/segRemarketMailMainP.ums'/>").submit();
}

// 모든 조건 선택 해제
function fAllClose() {
	$("#segInfoForm input[name='firstWhere']").each(function(idx,item){
		$(item).prop("checked", false);
	});
    fSecondClose();
}

// 2차 조건 모두 선택 해제
function fSecondClose() {
    var frm = window.document.segform;
	
    $("#segInfoForm input[name='secondWhere']").each(function(idx,item){
    	$(item).prop("checked", false);
    });
}

// Select 절 구하기(1차 조건 클릭)
function goSelect() {
    var frm = window.document.segform;
    var fromSql = "";
    var whereSql = "";
    var firstWhere = "";

    if($("#taskNm").val() == "") {
        fAllClose();
        alert("<spring:message code='SEGJSALT017'/>");		// 먼저 메일명을 선택해 주세요!!
        return;
    }

    firstWhere = $("#segInfoForm input[name='firstWhere']:checked").val();
    if(firstWhere == '001') {   // 성공
        fSecondClose();
        fromSql = "NEO_SENDLOG";
        whereSql  = "NEO_SENDLOG.SEND_RCODE = '000' AND NEO_SENDLOG.TASK_NO =  " + $("#taskNo").val();
        $("#segFlPath").val("1|0");
    } else if(firstWhere == '002') { // 오픈
        fSecondClose();
        fromSql = "NEO_SENDLOG, NEO_RESPLOG";
        whereSql  = "NEO_RESPLOG.TASK_NO =  " + $("#taskNo").val();
        whereSql += " AND NEO_SENDLOG.CUST_ID = NEO_RESPLOG.CUST_ID";
        $("#segFlPath").val("2|0");
    }

    $("#fromSql").val( fromSql );
    $("#whereSql").val( whereSql );
}

// 실패 구하기(2차 조건 클릭)
function fFail() {
    var fromSql = "NEO_SENDLOG";
    var whereSql = "";
    var firstWhere = "";
    var segFlPath = "";

    if($("#taskNm").val() == "") {
        fAllClose();
        alert("<spring:message code='SEGJSALT017'/>");		// 먼저 메일명을 선택해 주세요!!
        return;
    }
    
    firstWhere = $("#segInfoForm input[name='firstWhere']:checked").val();
    if(firstWhere != "003") {
        fSecondClose();
        alert("<spring:message code='SEGJSALT018'/>");		// 2차 조건은 1차 조건의 실패를 선택해야만 가능합니다.
        return;
    }

    segFlPath = "3|";

    var j = 0;
    $("#segInfoForm input[name='secondWhere']").each(function(idx,item){
    	if($(item).is(":checked") == true) {
    		if(j != 0) {
    			whereSql += ", ";
    		} else {
    			whereSql += "NEO_SENDLOG.SEND_RCODE IN (";
    		}
    		whereSql += "'"+ $(item).val() +"'";
    		segFlPath += $(item).val() + "|";
    		j++;
    	}
    });

    if(j > 0) whereSql += ") AND NEO_SENDLOG.TASK_NO =  " + $("#taskNo").val();

    $("#fromSql").val( fromSql );
    $("#whereSql").val( whereSql );
    $("#segFlPath").val( segFlPath );
}

// 대상수 구하기
function goSegCnt() {
    var obj = document.segform;

    if($("#dbConnNo").val() == "") {
        alert("<spring:message code='SEGJSALT008'/>");		// Connection 을 선택해 주세요.
        return;
    }

    if($("#selectSql").val() == "" || $("#fromSql").val() == "") {
        alert("<spring:message code='SEGJSALT009'/>");		// 쿼리문을 잘못 입력하셨습니다.
        return;
    }

    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segCount.json'/>?" + param, function(data) {
		$("#totCnt").val(data.totCnt);
	});
}

// 등록
function goRemarketAdd() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
        if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";		// 사용자
        }
    }
    if($("#segNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL002'/> ] ";			// 발송대상그룹명
    }

    if($("#taskNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL016'/> ] ";			// 메일명
    }

    if($("#selectSql").val() == "" || $("#fromSql").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL004'/> ] ";			// 질의문
    }

    if(errflag) {
        alert("<spring:message code='COMJSALT001'/>\n" + errstr);		// 입력값 에러\\n다음 정보를 확인하세요.
        return;
    }

    if($("#totCnt").val() == "0") {
        var a = confirm("<spring:message code='SEGJSALT010'/>");		// 대상자수 추출을 하지 않았습니다.\\n계속 실행을 하겠습니까?
        if ( a ) {
        	var param = $("#segInfoForm").serialize();
        	$.getJSON("<c:url value='/ems/seg/segAdd.json'/>?" + param, function(data) {
        		if(data.result == "Success") {
        			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
        			
        			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
        		} else if(data.result == "Fail") {
        			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
        		}
        	});
        } else return;
    } else {
    	var param = $("#segInfoForm").serialize();
    	$.getJSON("<c:url value='/ems/seg/segAdd.json'/>?" + param, function(data) {
    		if(data.result == "Success") {
    			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
    			
    			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
    		} else if(data.result == "Fail") {
    			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
    		}
    	});
    }
}

// 대상자보기
function goSegInfo() {
    var obj = document.segform;
     if($("#dbConnNo").val() == "") {
        alert("<spring:message code='SEGJSALT008'/>");		// Connection 을 선택해 주세요.
        return;
    }

    if($("#selectSql").val() == "" || $("#fromSql").val() == "") {
        alert("<spring:message code='SEGJSALT009'/>");		// 쿼리문을 잘못 입력하셨습니다.
        return;
    }

    window.open("","segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
    $("#segInfoForm").attr("target","segInfo").attr("action","<c:url value='/ems/seg/segInfoP.ums'/>").submit();
}

//리스트 이동 EVENT 구현
function goList() {
	$("#searchForm").attr("action", "<c:url value='/ems/seg/segMainP.ums'/>").submit();}
</script>

<c:set var="ID"/>
<c:set var="NAME"/>
<c:set var="EMAIL"/>
<c:if test="${fn:length(mergeKeyList) > 0}">
	<c:forEach items="${mergeKeyList}" var="mergeKey" varStatus="status">
		<c:choose>
			<c:when test="${status.index == 0}">
				<c:set var="EMAIL" value="${mergeKey.cdNm}"/>
			</c:when>
			<c:when test="${status.index == 1}">
				<c:set var="NAME" value="${mergeKey.cdNm}"/>
			</c:when>
			<c:when test="${status.index == 2}">
				<c:set var="ID" value="${mergeKey.cdNm}"/>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</c:if>


<div class="ex-layout">
	<div class="gnb">
		<!-- 상단메뉴화면 -->
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" name="searchSegNm" value="<c:out value='${searchVO.searchSegNm}'/>">
			<input type="hidden" name="searchDeptNo" value="<c:out value='${searchVO.searchDeptNo}'/>">
			<input type="hidden" name="searchUserId" value="<c:out value='${searchVO.searchUserId}'/>">
			<input type="hidden" name="searchCreateTy" value="<c:out value='${searchVO.searchCreateTy}'/>">
			<input type="hidden" name="searchStatus" value="<c:out value='${searchVO.searchStatus}'/>">
			<input type="hidden" name="searchStartDt" value="<c:out value='${searchVO.searchStartDt}'/>">
			<input type="hidden" name="searchEndDt" value="<c:out value='${searchVO.searchEndDt}'/>">
			</form>
			<form id="segInfoForm" name="segInfoForm" method="post">
	 		<!-- new title -->
    		<p class="title_default"><spring:message code="SEGTBLTL001"/></p><!-- 발송대상그룹 -->
    		<!-- //new title -->
		
			<div class="cWrap">
			
			<!-- tab 시작 -->
			<div id="divMenu1">
			<table  border="0" cellspacing="5" cellpadding="0" class="nTab">
				<tr>
					<td align="center"><a href="JavaScript:goCreateTy('000')"><spring:message code="SEGBTN001"/></a></td><!-- 추출도구이용 -->
					<td align="center"><a href="JavaScript:goCreateTy('002')"><spring:message code="SEGBTN003"/></a></td><!-- 직접 SQL 이용 -->
					<td align="center"><a href="JavaScript:goCreateTy('003')"><spring:message code="SEGBTN004"/></a></td><!-- 파일연동 -->
					<td align="center" class="on"><a href="JavaScript:goCreateTy('004')"><spring:message code="SEGBTN005"/></a></td><!-- 연계서비스지정 -->
				</tr>
			</table>
    		</div>
		    <!-- tab 시작 -->
		    
			<!-- 탭내용 시작 -->
			<div class="nTwrap">
				<table class="table_line_outline">
			        <tr>
			            <td class='td_title'>연계서비스 선택&nbsp;</td>
			            <td class='td_body' colspan="3">
				    		<select id="gubun" name="gubun"  onChange="goUrl(this.value)" style="width:130px;">
								<option value="1" selected>::::메일::::</option>
							</select>
			            </td>
			        </tr>
			        <tr>
			            <td class='td_title'><spring:message code="SEGTBLTL016"/>&nbsp;</td><!-- 메일명 -->
			            <td class='td_body'>
			                <input type=text id="taskNm" name="taskNm" class='readonly_style' value="" readonly  class="input" >
			                <input type="button" class="btn_style" value="<spring:message code='COMBTN012'/>" onClick="openInfo()"><!-- 찾기 -->
			            </td>
			            <td  class='td_title'><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
			            <td class='td_body'>
			                <input type="text" id="segNm" name="segNm" class="input" >
			            </td>
			        </tr>
			        
			        <!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
			        <c:if test="${'Y' eq NEO_ADMIN_YN}">
			        <tr>
			            <td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
			            <td class="td_body">
			                <select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
			                    <option value='0'>::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
			                    <c:if test="${fn:length(deptList) > 0}">
			                    	<c:forEach items="${deptList}" var="dept">
			                    		<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
			                    	</c:forEach>
			                    </c:if>
			                </select>
			            </td>
			            <td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
			            <td class="td_body">
			                <select id="userId" name="userId">
			                    <option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
			                </select>
			            </td>
			        </tr>
			        </c:if>
			        </table>
			
			        <!-- 조건 선택 -->
			        <table class="table_line_outline">
			        <colgroup>
			        	<col style="width:15%">
			        	<col style="width:85%">
			        </colgroup>
			        <tr  class="tr_head">
			            <td colspan="2"><spring:message code='SEGTBLTL017'/></td><!-- 조건선택 -->
			        </tr>
			        <tr>
			            <td class="td_title" ><spring:message code='SEGTBLTL018'/></td><!-- 1차조건 -->
			            <td  class="td_body" >
			                <span><input type="radio" name="firstWhere" value="001" onclick='goSelect()'> <spring:message code='SEGTBLLB005'/></span><!-- 성공 -->
			                <span><input type="radio" name="firstWhere" value="002" onclick='goSelect()'> <spring:message code='SEGTBLLB006'/></span><!-- 오픈 -->
			                <span><input type="radio" name="firstWhere" value="003" onclick='goSelect()'> <spring:message code='SEGTBLLB007'/></span><!-- 실패 -->
			            </td>
			        </tr>
			        <tr>
			            <td class="td_title"><spring:message code='SEGTBLTL019'/></td><!-- 2차조건 -->
			            <td class="td_body">
							<span><input type="checkbox" name="secondWhere" value="001" onclick='fFail()'> <spring:message code='SEGTBLLB008'/></span><!-- 생성에러 -->
							<span><input type="checkbox" name="secondWhere" value="002" onclick='fFail()'> <spring:message code='SEGTBLLB009'/></span><!-- 이메일문법오류 -->
							<span><input type="checkbox" name="secondWhere" value="003" onclick='fFail()'> <spring:message code='SEGTBLLB010'/></span><!-- 도메인없음 -->
							<span><input type="checkbox" name="secondWhere" value="004" onclick='fFail()'> <spring:message code='SEGTBLLB019'/></span><!-- 네트웍에러 -->
							<span><input type="checkbox" name="secondWhere" value="005" onclick='fFail()'> <spring:message code='SEGTBLLB011'/></span><!-- 트랜잭션에러 -->
							<span><input type="checkbox" name="secondWhere" value="006" onclick='fFail()'> <spring:message code='SEGTBLLB012'/></span><!-- 스팸차단 -->
							<span><input type="checkbox" name="secondWhere" value="007" onclick='fFail()'> <spring:message code='SEGTBLLB013'/></span><!-- 메일박스부족 -->
							<span><input type="checkbox" name="secondWhere" value="008" onclick='fFail()'> <spring:message code='SEGTBLLB014'/></span><!-- 계정없음 -->
			            </td>
			        </tr>
			    </table>
			    <!-- 조건 선택 -->
			
			    <!-- 조건절 -->
			    <table class="table_line_outline">
					<colgroup>
			        	<col style="width:15%">
			        	<col style="width:85%">
			        </colgroup>
			        <tr>
			            <td  class='td_title'>Select</td>
			            <td  class='td_body'>
			                <div id='divSelect'><textarea id="selectSql" name="selectSql" class='tArea'  readonly>NEO_SENDLOG.CUST_ID AS <c:out value="${ID}"/>, NEO_SENDLOG.CUST_EM AS <c:out value="${EMAIL}"/>, NEO_SENDLOG.CUST_NM AS <c:out value="${NAME}"/> </textarea></div>
			            </td>
			        </tr>
			        <tr>
			            <td class='td_title'>From</td>
			            <td class='td_body'>
			                <div id='divFrom'><textarea id="fromSql" name="fromSql" class='tArea'  readonly></textarea></div>
			            </td>
			        </tr>
			        <tr>
			            <td class='td_title'>Where</td>
			            <td class='td_body'>
			                <div id='divWhere'><textarea id="whereSql" name="whereSql" class='tArea'  readonly></textarea></div>
			            </td>
			        </tr>
			        </table>
			        <!-- 조건절 -->
					<div class="btn">
						<div class="left">
							<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
							<input type="text" id="totCnt" name="totCnt" value="0" class='readonly_style' size="9" readonly> <spring:message code='SEGTBLLB015'/><!-- 명 -->
						</div>
						<div class="right">
							<input type="hidden" id="dbConnNo" name="dbConnNo" value="0">
							<input type="hidden" id="segNo" name="segNo" value="0">
							<input type="hidden" id="mergeKey" name="mergeKey" value="<c:out value='${ID}'/>,<c:out value='${EMAIL}'/>,<c:out value='${NAME}'/>">
							<input type="hidden" id="createTy" name="createTy"  value='004'>
							<input type="hidden" id="taskNo" name="taskNo" value="0">
							<input type="hidden" id="subTaskNo" name="subTaskNo" value="0">
							<input type="hidden" id="orderbySql" name="orderbySql" value="">
							<input type="hidden" id="segFlPath" name="segFlPath" value="">
							<input type="hidden" id="mergeCol" name="mergeCol" value='NEO_SENDLOG.CUST_ID,NEO_SENDLOG.CUST_EM,NEO_SENDLOG.CUST_NM'>
							<input type="hidden" id="srcWhere" name="srcWhere"  readonly>
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN005'/>" onClick="goRemarketAdd()"><!-- 등록 -->
							<input type="button" class="btn_typeG" value="<spring:message code='SEGBTN007'/>" onClick="goSegInfo()"><!-- 대상자보기 -->
							<input type="button" class="btn_typeG" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
						</div>
					</div>
				</div>
			</div>
			</form>





			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
