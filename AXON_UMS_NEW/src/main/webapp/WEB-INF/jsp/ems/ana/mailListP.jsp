<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 메일별분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<div class="ex-layout">
	<div class="gnb">
		<!-- 상단메뉴화면 -->
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			
			<!------------------------------------------	TITLE	START	---------------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><p class="title_default"><spring:message code='ANATBLTL001'/></p></td><!-- 메일별분석 -->
				</tr>
				<tr>
				<td height="16"></td>
				</tr>
			</table>
			<!------------------------------------------	TITLE	END		---------------------------------------------->

			<!------------------------------------------	SEARCH	START	---------------------------------------------->
			<form id="searchForm" name="search_form" method="post">
			<input type="hidden" id="page" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" id="taskNo" name="taskNo" value="<c:out value='${searchVO.taskNo}'/>">
			<table width="1000" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
				<tr>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;"  name="searchTaskNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchTaskNm}'/>">
					</td>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL006'/></td><!-- 캠페인 -->
					<td width="22%" colspan=3 class="td_body">
						<select name="searchCampNo" style="width: 140px;" class="select">
							<option value=''>::: <spring:message code='ANATBLLB001'/> :::</option><!-- 캠페인 선택 -->
							<c:if test="${fn:length(campList) > 0}">
								<c:forEach items="${campList}" var="camp">
									<option value="<c:out value='${camp.campNo}'/>"<c:if test="${camp.campNo == searchVO.searchCampNo}"> selected</c:if>><c:out value='${camp.campNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<td width="10%" class="td_title"><spring:message code='ANATBLLB001'/></td><!-- 예약일 -->
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;" id="searchStartDt"  name="searchStartDt" class="readonly_style" style="width:70;cursor:hand" value="<c:out value='${searchVO.searchStartDt}'/>" readonly> ~
						<input type="text" style="border:1px solid #c0c0c0;" id="searchEndDt"  name="searchEndDt" class="readonly_style" style="width:70;cursor:hand" value="<c:out value='${searchVO.searchStartDt}'/>" readonly>
					</td>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
					<td width="22%" class="td_body">
						<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
						<c:if test="${'Y' eq NEO_ADMIN_YN}">
							<select name="searchDeptNo" style="width: 140px;" class="select" onchange="javascript:getUserList(this.value);">
								<option value=''>:: <spring:message code='COMTBLLB004'/> ::</option><!-- 그룹 선택 -->
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
						<c:if test="${'N' eq NEO_ADMIN_YN}">
							<select name="searchDeptNo" style="width: 140px;" class="select">
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
						<select name="searchUserId"  style="width: 140px;" class="select">
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
						<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset(this.form)"><!-- 초기화 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			<!------------------------------------------	SEARCH	END		---------------------------------------------->
			
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" height=3></td>
				</tr>
				<c:if test="${not empty searchVO.taskNo}">
					<tr>
						<td align="right" height=20>
							<input type="button" value="<spring:message code='ANATBLTL002'/>" class="btn_style" style="width:80px" onClick="goTask()"><!-- 정기메일분석 -->
						</td>
					</tr>
				</c:if>
				<tr>
					<td align="right" height=3>
				</td>
				</tr>
			</table>
			
			
			<!------------------------------------------	LIST	START	---------------------------------------------->
			<form id="listForm" name="listForm" method="post">
			<table width="1000" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
				<tr class="tr_head">
					<td width="3%"><input type="checkbox" name="isAll" onclick='goAll()' style="border:0"></td>
					<td width="10%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
					<td width="19%"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="10%"><spring:message code='ANATBLTL009'/></td><!-- 단발/정기 -->
					<td width="19%"><spring:message code='ANATBLTL010'/></td><!-- 발송그룹명 -->
					<td width="11%"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
					<td width="14%"><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
					<td width="11%"><spring:message code='ANATBLTL011'/></td><!-- 발송상태 -->
				</tr>
				<c:if test="${fn:length(mailList) > 0}">
					<c:forEach items="${mailList}" var="mail">
						<tr class="tr_body">
							<td>
								<input type="checkbox" name="taskNo" value="<c:out value='${mail.taskNo}'/>" style="border:0">
								<input type="checkbox" name="subTaskNo" value="<c:out value='${mail.subTaskNo}'/>" style="display:none">
							</td>
							<td><c:out value='${mail.campNm}'/></td>
							<td>
								<c:set var="strTh" value=""/>
								<c:if test="${'001' eq mail.sendRepeat}"><c:set var="strTh" value="${mail.subTaskNo}차"/></c:if>
								<a href="javascript:goOz('tab1','/ana/mailSummP.jsp','<c:out value='${mail.taskNo}'/>','<c:out value='${mail.subTaskNo}'/>')"><c:out value='${strTh}${mail.taskNm}'/></a>
							</td>
							<td><c:out value='${mail.sendRepeatNm}'/></td>
							<td><c:out value='${mail.segNm}'/></td>
							<td><c:out value='${mail.userNm}'/></td>
							<td><c:out value='${mail.sendDt}'/></td>
							<td><c:out value='${mail.statusNm}'/></td>
						</tr>
					</c:forEach>
				</c:if>
				<c:set var="emptyCnt" value="${searchVO.rows - fn:length(mailList)}"/>
				<c:if test="${emptyCnt > 0}">
					<c:forEach var="i" begin="1" end="${emptyCnt}">
						<tr class="tr_body">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</c:forEach>
				</c:if>
			</table>
			</form>
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" height=25>${pageUtil.pageHtml}</td>
			</tr>
			</table>
			<!------------------------------------------	LIST	END		---------------------------------------------->
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=30>
						<input type="button" value="<spring:message code='ANABTN002'/>" class="btn_typeC" onClick="goJoin()"><!-- 병합분석 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	OZREPORT	START		-------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="tab">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="90">
										<div id="click_tab1" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN003'/></td><!-- 결과요약 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab1" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab1','/ana/mailSummP.jsp')" class="tab"><spring:message code='ANABTN003'/><!--결과요약--></a><!-- 결과요약 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab2" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN004'/></td><!-- 세부에러 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab2" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab2','/ana/mailErrorP.jsp')" class="tab"><spring:message code='ANABTN004'/></a><!-- 세부에러 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab3" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN005'/></td><!-- 도메인별 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab3" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab3','/ana/mailDomainP.jsp')" class="tab"><spring:message code='ANABTN005'/></a><!-- 도메인별 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab4" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN006'/></td><!-- 발송시간별 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab4" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab4','/ana/mailSendP.jsp')" class="tab"><spring:message code='ANABTN006'/></a><!-- 발송시간별 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab5" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN007'/></td><!-- 응답시간별 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab5" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab5','/ana/mailRespP.jsp')" class="tab"><spring:message code='ANABTN007'/></a><!-- 응답시간별 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab6" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><spring:message code='ANABTN015'/></td><!-- 고객별 -->
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="tab6" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif">
														<a href="javascript:goOzTab('tab6','/ana/logListP.jsp')" class="tab"><spring:message code='ANABTN015'/></a><!-- 고객별 -->
													</td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td align="right">&nbsp;
										<c:if test="${'Y' eq WIZ_USE_YN && 'Y' eq WIZ_DISPLAY_YN}">
											<a href="javascript:reportScript(ifrm_report.report_form,'print')"><img src="/images/ana/oz_print.jpg" border='0' alt="<spring:message code='ANAJSALT003'/>" align="absbottom"></a><!-- 출력 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><img src="/images/ana/oz_save.jpg" border='0' alt="<spring:message code='ANAJSALT004'/>" align="absbottom"></a><!-- 저장 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><img src="/images/ana/oz_prev.jpg" border='0' alt="<spring:message code='ANAJSALT005'/>" align="absbottom"></a><!-- 이전페이지 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><img src="/images/ana/oz_next.jpg" border='0' alt="<spring:message code='ANAJSALT006'/>" align="absbottom"></a><!-- 다음페이지 -->
										</c:if>
									</td>
								</tr>
							</table>
						</div>
						<div id="notab" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">&nbsp;
										<c:if test="${'Y' eq WIZ_USE_YN && 'Y' eq WIZ_DISPLAY_YN}">
											<a href="javascript:reportScript(ifrm_report.report_form,'print')"><img src="/images/ana/oz_print.jpg" border='0' alt="<spring:message code='ANAJSALT003'/>" align="absbottom"></a><!-- 출력 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><img src="/images/ana/oz_save.jpg" border='0' alt="<spring:message code='ANAJSALT004'/>" align="absbottom"></a><!-- 저장 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><img src="/images/ana/oz_prev.jpg" border='0' alt="<spring:message code='ANAJSALT005'/>" align="absbottom"></a><!-- 이전페이지 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><img src="/images/ana/oz_next.jpg" border='0' alt="<spring:message code='ANAJSALT006'/>" align="absbottom"></a><!-- 다음페이지 -->
										</c:if>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td height=5 background="/img/com/Content_tab_bar.gif"><img src="/images/com/Content_tab_bar.gif" width="3" height="5"></td>
				</tr>
				<tr>
					<td>
						<div id="cust_menu" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="click_age" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">AGE</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="age" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('01')" class="tab" title='age'>AGE</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_wedding" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">WEDDING</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="wedding" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('02')" class="tab" title='wedding'>WEDDING</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_gender" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">GENDER</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="gender" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('03')" class="tab" title='gender'>GENDER</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_zip" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">ZIP</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="zip" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('04')" class="tab" title='zip'>ZIP</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_job" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">JOB</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="job" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('05')" class="tab" title='job'>JOB</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_regyr" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">REGYR</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="regyr" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('06')" class="tab" title='registration year'>REGYR</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_regst" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">REGST</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="regst" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('07')" class="tab" title='first registration site'>REGST</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_phmk" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">PHMK</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="phmk" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('08')" class="tab" title='phone maker'>PHMK</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_cyonphmd" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">CYONPHMD</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="cyonphmd" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('09')" class="tab" title='cyon phone model'>CYONPHMD</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_wowphmd" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">WOWPHMD</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="wowphmd" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('10')" class="tab" title='wowlg phone model'>WOWPHMD</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_telcom" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">TELCOM</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="telcom" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('11')" class="tab" title='telecom'>TELCOM</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_bizty" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">BIZTY</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="bizty" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('12')" class="tab" title='business type'>BIZTY</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_mlvl" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after_r.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab">MLVL</td>
													<td width="6"><img src="/images/com/Content_tab_back_r.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
										<div id="mlvl" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"><img src="/images/com/Content_tab_after.gif" width="6" height="23"></td>
													<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzCustTab('13')" class="tab" title='member level'>MLVL</a></td>
													<td width="6"><img src="/images/com/Content_tab_back.gif" width="6" height="23"></td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<iframe name="ifrm_report" border='0' frameborder='1' scrolling='no' width='100%' height='1070'></iframe>
					</td>
				</tr>
			</table>
			<!------------------------------------------	OZREPORT	END		------------------------------------------>
			<!------------------------------------------------------------------------------------------------------------>

			<form name="form_report">
			<input type="hidden" name="save_nm" value="">
			</form>
			
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
