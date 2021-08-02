<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 메일 수정에서 발송승인 처리 후 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>
<script type="text/javascript">
<c:choose>
	<c:when test="${result eq 'Success'}">
		alert("<spring:message code='CAMJSALT008'/>");		// 승인 성공
		window.parent.location.href = "<c:url value='/ems/cam/mailMainP.ums'/>";
	</c:when>
	<c:otherwise>
		<c:if test="${FILE_SIZE eq 'EXCESS' }">
			alert("<spring:message code='COMTBLLB001'/>");	// 파일 크기가 제한용량을 초과하였습니다.
		</c:if>
		<c:if test="${FILE_SIZE ne 'EXCESS' }">
			alert("<spring:message code='CAMJSALT009'/>");	// 승인 실패
		</c:if>
	</c:otherwise>
</c:choose>
</script>
