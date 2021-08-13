<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.11
	*	설명 : 누적분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<style type="text/css">
.tab {
	background-color:#cccccc;
}
</style>

<script type="text/javascript" src="<c:url value='/js/ems/ana/summMainP.js'/>"></script>

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
					<h2>기간별누적분석</h2>
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
			<p class="title_default">누적분석</p>
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
	<input type="hidden" id="searchCampNm" name="searchCampNm" value=""/>
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value=""/>
	<input type="hidden" id="searchUserNm" name="searchUserNm" value=""/>
	<table width="1000" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
		<tr>
			<td width="10%" class="td_title">캠페인</td>
			<td width="22%" class="td_body" colspan=5>
				<select id="searchCampNo" name="searchCampNo" style="width: 140px;" class="select">
					<option value="0">::: 캠페인 선택 :::</option>
					<c:if test="${fn:length(campList) > 0}">
						<c:forEach items="${campList}" var="camp">
							<option value="<c:out value='${camp.campNo}'/>"><c:out value='${camp.campNm}'/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
			<td width="10%" class="td_title">기간</td>
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
			<td width="10%" class="td_title">사용자그룹</td>
			<td width="22%" class="td_body">
				<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
				<c:if test="${'Y' eq NEO_ADMIN_YN}">
					<select id="searchDeptNo" name="searchDeptNo" style="width: 140px;" class="select" onchange="javascript:getUserList(this.value);">
						<option value="0">:: 그룹 선택 ::</option><!-- 그룹 선택 -->
						<c:if test="${fn:length(deptList) > 0}">
							<c:forEach items="${deptList}" var="dept">
								<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == NEO_DEPT_NO}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
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
			<td width="10%" class="td_title">사용자</td>
			<td width="22%" class="td_body">
				<select id="searchUserId" name="searchUserId"  style="width: 140px;" class="select">
					<option value=''>:: 사용자 선택 ::</option>
					<c:if test="${fn:length(userList) > 0}">
						<c:forEach items="${userList}" var="user">
							<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq NEO_USER_ID}"> selected</c:if>><c:out value='${user.userNm}'/></option>
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
				<input type="button" value="검색" class="btn_typeC" onClick="goOz()">
					<input type="button" value="초기화" class="btn_style" onClick="goReset()">
			</td>
		</tr>
				<tr>
			<td height="10"></td>
		</tr>
		<tr>
	</table>
	<!------------------------------------------------------------------------------------------------------------>
	<!------------------------------------------	SEARCH	END		---------------------------------------------->
	<!------------------------------------------------------------------------------------------------------------>
	<table width="1000" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right" height=5>
			</td>
		</tr>
	</table>
	<!------------------------------------------------------------------------------------------------------------>
	<!------------------------------------------	OZREPORT	START		-------------------------------------->
	<!------------------------------------------------------------------------------------------------------------>
	<table width="1000" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="95">
				<div id="click_tab7" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">월별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab7" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab7','<c:url value='/ems/ana/summMonthP.ums'/>')">월별</a></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab1" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">요일별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab1" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab1','<c:url value='/ems/ana/summWeekP.ums'/>')">요일별</a></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab2" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">일자별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab2" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab2','<c:url value='/ems/ana/summDateP.ums'/>')">일자별</font></a></b></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab3" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">도메인별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab3" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab3','<c:url value='/ems/ana/summDomainP.ums'/>')">도메인별</font></a></b></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab4" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">그룹별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab4" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab4','<c:url value='/ems/ana/summDeptP.ums'/>')">그룹별</font></a><b></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab5" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">사용자별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab5" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab5','<c:url value='/ems/ana/summUserP.ums'/>')">사용자별</font></a><b></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td width="1"></td>
			<td width="95">
				<div id="click_tab6" style="display : none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center" class="tab">캠페인별</td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
				<div id="tab6" style="display=">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"></td>
							<td width="110" align="center"><a href="javascript:goOzTab('tab6','<c:url value='/ems/ana/summCampP.ums'/>')">캠페인별</font></a><b></td>
							<td width="6"></td>
						</tr>
					</table>
				</div>
			</td>
			<td align="right">&nbsp;
			</td>
		</tr>
		<tr>
		  <td colspan=15 height=5></td>
		</tr>
	</table>
	<table width="1000" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<iframe name="iFrmReport" border='0' frameborder='1' scrolling='no' width='100%' height='1070'></iframe>
			</td>
		</tr>
	</table>
	<!------------------------------------------------------------------------------------------------------------>
	<!------------------------------------------	OZREPORT	END		------------------------------------------>
	<!------------------------------------------------------------------------------------------------------------>





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
