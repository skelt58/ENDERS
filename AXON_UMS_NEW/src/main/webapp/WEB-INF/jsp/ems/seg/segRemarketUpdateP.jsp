<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.25
	*	설명 : 연계서비스지정 수정화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
//사용자그룹 선택시 사용자 목록 설정
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#userId").append(option);
		});
	});
}

//Select 절 구하기(1차 조건 클릭)
function goSelect() {
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

//실패 구하기(2차 조건 클릭)
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

//모든 조건 선택 해제
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

//대상수 구하기
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

//수정버튼 클릭시(삭제된 발송대상)
function isStatus() {
    alert("<spring:message code='SEGTBLLB020'/>.");		// 삭제된 발송대상그룹입니다!!\\n삭제된 발송대상그룹은 수정을 할 수 없습니다!!
}

//수정버튼 클릭 시
function goRemarketUpdate() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
    	if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";			// 사용자
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
        	$.getJSON("<c:url value='/ems/seg/segUpdate.json'/>?" + param, function(data) {
        		if(data.result == "Success") {
        			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
        			
        			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
        		} else if(data.result == "Fail") {
        			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
        		}
        	});
        } else return;
    } else {
    	var param = $("#segInfoForm").serialize();
    	$.getJSON("<c:url value='/ems/seg/segUpdate.json'/>?" + param, function(data) {
    		if(data.result == "Success") {
    			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
    			
    			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
    		} else if(data.result == "Fail") {
    			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
    		}
    	});
    }
}

//복구 버튼 클릭시
function goEnable() {
	$("#status").val("000");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='CAMJSALT027'/>");		// 복구성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='CAMJSALT029'/>");		// 복구실패
		}
	});
}

//사용중지 버튼 클릭 시
function goDisable() {
	$("#status").val("001");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='CAMJSALT028'/>");		// 사용중지성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='CAMJSALT030'/>");		// 사용중지실패
		}
	});
}

//삭제 버튼 클릭 시
function goDelete() {
	$("#status").val("002");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='COMJSALT012'/>");		// 삭제 성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='COMJSALT013'/>");		// 삭제 실패
		}
	});
}

