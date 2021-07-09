<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.06
	*	설명 : 로그인 후 처리
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>
<c:if test="${'Y' eq result}">
<script type="text/javascript">
window.location.href = "<c:url value='/index.ums'/>";
</script>
</c:if>
