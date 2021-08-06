<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.13
	*	설명 : DB 사용 권한 목록 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>
<script type="text/javascript">

$(document).ready(function() {
	$("#btnAddMetaTable").click(function(e){
		e.preventDefault();
		goMetaTableAdd();
	});
	$("#btnUpdateMetaTable").click(function(e){
		e.preventDefault();
		goMetaTableUpdate();
	});
	
	$("#btnDeleteMetaTable").click(function(e){
		e.preventDefault();
		goMetaTableDelete();
	});
});
</script>

<!-- 메타 테이블 목록 Start -->
<table border="1" cellspacing="0" style="width:380px;">
	<tr class="tr_head">
		<td><spring:message code='SYSTBLTL060'/></td><!-- 메타테이블 -->
	</tr>
	<c:if test="${fn:length(realTableList) > 0}">
		<c:forEach items="${realTableList}" var="realTable">
			<c:set var="tblNo" value="${0}"/>
			<c:set var="tblAlias" value=""/>
			<c:if test="${fn:length(metaTableList) > 0}">
				<c:forEach items="${metaTableList}" var="metaTable">
					<c:if test="${fn:toUpperCase(realTable) eq fn:toUpperCase(metaTable.tblNm)}">
						<c:set var="tblNo" value="${metaTable.tblNo}"/>
						<c:set var="tblAlias" value="${metaTable.tblAlias}"/>
					</c:if>
				</c:forEach>
			</c:if>
			<tr>
				<td>
					<c:if test="${tblNo > 0}">
						<a href="javascript:goMetaTableInfo('<c:out value="${tblNo}"/>','<c:out value="${realTable}"/>')"><c:out value="${realTable}"/></a>
						<a href="javascript:goMetaTableInfo('<c:out value="${tblNo}"/>','<c:out value="${realTable}"/>')">[<c:out value="${tblAlias}"/>]</a>
					</c:if>
					<c:if test="${tblNo == 0 }">
						<a href="javascript:goMetaTableForm('<c:out value="${realTable}"/>')"><c:out value="${realTable}"/></a>
					</c:if>
				</td>
			</tr>
		</c:forEach> 
	</c:if>
</table>
<!-- 메타 테이블 목록 End -->

<br/>
<br/>

<!-- 메타 테이블 등록 Start -->
<div id="divMetaTableInfo" style="display:none;">
	<form id="metaTableInfo" name="metaTableInfo">
	<input type="hidden" name="dbConnNo" value="${dbConnNo}"/>
	<input type="hidden" id="tblNo" name="tblNo" value="${tblNo}"/>
	<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:998px;">
		<tr>
		    <td class="td_title" width="13%"><spring:message code='SYSTBLTL061'/></td><!-- 테이블명 -->
			<td class="td_body" width="37%">
				<input type="text" id="tblNm" name="tblNm" maxlength="30" value="" readOnly size="20">
			</td>
		    <td class="td_title" width="13%"><spring:message code='SYSTBLTL062'/></td><!-- 별칭 -->
			<td class="td_body" width="37%">
				<input type="text" id="tblAlias" name="tblAlias" maxlength="100" value="" size="30">
			</td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL058'/></td><!-- 설명 -->
			<td class="td_body" colspan="4">
				<textarea id="tblDesc" name="tblDesc" cols="70" rows="1"></textarea>
			</td>
		</tr>
	</table>
	<div id="divMetaTableInsertBtn" style="width:900px;text-align:right;align:right;" style="display:none;">
		<input type="button" id="btnAddMetaTable" value="<spring:message code='COMBTN005'/>" class="btn_typeC"><!-- 등록 -->
		<input type="reset" value="<spring:message code='COMBTN009'/>" class="btn_typeC"><!-- 재입력 -->
	</div>
	<div id="divMetaTableUpdateBtn" style="width:900px;text-align:right;align:right;" style="display:none;">
		<input type="button" id="btnDeleteMetaTable" value="<spring:message code='COMBTN008'/>" class="btn_typeC"><!-- 삭제 -->
		<input type="button" id="btnUpdateMetaTable" value="<spring:message code='COMBTN007'/>" class="btn_typeC"><!-- 수정 -->
		<input type="reset" value="<spring:message code='COMBTN009'/>" class="btn_typeC"><!-- 재입력 -->
	</div>
	</form>
</div>
<!-- 메타 테이블 등록 End -->

<br/>
<br/>

<!-- 메타 컬럼 등록 Start -->
<div id="divMetaColumnInfo" style="display:none;"></div>
<!-- 메타 컬럼 등록 End -->

<br/>
<br/>

<!-- 메타 관계식,관계값 등록 Start -->
<div id="divMetaOperValueInfo" style="display:none;"></div>
<!-- 메타 관계식 등록 End -->

