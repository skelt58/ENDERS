<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.04
	*	설명 : 통계분석 응답시간별 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
function goPageNum(page) {
	$("#page").val(page);
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/ana/mailRespP.ums'/>").submit();
}
</script>

<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="page" name="page" value="<c:out value='${taskVO.page}'/>"/>
<input type="hidden" id="taskNo" name="taskNo" value="<c:out value='${taskVO.taskNo}'/>"/>
<input type="hidden" id="subTaskNo" name="subTaskNo" value="${taskVO.subTaskNo}"/>
</form>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL141'/></td><!-- 응답시간별 -->
	</tr>
</table>

<br>
	
<c:if test="${not empty mailInfo}">
<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=2></td>
	</tr>
	<tr class="tr_head">
		<td colspan=2 align="left"><b><spring:message code='ANATBLTL102'/></b></td><!-- 메일정의 -->
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB101'/></td><!-- 캠페인유형 -->
		<td class="td_body"><c:out value='${mailInfo.campTy}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB102'/></td><!-- 캠 페 인 명 -->
		<td class="td_body"><c:out value='${mailInfo.campNm}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB103'/></td><!-- 발 송 대 상 -->
		<td class="td_body"><c:out value='${mailInfo.segNm}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB104'/></td><!-- 발 송 일 자 -->
		<td class="td_body">
			<fmt:parseDate var="mailSendDt" value="${mailInfo.sendDt}" pattern="yyyyMMddHHmm"/>
			<fmt:formatDate var="sendDt" value="${mailSendDt}" pattern="yyyy-MM-dd HH:mm"/>
			<fmt:parseDate var="mailEndDt" value="${mailInfo.endDt}" pattern="yyyyMMddHHmm"/>
			<fmt:formatDate var="endDt" value="${mailEndDt}" pattern="yyyy-MM-dd HH:mm"/>
			<c:out value='${sendDt}'/> ~ <c:out value='${endDt}'/>
		</td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB105'/></td><!-- 메&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;명 -->
		<td class="td_body"><c:out value='${mailInfo.taskNm}'/></td>
	</tr>
</table>
</c:if>

<br>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=6></td>
	</tr>
	<tr class="tr_head">
		<td align="left" colspan=6>
			<b><spring:message code='ANATBLLB011'/>&nbsp;:&nbsp;<!-- 성공수 -->
			<fmt:formatNumber var="sumSuccCnt" type="number" value="${respSum.succCnt}" /><c:out value="${sumSuccCnt}"/></b>
		</td>
	</tr>
	<tr>
	<td class="td_title" width=60><b>NO</b></td>
		<td class="td_title" width=120><b><spring:message code='ANATBLLB131'/></b></td><!-- 시간 -->
		<td class="td_title" width=130><b><spring:message code='ANATBLLB012'/></b></td><!-- 오픈수 -->
		<td class="td_title" width=130><b><spring:message code='ANATBLLB013'/></b></td><!-- 유효오픈수 -->
		<td class="td_title" width=130><b><spring:message code='ANATBLLB141'/></b></td><!-- 클릭수 -->
		<td class="td_title" width=130><b><spring:message code='ANATBLLB015'/></b></td><!-- 수신거부 -->
	</tr>
	<c:if test="${fn:length(respList) > 0}">
		<c:forEach items="${respList}" var="resp" varStatus="respStatus">
		<tr>
			<td class="td_body" align="center"><c:out value='${(pageUtil.currPage-1)*pageUtil.pageRow + respStatus.count}'/></td>
			<td class="td_body" align="center">
				<fmt:parseDate var="respTime" value="${resp.respTime}" pattern="yyyyMMddHH"/>
				<fmt:formatDate var="respTime" value="${respTime}" pattern="yyyy-MM-dd HH"/>
				<c:out value='${respTime}'/><spring:message code='ANATBLLB016'/><!-- 시 -->
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="openCnt" type="number" value="${resp.openCnt}" /><c:out value="${openCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="validCnt" type="number" value="${resp.validCnt}" /><c:out value="${validCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="clickCnt" type="number" value="${resp.clickCnt}" /><c:out value="${clickCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="blockCnt" type="number" value="${resp.blockCnt}" /><c:out value="${blockCnt}"/>
			</td>
		</tr>
		</c:forEach>
	</c:if>
	<c:if test="${empty respList}">
		<tr>
			<td class="td_body" align="center">1</td>
			<td class="td_body" align="center"><spring:message code='ANATBLLB016'/></td><!-- 시 -->
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0</td>
		</tr>
	</c:if>
	<c:if test="${not empty respSum}">
		<tr>
			<td class="td_body" align="center" colspan=2><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumOpenCnt" type="number" value="${respSum.openCnt}" /><c:out value="${sumOpenCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumValidCnt" type="number" value="${respSum.validCnt}" /><c:out value="${sumValidCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumClickCnt" type="number" value="${respSum.clickCnt}" /><c:out value="${sumClickCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumBlockCnt" type="number" value="${respSum.blockCnt}" /><c:out value="${sumBlockCnt}"/>
			</td>
		</tr>
	</c:if>
</table>

<table width="700" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" height=25>${pageUtil.pageHtml}</td>
	</tr>
</table>

</body>
</html>
