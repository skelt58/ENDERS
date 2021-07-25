<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.25
	*	설명 : 파일연동 수정 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
$(document).ready(function(){
	// 구분자 확인 실행
	fncSep();
});

// 다운로드 버튼 클릭
function goDownload() {
	$("#segInfoForm").attr("target","iFrmDown").attr("action","<c:url value='/com/down.ums'/>").submit();
	obj.action = "/com/down.jsp";
}

//찾기 버튼 클릭(파일 업로드)
function fileUpload(rFileName,vFileName) {
	$("#totCnt").val("0");
	$("#separatorChar").val("");
	$("#fileContentView").empty();

	window.open("<c:url value='/com/uploadP.ums'/>?folder=addressfile/<c:out value='${NEO_USER_ID}'/>&inputType=text&ext=txt,csv&formName=segInfoForm&title=Address&charset=UTF-8&rFileName="+rFileName+"&vFileName="+vFileName, "window", "width=640, height=120");
}

//구분자 확인
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

// 수정버튼 클릭시(삭제된 발송대상)
function isStatus() {
    alert("<spring:message code='SEGTBLLB020'/>.");		// 삭제된 발송대상그룹입니다!!\\n삭제된 발송대상그룹은 수정을 할 수 없습니다!!
}

// 수정버튼 클릭시(발송대상(세그먼트) 정보 수정)
function goFileUpdate() {
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

//목록으로 이동
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
			<input type="hidden" id="segNo" name="segNo" value="<c:out value='${segmentInfo.segNo}'/>">
			<input type="hidden" id="status" name="status">
			<input type="hidden" id="downType" name="downType" value="002">

			<p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
			
			<div class="cWrap">
			<div id="divMenu1">
				<table class="nTab">
					<tr>
						<td align="center" id="td_tab1"><spring:message code='SEGBTN001'/></td><!-- 추출도구이용 -->
						<td align="center" id="td_tab2"><spring:message code='SEGBTN003'/></td><!-- 직접 SQL 이용 -->
						<td align="center" id="td_tab3" class='on'><spring:message code='SEGBTN004'/></td><!-- 파일연동 -->
						<td align="center" id="td_tab4"><spring:message code='SEGBTN005'/></td><!-- 연계서비스지정 -->
					</tr>
				</table>
			</div>
			<div class="nTwrap">
				<table border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<tr height="20">
						<td align=right class="td_title"><spring:message code='SEGTBLTL031'/>&nbsp;</td><!-- 파일선택 -->
						<td height="23" class="td_body" <c:if test="${'Y' eq NEO_ADMIN_YN}">colspan="3"</c:if>>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width='30%'><input type="text" id="tempFlPath" name="tempFlPath" value="<c:out value='${fn:substring(segmentInfo.segFlPath, fn:indexOf(segmentInfo.segFlPath,"-")+1, fn:length(segmentInfo.segFlPath))}'/>" class='readonly_style' size=30 readonly></td>
									<td width='30%'>
										<input type="button" class="btn_style" value="<spring:message code='COMBTN013'/>" onClick="goDownload('<c:out value='${segmentInfo.segNo}'/>')"><!-- 다운로드 -->
										<input type="button" class="btn_style" value="<spring:message code='COMBTN012'/>" onClick="fileUpload('segFlPath', 'tempFlPath')"><!-- 찾기 -->
									</td>
									<td width='15%'><spring:message code='SEGTBLLB016'/></td><!-- 구분자 -->
									<td width='13%'><input type="text" id="separatorChar" name="separatorChar" value="<c:out value='${segmentInfo.separatorChar}'/>" style="width:25;"></td>
									<td width='12%'><input type="button" class="btn_style" value="<spring:message code='COMBTN011'/>" onClick="fncSep()"></td><!-- 확인 -->
									<td width='0%'>
										<input type="hidden" id="segFlPath" name="segFlPath" style="width:0;" value="<c:out value='${segmentInfo.segFlPath}'/>">
										<input type="hidden" id="mergeKey" name="mergeKey" style="width:0;" value="<c:out value='${segmentInfo.mergeKey}'/>">
										<input type="hidden" id="mergeCol" name="mergeCol" style="width:0;" value="<c:out value='${segmentInfo.mergeCol}'/>">
										<input type="hidden" id="createTy" name="createTy" value='003' style="width:0;" readonly>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr height="20">
						<td align=right class="td_title"><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
						<td class="td_body"<c:if test="${'Y' eq NEO_ADMIN_YN}"> colspan="3"</c:if>>
							<input type="text" id="segNm" name="segNm" value="<c:out value='${segmentInfo.segNm}'/>" size=40 maxlength='40'>
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
							                <option value="<c:out value='${user.cd}'/>"<c:if test="${user.cd == segmentInfo.userId}"> selected</c:if>><c:out value='${user.cdNm}'/></option>
										</c:forEach>
					            	</c:if>
					            </select>
					        </td>
					    </tr>
				    </c:if>
				</table>
				
				<!-- File Upload -->
				<table border="0" cellspacing="0" cellpadding="0">
					<tr><td height='10'></td></tr>
				</table>
				
				<!-- 커리문 -->
				<table border="0" cellspacing="0" cellpadding="0" style="width:100%;">
					<tr class='tr_head' >
						<td>
							<!-- 주소록 파일을 보여줌 -->
							<div id="fileContentView" style="width:100%;height:300px;"></div>
							<!-- 주소록 파일을 보여줌 -->
						</td>
					</tr>
				</table>
				<!-- 커리문 -->
			
				<div class="btn">
					<div class="left">
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>"><!-- 대상자수추출 -->
						<input type="text" id="totCnt" name="totCnt"  value="<c:out value='${segmentInfo.totCnt}'/>" class='readonly_style' size="9" readonly>
					</div>
					<div class="right">
						<c:if test="${'002' eq segmentInfo.status}">
						<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status}">
						<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goFileUpdate()"><!-- 수정 -->
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
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goSegList()"><!-- 리스트 -->
					</div>
				</div>
			
			</div>
			</div>
			
			</form>
			<iframe name="iFrmDown" frameborder="0" width='0' height='0'></iframe>


			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
