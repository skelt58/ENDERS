<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.11
	*	설명 : 통계분석 누적분석 요일별탭 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<body>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30>누적분석</td>
	</tr>
</table>
<br>
<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=4></td>
	</tr>
	<tr class="tr_head">
		<td colspan=4 align="left"><b>누적분석</b></td>
	</tr>
	<tr>
		<td class="td_title">분 석 구 분</td>
		<td class="td_body" colspan=3>요일별분석</td>
	</tr>
	<tr>
		<td class="td_title" width=120>캠 페 인 명</td>
		<td class="td_body" width=240><c:out value="${searchVO.searchCampNm}"/></td>
		<td class="td_title" width=120>사용자 그룹</td>
		<td class="td_body" width=240><c:out value="${searchVO.searchDeptNm}"/></td>
	</tr>
	<tr>
		<td class="td_title">사&nbsp;&nbsp;&nbsp;&nbsp;용&nbsp;&nbsp;&nbsp;&nbsp;자</td>
		<td class="td_body"><c:out value="${searchVO.searchUserNm}"/></td>
		<td class="td_title">기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;간</td>
		<td class="td_body">
			<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMdd"/>
			<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy.MM.dd"/> 
			<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMdd"/>
			<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy.MM.dd"/> 
			<c:out value="${searchStartDt}"/> ~ <c:out value="${searchEndDt}"/>
		</td>
	</tr>
</table>

<br>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=8></td>
	</tr>
	<tr>
		<td class="td_title" width=100>요일</td>
		<td class="td_title" width=100>발송수</td>
		<td class="td_title" width=100>성공수</td>
		<td class="td_title" width=100>실패수</td>
		<td class="td_title" width=75>오픈수</td>
		<td class="td_title" width=75>유효오픈수</td>
		<td class="td_title" width=75>클릭수</td>
		<td class="td_title" width=75>수신거부</td>
	</tr>

	<c:set var="sumSendCnt" value="${0}"/>
	<c:set var="sumSuccCnt" value="${0}"/>
	<c:set var="sumFailCnt" value="${0}"/>
	<c:set var="sumOpenCnt" value="${0}"/>
	<c:set var="sumValidCnt" value="${0}"/>
	<c:set var="sumClickCnt" value="${0}"/>
	<c:set var="sumBlockCnt" value="${0}"/>
	<c:if test="${fn:length(weekList) > 0}">
		<c:forEach items="${weekList}" var="week">
			<c:set var="sumSendCnt" value="${sumSendCnt + week.sendCnt}"/>
			<c:set var="sumSuccCnt" value="${sumSuccCnt + week.succCnt}"/>
			<c:set var="sumFailCnt" value="${sumFailCnt + (week.sendCnt - week.succCnt)}"/>
			<c:set var="sumOpenCnt" value="${sumOpenCnt + week.openCnt}"/>
			<c:set var="sumValidCnt" value="${sumValidCnt + week.validCnt}"/>
			<c:set var="sumClickCnt" value="${sumClickCnt + week.clickCnt}"/>
			<c:set var="sumBlockCnt" value="${sumBlockCnt + week.blockCnt}"/>
			<tr>
				<td class="td_body" align=center><c:out value="${week.weekNm}"/></td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="sendCntNum" type="number" value="${week.sendCnt}" /><c:out value="${sendCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="succCntNum" type="number" value="${week.succCnt}" /><c:out value="${succCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="failCntNum" type="number" value="${week.sendCnt - week.succCnt}" /><c:out value="${failCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="openCntNum" type="number" value="${week.openCnt}" /><c:out value="${openCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="validCntNum" type="number" value="${week.validCnt}" /><c:out value="${validCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="clickCntNum" type="number" value="${week.clickCnt}" /><c:out value="${clickCntNum}"/>
				</td>
				<td class="td_body" align=right>
					<fmt:formatNumber var="blockCntNum" type="number" value="${week.blockCnt}" /><c:out value="${blockCntNum}"/>
				</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${empty weekList}">
		<tr>
			<td class="td_body" align=center></td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
			<td class="td_body" align=right>0</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_body" align=center>합계</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumSendCntNum" type="number" value="${sumSendCnt}" /><c:out value="${sumSendCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumSuccCntNum" type="number" value="${sumSuccCnt}" /><c:out value="${sumSuccCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumFailCntNum" type="number" value="${sumFailCnt}" /><c:out value="${sumFailCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumOpenCntNum" type="number" value="${sumOpenCnt}" /><c:out value="${sumOpenCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumValidCntNum" type="number" value="${sumValidCnt}" /><c:out value="${sumValidCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumClickCntNum" type="number" value="${sumClickCnt}" /><c:out value="${sumClickCntNum}"/>
		</td>
		<td class="td_body" align=right>
			<fmt:formatNumber var="sumBlockCntNum" type="number" value="${sumBlockCnt}" /><c:out value="${sumBlockCntNum}"/>
		</td>
	</tr>
</table>



</body>
</html>
