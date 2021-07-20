<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.20
	*	설명 : 연결된 테이블/컬럼 설정 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>


<table border="0" cellspacing="25" cellpadding="0">
	<tr>
    	<td colspan="3" height="5"></td>
	</tr>
    <tr>
	    <c:set var="tblListCnt" value="${3}"/>
	    <c:set var="cnt" value="${0}"/>
	    <c:if test="${fn:length(metaTableList) > 0}">
	    	<c:forEach items="${metaTableList}" var="metaTable">
	    		<c:set var="cnt" value="${cnt+1}"/>
	    		<td valign="top">
	    		<table border="1">
	    			<tr>
		    			<td colspan="2" align="center">
		    				<c:out value="${metaTable.tblAlias}"/>
		    				<input type="checkbox" name="metaTblNm" value="<c:out value="${metaTable.tblNm}"/>">
		    			</td>
		    		</tr>
		    		<c:if test="${fn:length(metaColumnList) > 0}">
		    			<c:forEach items="${metaColumnList}" var="metaColumn">
		    				<c:if test="${metaTable.tblNo == metaColumn.tblNo}">
		    					<tr>
		    						<td width="25">
		    							<input type="checkbox" name="metaColInfo" value="<c:out value="${metaTable.tblNm}"/>.<c:out value="${metaColumn.colNm}"/> AS <c:out value="${metaColumn.colAlias}"/>" onclick='goColumnClick()'>
		    						</td>
		    						<td width="230"><c:out value="${metaColumn.colAlias}"/></td>
		    					</tr>
		    				</c:if>
		    			</c:forEach>
		    		</c:if>
	    		</table>
	    		</td>
	    		<c:if test="${cnt != 1 && cnt%tblListCnt == 0}">
				</tr>
				<tr><td colspan='5' height='5'></td></tr>
				<tr>
	    		</c:if>
	    	</c:forEach>
	    </c:if>
	    <c:if test="${cnt != 0 &&  cnt % tblListCnt == 1}">
		<td colspan='2'></td></tr>
	    </c:if>
	    <c:if test="${cnt != 0 &&  cnt % tblListCnt == 2}">
	    <td width=260></td></tr>
	    </c:if>
	    <tr>
	        <td colspan="3" height="5"></td>
	    </tr>
</table>
