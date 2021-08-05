<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
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
			$("#pUserPwd").focus();
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
	//입력값을 확인한다.
	var errflag = false;
	var errstr = "";

	if($("#pUserId").val() == "") {
		errflag = true;
		errstr += " [아이디] ";
	} 

	if($("#pUserPwd").val() == "") {
		errflag = true;
		errstr += " [비밀번호] ";
	} 

	if(errflag) {
		alert("다음 정보를 확인하세요..\n" + errstr);
		return;
	}

	$("#loginForm").submit();
}
</script>

<body>

	<div id="wrap">

		<!-- login// -->
		<div id="login">
			<form id="loginForm" name="loginForm" action="<c:url value='/lgn/lgn.ums'/>" method="post">
				<fieldset>
					<legend>로그인</legend>
					<section class="login-inner">
						<h1><img src="../img/common/logo_white.png" class="logo" alt="AXon UMS"></h1>
						<div class="form-box">
							<input type="text" id="pUserId" name="pUserId" placeholder="아이디">
							<input type="password" id="pUserPwd" name="pUserPwd" placeholder="비밀번호">
							<div class="error">
								<c:if test="${'N' eq result}">
								<p>*  입력된 아이디, 비밀번호가 일치하지 않습니다. 다시 입력해주세요.</p>
								</c:if>
							</div>
							<a href="javascript:goLogin();" class="btn fullblue login">로그인</a>
							<p class="gray_txt">* 비밀번호 변경 등 문의사항은 서비스 관리자에게 문의바랍니다.</p>
						</div>
					</section>
				</fieldset>
			</form>
		</div>
		<!-- // login -->

	</div>

</body>
</html>
