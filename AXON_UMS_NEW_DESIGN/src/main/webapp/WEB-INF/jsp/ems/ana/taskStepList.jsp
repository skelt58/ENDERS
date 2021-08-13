<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 통계분석 메일별분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="listForm" name="listForm" method="post">
<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td width="3%" align="center">
			<label for="checkbox_all"><input type="checkbox" id="checkbox_all" name="isAll" onclick='goAll()'><span></span></label>
		</td>
		<td width="10%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
		<td width="19%"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
		<td width="10%"><spring:message code='ANATBLTL009'/></td><!-- 단발/정기 -->
		<td width="19%"><spring:message code='ANATBLTL010'/></td><!-- 발송그룹명 -->
		<td width="11%"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
		<td width="14%"><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
		<td width="11%"><spring:message code='ANATBLTL011'/></td><!-- 발송상태 -->
	</tr>
	<c:if test="${fn:length(mailList) > 0}">
		<c:forEach items="${mailList}" var="mail" varStatus="mailStatus">
			<tr class="tr_body">
				<td align="center">
					<label for="checkbox${mailStatus.count}"><input type="checkbox" id="checkbox${mailStatus.count}" name="taskNos" value="<c:out value='${mail.taskNo}'/>"><span></span></label>
					<input type="checkbox" name="subTaskNos" value="<c:out value='${mail.subTaskNo}'/>" style="display:none;">
				</td>
				<td><c:out value='${mail.campNm}'/></td>
				<td>
					<c:set var="strTh" value=""/>
					<c:if test="${'001' eq mail.sendRepeat}"><c:set var="strTh" value="[${mail.subTaskNo}차]"/></c:if>
					<div style="width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<c:out value='${strTh}${mail.taskNm}'/>">
					<a href="javascript:goOz('tab1','<c:url value='/ems/ana/mailSummP.ums'/>','<c:out value='${mail.taskNo}'/>','<c:out value='${mail.subTaskNo}'/>')"><c:out value='${strTh}${mail.taskNm}'/></a>
					</div>
				</td>
				<td><c:out value='${mail.sendRepeatNm}'/></td>
				<td><c:out value='${mail.segNm}'/></td>
				<td><c:out value='${mail.userNm}'/></td>
				<td>
					<fmt:parseDate var="sendDt" value="${mail.sendDt}" pattern="yyyyMMddHHmm"/>
					<fmt:formatDate var="mailSendDt" value="${sendDt}" pattern="yyyy-MM-dd HH:mm"/>
					<c:out value='${mailSendDt}'/>
				</td>
				<td><c:out value='${mail.statusNm}'/></td>
			</tr>
		</c:forEach>
	</c:if>
	<c:set var="emptyCnt" value="${pageUtil.pageRow - fn:length(mailList)}"/>
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
