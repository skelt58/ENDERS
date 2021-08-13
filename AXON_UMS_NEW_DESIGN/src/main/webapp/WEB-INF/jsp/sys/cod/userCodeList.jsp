<%--
	/**********************************************************
	*	작성자 : 김준희
	*	작성일시 : 2021.08.05
	*	설명 : 코드 목록
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="listForm" name="listForm" method="post">
<table width="1000" border="1" cellspacing="0" cellpadding="0">
	<tr class="tr_head">
		<td align="center" width="5%">NO</td>
		<td align="center" width="10%"><input type="checkbox" id="userCodeAllChk" name="userCodeAllChk" onclick='selectAll(this)'></td>
		<td align="center" width="10%">공통코드</td>
		<td align="left"width="15%">공통코드명</td>
		<td align="left"width="15%">상위코드</td>
		<td align="left"width="25%">설명</td>
		<td align="center"width="10%">사용여부</td>
		<td style="visibility:hidden;position:absolute;">시스템여부</td>
		<td style="visibility:hidden;position:absolute;">공통코드</td>
		<td style="visibility:hidden;position:absolute;">공통코드그룹</td>
	</tr>
	<c:if test="${fn:length(userCodeList) > 0}">
		<c:forEach items="${userCodeList}" var="userCode" varStatus="userCodeStatus">				
			<tr class="tr_body">
				<td align="center">${userCodeStatus.count}</td>			
				<td align="center">
					<c:if test="${userCode.sysYn eq 'Y'}">
						<input type="checkbox" name="userCodeDelYn" disabled="disabled">
					</c:if> 
					<c:if test="${userCode.sysYn eq 'N'}">
						<input type="checkbox" name="userCodeDelYn">
					</c:if> 							
				</td>					
				<td align="center">	<c:out value='${userCode.cd}'/></td>				
				<td align="left" onClick="goSelect(this)"><c:out value='${userCode.cdNm}'/></td>	
				<td align="left"><c:out value='${userCode.upCdNm}'/></td>
				<td align="left"><c:out value='${userCode.cdDtl}'/></td>
				<td align="center"><c:out value='${userCode.useYn}'/></td>
				<td style="visibility:hidden;position:absolute;"><c:out value='${userCode.sysYn}'/></td>
				<td style="visibility:hidden;position:absolute;"><c:out value='${userCode.cd}'/></td>	
				<td style="visibility:hidden;position:absolute;"><c:out value='${userCode.cdGrp}'/></td>
			</tr>
		</c:forEach>
	</c:if>
	<c:set var="emptyCnt" value="${pageUtil.pageRow - fn:length(userCodeList)}"/>
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
