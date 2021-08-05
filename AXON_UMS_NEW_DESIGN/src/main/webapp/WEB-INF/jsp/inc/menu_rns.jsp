<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 좌측메뉴(RNS)
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
		<li class="active"><!-- 현재페이지 : li class="active" 추가 -->
			<a href="javascript:;" class="depth1"><span class="item01">메뉴1</span></a>
			<div class="inner-menu">
				<ul>
					<li class="active"><a href="javascript:;">메뉴1-1</a></li>
					<li><a href="javascript:;">메뉴1-2</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="javascript:;" class="depth1"><span class="item02">메뉴2</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">메뉴2-1</a></li>
					<li><a href="javascript:;">메뉴2-2</a></li>
					<li><a href="javascript:;">메뉴2-3</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="javascript:;" class="depth1"><span class="item03">메뉴3</span></a>
			<div class="inner-menu">
				<ul>
					<li><a href="javascript:;">메뉴3-1</a></li>
					<li><a href="javascript:;">메뉴3-2</a></li>
				</ul>
			</div>
		</li>
	</ul>
</nav>
<!-- //메뉴 -->