<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.19
	*	설명 : 파일에서 대상자 추출
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	var totCount = "<c:out value='${totCount}'/>";
	$("#totCnt").val(totCount);
	
	var mergeKey = "<c:out value='${mergeKey}'/>";
	$("#mergeKey").val(mergeKey);
	$("#mergeCol").val(mergeKey);
});
</script>

    <table style="width: 100%" border="" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table border="1" cellspacing="0" cellpadding="0" width="100%" class="table_line_outline">
            
            	<c:if test="${'Success' eq result }">
					<tr height="23" class="tr_head">
						<c:forEach items="${memAlias}" var="memTitle">
							<td><c:out value="${memTitle}"/></td>
						</c:forEach>
					</tr>
					<c:forEach items="${memList}" var="member">
						<tr>
							<c:forEach items="${memAlias}" var="memTitle">
								<c:forEach items="${member}" var="mem">
									<c:if test="${memTitle eq mem.key}">
										<td><c:out value="${mem.value}"/></td>
									</c:if>
								</c:forEach>
							</c:forEach>
						</tr>
					</c:forEach>					
					
            	</c:if>
            	<c:if test="${'Fail' eq result}">
		            <tr bgcolor='white'>
		                <td height='378' width='100%' align="left" valign="top">
		                    <BR><BR>
		                    <font color='red'>
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    * Error!!<BR><BR>
		                    <c:set var="LINE"/>
		                    <c:set var="Error"/>
							<c:forEach items="${memList}" var="member">
								<c:forEach items="${member}" var="mem">
									<c:forEach items="${mem.key}" var="item">
										<c:if test="${'LINE' eq item}">
											<c:set var="LINE" value="${mem.value}"/>
										</c:if>
										<c:if test="${'Error' eq item}">
											<c:set var="Error" value="${mem.value}"/>
										</c:if>
									</c:forEach>
								</c:forEach>
							</c:forEach>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    * Line : <c:out value="${LINE}"/>
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    MSG : <c:out value="${Error}"/>
		                    </font>
            	</c:if>
            	
            </table>
        </td>
    </tr>
    </table>
    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height='20' align="center">
        ${pageUtil.pageHtml}
        </td>
    </tr>
    </table>