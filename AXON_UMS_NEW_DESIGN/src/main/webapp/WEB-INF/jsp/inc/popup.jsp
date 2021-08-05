<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 신규발송 팝업(내부)
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<div id="popup_mailsend" class="poplayer popmailsend"><!-- id값 수정 가능 -->
	<div class="inner"><!-- width 조정 필요시 style="max-width:숫자px"로 넣어주세요. -->
		<header>
			<h2>EMS 신규 메일 발송</h2>
		</header>
		<div class="cont">
			<!-- 컨텐츠 마크업 -->
			<ul class="list-wrap">
				<li>
					<strong>단기메일</strong>
					<p>
						지정된 수신자(들)에게<br>
						1회만 메일 발송이 필요한 경우
					</p>
					<a href="javascript:;">바로가기</a>
				</li>
				<li>
					<strong>정기메일</strong>
					<p>
						지정된 수신자(들)에게<br>
						정기적으로 메일 발송이 필요한 경우
					</p>
					<a href="javascript:;">바로가기</a>
				</li>
			</ul>
		</div>
		<button type="button" class="btn_popclose" onclick="fn.popupClose('#popup_mailsend');"><span class="hidden">팝업닫기</span></button>
	</div>
	<span class="poplayer-background" onclick="fn.popupClose('#popup_mailsend');"></span>
</div>