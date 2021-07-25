<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.19
	*	설명 : 파일연동 등록화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
function goCreateTy(no) {
    var actionUrl;
    
    if(no == '000') actionUrl = "<c:url value='/ems/seg/segToolAddP.ums'/>";      	// 추출도구이용
    if(no == '001') actionUrl = "<c:url value='/ems/seg/segOneClickAddP.ums'/>";  	// One Click
    if(no == '002') actionUrl = "<c:url value='/ems/seg/segDirectSQLAddP.ums'/>";	// SQL 직접 입력
    if(no == '003') actionUrl = "<c:url value='/ems/seg/segFileAddP.ums'/>";   		// 파일그룹
    if(no == '004') actionUrl = "<c:url value='/ems/seg/segRemarketAddP.ums'/>";    // 연계 캠페인 지정
    
    
    $("#searchForm").attr("action", actionUrl).submit();
}

// 찾기 버튼 클릭(파일 업로드)
function fileUpload(rFileName,vFileName) {
	$("#totCnt").val("0");
	$("#separatorChar").val("");
	$("#fileContentView").empty();

	window.open("<c:url value='/com/uploadP.ums'/>?folder=addressfile/<c:out value='${NEO_USER_ID}'/>&inputType=text&ext=txt,csv&formName=segInfoForm&title=Address&charset=UTF-8&rFileName="+rFileName+"&vFileName="+vFileName, "window", "width=640, height=120");
}

