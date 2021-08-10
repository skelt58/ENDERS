<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 서비스 선택화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
function goEMS() {
	document.location.href = "<c:url value='/ems/index.ums'/>";
}

function goRNS() {
	document.location.href = "<c:url value='/rns/index.ums'/>";
}

function goSMS() {
	alert("서비스 준비중입니다.");
}

function goPUSH() {
	alert("서비스 준비중입니다.");
}

function goSYS() {	
	document.location.href = "<c:url value='/sys/index.ums'/>";
}
</script>

<body>
	<div id="wrap">

		<!-- service// -->
		<div id="service">
			<section class="service-inner">
				<h1 class="logo-box">
					<img src="../img/common/logo.png" alt="ums로고">
					<span>
						Unified Messaging System
						통합 메시징 시스템
					</span>
				</h1>
				<div class="list-area">
					<ul class="service-list">
						<li>
							<a href="javascript:goEMS();">
								<strong>AXon EMS</strong>
								<p>
									Email Marketing System<br>
									통합 이메일 발송 시스템
								</p>
							</a>
						</li>
	
						<li>
							<a href="javascript:goRNS();">
								<strong>AXon RNS</strong>
								<p>
									Real-time Notification Service<br>
									실시간 자동응답 서비스
								</p>
							</a>
						</li>
	
						<li>
							<a href="javascript:goSMS();">
								<strong>AXon SMS</strong>
								<p>SMS 문자메시지 발송 시스템</p>
							</a>
						</li>
	
						<li>
							<a href="javascript:goPUSH();">
								<strong>AXon PUSH</strong>
								<p>모바일 푸시 알림 발송 시스템</p>
							</a>
						</li>
					</ul>

					<a href="javascript:goSYS();" class="btn-setting">공통설정</a>
				</div>
			</section>

			 <footer class="ums-footer">
				<p>copyright © Enders All Rights Reserved.</p> 
			</footer>
		</div>
		<!-- //service -->

	</div>

</body>
</html>
