<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.09
	*	설명 : 통계분석 정기메일분석 도메인별 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL121'/></td><!-- 도메인별 -->
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

<c:if test="${fn:length(domainList) > 0}">
	<c:set var="domainNm" value=""/>
	<c:set var="sendCnt" value="${0}"/>
	<c:set var="succCnt" value="${0}"/>
	<c:set var="failCnt" value="${0}"/>
	<c:set var="errorCnt" value="${0}"/>
	<c:set var="sumSendCnt" value="${0}"/>
	<c:set var="sumSuccCnt" value="${0}"/>
	<c:set var="sumFailCnt" value="${0}"/>
	<c:set var="sumErrorCnt" value="${0}"/>
	<c:forEach items="${domainList}" var="domain">
		<c:set var="sendCnt" value="${domain.sendCnt}"/>
		<c:set var="succCnt" value="${domain.succCnt}"/>
		<c:set var="failCnt" value="${sendCnt - succCnt}"/>
		<c:set var="errorCnt" value="${domain.errorCnt}"/>
		<c:set var="sumSendCnt" value="${sumSendCnt + sendCnt}"/>
		<c:set var="sumSuccCnt" value="${sumSuccCnt + succCnt}"/>
		<c:set var="sumFailCnt" value="${sumFailCnt + failCnt}"/>
		<c:set var="sumErrorCnt" value="${sumErrorCnt + errorCnt}"/>
	</c:forEach>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=9></td>
	</tr>
	<tr>
		<td class="td_title" width=30><b>NO</b></td>
		<td class="td_title" width=130><b><spring:message code='ANATBLLB121'/></b></td>
		<td class="td_title" width=90><b><spring:message code='ANATBLLB122'/></b></td>
		<td class="td_title" width=90><b><spring:message code='ANATBLLB011'/></b></td>
		<td class="td_title" width=90><b><spring:message code='ANATBLLB010'/></b></td>
		<td class="td_title" width=90><b><spring:message code='ANATBLLB123'/></b></td>
		<td class="td_title" width=60><b><spring:message code='ANATBLLB124'/></b></td>
		<td class="td_title" width=60><b><spring:message code='ANATBLLB125'/></b></td>
		<td class="td_title" width=70><b><spring:message code='ANATBLLB126'/></b></td>
	</tr>

	<c:forEach items="${domainList}" var="domain" varStatus="domainStatus">
		<tr>
			<td class="td_body" align="center"><c:out value='${domainStatus.count}'/></td>
			<td class="td_body"><c:out value='${domain.domainNm}'/></td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sendCntNum" type="number" value="${domain.sendCnt}" /><c:out value="${sendCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="succCntNum" type="number" value="${domain.succCnt}" /><c:out value="${succCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="failCntNum" type="number" value="${domain.sendCnt - domain.succCnt}" /><c:out value="${failCntNum}"/>
			</td>
			<td class="td_body" align="right"<c:if test="${domain.errorCnt > 0}">onClick="openError('<c:out value='${domain.domainNm}'/>')" style="cursor:hand"</c:if>>
				<fmt:formatNumber var="errorCntNum" type="number" value="${domain.errorCnt}" /><c:out value="${errorCntNum}"/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="succPer" type="percent" value="${domain.sendCnt == 0 ? 0 : domain.succCnt / domain.sendCnt}" /><c:out value='${succPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="failPer" type="percent" value="${domain.sendCnt == 0 ? 0 : (domain.sendCnt - domain.succCnt) / domain.sendCnt}" /><c:out value='${failPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="errorPer" type="percent" value="${(domain.sendCnt - domain.succCnt) == 0 ? 0 : domain.errorCnt / (domain.sendCnt - domain.succCnt)}" /><c:out value='${errorPer}'/>
			</td>
		</tr>
	</c:forEach>
	<tr>
		<td class="td_body" align="center" colspan=2><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		<td class="td_body" align="right">
			<fmt:formatNumber var="sumSendCntNum" type="number" value="${sumSendCnt}" /><c:out value="${sumSendCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="sumSuccCntNum" type="number" value="${sumSuccCnt}" /><c:out value="${sumSuccCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="sumFailCntNum" type="number" value="${sumFailCnt}" /><c:out value="${sumFailCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="sumErrorCntNum" type="number" value="${sumErrorCnt}" /><c:out value="${sumErrorCntNum}"/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="succPer" type="percent" value="${sumSendCnt == 0 ? 0 : sumSuccCnt / sumSendCnt}" /><c:out value='${succPer}'/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="failPer" type="percent" value="${sumSendCnt == 0 ? 0 : sumFailCnt / sumSendCnt}" /><c:out value='${failPer}'/>
		</td>
		<td class="td_body" align="right">
			<fmt:formatNumber var="errorPer" type="percent" value="${sumFailCnt == 0 ? 0 : sumErrorCnt / sumFailCnt}" /><c:out value='${errorPer}'/>
		</td>
	</tr>
</table>
</c:if>

</body>
</html>
