<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.10
	*	설명 : 통계분석 캠페인별분석 결과요약 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
function openMail(taskNo) {
	var url = "./mailInfoP.ums?taskNo=" + taskNo + "&subTaskNo=1";
	var feature = "menubar=no, scrollbars=yes, toolbar=no, width=1000, height=500, top=0, left=0";
	window.open(url, "", feature);
}
</script>

<body>

	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr class="tr_head">
			<td class="title_report" height=30><spring:message code='ANATBLTL161'/></td>
		</tr>
	</table>

	<br>
	
	<c:if test="${not empty campInfo}">
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line" colspan=2></td>
		</tr>
		<tr class="tr_head">
			<td colspan=2 align="left"><b><spring:message code='ANATBLTL162'/></b></td><!-- 캠페인 정의 -->
		</tr>
		<tr>
			<td class="td_title" width=120><spring:message code='ANATBLLB102'/></td><!-- 캠 페 인 명 -->
			<td class="td_body" width=550><c:out value="${campInfo.campNm}"/></td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='ANATBLLB101'/></td><!-- 캠페인유형 -->
			<td class="td_body"><c:out value="${campInfo.campTy}"/></td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='ANATBLLB153'/></td><!-- 사용자 그룹 -->
			<td class="td_body"><c:out value="${campInfo.deptNm}"/></td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='ANATBLLB152'/></td><!-- 사&nbsp;&nbsp;&nbsp;&nbsp;용&nbsp;&nbsp;&nbsp;&nbsp;자 -->
			<td class="td_body"><c:out value="${campInfo.userNm}"/></td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='ANATBLLB161'/></td><!-- 등 록 일 자 -->
			<td class="td_body">
				<fmt:parseDate var="campRegDt" value="${campInfo.regDt}" pattern="yyyyMMddHHmmss"/>
				<fmt:formatDate var="regDt" value="${campRegDt}" pattern="yyyy-MM-dd HH:mm:ss"/>
				<c:out value="${regDt}"/>
			</td>
		</tr>
	</table>
	</c:if>
	
	<br>
	
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line" colspan=6></td>
		</tr>
		<tr class="tr_head">
			<td colspan=6 align="left"><b><spring:message code='ANATBLTL152'/></b></td><!-- 메일 리스트 -->
		</tr>

	<c:if test="${fn:length(mailList) > 0}">
		<c:forEach items="${mailList}" var="mail">
		<tr>
			<td class="td_body" width=110 align="center" onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:pointer;"><b><c:out value='${mail.taskNo}'/></b></td>
			<td class="td_body" colspan=5 onClick="openMail('<c:out value='${mail.taskNo}'/>')" style="cursor:pointer;"><b><c:out value='${mail.taskNm}'/></b></td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB122'/></td><!-- 발송수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="sendCntNum" type="number" value="${mail.sendCnt}" /><c:out value="${sendCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="succCntNum" type="number" value="${mail.succCnt}" /><c:out value="${succCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="failCntNum" type="number" value="${mail.sendCnt - mail.succCnt}" /><c:out value="${failCntNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB012'/></td><!-- 오픈수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="openCntNum" type="number" value="${mail.openCnt}" /><c:out value="${openCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB013'/></td><!-- 유효오픈수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="validCntNum" type="number" value="${mail.validCnt}" /><c:out value="${validCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB015'/></td><!-- 수신거부 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="blockCntNum" type="number" value="${mail.blockCnt}" /><c:out value="${blockCntNum}"/>
			</td>
		</tr>
		</c:forEach>
	</c:if>
	<c:if test="${empty mailList}">
		<tr>
			<td class="td_body" width=110><b>&nbsp;</b></td>
			<td class="td_body" colspan=5>&nbsp;</td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB122'/></td><!-- 발송수 -->
			<td class="td_body" width=120 align="right">0</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
			<td class="td_body" width=120 align="right">0</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
			<td class="td_body" width=120 align="right">0</td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB012'/></td><!-- 오픈수 -->
			<td class="td_body" width=120 align="right">0</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB013'/></td><!-- 유효오픈수 -->
			<td class="td_body" width=120 align="right">0</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB015'/></td><!-- 수신거부 -->
			<td class="td_body" width=120 align="right">0</td>
		</tr>
	</c:if>

	<c:if test="${not empty mailTotal && pageUtil.totalPage == pageUtil.currPage}">
		<tr>
			<td class="td_body" width=110 align="center"><b><spring:message code='ANATBLLB112'/></b></td><!-- 합계 -->
			<td class="td_body" colspan=5>&nbsp;</td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB122'/></td><!-- 발송수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totSendCntNum" type="number" value="${mailTotal.sendCnt}" /><c:out value="${totSendCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totSuccCntNum" type="number" value="${mailTotal.succCnt}" /><c:out value="${totSuccCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totFailCntNum" type="number" value="${mailTotal.sendCnt - mailTotal.succCnt}" /><c:out value="${totFailCntNum}"/>
			</td>
		</tr>
		<tr>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB012'/></td><!-- 오픈수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totOpenCntNum" type="number" value="${mailTotal.openCnt}" /><c:out value="${totOpenCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB013'/></td><!-- 유효오픈수 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totValidCntNum" type="number" value="${mailTotal.validCnt}" /><c:out value="${totValidCntNum}"/>
			</td>
			<td class="td_body" width=110 align="center"><spring:message code='ANATBLLB015'/></td><!-- 수신거부 -->
			<td class="td_body" width=120 align="right">
				<fmt:formatNumber var="totBlockCntNum" type="number" value="${mailTotal.blockCnt}" /><c:out value="${totBlockCntNum}"/>
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
