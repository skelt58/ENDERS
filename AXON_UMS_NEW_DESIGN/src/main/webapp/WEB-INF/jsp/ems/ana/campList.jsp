<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.10
	*	설명 : 통계분석 캠페인별분석 캠페인 목록
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="listForm" name="listForm" method="post">
<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td width="3%" align="center"><input type="checkbox" name="isAll" onclick='goAll()' style="border:0"></td>
		<td width="19%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
		<td width="13%"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
		<td width="13%"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
		<td width="13%"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
		<td width="13%"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
		<td width="13%"><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
		<td width="13%"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
	</tr>
	<c:if test="${fn:length(campaignList) > 0}">
		<c:forEach items="${campaignList}" var="campaign">
			<tr class="tr_body">
				<td align="center"><input type="checkbox" name="campNos" value="<c:out value='${campaign.campNo}'/>" style="border:0"></td>
				<td><a href="javascript:goOz('<c:out value='${campaign.campNo}'/>','<c:url value='/ems/ana/campSummP.ums'/>')"><c:out value='${campaign.campNm}'/></a></td>
				<td><c:out value='${campaign.campTyNm}'/></td>
				<td><c:out value='${campaign.statusNm}'/></td>
				<td><c:out value='${campaign.deptNm}'/></td>
				<td><c:out value='${campaign.userNm}'/></td>
				<td><c:out value='${campaign.regNm}'/></td>
				<td>
					<fmt:parseDate var="regDt" value="${campaign.regDt}" pattern="yyyyMMddHHmmss"/>
					<fmt:formatDate var="campRegDt" value="${regDt}" pattern="yyyy-MM-dd"/>
					<c:out value='${campRegDt}'/>
				</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:set var="emptyCnt" value="${pageUtil.pageRow - fn:length(campaignList)}"/>
	<c:if test="${emptyCnt > 0}">
		<c:forEach var="i" begin="1" end="${emptyCnt}">
			<tr class="tr_body">
				<td>&nbsp;</td>
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
