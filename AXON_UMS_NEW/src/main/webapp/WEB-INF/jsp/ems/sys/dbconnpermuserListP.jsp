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
	$("#btnAdd").click(function(e){
		e.preventDefault();
		goConnPermAdd();
	});
	
	$("#btnReset").click(function(e){
		e.preventDefault();
		$("#dbConnPermForm")[0].reset();
	});
});
</script>


<form id="dbConnPermForm" name="dbConnPermForm" method="post">
	<input type="hidden" name="dbConnNo" value="<c:out value='${dbConnNo}'/>">
	<table border="1" style="width: 1015px;">
	   	<colgroup>
	   		<col style="width:10%">
	   		<col style="width:30%">
	   		<col style="width:60%">
	   	</colgroup>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL059'/></td><!-- 그룹선택 -->
			<td class="td_title"><spring:message code='SYSTBLTL017'/></td><!-- 그룹 -->
			<td class="td_title"><spring:message code='SYSTBLTL023'/></td><!-- 사용자 -->
		</tr>
		<c:if test="${fn:length(deptList) > 0}">
			<c:forEach items="${deptList}" var="deptVO">
				<tr>
					<td>
						<input type="checkbox" name="selAll" onclick="setAllUser('<c:out value='${deptVO.cd}'/>',this.checked)">
					</td>
					<td>
						<c:out value="${deptVO.cdNm}"/>
					</td>
					<td>
						<c:if test="${fn:length(dbConnPermList) > 0}">
						<table>
							<c:forEach items="${dbConnPermList}" var="dbConnPermVO" varStatus="status">
								<c:if test="${status.index == 1}">
								<tr>
								</c:if>
									<c:if test="${dbConnPermVO.deptNo eq deptVO.cd}">
										<td>
											<input type="hidden" name="deptNo" value="<c:out value='${dbConnPermVO.deptNo}'/>">
											<c:set var="checked" value=""/>
											<c:if test="${dbConnPermVO.permYn eq 'Y'}"><c:set var="checked" value=" checked"/></c:if>
											<input type="checkbox" name="userId" value="<c:out value='${dbConnPermVO.userId}'/>" <c:out value="${checked}"/>> <c:out value='${dbConnPermVO.userId}'/>
										</td>
									</c:if>
								<c:if test="${status.index%4 == 0}">
								</tr>
								<tr>
								</c:if>
							</c:forEach>
						</table>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
	<div class="btn">
		<div class="btnR">
	      	<input type="button" id="btnAdd" class="btn_typeC" value="<spring:message code='COMBTN005'/>"><!-- 등록 -->
	        <input type="button" id="btnReset" class="btn_typeC" value="<spring:message code='COMBTN009'/>"><!-- 재입력 -->
		</div>
	</div>
</form>