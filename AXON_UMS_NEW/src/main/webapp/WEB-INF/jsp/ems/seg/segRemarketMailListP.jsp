<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.12
	*	설명 : 메일 목록 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<table border="1" align="center" cellspacing="0" cellpadding="0" class="table_line_outline" style="width:100%;">
	<tr class="tr_head">
        <td width="22%" align=center>캠페인명</td>
        <td width="26%" align=center>메일명</td>
        <td width="22%" align=center>발송그룹명</td>
        <td width="7%" align=center>메일유형</td>
        <td width="10%" align=center>등록자</td>
        <td width="13%" align=center>예약일</td>
    </tr>
    <c:if test="${fn:length(mailList) > 0}">
    	<c:forEach items="${mailList}" var="mail">
	        <tr class="tr_body">
	            <td align=left>
	            	<c:out value="${mail.campNm }"/>
	            </td>
	            <td align=left>
	                <a href="JavaScript:window.opener.goMailSelect('<c:out value='${mail.taskNo}'/>','<c:out value='${mail.subTaskNo}'/>','<c:out value='${mail.taskNm}'/>');JavaScript:top.window.close();" title="<c:out value='${mail.taskNm}'/>">
	                	<c:if test="${mail.sendRepeat ne '000'}">[<c:out value="${mail.subTaskNo}"/>차]</c:if> <c:out value="${mail.taskNm}"/>
	                </a>
	            </td>
	            <td align=left>
	            	<c:out value="${mail.segNm}"/>
	            </td>
	            <td align=center><c:out value="${mail.sendRepeatNm}"/></td>
	            <td align=center><c:out value="${mail.userId }"/></td>
	            <td align=center>
	            	<fmt:parseDate var="sendDt" value="${mail.sendDt}" pattern="yyyyMMddHHmm"/>
					<fmt:formatDate var="dispSendDt" value="${sendDt}" pattern="yyyy-MM-dd HH:mm"/>
					<c:out value="${dispSendDt}"/>
	            </td>
	        </tr>
    	</c:forEach>
    </c:if>
</table>
