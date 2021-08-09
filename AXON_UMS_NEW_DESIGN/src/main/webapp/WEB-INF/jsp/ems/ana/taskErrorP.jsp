<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.09
	*	설명 : 통계분석 정기메일분석 세부에러 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
function openError(step1, step2, step3) {
	var url = "<c:url value='/ems/ana/failListP.ums'/>?taskNo=<c:out value='${taskVO.taskNo}'/>&subTaskNo=<c:out value='${taskVO.subTaskNo}'/>";
	url = url + "&step1=" + step1 + "&step2=" + step2 + "&step3=" + step3;
	var feature = "menubar=no, scrollbars=no, toolbar=no, width=800, height=500, top=0, left=0";
	window.open(url, "", feature);
}
</script>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL111'/></td><!-- 세부에러 -->
	</tr>
</table>

<br>

<c:if test="${not empty mailInfo}">
<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=2></td>
	</tr>
	<tr class="tr_head">
		<td colspan=2 align=left><b><spring:message code='ANATBLTL102'/></b></td><!-- 메일정의 -->
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

<c:set var="totCnt" value="${0}"/>
<c:if test="${fn:length(errorList) > 0}">
	<c:forEach items="${errorList}" var="error">
		<c:set var="totCnt" value="${totCnt + error.cntStep3}"/>
	</c:forEach>
</c:if>
<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=3></td>
	</tr>
	<tr class="tr_head">
		<td colspan=3 align=left><b><spring:message code='ANATBLLB113'/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code='ANATBLLB114'/> : <c:out value='${totCnt}'/></b></td><!-- 메일 에러 종류별 건수 / 총에러건수 -->
	</tr>
</table>

<table width="700" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="td_body" width=150 align=center style="border-right:solid 1px;border-left:solid 1px;"><spring:message code='ANATBLLB115'/></td><!-- 대분류건수 -->
		<td class="td_body" width=200 align=center style="border-right:solid 1px"><spring:message code='ANATBLLB116'/></td><!-- 중분류건수 -->
		<td class="td_body" width=350 align=center style="border-right:solid 1px"><spring:message code='ANATBLLB117'/></td><!-- 소분류건수 -->
	</tr>
	
	<c:set var="tmpNmStep1" value=""/>
	<c:set var="tmpNmStep2" value=""/>
	<c:set var="nmStep1" value=""/>
	<c:set var="nmStep2" value=""/>
	<c:set var="step1" value=""/>
	<c:set var="step2" value=""/>
	<c:set var="step3" value=""/>
	<c:set var="cntStep1" value="${0}"/>
	<c:set var="cntStep2" value="${0}"/>
	<c:set var="cntStep3" value="${0}"/>
	<c:set var="htmlStr" value=""/>
	<c:if test="${fn:length(errorList) > 0}">
		<c:forEach items="${errorList}" var="error">
			<c:set var="nmStep1" value="${error.nmStep1}"/>
			<c:set var="nmStep2" value="${error.nmStep2}"/>
			<c:set var="step1" value="${error.step1}"/>
			<c:set var="step2" value="${error.step2}"/>
			<c:set var="step3" value="${error.step3}"/>
			<c:set var="cntStep1" value="${error.cntStep1}"/>
			<c:set var="cntStep2" value="${error.cntStep2}"/>
			<c:set var="cntStep3" value="${error.cntStep3}"/>
			
			<tr>
				<c:choose>
					<c:when test="${cntStep1 > 0}">
						<c:set var="htmlStr" value=" onclick=openError('${step1}','','') style='cursor:pointer;'"/>
					</c:when>
					<c:otherwise>
						<c:set var="htmlStr" value=""/>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${not empty tmpNmStep1 && tmpNmStep1 eq nmStep1}">
						<td class="td_body" width=150 align=right style="border-right:solid 1px;border-left:solid 1px;"${htmlStr}>&nbsp;</td>
					</c:when>
					<c:otherwise>
						<td class="td_body" width=150 align=right style="border-top:solid 1px;border-right:solid 1px;border-left:solid 1px;"${htmlStr}>
							<c:out value='${nmStep1}'/> : <fmt:formatNumber var="cntStep1Num" type="number" value="${cntStep1}" /><c:out value="${cntStep1Num}"/>
						</td>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${cntStep2 > 0}">
						<c:set var="htmlStr" value=" onclick=openError('${step1}','${step2}','') style='cursor:pointer;'"/>
					</c:when>
					<c:otherwise>
						<c:set var="htmlStr" value=""/>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${not empty tmpNmStep2 && tmpNmStep2 eq nmStep2}">
						<td class="td_body" width=200 align=right style="border-right:solid 1px;"${htmlStr}>&nbsp;</td>
					</c:when>
					<c:otherwise>
						<td class="td_body" width=200 align=right style="border-top:solid 1px;border-right:solid 1px;"${htmlStr}>
							<c:out value='${nmStep2}'/> : <fmt:formatNumber var="cntStep2Num" type="number" value="${cntStep2}" /><c:out value="${cntStep2Num}"/>
						</td>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${cntStep3 > 0}">
						<c:set var="htmlStr" value=" onclick=openError('${step1}','${step2}','${step3}') style='cursor:pointer;'"/>
					</c:when>
					<c:otherwise>
						<c:set var="htmlStr" value=""/>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${empty error.nmStep3}">
						<td class="td_body" width=350 align=right style="border-top:solid 1px;border-right:solid 1px"${htmlStr}>
							<c:out value='${nmStep2}'/> : <fmt:formatNumber var="cntStep2Num" type="number" value="${cntStep2}" /><c:out value="${cntStep2Num}"/>
						</td>
					</c:when>
					<c:otherwise>
						<td class="td_body" width=350 align=right style="border-top:solid 1px;border-right:solid 1px"${htmlStr}>
							<c:out value='${error.nmStep3}'/> : <fmt:formatNumber var="cntStep3Num" type="number" value="${cntStep3}" /><c:out value="${cntStep3Num}"/>
						</td>
					</c:otherwise>
				</c:choose>
			</tr>
			<c:set var="tmpNmStep1" value="${nmStep1}"/>
			<c:set var="tmpNmStep2" value="${nmStep2}"/>
		</c:forEach>
	</c:if>
	<tr>
		<td colspan=3 style="border-top:solid 1px;font-size:1pt">&nbsp;</td>
	</tr>
</table>

</body>
</html>
