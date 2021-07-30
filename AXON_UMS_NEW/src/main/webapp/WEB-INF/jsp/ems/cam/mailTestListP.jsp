<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.30
	*	설명 : 테스트발송 팝업화면 출력
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
// 등록 버튼 클릭시
function goAdd() {
	var param = $("#testUserForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailTestAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			
			// 목록 재조회;
			$("#testUserForm").attr("target","").attr("action","<c:url value='/ems/cam/mailTestListP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}

//수정 버튼 클릭시
function goUpdate(no, pos) {
    $("#testUserNo").val(no);
    $("#testUserNm").val($("#listForm input[name='testUserNm']").eq(pos).val());
    $("#testUserEm").val($("#listForm input[name='testUserEm']").eq(pos).val());
    
	var param = $("#testUserForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailTestUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			
			// 목록 재조회;
			$("#testUserForm").attr("target","").attr("action","<c:url value='/ems/cam/mailTestListP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

// 삭제 버튼 클릭시
function goDelete(no) {
    $("#testUserNo").val(no);
	var param = $("#testUserForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailTestDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			
			// 목록 재조회;
			$("#testUserForm").attr("target","").attr("action","<c:url value='/ems/cam/mailTestListP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}
</script>

<form id="testUserForm" name="testUserForm" method="post">
<input type='hidden' name='subTaskNos' value='<c:out value='${testUserVO.subTaskNos}'/>'>
<input type='hidden' name='taskNos' value='<c:out value='${testUserVO.taskNos}'/>'>
<input type="hidden" id="testUserNo" name="testUserNo" value="0">
<table width="900" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan="3"></td>
	</tr>
	<tr class="tr_head" align="center">
		<td width='30%'><spring:message code='CAMTBLTL044'/></td><!-- 이름 -->
		<td width='40%'><spring:message code='CAMTBLTL045'/></td><!-- 이메일 -->
		<td width='30%'><spring:message code='COMBTN005'/></td><!-- 등록 -->
	</tr>
	<tr class="tr_body" height="20">
		<td align="left"><input type="text" id="testUserNm" name="testUserNm" size="10"></td>
		<td align="left"><input type="text" id="testUserEm" name="testUserEm" size="20"></td>
		<td align="center"><input type="button" class="btn_style" value="<spring:message code='COMBTN005'/>" onClick="goAdd()"></td><!-- 등록 -->
	</tr>
</table>
</form>
<!-- 등록 -->

<!-- 수정 -->
<form id="listForm" name="listForm" method="post">
<table width="900" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan="5"></td>
	</tr>
	<tr class="tr_head" align="center">
		<td width='7%'><input type="checkbox" name="isAll" onclick='goAll()'></td>
		<td width='23%'>이름</td>
		<td width='40%'>이메일</td>
		<td width='15%'>수정처리</td>
		<td width='15%'>삭제처리</td>
	</tr>
	<c:if test="${fn:length(testUserList) > 0}">
		<c:forEach items="${testUserList}" var="testUser" varStatus="userStatus">
			<tr class="tr_body" height="20">
				<td align="center">
					<input type="checkbox" name="testEmail" value="<c:out value='${testUser.testUserEm}'/>">
				</td>
				<td align="left">
					<input type="text" name="testUserNm" value="<c:out value='${testUser.testUserNm}'/>" size="10">
				</td>
				<td align="left">
					<input type="text" name="testUserEm" value="<c:out value='${testUser.testUserEm}'/>" size="20">
				</td>
				<td>
					<input type="button" class="btn_style" value="<spring:message code='COMBTN007'/>" onClick="goUpdate(<c:out value='${testUser.testUserNo}'/>,<c:out value='${userStatus.index}'/>)"><!-- 수정 -->
				</td>
				<td>
					<input type="button" class="btn_style" value="<spring:message code='COMBTN008'/>" onClick="goDelete(<c:out value='${testUser.testUserNo}'/>)"><!-- 삭제 -->
				</td>
			</tr>
		</c:forEach>
	</c:if>
</table>
<table width="900" border="1" cellspacing="0" cellpadding="0">
	<tr><td height=5></td></tr>
	<tr>
		<td align=right>
			<input type="button" class="btn_style" value="<spring:message code='COMBTN001'/>" onClick="window.close()"><!-- 닫기 -->
			<input type="button" class="btn_typeC"  value="<spring:message code='CAMBTN002'/>" onClick="goTestSend()"><!-- 테스트발송 -->
		</td>
	</tr>
</table>
</form>

</body>
</html>