//대상자보기(미리보기)
function goSegInfo() {
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

// 리스트 버튼 클릭시
function goList() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
}
</script>

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
			<input type="hidden" id="status"     name="status">
			<input type="hidden" id="dbConnNo"   name="dbConnNo" value="0">
			<input type="hidden" id="segNo"      name="segNo"  value="<c:out value='${segmentInfo.segNo}'/>">
			<input type="hidden" id="mergeKey"   name="mergeKey" value="<c:out value='${segmentInfo.mergeKey}'/>">
			<input type="hidden" id="mergeCol"   name="mergeCol" value="<c:out value='${segmentInfo.mergeCol}'/>">
			<input type="hidden" id="createTy"   name="createTy"  value='004'>
			<input type="hidden" id="taskNo"     name="taskNo" value="<c:out value='${taskNo}'/>">
			<input type="hidden" id="subTaskNo"  name="subTaskNo" value="<c:out value='${subTaskNo}'/>">
			<input type="hidden" id="orderbySql" name="orderbySql"  value="<c:out value='${segmentInfo.orderbySql}'/>">
			<input type="hidden" id="segFlPath"  name="segFlPath" value="<c:out value='${segmentInfo.segFlPath}'/>">
			<input type="hidden" id="srcWhere"   name="srcWhere" value="<c:out value='${segmentInfo.srcWhere}'/>">
			
			<p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
			
			<div class="cWrap">
			
			<div id="divMenu1" style="width: 1015px;">
				<table class="nTab">
					<tr>
						<td align="center" id="td_tab1"><spring:message code='SEGBTN001'/></td><!-- 추출도구이용 -->
						<td align="center" id="td_tab2"><spring:message code='SEGBTN003'/></td><!-- 직접 SQL 이용 -->
						<td align="center" id="td_tab3"><spring:message code='SEGBTN004'/></td><!-- 파일연동 -->
						<td align="center" id="td_tab4" class="on"><spring:message code='SEGBTN005'/></td><!-- 연계서비스지정 -->
					</tr>
				</table>
			</div>
			<div class="nTwrap">
				<table width="800" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<tr height="20">
						<td width="100" align=right class='td_title'><spring:message code='SEGTBLTL016'/>&nbsp;</td><!-- 메일명 -->
						<td width="300" class='td_body'>
							<input type="text" id="taskNm" name="taskNm" value="<c:out value='${taskNm}'/>" class='readonly_style' readonly style="width:230;">
						</td>
						<td width="100" align=right class='td_title'><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
						<td width="300" class='td_body'>
							<input type="text" id="segNm" name="segNm" value="<c:out value='${segmentInfo.segNm}'/>" style="width:280;">
						</td>
					</tr>
					<!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
					<c:if test="${'Y' eq NEO_ADMIN_YN}">
						<tr>
							<td  class="td_title"><spring:message code="COMTBLTL004"/></td><!-- 사용자그룹 -->
					        <td  class="td_body">
					            <select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
					                <option value='0'>::::<spring:message code="COMTBLLB004"/>::::</option><!-- 그룹 선택 -->
					                <c:if test="${fn:length(deptList) > 0}">
					                	<c:forEach items="${deptList}" var="dept">
					                		<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == segmentInfo.deptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
					                	</c:forEach>
					                </c:if>
					            </select>
					        </td>
					        <td  class="td_title"><spring:message code="COMTBLTL005"/></td><!-- 사용자 -->
					        <td  class="td_body">
					            <select id="userId" name="userId">
					                <option value="">::::<spring:message code="COMTBLLB005"/>::::</option><!-- 사용자 선택 -->
					            	<c:if test="${fn:length(userList) > 0}">
					            		<c:forEach items="${userList}" var="user">
							                <option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId == segmentInfo.userId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
										</c:forEach>
					            	</c:if>
					            </select>
					        </td>
					    </tr>
				    </c:if>
				</table>
			
				<!-- 조건 선택 -->
				<table width="800" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<tr height="20" class="tr_head">
						<td  colspan="2" class="td_10" align="left"><spring:message code="SEGTBLTL017"/></td><!-- 조건선택 -->
					</tr>
					<tr>
						<td class="td_title" width="120"><spring:message code="SEGTBLTL018"/></td><!-- 1차조건 -->
						<td  class="td_body" width='680'>
							<span><input type="radio" name="firstWhere" value="001" onclick='goSelect()'<c:if test="${'1|0' eq segmentInfo.segFlPath}"> checked</c:if>> <spring:message code="SEGTBLLB005"/></span><!-- 성공 -->
							<span><input type="radio" name="firstWhere" value="002" onclick='goSelect()'<c:if test="${'2|0' eq segmentInfo.segFlPath}"> checked</c:if>> <spring:message code="SEGTBLLB006"/></span><!-- 오픈 -->
							<span><input type="radio" name="firstWhere" value="003" onclick='goSelect()'<c:if test="${'3|'  eq fn:substring(segmentInfo.segFlPath,0,2)}"> checked</c:if>> <spring:message code="SEGTBLLB007"/></span><!-- 실패 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code="SEGTBLTL019"/></td><!-- 2차조건 -->
						<td class="td_body">
							<c:set var="sw1" value=""/>
							<c:set var="sw2" value=""/>
							<c:set var="sw3" value=""/>
							<c:set var="sw4" value=""/>
							<c:set var="sw5" value=""/>
							<c:set var="sw6" value=""/>
							<c:set var="sw7" value=""/>
							<c:set var="sw8" value=""/>
							<c:set var="checkedArray" value="${fn:split(segmentInfo.segFlPath,'|')}"/>
							<c:forEach items="${checkedArray}" var="sw" varStatus="idx">
								<c:choose>
									<c:when test="${'001' eq sw}"><c:set var="sw1" value=" checked"/></c:when>
									<c:when test="${'002' eq sw}"><c:set var="sw2" value=" checked"/></c:when>
									<c:when test="${'003' eq sw}"><c:set var="sw3" value=" checked"/></c:when>
									<c:when test="${'004' eq sw}"><c:set var="sw4" value=" checked"/></c:when>
									<c:when test="${'005' eq sw}"><c:set var="sw5" value=" checked"/></c:when>
									<c:when test="${'006' eq sw}"><c:set var="sw6" value=" checked"/></c:when>
									<c:when test="${'007' eq sw}"><c:set var="sw7" value=" checked"/></c:when>
									<c:when test="${'008' eq sw}"><c:set var="sw8" value=" checked"/></c:when>
								</c:choose>
							</c:forEach>
							<span><input type="checkbox" name="secondWhere" value="001" onclick='fFail()'<c:out value="${sw1}"/>> <spring:message code="SEGTBLLB008"/></span><!-- 생성에러 -->
							<span><input type="checkbox" name="secondWhere" value="002" onclick='fFail()'<c:out value="${sw2}"/>> <spring:message code="SEGTBLLB009"/></span><!-- 이메일문법오류 -->
							<span><input type="checkbox" name="secondWhere" value="003" onclick='fFail()'<c:out value="${sw3}"/>> <spring:message code="SEGTBLLB010"/></span><!-- 도메인없음 -->
							<span><input type="checkbox" name="secondWhere" value="004" onclick='fFail()'<c:out value="${sw4}"/>> <spring:message code="SEGTBLLB019"/></span><!-- 네트웍에러 -->
							<span><input type="checkbox" name="secondWhere" value="005" onclick='fFail()'<c:out value="${sw5}"/>> <spring:message code="SEGTBLLB011"/></span><!-- 트랜잭션에러 -->
							<span><input type="checkbox" name="secondWhere" value="006" onclick='fFail()'<c:out value="${sw6}"/>> <spring:message code="SEGTBLLB012"/></span><!-- 스팸차단 -->
							<span><input type="checkbox" name="secondWhere" value="007" onclick='fFail()'<c:out value="${sw7}"/>> <spring:message code="SEGTBLLB013"/></span><!-- 메일박스부족 -->
							<span><input type="checkbox" name="secondWhere" value="008" onclick='fFail()'<c:out value="${sw8}"/>> <spring:message code="SEGTBLLB014"/></span><!-- 계정없음 -->
						</td>
					</tr>
				</table>
				<!-- 조건 선택 -->
			
				<!-- 조건절 -->
				<table width="800" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<tr height="20">
						<td width='120' class='td_title'>Select</td>
						<td width='680' class='td_body'>
							<div id='divSelect'><textarea id="selectSql" name="selectSql" style="width:870px;height:50px;" class='readonly_style' readonly><c:out value="${segmentInfo.selectSql}"/></textarea></div>
						</td>
					</tr>
					<tr>
						<td class='td_title'>From</td>
						<td class='td_body'>
							<div id='divFrom'><textarea id="fromSql" name="fromSql" style="width:870px;height:50px;" class='readonly_style' readonly><c:out value="${segmentInfo.fromSql}"/></textarea></div>
						</td>
					</tr>
					<tr>
						<td class='td_title'>Where</td>
						<td class='td_body'>
							<div id='divWhere'><textarea id="whereSql" name="whereSql" style="width:870px;height:80px;" class='readonly_style' readonly><c:out value="${segmentInfo.whereSql}"/></textarea></div>
						</td>
					</tr>
				</table>
				<!-- 조건절 -->
			
				<div class="btn">
					<div class="left">
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
						<input type="text" id="totCnt" name="totCnt" value="<c:out value='${segmentInfo.totCnt}'/>" class='readonly_style' size="9" readonly>
					</div>
					<div class="right">
						<c:if test="${'002' eq segmentInfo.status}">
							<input type="button" class=btn_typeC value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status }">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goRemarketUpdate()"><!-- 수정 -->
						</c:if>
						<c:if test="${'001' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN013'/>" onClick="goEnable()"><!-- 복구 -->
						</c:if>
						<c:if test="${'000' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN006'/>" onClick="goDisable()"><!-- 사용중지 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN008'/>" onClick="goDelete()"><!-- 삭제 -->
						</c:if>
						
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN007'/>" onClick="goSegInfo()"><!-- 대상자보기 -->
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
	
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
