<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.22
	*	설명 : DB CONNECTION 메타 정보 관리 메인화면을 출력
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<table class="table_line_outline typeS" border="1" cellspacing="0">
	<tr class="tr_head">
	    <td width="60%"><spring:message code="SYSTBLTL063"/></td><!-- 컬럼명 -->
		<td width="40%"><spring:message code="SYSTBLTL064"/></td><!-- 타입 -->
	</tr>
	<c:if test="${fn:length(realColumnList) > 0}">
		<c:forEach items="${realColumnList}" var="realColumn">
			<input type="hidden" name="colDataTyJdbc" value="<c:out value='${realColumn.colDataTyJdbc}'/>"/>
			<tr>
				<td><input type="text" name="colNm" value="<c:out value='${realColumn.colNm}'/>" size="30" readOnly></td>
				<td><input type="text" name="colDataTy" value="<c:out value='${realColumn.colDataTy}'/>" size="20" readOnly></td>
			</tr>
		</c:forEach>
	</c:if>
</table>