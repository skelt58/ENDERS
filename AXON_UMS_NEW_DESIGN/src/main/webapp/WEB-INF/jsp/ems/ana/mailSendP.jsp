<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.04
	*	설명 : 통계분석 메일별분석 발송시간별 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
function goPageNum(page) {
	$("#page").val(page);
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/ana/mailSendP.ums'/>").submit();
}
</script>

<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="page" name="page" value="<c:out value='${taskVO.page}'/>"/>
<input type="hidden" id="taskNo" name="taskNo" value="<c:out value='${taskVO.taskNo}'/>"/>
<input type="hidden" id="subTaskNo" name="subTaskNo" value="${taskVO.subTaskNo}"/>
</form>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL131'/></td><!-- 발송시간별 -->
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
		<td class="td_line" colspan=7></td>
	</tr>
	<tr>
		<td class="td_title" width=60><b>NO</b></td>
		<td class="td_title" width=120><b><spring:message code='ANATBLLB131'/></b></td><!-- 시간 -->
		<td class="td_title" width=120><b><spring:message code='ANATBLLB122'/></b></td><!-- 발송수 -->
		<td class="td_title" width=120><b><spring:message code='ANATBLLB011'/></b></td><!-- 성공수 -->
		<td class="td_title" width=120><b><spring:message code='ANATBLLB010'/></b></td><!-- 실패수 -->
		<td class="td_title" width=80><b><spring:message code='ANATBLLB124'/></b></td><!-- 성공율 -->
		<td class="td_title" width=80><b><spring:message code='ANATBLLB125'/></b></td><!-- 실패율 -->
	</tr>
	<c:if test="${fn:length(sendList) > 0}">
		<c:forEach items="${sendList}" var="send" varStatus="sendStatus">
		<tr>
			<td class="td_body" align="center"><c:out value='${(pageUtil.currPage-1)*pageUtil.pageRow + sendStatus.count}'/></td>
			<td class="td_body" align="center">
				<fmt:parseDate var="sendTime" value="${send.sendTime}" pattern="yyyyMMddHH"/>
				<fmt:formatDate var="sendTime" value="${sendTime}" pattern="yyyy-MM-dd HH"/>
				<c:out value='${sendTime}'/><spring:message code='ANATBLLB016'/><!-- 시 -->
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sendCnt" type="number" value="${send.sendCnt}" /><c:out value="${sendCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="succCnt" type="number" value="${send.succCnt}" /><c:out value="${succCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="failCnt" type="number" value="${send.sendCnt - send.succCnt}" /><c:out value="${failCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="succPer" type="percent" value="${send.sendCnt == 0 ? 0 : send.succCnt / send.sendCnt}" /><c:out value='${succPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="failPer" type="percent" value="${send.sendCnt == 0 ? 0 : (send.sendCnt - domain.succCnt) / send.sendCnt}" /><c:out value='${failPer}'/>
			</td>
		</tr>
		</c:forEach>
	</c:if>
	<c:if test="${empty sendList}">
		<tr>
			<td class="td_body" align="center">1</td>
			<td class="td_body" align="center"><spring:message code='ANATBLLB016'/></td><!-- 시 -->
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0</td>
			<td class="td_body" align="right">0%</td>
			<td class="td_body" align="right">0%</td>
		</tr>
	</c:if>
	<c:if test="${not empty sendSum && pageUtil.totalPage == pageUtil.currPage}">
		<tr>
			<td class="td_body" align="center" colspan=2><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumSendCnt" type="number" value="${sendSum.sendCnt}" /><c:out value="${sumSendCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumSuccCnt" type="number" value="${sendSum.succCnt}" /><c:out value="${sumSuccCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumFailCnt" type="number" value="${sendSum.sendCnt - sendSum.succCnt}" /><c:out value="${sumFailCnt}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumSuccPer" type="percent" value="${sendSum.sendCnt == 0 ? 0 : sendSum.succCnt / sendSum.sendCnt}" /><c:out value='${sumSuccPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumFailPer" type="percent" value="${sendSum.sendCnt == 0 ? 0 : (sendSum.sendCnt - sendSum.succCnt) / sendSum.sendCnt}" /><c:out value='${sumFailPer}'/>
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
