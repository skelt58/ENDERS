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

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=6></td>
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
	<c:set var="totSendCnt" value="${0}"/>
	<c:set var="totSuccCnt" value="${0}"/>
	<c:set var="totFailCnt" value="${0}"/>
	<c:if test="${fn:length(mailList) > 0}">
		<c:forEach items="${mailList}" var="mail">
			<c:set var="totSendCnt" value="${totSendCnt + mail.totCnt}"/>
			<c:set var="totSuccCnt" value="${totSuccCnt + mail.sucCnt}"/>
			<c:set var="totFailCnt" value="${totFailCnt + (mail.totCnt - mail.sucCnt)}"/>
			<tr>
				<td class="td_body" align="center" onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:pointer"><c:out value='${mail.taskNo}'/></td>
				<td class="td_body" onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:hand"><c:out value='${mail.taskNm}'/></td>
				<td class="td_body" align="center">
					<fmt:parseDate var="mailSendDt" value="${mail.sendDt}" pattern="yyyyMMddHHmm"/>
					<fmt:formatDate var="sendDt" value="${mailSendDt}" pattern="yyyy-MM-dd HH:mm"/>
					<c:out value='${sendDt}'/>
				</td>
				<td class="td_body" align="right"><c:out value='${mail.totCnt}'/></td>
				<td class="td_body" align="right"><c:out value='${mail.sucCnt}'/></td>
				<td class="td_body" align="right"><c:out value='${mail.totCnt - mail.sucCnt}'/></td>
			</tr>
		</c:forEach>
	</c:if>
	<tr>
		<td class="td_body" colspan=3 align="center"><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		<td class="td_body" align="right">
			<fmt:formatNumber var="totSendCntNum" type="number" value="${totSendCnt}" /><c:out value="${totSendCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="totSuccCntNum" type="number" value="${totSuccCnt}" /><c:out value="${totSuccCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="totFailCntNum" type="number" value="${totFailCnt}" /><c:out value="${totFailCntNum}"/>
		</td>
	</tr>
</table>

<br/>
<c:if test="${not empty respLog}">
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line" colspan=3></td>
		</tr>
		<tr class="tr_head">
			<td colspan=3 align="left"><b><spring:message code='ANATBLTL103'/></b></td><!-- 발송결과 -->
		</tr>
		<tr>
			<td class="td_title" width=85><spring:message code='ANATBLLB106'/></td><!-- 대상수 -->
			<td class="td_title" width=85><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
			<td class="td_title" width=85><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
		</tr>
		<tr>
			<td class="td_body" rowspan=2 align="right">
				<c:out value="${totSendCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<c:out value="${totSuccCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<c:out value="${totFailCntNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="succPer" type="percent" value="${totSendCnt == 0 ? 0 : totSuccCnt / totSendCnt}" /><c:out value='${succPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="failPer" type="percent" value="${totSendCnt == 0 ? 0 : totFailCnt / totSendCnt}" /><c:out value='${failPer}'/>
			</td>
		</tr>
	</table>
	
	<br/>
	
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line" colspan=6></td>
		</tr>
		<tr class="tr_head">
			<td colspan=6 align="left"><b><spring:message code='ANATBLTL104'/></b></td><!-- 반응결과 -->
		</tr>
		<tr>
			<td class="td_title" width=70>&nbsp;</td>
			<td class="td_title" width=80><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
			<td class="td_title" width=70><spring:message code='ANATBLLB012'/></td><!-- 오픈수 -->
			<td class="td_title" width=70><spring:message code='ANATBLLB013'/></td><!-- 유효오픈수 -->
			<td class="td_title" width=70><spring:message code='ANATBLLB014'/></td><!-- 링크클릭수 -->
			<td class="td_title" width=70><spring:message code='ANATBLLB015'/></td><!-- 수신거부 -->
		</tr>
		<tr>
			<td class="td_body"><spring:message code='ANATBLLB109'/></td><!-- 반응수 -->
			<td class="td_body" rowspan=3 align="right">
				<c:out value="${totSuccCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="openCntNum" type="number" value="${respLog.openCnt}" /><c:out value="${openCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="validCntNum" type="number" value="${respLog.validCnt}" /><c:out value="${validCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="clickCntNum" type="number" value="${respLog.clickCnt}" /><c:out value="${clickCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="blockCntNum" type="number" value="${respLog.blockCnt}" /><c:out value="${blockCntNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body"><spring:message code='ANATBLLB110'/></td><!-- 성공대비 -->
			<td class="td_body" align="right">
				<fmt:formatNumber var="openPer" type="percent" value="${totSuccCnt == 0 ? 0 : respLog.openCnt / totSuccCnt}" /><c:out value='${openPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="validPer" type="percent" value="${totSuccCnt == 0 ? 0 : respLog.validCnt / totSuccCnt}" /><c:out value='${validPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="clickPer" type="percent" value="${totSuccCnt == 0 ? 0 : respLog.clickCnt / totSuccCnt}" /><c:out value='${clickPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="blockPer" type="percent" value="${totSuccCnt == 0 ? 0 : respLog.blockCnt / totSuccCnt}" /><c:out value='${blockPer}'/>
			</td>
		</tr>
		<tr>
			<td class="td_body"><spring:message code='ANATBLLB111'/></td><!-- 전체대비 -->
			<td class="td_body" align="right">
				<fmt:formatNumber var="totOpenPer" type="percent" value="${totSendCnt == 0 ? 0 : respLog.openCnt / totSendCnt}" /><c:out value='${totOpenPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="totValidPer" type="percent" value="${totSendCnt == 0 ? 0 : respLog.validCnt / totSendCnt}" /><c:out value='${totValidPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="totClickPer" type="percent" value="${totSendCnt == 0 ? 0 : respLog.clickCnt / totSendCnt}" /><c:out value='${totClickPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="totBlockPer" type="percent" value="${totSendCnt == 0 ? 0 : respLog.blockCnt / totSendCnt}" /><c:out value='${totBlockPer}'/>
			</td>
		</tr>
	</table>
</c:if>

<c:if test="${fn:length(errorList) > 0}">
	<c:set var="syntaxErrCnt" value="${0}"/>
	<c:set var="webAgentErrCnt" value="${0}"/>
	<c:set var="dbAgentErrCnt" value="${0}"/>
	<c:set var="mailBodyErrCnt" value="${0}"/>
	<c:set var="domainErrCnt" value="${0}"/>
	<c:set var="networkErrCnt" value="${0}"/>
	<c:set var="connectErrCnt" value="${0}"/>
	<c:set var="heloErrCnt" value="${0}"/>
	<c:set var="mailFromErrCnt" value="${0}"/>
	<c:set var="rcptToErrCnt" value="${0}"/>
	<c:set var="resetErrCnt" value="${0}"/>
	<c:set var="dataErrCnt" value="${0}"/>
	<c:set var="dotErrCnt" value="${0}"/>
	<c:set var="quitErrCnt" value="${0}"/>
	<c:set var="sumStep1Err" value="${0}"/>
	<c:set var="sumStep2Err" value="${0}"/>
	<c:set var="failCnt" value="${0}"/>
	<c:forEach items="${errorList}" var="error">
		<c:set var="failCnt" value="${eror.cntStep2}"/>
		<c:if test="${'001' eq error.step1}">
			<c:set var="sumStep1Err" value="${sumStep1Err + failCnt}"/>
			<c:choose>
				<c:when test="${'001' eq error.step2}">
					<c:set var="syntaxErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'002' eq error.step2}">
					<c:set var="webAgentErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'003' eq error.step2}">
					<c:set var="dbAgentErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'004' eq error.step2}">
					<c:set var="mailBodyErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'005' eq error.step2}">
					<c:set var="domainErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'006' eq error.step2}">
					<c:set var="networkErrCnt" value="${failCnt}"/>
				</c:when>
			</c:choose>
		</c:if>
		<c:if test="${'002' eq error.step1}">
			<c:set var="sumStep2Err" value="${sumStep2Err + failCnt}"/>
			<c:choose>
				<c:when test="${'001' eq error.step2}">
					<c:set var="connectErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'002' eq error.step2}">
					<c:set var="heloErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'003' eq error.step2}">
					<c:set var="mailFromErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'004' eq error.step2}">
					<c:set var="rcptToErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'005' eq error.step2}">
					<c:set var="resetErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'006' eq error.step2}">
					<c:set var="dataErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'007' eq error.step2}">
					<c:set var="dotErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'008' eq error.step2}">
					<c:set var="quitErrCnt" value="${failCnt}"/>
				</c:when>
			</c:choose>
		</c:if>
	</c:forEach>
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line"></td>
		</tr>
		<tr class="tr_head">
			<td align="left"><b><spring:message code='ANATBLTL105'/></b></td><!-- 세부에러 -->
		</tr>
		<tr class="tr_head">
			<td class="td_title"><b><spring:message code='ANATBLLB107'/></b></td><!-- 메일발송 전 단계 -->
		</tr>
	<table>
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_body" align=center width=100>Syntax</td>
			<td class="td_body" align=center width=100>Web Agent</td>
			<td class="td_body" align=center width=100>DB Agent</td>
			<td class="td_body" align=center width=100>Mail Body</td>
			<td class="td_body" align=center width=100>Domain</td>
			<td class="td_body" align=center width=100>Network</td>
			<td class="td_body" align=center width=100><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="syntaxErrCntNum" type="number" value="${syntaxErrCnt}" /><c:out value="${syntaxErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="webAgentErrCntNum" type="number" value="${webAgentErrCnt}" /><c:out value="${webAgentErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dbAgentErrCntNum" type="number" value="${dbAgentErrCnt}" /><c:out value="${dbAgentErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailBodyErrCntNum" type="number" value="${mailBodyErrCnt}" /><c:out value="${mailBodyErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="domainErrCntNum" type="number" value="${domainErrCnt}" /><c:out value="${domainErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="networkErrCntNum" type="number" value="${networkErrCnt}" /><c:out value="${networkErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep1ErrNum" type="number" value="${sumStep1Err}" /><c:out value="${sumStep1ErrNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="syntaxErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : syntaxErrCnt / totFailCnt}" /><c:out value='${syntaxErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="webAgentErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : webAgentErrCnt / totFailCnt}" /><c:out value='${webAgentErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dbAgentErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : dbAgentErrCnt / totFailCnt}" /><c:out value='${dbAgentErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailBodyErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : mailBodyErrCnt / totFailCnt}" /><c:out value='${mailBodyErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="domainErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : domainErrCnt / totFailCnt}" /><c:out value='${domainErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="networkErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : networkErrCnt / totFailCnt}" /><c:out value='${networkErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep1ErrPer" type="percent" value="${totFailCnt == 0 ? 0 : sumStep1Err / totFailCnt}" /><c:out value='${sumStep1ErrPer}'/>
			</td>
		</tr>
	</table>
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr class="tr_head">
			<td><b><spring:message code='ANATBLLB106'/></b></td><!-- 대상수 -->
		</tr>
	</table>
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_body" align=center width=75>CONNECT</td>
			<td class="td_body" align=center width=75>HELO</td>
			<td class="td_body" align=center width=75>MAIL FROM</td>
			<td class="td_body" align=center width=75>RCPT TO</td>
			<td class="td_body" align=center width=75>RESET</td>
			<td class="td_body" align=center width=75>DATA</td>
			<td class="td_body" align=center width=75>DOT</td>
			<td class="td_body" align=center width=75>QUIT</td>
			<td class="td_body" align=center width=100><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="connectErrCntNum" type="number" value="${connectErrCnt}" /><c:out value="${connectErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="heloErrCntNum" type="number" value="${heloErrCnt}" /><c:out value="${heloErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailFromErrCntNum" type="number" value="${mailFromErrCnt}" /><c:out value="${mailFromErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="rcptToErrCntNum" type="number" value="${rcptToErrCnt}" /><c:out value="${rcptToErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="resetErrCntNum" type="number" value="${resetErrCnt}" /><c:out value="${resetErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dataErrCntNum" type="number" value="${dataErrCnt}" /><c:out value="${dataErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dotErrCntNum" type="number" value="${dotErrCnt}" /><c:out value="${dotErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="quitErrCntNum" type="number" value="${quitErrCnt}" /><c:out value="${quitErrCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep2ErrNum" type="number" value="${sumStep2Err}" /><c:out value="${sumStep2ErrNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="connectErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : connectErrCnt / totFailCnt}" /><c:out value='${connectErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="heloErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : heloErrCnt / totFailCnt}" /><c:out value='${heloErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailFromErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : mailFromErrCnt / totFailCnt}" /><c:out value='${mailFromErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="rcptToErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : rcptToErrCnt / totFailCnt}" /><c:out value='${rcptToErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="resetErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : resetErrCnt / totFailCnt}" /><c:out value='${resetErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dataErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : dataErrCnt / totFailCnt}" /><c:out value='${dataErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dotErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : dotErrCnt / totFailCnt}" /><c:out value='${dotErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="quitErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : quitErrCnt / totFailCnt}" /><c:out value='${quitErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep2ErrPer" type="percent" value="${sumStep2Err == 0 ? 0 : quitErrCnt / totFailCnt}" /><c:out value='${sumStep2ErrPer}'/>
			</td>
		</tr>
	</table>
</c:if>


</body>
</html>
