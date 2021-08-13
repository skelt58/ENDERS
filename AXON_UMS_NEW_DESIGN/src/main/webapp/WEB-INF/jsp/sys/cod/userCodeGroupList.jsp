<%--
	/**********************************************************
	*	작성자 : 김준희
	*	작성일시 : 2021.08.05
	*	설명 : 분류코드 목록
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="listForm" name="listForm" method="post">
<table width="1000" border="1" cellspacing="0" cellpadding="0">
	<tr class="tr_head">
		<td align="center" width="5%">NO</td>
		<td align="center" width="10%"><input type="checkbox" id="userCodeGrouupAllChk" name="userCodeGrouupAllChk" onclick='selectAll(this)'></td>
		<td align="center" width="10%">분류코드</td>
		<td align="left"width="15%">분류명</td>
		<td align="left"width="15%">상위코드</td>
		<td align="left"width="25%">설명</td>
		<td align="center"width="10%">사용여부</td>
		<td style="visibility:hidden;position:absolute;">분류코드</td>
	</tr>
	<c:if test="${fn:length(userCodeGroupList) > 0}">
		<c:forEach items="${userCodeGroupList}" var="userCodeGroup" varStatus="userCodeGroupStatus">				
			<tr class="tr_body">
				<td align="center">${userCodeGroupStatus.count}</td>			
				<td align="center">
					<c:if test="${userCodeGroup.sysYn eq 'Y'}">
						<input type="checkbox" id="userCodeGrouupDelYn" name="userCodeGrouupDelYn" disabled="disabled">
					</c:if> 
					<c:if test="${userCodeGroup.sysYn eq 'N'}">
						<input type="checkbox" id="userCodeGrouupDelYn" name="userCodeGrouupDelYn">
					</c:if> 							
				</td>					
				<td align="center">
					<a href="javascript:goSelect('<c:out value='${userCodeGroup.cdGrp}'/>')"><c:out value='${userCodeGroup.cdGrp}'/></a>
				</td>
				<!-- <td align="left" ondblclick="goSearch()"><c:out value='${userCodeGroup.cdGrpNm}'/></td> -->
				<td align="left">
					<a href="javascript:goSelect('<c:out value='${userCodeGroup.cdGrp}'/>')"><c:out value='${userCodeGroup.cdGrpNm}'/></a>
				</td>				
				<td align="left"><c:out value='${userCodeGroup.upCdGrpNm}'/></td>				
				<td align="left"><c:out value='${userCodeGroup.cdGrpDtl}'/></td>
				<td align="center"><c:out value='${userCodeGroup.useYn}'/></td>				
				<td style="visibility:hidden;position:absolute;"><c:out value='${userCodeGroup.cdGrp}'/></td>	
			</tr>
		</c:forEach>
	</c:if>
	<c:set var="emptyCnt" value="${pageUtil.pageRow - fn:length(userCodeGroupList)}"/>
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
				<td style="visibility:hidden;position:absolute;"></td>
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
