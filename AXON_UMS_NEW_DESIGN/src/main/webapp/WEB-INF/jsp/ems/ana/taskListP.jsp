<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 통계분석 정기메일분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<style type="text/css">
.tab {
	background-color:#cccccc;
}
</style>

<script type="text/javascript" src="<c:url value='/js/ems/ana/taskListP.js'/>"></script>

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
					<h2><c:out value='${NEO_MENU_NM}'/></h2>
				</div>
				
				<!-- 공통 표시부// -->
				<%@ include file="/WEB-INF/jsp/inc/top.jsp" %>
				<!-- //공통 표시부 -->
				
			</section>
			<!-- //cont-head -->

			<!-- cont-body// -->
			<section class="cont-body">



			<!------------------------------------------	TITLE	START	---------------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><p class="title_default"><spring:message code='ANATBLTL002'/></p></td><!-- 정기메일분석 -->
				</tr>
				<tr>
					<td height="3"></td>
				</tr>
				<tr>
					<td height="16"></td>
				</tr>
			</table>
			<!------------------------------------------	TITLE	END		---------------------------------------------->

			<!------------------------------------------	SEARCH	START	---------------------------------------------->
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" id="page" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" id="taskNo" name="taskNo" value="<c:out value='${searchVO.taskNo}'/>">
			<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
				<tr>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;" id="searchTaskNm" name="searchTaskNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchTaskNm}'/>">
					</td>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL006'/></td><!-- 캠페인 -->
					<td width="22%" colspan=3 class="td_body">
						<select id="searchCampNo" name="searchCampNo" style="width: 140px;" class="select">
							<option value="0">::: <spring:message code='ANATBLLB001'/> :::</option><!-- 캠페인 선택 -->
							<c:if test="${fn:length(campList) > 0}">
								<c:forEach items="${campList}" var="camp">
									<option value="<c:out value='${camp.campNo}'/>"<c:if test="${camp.campNo == searchVO.searchCampNo}"> selected</c:if>><c:out value='${camp.campNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
					<td width="22%" class="td_body">
						<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMdd"/>
						<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy.MM.dd"/> 
						<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMdd"/>
						<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy.MM.dd"/> 
						<div class="datepickerrange fromDate">
							<label>
								<input type="text" id="searchStartDt" name="searchStartDt" value="<c:out value='${searchStartDt}'/>" readonly>
							</label>
						</div>
						<span class="hyppen date"></span>
						<div class="datepickerrange toDate">
							<label>
								<input type="text" id="searchEndDt"  name="searchEndDt" value="<c:out value='${searchEndDt}'/>" readonly>
							</label>
						</div>
					</td>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
					<td width="22%" class="td_body">
						<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
						<c:if test="${'Y' eq NEO_ADMIN_YN}">
							<select id="searchDeptNo" name="searchDeptNo" style="width: 140px;" class="select" onchange="javascript:getUserList(this.value);">
								<option value="0">:: <spring:message code='COMTBLLB004'/> ::</option><!-- 그룹 선택 -->
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
						<c:if test="${'N' eq NEO_ADMIN_YN}">
							<select id="searchDeptNo" name="searchDeptNo" style="width: 140px;" class="select">
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>" selected><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
					</td>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
					<td width="22%" class="td_body">
						<select id="searchUserId" name="searchUserId"  style="width: 140px;" class="select">
							<option value=''>:: <spring:message code='COMTBLLB005'/> ::</option><!-- 사용자 선택 -->
							<c:if test="${fn:length(userList) > 0}">
								<c:forEach items="${userList}" var="user">
									<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
			</table>
			</form>
			
			<!--검색/초기화 버튼-->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="3"></td>
				</tr>
				<tr>
					<td align="right">
						<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_typeC" onClick="goSearch()"><!-- 검색 -->
						<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset()"><!-- 초기화 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			<!------------------------------------------	SEARCH	END		---------------------------------------------->
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" height=5></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	LIST	START	---------------------------------------------->
			<div id="divTaskList"></div>
			<!------------------------------------------	LIST	END		---------------------------------------------->
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td height=30>
						<input type="button" value="<spring:message code='ANABTN002'/>" class="btn_typeC" onClick="goJoin()"><!-- 병합분석 -->
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	OZREPORT	START		-------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="tab">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100">
										<div id="click_tab1" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr height="23">
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN003'/></td><!-- 결과요약 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab1" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr height="23">
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab1','/ems/ana/taskSummP.ums')"><spring:message code='ANABTN003'/></a><!-- 결과요약 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab2" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN004'/></td><!-- 세부에러 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab2" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab2','/ems/ana/taskErrorP.ums')"><spring:message code='ANABTN004'/></a><!-- 세부에러 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab3" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN005'/></td><!-- 도메인별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab3" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab3','/ems/ana/taskDomainP.ums')"><spring:message code='ANABTN005'/></a><!-- 도메인별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab4" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN006'/></td><!-- 발송시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab4" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab4','/ems/ana/taskSendP.ums')"><spring:message code='ANABTN006'/></a><!-- 발송시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab5" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN007'/></td><!-- 응답시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab5" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab5','/ems/ana/taskRespP.ums')"><spring:message code='ANABTN007'/></a><!-- 응답시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td align="right">&nbsp;</td>
								</tr>
							</table>
						</div>
						<div id="notab" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">&nbsp;
										</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td height=5></td>
				</tr>
				<tr>
					<td>
						<iframe name="iFrmReport" border='0' frameborder='1' scrolling='no' width='100%' height='1100'></iframe>
					</td>
				</tr>
			</table>
			<!------------------------------------------	OZREPORT	END		------------------------------------------>





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
