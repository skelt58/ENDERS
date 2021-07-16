<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.16
	*	설명 : 메타조인 관리 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<script type="text/javascript">

</script>

<form id="metaJoinUpdateData" name="metaJoinUpdateData">
<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>"/>
<input type="hidden" name="joinNo"/>
<input type="hidden" name="mstTblNm"/>
<input type="hidden" name="mstColNm"/>
<input type="hidden" name="forTblNm"/>
<input type="hidden" name="forColNm"/>
<input type="hidden" name="joinTy"/>
<input type="hidden" name="relTy"/>
</form>

<form id="metaJoinUpdateForm" name="metaJoinUpdateForm">
<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>"/>
<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:998px;">
	<tr class="tr_head" align="center">
		<td><spring:message code='SYSTBLTL066'/></td><!-- 마스터키정보 -->
		<td><spring:message code='SYSTBLTL067'/></td><!-- 포린키정보 -->
		<td><spring:message code='SYSTBLTL068'/></td><!-- 조인유형 -->
		<td><spring:message code='SYSTBLTL069'/></td><!-- 관계유형 -->
		<td><spring:message code='SYSTBLTL065'/></td><!-- 처리 -->
	</tr>
	<c:choose>
		<c:when test="${fn:length(metaJoinList) > 0}">
			<c:set var="metaJoinCnt" value="${fn:length(metaJoinList)}"/>
			<c:forEach items="${metaJoinList}" var="metaJoin" varStatus="joinStatus">
				<input type="hidden" name="joinNo" value="<c:out value='${metaJoin.joinNo}'/>">
				<tr align="center">
					<td>
						[T]<input type="text" name="mstTblNm" value="<c:out value='${metaJoin.mstTblNm}'/>" size="15" readOnly class="readonly_style"><br>
						[C]<input type="text" name="mstColNm" value="<c:out value='${metaJoin.mstColNm}'/>" size="15" readOnly class="readonly_style">
					</td>
					<td>
						[T]<input type="text" name="forTblNm" value="<c:out value='${metaJoin.forTblNm}'/>" size="15" readOnly class="readonly_style"><br>
						[C]<input type="text" name="forColNm" value="<c:out value='${metaJoin.forColNm}'/>" size="15" readOnly class="readonly_style">
					</td>
					<td>
						<select name="joinTy">
							<c:if test="${fn:length(joinTyList) > 0}">
								<c:forEach items="#{joinTyList}" var="joinTy">
									<c:set var="joinTySelected" value=""/>
									<c:if test="${metaJoin.joinTy eq joinTy.cd}">
										<c:set var="joinTySelected" value=" selected"/>
									</c:if>
									<option value="<c:out value='${joinTy.cd}'/>"<c:out value='${joinTySelected}'/>><c:out value='${joinTy.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<td>
						<select name="relTy">
							<c:if test="${fn:length(relTyList) > 0}">
								<c:forEach items="#{relTyList}" var="relTy">
									<c:set var="relTySelected" value=""/>
									<c:if test="${metaJoin.relTy eq relTy.cd}">
										<c:set var="relTySelected" value=" selected"/>
									</c:if>
									<option value="<c:out value='${relTy.cd}'/>"<c:out value='${relTySelected}'/>><c:out value='${relTy.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<td align="center">
						<input type="button" value="<spring:message code='COMBTN007'/>" onClick="goMetaJoinUpdate('<c:out value='${metaJoin.joinNo}'/>','<c:out value='${joinStatus.index}'/>','<c:out value='${metaJoinCnt}'/>')" class="btn_style"><!-- 수정 -->
						<input type="button" value="<spring:message code='COMBTN008'/>" onClick="goMetaJoinDelete('<c:out value='${metaJoin.joinNo}'/>')" class="btn_style"><!-- 삭제 -->
					</td>
				</tr>
				
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr class="tr_body">
				<td align="center" colspan="5">데이터가 없습니다.</td>
			</tr>
		</c:otherwise>
	</c:choose>
</table>
</form>

<br/>
<br/>

<form id="metaJoinInsertForm" name="metaJoinInsertForm">
<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>"/>
<input type="hidden" name="page" value="0"/>
<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:998px;">
	<tr class="tr_head">
		<td width="100%" colspan="2"><spring:message code='SYSTBLTL066'/></td><!-- 마스터키정보 -->
	</tr>
	<tr>
		<td align="center" width="30%" class="td_body"><spring:message code='SYSTBLTL070'/></td><!-- 테이블 -->
		<td bgcolor="white" width="70%">
			<select name="mstTblNm" onChange="setTableColumn('mstColNm', this.value)">
				<option value="">:::<spring:message code='SYSTBLLB009'/>:::</option><!-- 테이블을 선택하세요. -->
				<c:if test="${fn:length(metaTableList) > 0}">
					<c:forEach items="${metaTableList}" var="metaTable">
						<option value="<c:out value='${metaTable.tblNm}'/>"><c:out value='${metaTable.tblNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
	<tr height="20">
		<td align="center"  class="td_body"><spring:message code='SYSTBLTL071'/></td><!-- 키컬럼 -->
		<td bgcolor="white">
			<select name="mstColNm">
				<option value="">:::<spring:message code='SYSTBLLB010'/>:::</option><!-- 컬럼을 선택하세요. -->
			</select>
		</td>
	</tr>
</table>
<br>
<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:998px;">
	<tr class="tr_head">
		<td width="50%"><spring:message code='SYSTBLTL068'/></td><!-- 조인유형 -->
		<td width="50%"><spring:message code='SYSTBLTL069'/></td><!-- 관계유형 -->
	</tr>
	<tr class="tr_body">
		<td align="center">
			<select name="joinTy">
				<c:if test="${fn:length(joinTyList) > 0}">
					<c:forEach items="${joinTyList}" var="joinTy">
						<option value="<c:out value='${joinTy.cd}'/>"><c:out value='${joinTy.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
		<td align="center">
			<select name="relTy">
				<c:if test="${fn:length(relTyList) > 0}">
					<c:forEach items="${relTyList}" var="relTy">
						<option value="<c:out value='${relTy.cd}'/>"><c:out value='${relTy.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
</table>
<br>
<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:998px;">
	<tr class="tr_head">
		<td width="100%" colspan="2"><spring:message code='SYSTBLTL067'/></td><!-- 포린키정보 -->
	</tr>
	<tr>
		<td align="center" width="30%" class="td_body"><spring:message code='SYSTBLTL070'/></td><!-- 테이블 -->
		<td bgcolor="white" width="70%">
			<select name="forTblNm" onChange="setTableColumn('forColNm', this.value)">
				<option value="">:::<spring:message code='SYSTBLLB009'/>:::</option><!-- 테이블을 선택하세요. -->
				<c:if test="${fn:length(metaTableList) > 0}">
					<c:forEach items="${metaTableList}" var="metaTable">
						<option value="<c:out value='${metaTable.tblNm}'/>"><c:out value='${metaTable.tblNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
	<tr height="20">
		<td align="center" class="td_body"><spring:message code='SYSTBLTL071'/></td><!-- 키컬럼 -->
		<td bgcolor="white">
			<select name="forColNm">
			<option value="">:::<spring:message code='SYSTBLLB010'/>:::</option><!-- 컬럼을 선택하세요. -->
			</select>
		</td>
	</tr>
</table>
<div class="btn">
	<div class="btnR">
		<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goMetaJoinAdd()"><!-- 등록 -->
		<input type="reset" value="<spring:message code='COMBTN009'/>" class="btn_typeC"><!-- 재입력 -->
	</div>
</div>
</form>
