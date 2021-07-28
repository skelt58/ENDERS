<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.28
	*	설명 : 웹에이전트 팝업 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	$("#webUrl").focus();
});

function webAgentSubmit() {
	var webAgentUrl = $("#webUrl").val();
	
	if(webAgentUrl == "") {
        alert("URL을 입력해 주세요!!");
        return;
    } else {
		opener.setWebAgent(webAgentUrl);
		window.close();
    }
}
</script>

<form id="webAgent" name="webAgent" method="post">
<table width="390" height="200" align="center" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr height=40>
    	<td align=center valign=top>
        	<table style="width:390px; text-align:center; border:none;" cellspacing="1" cellpadding="0" class="table_line_outline">
        		<tr class='tr_head'>
            		<td align="left">&nbsp;&nbsp;<b>Web Agent 추가</b></td>
        		</tr>
        		<tr class='tr_body' height=30>
            		<td align="left">
                		<BR>&nbsp;&nbsp;Web Agent를 이용하여 웹페이지나 CGI, ASP, Servlet, JSP 등으로
                		<BR>&nbsp;&nbsp;부터 정보를 추출하여 Contents를 동적으로 생성합니다. <br><br>
                		<BR>&nbsp;&nbsp;URL을 입력하십시오.
                		<BR><BR>&nbsp;&nbsp;<input type=text id="webUrl" name="webUrl" size=60>
                		<BR><BR>
            		</td>
        		</tr>
        	</table>
    	</td>
	</tr>
	<tr height=40>
		<td align=right>
        	<input type="button" class='btn_style' value="<spring:message code='COMBTN011'/>" onClick="webAgentSubmit()"><!-- 확인 -->
        	<input type="button" class='btn_style' value="<spring:message code='COMBTN001'/>" onClick="window.close()"><!-- 닫기 -->
   		</td>
	</tr>
	<tr height=*>
		<td></td>
	</tr>
</table>
</form>

</body>
</html>
