<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.14
	*	설명 : 메타 컬럼 처리 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="metaColumnDataForm">
<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>">
<input type="hidden" name="tblNo" value="<c:out value='${tblNo}'/>">
<input type="hidden" name="tblNm" value="<c:out value='${tblNm}'/>">
<input type="hidden" name="colNo" value="0"/>
<input type="hidden" name="colNm"/>
<input type="hidden" name="colAlias"/>
<input type="hidden" name="colDataTy"/>
<input type="hidden" name="colDataTyJdbc"/>
<input type="hidden" name="colDesc"/>
</form>

<form id="metaColumnForm" name="metaColumnForm">
<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>">
<input type="hidden" name="tblNo" value="<c:out value='${tblNo}'/>">
<input type="hidden" name="tblNm" value="<c:out value='${tblNm}'/>">
<table border="1" cellspacing="1" cellpadding="0" class="table_line_outline" style="width:998px;">
	<tr class="tr_head">
	    <td width="19%"><spring:message code='SYSTBLTL063'/></td><!-- 컬럼명 -->
		<td width="19%"><spring:message code='SYSTBLTL062'/></td><!-- 별칭 -->
		<td width="15%"><spring:message code='SYSTBLTL064'/></td><!-- 타입 -->
		<td width="23%"><spring:message code='SYSTBLTL058'/></td><!-- 설명 -->
		<td width="25%"><spring:message code='SYSTBLTL065'/></td><!-- 처리 -->
	</tr>
	<c:if test="${fn:length(realColumnList) > 0}">
		<c:set var="realColumnListSize" value="${fn:length(realColumnList)}"/>
		<c:forEach items="${realColumnList}" var="realColumn" varStatus="status">
			<c:set var="colNo" value="${0}"/>
			<c:set var="colDesc" value=""/>
			<c:set var="colAlias" value=""/>
			<c:if test="${fn:length(metaColumnList) > 0}">
				<c:forEach items="${metaColumnList}" var="metaColumn">
					<c:if test="${fn:toUpperCase(realColumn.colNm) eq fn:toUpperCase(metaColumn.colNm)}">
						<c:set var="colNo" value="${metaColumn.colNo}"/>
						<c:set var="colDesc" value="${metaColumn.colDesc}"/>
						<c:set var="colAlias" value="${metaColumn.colAlias}"/>
					</c:if>
				</c:forEach>
			</c:if>
			<input type="hidden" name="colDataTyJdbc" value="${realColumn.colDataTyJdbc}"/>
			<input type="hidden" name="colNo" value="${colNo}"/>
			<tr>
				<td>
					<input type="text" name="colNm" value="<c:out value='${realColumn.colNm}'/>" readOnly size="15" maxlength="50"  class="readonly_style">
				</td>
				<td>
					<input type="text" name="colAlias" value="<c:out value='${colAlias}'/>" size="15" maxlength="20">
				</td>
				<td>
					<input type="text" name="colDataTy" value="<c:out value='${realColumn.colDataTy}'/>" maxlength="20" size="10" readOnly class="readonly_style">
				</td>
				<td>
					<textarea name="colDesc" rows="1" cols="18"><c:out value='${colDesc}'/></textarea>
				</td>
				<td>
				<c:if test="${colNo == 0}">
					<input type="button" value="<spring:message code='COMBTN005'/>" onClick="goMetaColumnUpdate('','<c:out value='${status.index}'/>','<c:out value='${realColumnListSize}'/>')" class="btn_style"><!-- 등록 -->
				</c:if>
				<c:if test="${colNo != 0}">
					<input type="button" value="<spring:message code='COMBTN008'/>" onClick="goMetaColumnDelete('<c:out value='${colNo}'/>')" class="btn_style"><!--삭제 -->
					<input type="button" value="<spring:message code='COMBTN007'/>" onClick="goMetaColumnUpdate('<c:out value='${colNo}'/>','<c:out value='${status.index}'/>','<c:out value='${realColumnListSize}'/>')" class="btn_style"><!-- 수정 -->
					<input type="button" value="OPER" onClick="goMetaOperation('<c:out value='${colNo}'/>','<c:out value='${realColumn.colNm}'/>')" class="btn_style">
				</c:if>
				</td>
			</tr>
		</c:forEach>
	</c:if>
</table>
</form>
