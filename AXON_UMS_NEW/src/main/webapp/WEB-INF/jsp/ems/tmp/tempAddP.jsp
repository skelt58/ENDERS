<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.27
	*	설명 : 템플릿 등록 처리
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>
<script type="text/javascript">
var result = "<c:out value="${result}"/>";
if(result == "Success") {
	alert("<spring:message code='COMJSALT008'/>");		// 등록 성공
	parent.goSearch();
} else {
	alert("<spring:message code='COMJSALT009'/>");		// 등록 실패
}
</script>