function goNoticeParamPop() {
	window.open("<c:url value='/ems/seg/fileSampleDownPop.ums'/>", "segParamInfo", 'width=450,height=168,status=yes,scrollbars=no,resizable=no');
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

// 구분자 확인
function fncSep() {
    if($("#segFlPath").val() == "") {
    	$("#separatorChar").val("");
        alert("<spring:message code='SEGJSALT002'/>");		// 파일이 입력되어 있지 않습니다.\\n파일을 입력하신 후 구분자를 입력해 주세요.
        fileUpload("segFlPath", "tempFlPath");
        return;
    }
    
    if($("#separatorChar").val() == "") {
    	alert("구분자를 입력하세요.");
    	return;
    }

    var tmp = $("#segFlPath").val().substring($("#segFlPath").val().lastIndexOf("/")+1);

    $("#segFlPath").val("addressfile/<c:out value='${NEO_USER_ID}'/>/" + tmp);
	
	var param = $("#segInfoForm").serialize();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/segFileMemberListP.ums'/>?" + param,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#fileContentView").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

function goPageNum(page) {
	$("#segInfoForm input[name='page']").val(page);
	var param = $("#segInfoForm").serialize();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/segFileMemberListP.ums'/>?" + param,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#fileContentView").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

// 발송대상(세그먼트) 정보 등록
function goSegFileAdd() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
        if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";		// 사용자
        }
    }
    if($("#segFlPath").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL032'/> ] ";			// 파일
    }
    if($("#segNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL002'/> ] ";			// 발송대상그룹명
    }
    if($("#separatorChar").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLLB016'/> ] ";			// 구분자
    }
    if(errflag) {
        alert("<spring:message code='COMJSALT001'/>\n" + errstr);		// 입력값 에러\\n다음 정보를 확인하세요.
        return;
    }

    if($("#totCnt").val() == 0) {
        var a = confirm("<spring:message code='SEGJSALT001'/>");		// 쿼리테스트를 하지 않았습니다.\\n계속 실행을 하겠습니까?
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
        } else {
        	return;
        }
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

// 목록으로 이동
function goSegList() {
	$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
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
		    <input type="hidden" name="page" value="1"/>
		    <!-- new title -->
		    <p class="title_default"><spring:message code="SEGTBLTL001"/></p><!-- 발송대상그룹 -->
		    <!-- //new title -->
		    
			<div class="cWrap">

			<div id="divMenu1">
				<table  border="0" cellspacing="5" cellpadding="0" class="nTab">
					<tr>
						<td align="center"><a href="JavaScript:goCreateTy('000')"><spring:message code="SEGBTN001"/></a></td><!-- 추출도구이용 -->
						<td align="center"><a href="JavaScript:goCreateTy('002')"><spring:message code="SEGBTN003"/></a></td><!-- 직접 SQL 이용 -->
						<td align="center" class="on"><a href="JavaScript:goCreateTy('003')"><spring:message code="SEGBTN004"/></a></td><!-- 파일연동 -->
						<td align="center"><a href="JavaScript:goCreateTy('004')"><spring:message code="SEGBTN005"/></a></td><!-- 연계서비스지정 -->
					</tr>
				</table>
		    </div>
		    
		    <div class="nTwrap">
		    	<table  class="table_line_outline">
			   		<colgroup>
			   			<col style="width:10%">
			   			<col style="width:40%">
			   			<col style="width:10%">
			   			<col style="width:35%">
			   		</colgroup>
				    <tr>
				        <td class="td_title"><spring:message code="SEGTBLTL031"/></td><!-- 파일선택 -->
		        		<td class="td_body">
			        		<input type="text" id="tempFlPath" name="tempFlPath" class="readonly_style" readonly>
			        		<input type="button" class="btn_style" value="<spring:message code="COMBTN012"/>" onClick="fileUpload('segFlPath', 'tempFlPath')"><!-- 찾기 -->
			        		<input type="button" class="btn_style" value="<spring:message code="COMBTN014"/>" onClick="goNoticeParamPop()"><!-- 샘플다운로드 -->
		        		</td>
				        <td class="td_title"><spring:message code="SEGTBLLB016"/></td><!-- 구분자 -->
				        <td class="td_body">
					        <input type="text" id="separatorChar" name="separatorChar" >
					        <input type="button" class="btn_style" value="<spring:message code="COMBTN011"/>" onClick="fncSep()"><!-- 확인 -->
					        <input type="hidden" id="segFlPath" name="segFlPath">
					        <input type="hidden" id="mergeKey" name="mergeKey">
					        <input type="hidden" id="mergeCol" name="mergeCol">
					        <input type="hidden" id="createTy" name="createTy" value='003'>
				        </td>
				    </tr> 
					<tr>
				        <td class="td_title"><spring:message code="SEGTBLTL002"/></td><!-- 발송대상그룹명 -->
				        <td class="td_body" colspan="3">
				        <input type="text" id="segNm" name="segNm">
				        </td>
				    </tr>
				    <c:if test="${'Y' eq NEO_ADMIN_YN}">
					    <tr>
					        <td  class="td_title"><spring:message code="COMTBLTL004"/></td><!-- 사용자그룹 -->
					        <td  class="td_body">
					            <select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
					                <option value='0'>::::<spring:message code="COMTBLLB004"/>::::</option><!-- 그룹 선택 -->
					                <c:if test="${fn:length(deptList) > 0}">
					                	<c:forEach items="${deptList}" var="dept">
					                		<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
					                	</c:forEach>
					                </c:if>
					            </select>
					        </td>
					        <td  class="td_title"><spring:message code="COMTBLTL005"/></td><!-- 사용자 -->
					        <td  class="td_body">
					            <select id="userId" name="userId">
					                <option value=''>::::<spring:message code="COMTBLLB005"/>::::</option><!-- 사용자 선택 -->
					            </select>
					        </td>
					    </tr>
				    </c:if>

				</table>
				
			    <!-- File Upload -->
				<table border="0" cellspacing="0" cellpadding="0" style="width:100%;height:200px">
				    <tr class='tr_head' >
				        <td>
				            <div id="fileContentView" style="width:100%;height:300px;"></div>
				        </td>
				    </tr>
			    </table>
			
			    <!-- 커리문 -->
			    <div class="btn">
			    	<div class="left">
				    	<input type="button" class="btn_style" value="<spring:message code="SEGBTN006"/>"><!-- 대상자수추출 -->
				    	<input type="text" id="totCnt" name="totCnt" size="9" value="0" class="readonly_style" readonly> <spring:message code="SEGTBLLB015"/><!-- 명 --> 
			    	</div>
			    	<div class="right">
			    		<input type="button" class="btn_typeC" value="<spring:message code="COMBTN005"/>" onClick="goSegFileAdd()">
			            <input type="button" class="btn_typeG" value="<spring:message code="COMBTN010"/>" onClick="goSegList()">
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
