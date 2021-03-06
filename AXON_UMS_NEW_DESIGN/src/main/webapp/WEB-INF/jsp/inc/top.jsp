<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 상단 메뉴 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<script type="text/javascript">
function goService() {
	document.location.href = "<c:url value='/service.ums'/>";
}

function goLogout() {
	document.location.href = "<c:url value='/lgn/logout.ums'/>";
}
function goSys() {	
	document.location.href = "<c:url value='/sys/index.ums'/>";
}
</script>

<div class="util">
	<a href="javascript:goService();" class="btn-util item01">전체 서비스</a>
	<a href="javascript:goSys();" class="btn-util item02">공통 설정</a>
	<div class="user">
		<div class="info">
			<em><c:out value='${NEO_USER_NM}'/></em>
			<span><c:out value='${NEO_DEPT_NM}'/></span>
			<button type="button">열기</button>
		</div>
		<div class="link">
			<a href="javascript:;">사용자 정보수정</a>
			<a href="javascript:goLogout();">로그아웃</a>
		</div>
	</div>
</div>
