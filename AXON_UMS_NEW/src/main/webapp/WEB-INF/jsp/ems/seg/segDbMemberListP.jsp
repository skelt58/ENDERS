<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.21
	*	설명 : 대상자보기(미리보기)에서 DB 멤버 조회
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<table class="popWordbreak" style="width: 100%">
    <tr>
        <td>
            <table style="width: 100%" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
            
            <tr height="23" class="tr_head">
            	<c:forTokens items="${segmentVO.mergeKey}" delims="," var="mergeKey" varStatus="keyStatus">
            		<td><c:out value="${mergeKey}"/></td>
            	</c:forTokens>
            </tr>
			<c:if test="${fn:length(memberList) > 0}">
				<c:forEach items="${memberList}" var="member" varStatus="memberStatus">
					<tr>
						<c:forTokens items="${segmentVO.mergeKey}" delims="," var="mergeKey">
							<c:forEach items="${member}" var="mem">
								<c:if test="${mem.key eq mergeKey}">
									<td><c:out value="${mem.value}"/></td>
								</c:if>
							</c:forEach>
						</c:forTokens>
					</tr>
				</c:forEach>
			</c:if>
            </table>
        </td>
    </tr>
    </table>
    <table style="width: 100%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height='20' align="center">
        ${pageUtil.pageHtml}
        </td>
    </tr>
</table>
