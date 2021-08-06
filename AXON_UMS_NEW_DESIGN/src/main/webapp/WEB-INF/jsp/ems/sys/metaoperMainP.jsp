<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.15
	*	설명 : 메타 관계식 처리 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="metaOperatorForm" name="metaOperatorForm">
<input type="hidden" name="colNo" value="<c:out value='${colNo}'/>">
<input type="hidden" name="colNm" value="<c:out value='${colNm }'/>">
<table border="1" cellspacing="1" cellpadding="0" class="table_line_outline" style="width:1000px">
	<tr class="tr_head">
		<td align="center">
			<b>[<c:out value="${colNm}"/>]</b> OPERATION
		</td>
	</tr>
	<tr class="tr_body">
		<td width="15%">

			<table width="100%" border="0">
				<c:if test="${fn:length(operCodeList) > 0}">
					<c:forEach items="${operCodeList}" var="operCode" varStatus="status">
						<c:if test="${status.count == 1}">
						<tr>
						</c:if>
						<td>
						<c:set var="checked" value=""/>
						<c:if test="${fn:length(metaOperatorList) > 0}">
							<c:forEach items="${metaOperatorList}" var="operVO">
								<c:if test="${operCode.cd eq operVO.operCd}"><c:set var="checked" value=" checked"></c:set></c:if>
							</c:forEach>
						</c:if>
						<input type="checkbox" name="operCd" value="<c:out value='${operCode.cd}'/>"<c:out value="${checked}"/>/> <c:out value='${operCode.cdDtl}'/> 
						</td>
						<c:if test="${status.count != 1 && status.count%3 == 0}">
						</tr>
						<tr>
						</c:if>
					</c:forEach>
				</c:if>
			</table>
		</td>
</table>
<div class="btn">
	<div class="btnR">
		<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goMetaOperUpdate()"><!-- 수정 -->
		<input type="reset" class="btn_typeC" value="<spring:message code='COMBTN009'/>"><!-- 재입력 -->
	</div>
</div>
</form>

<br/>

<form id="metaValueUpdate" name="metaValueUpdate">
<input type="hidden" name="colNo" value="<c:out value='${colNo}'/>">
<input type="hidden" name="colNm" value="<c:out value='${colNm }'/>">
<input type="hidden" name="valueNo"/>
<input type="hidden" name="valueNm"/>
<input type="hidden" name="valueAlias"/>
</form>
<form id="metaValueList" name="metaValueList">
<table width="280" border="1" cellspacing="1" cellpadding="0" class="table_line_outline" style="width:1000px">
	<tr class="tr_head">
		<td colspan="3">
			<b>[<c:out value="${colNm}"/>]</b> VALUE&nbsp;&nbsp;<!-- input type="button" value="<spring:message code='COMBTN004'/>" onClick="goAddf()" class="btn_style"--><!-- 신규등록 -->
		</td>
	</tr>
	<tr align="center">
		<td class="td_body tAlign" width="40%">VALUE</td>
		<td class="td_body tAlign" width="40%"><spring:message code='SYSTBLTL062'/></td><!-- 별칭 -->
		<td class="td_body tAlign" width="20%"><spring:message code='SYSTBLTL065'/></td><!-- 처리 -->
	</tr>
	<c:if test="${fn:length(metaValueList) > 0}">
		<c:set var="listSize" value="${fn:length(metaValueList)}"/>
		<c:forEach items="${metaValueList}" var="valueVO" varStatus="status">
			<tr>
				<td>
					<input type="text" name="valueNm" value="<c:out value='${valueVO.valueNm}'/>" size="10" maxlength="50">
				</td>
				<td>
					<input type="text" name="valueAlias" value="<c:out value='${valueVO.valueAlias}'/>" size="10" maxlength="50">
				</td>
				<td>
					<input type="button" value="<spring:message code='COMBTN007'/>" onClick="goMetaValueUpdate('<c:out value="${valueVO.valueNo}"/>','<c:out value="${status.index}"/>','<c:out value="${listSize}"/>')" class="btn_style"><!-- 수정 -->
					<input type="button" value="<spring:message code='COMBTN008'/>" onClick="goMetaValueDelete('<c:out value="${valueVO.valueNo}"/>')" class="btn_style"><!-- 삭제 -->
				</td>
			</tr>
		
		</c:forEach>
	</c:if>
</table>
</form>

<br/>
<br/>


<form id="metaValueForm" name="metaValueForm">
<input type="hidden" name="colNo" value="<c:out value='${colNo}'/>">
<input type="hidden" name="colNm" value="<c:out value='${colNm }'/>">
<table border="1" cellspacing="1" cellpadding="0" class="table_line_outline" style="width:1013px;">
	<tr class="tr_head">
		<td>VALUE</td>
		<td><spring:message code='SYSTBLTL062'/></td><!-- 별칭 -->
	</tr>
<%	for(int i = 0 ; i < 2; i++) {					%>
	<tr class="tr_body">
		<td>
			<input type="text" name="valueNm" value="" size="20" maxlength="50">
		</td>
		<td>
			<input type="text" name="valueAlias" value="" size="20" maxlength="50">
		</td>
	</tr>
<%	}												%>
</table>
<div class="btn">
	<div class="btnR">
		<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goMetaValueAdd()" /><!-- 등록 -->
		<input type="reset" value="<spring:message code='COMBTN009'/>" class="btn_typeC" /><!-- 재입력 -->
	</div>
</div>
</form>