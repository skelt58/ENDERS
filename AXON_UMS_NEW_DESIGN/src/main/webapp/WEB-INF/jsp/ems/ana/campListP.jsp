<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.10
	*	설명 : 통계분석 캠페인별분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript" src="<c:url value='/js/ems/ana/campListP.js'/>"></script>

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
					<h2>캠페인별분석</h2>
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
			<p class="title_default"><spring:message code='ANATBLTL003'/></p><!-- 캠페인별분석 -->
		</tr>
        <tr>
          <td height="3"><img src="/img/com/Content_titlebar.gif" width="1000" height="1"></td>
        </tr>
		<tr>
			<td height="16"></td>
		</tr>
	</table>
	<!------------------------------------------	TITLE	END		---------------------------------------------->

	<!------------------------------------------	SEARCH	START	---------------------------------------------->
	<form id="searchForm" name="searchForm" method="post">
	<input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>">
	<input type="hidden" name="campNo" value="0">
	<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td width="10%" class="td_title"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
			<td width="22%" class="td_body">
				<input type="text" style="border:1px solid #c0c0c0;" id="searchCampNm" name="searchCampNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchCampNm}'/>">
			</td>
			<td width="10%" class="td_title"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
			<td width="22%" class="td_body">
				<select id="searchCampTy" name="searchCampTy" style="width: 140px;" class="select">
					<option value=''>:: <spring:message code='COMTBLLB002'/> ::</option><!-- 목적 선택 -->
					<c:if test="${fn:length(campTyList) > 0}">
						<c:forEach items="#{campTyList}" var="campTy">
							<option value="<c:out value='${campTy.cd}'/>"<c:if test="${campTy.cd eq searchVO.searchCampTy}"> selected</c:if>><c:out value='${campTy.cdNm}'/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
			<td width="10%" class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
			<td width="22%" class="td_body">
				<select id="searchStatus" name="searchStatus" style="width: 140px;" class="select">
					<option value='ALL'>:: <spring:message code='COMTBLLB003'/> ::</option><!-- 상태 선택 -->
					<c:if test="${fn:length(statusList) > 0}">
						<c:forEach items="${statusList}" var="status">
							<option value="<c:out value='${status.cd}'/>"<c:if test="${status.cd eq searchVO.searchStatus}"> selected</c:if>><c:out value='${status.cdNm}'/></option>
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
				<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_typeC" onClick="goSearch('1')"><!-- 검색 -->
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
			<td align="right" height=5>
			</td>
		</tr>
	</table>
	
	<!------------------------------------------	LIST	START	---------------------------------------------->
	<div id="divCampList"></div>
	<!------------------------------------------	LIST	END		---------------------------------------------->
	
	<table width="1000" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height=10>
			</td>
		</tr>
		<tr>
			<td width=100 height=30>
				<input type="button" value="<spring:message code='ANABTN002'/>" class="btn_typeC" onClick="goJoin()"><!-- 병합분석 -->
			</td>
			<td width=1000 align="right">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right">&nbsp;

					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10>
			</td>
		</tr>
	</table>
	<table width="1000" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<iframe name="iFrmReport" border='0' frameborder='1' scrolling='no' width='100%' height='1070'></iframe>
			</td>
		</tr>
	</table>




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
