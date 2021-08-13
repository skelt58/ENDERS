<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 통계분석 정기메일분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="listForm" name="listForm" method="post">
<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td width="3%">
			<label for="checkbox_all"><input type="checkbox" id="checkbox_all" name="isAll" onclick='goAll()'><span></span></label>
		</td>
		<td width="10%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
		<td width="23%"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
		<td width="24%"><spring:message code='ANATBLTL010'/></td><!-- 발송그룹명 -->
		<td width="10%"><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
		<td width="10%"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
		<td width="10%"><spring:message code='ANATBLTL011'/></td><!-- 발송상태 -->
		<td width="10%"><spring:message code='ANATBLTL001'/></td><!-- 메일별분석 -->
	</tr>
	<c:if test="${fn:length(taskList) > 0}">
		<c:forEach items="${taskList}" var="mail" varStatus="mailStatus">
			<tr class="tr_body">
				<td height="30">
					<label for="checkbox_<c:out value='${mailStatus.count}'/>"><input type="checkbox" id="checkbox_<c:out value='${mailStatus.count}'/>" name="taskNos" value="<c:out value='${mail.taskNo}'/>"><span></span></label>
				</td>
				<td><c:out value='${mail.campNm}'/></td>
				<td><a href="javascript:goOz('tab1','<c:url value='/ems/ana/taskSummP.ums'/>','<c:out value='${mail.taskNo}'/>')"><c:out value='${mail.taskNm}'/></a></td>
				<td><c:out value='${mail.segNm}'/></td>
				<td><c:out value='${mail.userNm}'/></td>
				<td>
					<fmt:parseDate var="regDt" value="${mail.regDt}" pattern="yyyyMMddHHmmss"/>
					<fmt:formatDate var="mailRegDt" value="${regDt}" pattern="yyyy-MM-dd"/>
					<c:out value='${mailRegDt}'/>
				</td>
				<td><c:out value='${mail.statusNm}'/></td>
				<td><input type="button" value="<spring:message code='ANATBLTL001'/>" class="btn_style" onClick="goTaskStep('<c:out value='${mail.taskNo}'/>')"></td><!-- 메일별분석 -->
			</tr>
		</c:forEach>
	</c:if>
	<c:set var="emptyCnt" value="${searchVO.rows - fn:length(taskList)}"/>
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
