<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 상단 메뉴 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<!-- 신규발송// -->
<span class="logo-ums"><img src="../img/common/logo_ums.png" alt="UMS"></span>
<h1>AXon EMS</h1>

<div class="btn-mail">
	<button type="button" class="btn fullblue" onclick="fn.popupOpen('#popup_mailsend');">신규발송</button>
</div>
<!-- //신규발송 -->

<!-- 메뉴// -->
<nav>
	<ul>
		<li><!-- 현재페이지 : li class="active" 추가 -->
			<a href="javascript:;" class="depth1"><span class="item01">발송현황</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">주간일정</a></li><!-- 현재페이지 : li class="active" 추가 -->
					<li><a href="javascript:;">월간일정</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="javascript:;" class="depth1"><span class="item02">메일발송</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">단기메일</a></li>
					<li><a href="javascript:;">정기메일</a></li>
					<li><a href="javascript:;">테스트메일</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="javascript:;" class="depth1"><span class="item03">메일관리</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">캠페인관리</a></li>
					<li><a href="javascript:;">수신자그룹관리</a></li>
					<li><a href="javascript:;">탬플릿관리</a></li>
					<li><a href="javascript:;">발송승인관리</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="javascript:;" class="depth1"><span class="item04">통계분석</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">단기메일분석</a></li>
					<li><a href="javascript:;">정기메일분석</a></li>
					<li><a href="javascript:;">캠페인별분석</a></li>
					<li><a href="javascript:;">기간별누적분석</a></li>
					<li><a href="javascript:;">로그 분석</a></li>
				</ul>
			</div>
		</li>
	</ul>
</nav>
<!-- //메뉴 -->