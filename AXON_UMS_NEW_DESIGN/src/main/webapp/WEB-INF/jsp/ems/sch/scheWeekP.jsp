<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 주간일정 조회 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<body>
	<div id="wrap">

		<!-- lnb// -->
		<div id="lnb">
			<!-- LEFT MENU -->
			<%@ include file="/WEB-INF/jsp/inc/menu_ems.jsp" %>
			<!-- LEFT MENU -->
		</div>
		<!-- //lnb -->

		<!-- content// -->
		<div id="content">

			<!-- cont-head// -->
			<section class="cont-head">
				<div class="title">
					<h2>주간일정</h2>
				</div>
				
				<!-- 공통 표시부// -->
				<%@ include file="/WEB-INF/jsp/inc/top.jsp" %>
				<!-- //공통 표시부 -->
				
			</section>
			<!-- //cont-head -->

			<!-- cont-body// -->
			<section class="cont-body">




				<!-- 주간일정// -->
				<div class="week-wrap">
					<h3 class="hide">주간일정 스케줄</h3>

					<!-- calendar-date// -->
					<div class="calendar-date">
						<button type="button" class="btn-prev">저번 주</button>
						<p>2021.07.18 - 2021.07.24</p>
						<button type="button" class="btn-next">다음 주</button>
						<button type="button" class="btn-calendar">달력</button>
					</div>
					<!-- //calendar-date -->

					<!-- calendar state// -->
					<ul class="calendar-state">
						<li class="wait">예약</li>
						<li class="ing">진행</li>
						<li class="end">완료</li>
					</ul>
					<!-- //calendar state -->

					<!-- calendar-week// -->
					<div class="calendar-week">
						<ul>
							<li>
								<div class="color-red">일 7/18</div>
								<div class="date-list"></div>
							</li>
							<li>
								<div>월 7/19</div>
								<div class="date-list"></div>
							</li>
							<li>
								<div>화 7/20</div>
								<div class="date-list"></div>
							</li>
							<li>
								<div>
									<span class="today">Today</span>
									수 7/21
								</div>
								<div class="date-list"></div>
							</li>
							<li>
								<div>목 7/22</div>
								<div class="date-list">
									<!--
										아래 3가지 케이스에 따라 클래스 부여해주세요.
										예약 : wait
										진행 : ing
										완료 : end
									-->
									<div class="wait">
										<span class="time">10:00 [단기]</span>
										<p>
											<a href="javascript:;">[광고]테스트 광고입니다.</a>
											<span>이벤트혜택  [A이벤트대상자] (관리자A) <em>발송완료</em></span>
										</p>
									</div>
									<div class="wait">
										<span class="time">10:30 [단기]</span>
										<p>
											<a href="javascript:;">[광고]테스트 광고입니다.</a>
											<span>이벤트혜택  [A이벤트대상자] (관리자A) <em class="color-red">발송실패</em></span>
										</p>
									</div>
									<div class="ing">
										<span class="time">12:00 [정기]</span>
										<p>
											<a href="javascript:;">[1차][광고]테스트 광고입니다.</a>
											<span>이벤트혜택  [수신자그룹] (발송자명) <em>발송승인</em></span>
										</p>
									</div>
									<div class="end">
										<span class="time">15:00 [정기]</span>
										<p>
											<a href="javascript:;">[1차][광고]테스트 광고입니다.</a>
											<span>이벤트혜택  [수신자그룹] (발송자명) <em>발송대기</em></span>
										</p>
									</div>
								</div>
							</li>
							<li>
								<div>금 7/23</div>
								<div class="date-list"></div>
							</li>
							<li>
								<div class="color-blue">토 7/24</div>
								<div class="date-list"></div>
							</li>
						</ul>
					</div>
					<!-- //calendar-week -->

				</div>
				<!-- //주간일정 -->




			</section>
			<!-- //cont-body -->
			
		</div>
		<!-- // content -->
	</div>

	<!-- 팝업// -->
	<%@ include file="/WEB-INF/jsp/inc/popup.jsp" %>
	<!-- //팝업 -->
</body>
</html>
