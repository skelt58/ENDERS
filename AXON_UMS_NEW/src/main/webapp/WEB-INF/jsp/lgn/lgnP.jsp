<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.06
	*	설명 : 로그인 아이디 비밀번호 입력 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">

$(document).ready(function() {
	$("#pUserId").focus();
	$("#pUserId").keypress(function(e) {
		if(e.which == 13) {
			e.preventDefault();
		}
	});
	
	$("#pUserPwd").keypress(function(e) {
		if(e.which == 13) {
			goLogin();
		}
	});
	
	$("#lgnBtn").click(function(e) {
		goLogin();
	});
	
});

function goLogin() {
	var frm = $("#lgn")[0];
	
	//입력값을 확인한다.
	var errflag = false;
	var errstr = "";

	if($(frm.pUserId).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='000LGNTBLLB001'/>] ";
	} 

	if($(frm.pUserPwd).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='000LGNTBLLB002'/>] ";
	} 

	if(errflag) {
		alert("<spring:message code='000COMJSALT016'/>.\n" + errstr);
		return;
	}

	frm.submit();
}
</script>

<form id="lgn" name="lgn" action="/lgn/lgn.ums" method="post">
<spring:message code='000LGNTBLLB001'/> : <input id="pUserId" name="pUserId" id="pUserId" type="text"/><br/>
<spring:message code='000LGNTBLLB002'/> : <input id="pUserPwd" name="pUserPwd" type="password"/><br/>
</form>
<button id="lgnBtn">로그인</button>


<c:if test="${'N' eq result}">
<script type="text/javascript">
alert("로그인에 실패하였습니다.");
</script>
</c:if>

</body>
</html>
