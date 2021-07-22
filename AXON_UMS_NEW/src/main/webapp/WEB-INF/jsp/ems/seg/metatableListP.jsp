<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.22
	*	설명 : DB CONNECTION 메타 정보 관리 메인화면을 출력
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<table style="width:100%">
	<tr>
		<td valign="top">
			<div style="width:320px;height:800px;">
				<table class="table_line_outline typess" border="1" cellspacing="0">
					<tr class="tr_head">
						<td>
							<spring:message code="SYSTBLTL060"/><!-- 메타테이블 -->
						</td>
					</tr>
					<c:if test="${fn:length(realTableList) > 0}">
						<c:forEach items="${realTableList}" var="realTable">
							<tr class="tr_body">
								<td align="left">
									<a href="javascript:goColumnInfo('<c:out value="${realTable}"/>')"><c:out value="${realTable}"/></a>
								</td>
							</tr>
						</c:forEach>
					</c:if>
			</table>
			</div>
		</td>
		<td valign="top">
			<div id="divMetaColumnInfo" style="width:520px;height:800px;"></div>
		</td>
	</tr>
</table>