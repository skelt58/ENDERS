<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 병합분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL151'/></td><!-- 메일 병합분석 -->
	</tr>
</table>

<br>

<table width="700" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=2></td>
	</tr>
	<tr class="tr_head">
		<td colspan=6 align=left><b><spring:message code='ANATBLTL152'/></b></td><!-- 메일 리스트 -->
	</tr>
	<tr align="center">
		<td class="td_body" width=70><spring:message code='ANATBLLB142'/></td><!-- 번호 -->
		<td class="td_body" width=240><spring:message code='ANATBLLB143'/></td><!-- 메일명 -->
		<td class="td_body" width=120><spring:message code='ANATBLLB144'/></td><!-- 예약일자 -->
		<td class="td_body" width=90><spring:message code='ANATBLLB106'/></td><!-- 대상수 -->
		<td class="td_body" width=90><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
		<td class="td_body" width=90><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
	</tr>

	<c:if test="${fn:length(mailList) > 0}">
		<c:forEach items="${mailList}" var="mail">
	<tr>
		<td class="td_body" align="center" onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:pointer"><c:out value='${mail.taskNo}'/></td>
		<td class="td_body" onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:hand"><c:out value='${mail.taskNm}'/></td>
		<td class="td_body" align="center"><c:out value='${mail.sendDt}'/></td>
		<td class="td_body" align="right"><c:out value='${mail.totCnt}'/></td>
		<td class="td_body" align="right"><c:out value='${mail.sucCnt}'/></td>
		<td class="td_body" align="right"><c:out value='${mail.totCnt - mail.sucCnt}'/></td>
	</tr>
		
		</c:forEach>
	</c:if>
</table>


</body>
</html>
