<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 환경설정 팝업 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type='text/javascript'>
// 페이지 로딩시 초기값 설정(오픈창에서 값 받아서 설정)
function goLoad() {
	$("#mailFromNm").val( $("#mailFromNm", opener.document).val() );
	$("#mailFromEm").val( $("#mailFromEm", opener.document).val() );
	$("#replyToEm").val( $("#replyToEm", opener.document).val() );
	$("#returnEm").val( $("#returnEm", opener.document).val() );
	
	$("#headerEnc").val( $("#headerEnc", opener.document).val() );
	$("#bodyEnc").val( $("#bodyEnc", opener.document).val() );
	$("#charset").val( $("#charset", opener.document).val() );
	
	$("#socketTimeout").val( $("#socketTimeout", opener.document).val() );
	$("#connPerCnt").val( $("#connPerCnt", opener.document).val() );
	$("#retryCnt").val( $("#retryCnt", opener.document).val() );
	$("#sendMode").val( $("#sendMode", opener.document).val() );
}

// 등록 버튼 클릭
function goSave() {
	// goLoad의 정보와 변경되었음...
	var obj = opener.document.mailform;
	var op_obj = document.optform;
	
	var errflag = false;
	var errstr = "";
	
	if($("#replyToEm").val() == "") {
		errflag = true;
		errstr += " [ <spring:message code='CAMTBLTL034'/> ] ";		// 반송 이메일
	}
	if($("#returnEm").val() == "") {
		errflag = true;
		errstr += " [ <spring:message code='CAMTBLTL046'/> ] ";		// 리턴 이메일
	}
	if($("#socketTimeout").val() == "") {
		errflag = true;
		errstr += " [ Socket Timeout ] ";
	}
	if($("#connPerCnt").val() == "") {
		errflag = true;
		errstr += " [ <spring:message code='CAMTBLTL035'/> ] ";		// Connection 당 발송수
	}
	if($("#retryCnt").val() == "") {
		errflag = true;
		errstr += " [ <spring:message code='CAMTBLTL036'/> ] ";		// 재발송수
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT001'/>.\n" + errstr);	// 입력값 에러\\n다음 정보를 확인하세요.
		return;
	}
	
	$("#mailFromNm", opener.document).val( $("#mailFromNm").val() );
	$("#mailFromEm", opener.document).val( $("#mailFromEm").val() );
	$("#replyToEm", opener.document).val( $("#replyToEm").val() );
	$("#returnEm", opener.document).val( $("#returnEm").val() );
	
	$("#headerEnc", opener.document).val( $("#headerEnc").val() );
	$("#bodyEnc", opener.document).val( $("#bodyEnc").val() );
	$("#charset", opener.document).val( $("#charset").val() );
	
	$("#socketTimeout", opener.document).val( $("#socketTimeout").val() );
	$("#connPerCnt", opener.document).val( $("#connPerCnt").val() );
	$("#retryCnt", opener.document).val( $("#retryCnt").val() );
	$("#sendMode", opener.document).val( $("#sendMode").val() );
	
	window.close();
}

// 메일헤더 초기화
function goMailHeader() {
	$("#mailFromNm").val( $("#mailFromNm", opener.document).val() );
	$("#mailFromEm").val( $("#mailFromEm", opener.document).val() );
	$("#replyToEm").val( $("#replyToEm", opener.document).val() );
	$("#returnEm").val( $("#returnEm", opener.document).val() );
}

// 인코딩 초기화
function goEnc() {
	$("#headerEnc").val( $("#headerEnc", opener.document).val() );
	$("#bodyEnc").val( $("#bodyEnc", opener.document).val() );
	$("#charset").val( $("#charset", opener.document).val() );
}

// 발송환경 초기화
function goSendMode() {
	$("#socketTimeout").val( $("#socketTimeout", opener.document).val() );
	$("#connPerCnt").val( $("#connPerCnt", opener.document).val() );
	$("#retryCnt").val( $("#retryCnt", opener.document).val() );
	$("#sendMode").val( $("#sendMode", opener.document).val() );
}
</script>

<body onload="goLoad()">

<form id="optionForm" name="optionForm" method="post">
<table style="width:340px; margin:10px auto 0; border:none;" cellspacing="1" cellpadding="0" class="table_line_outline">
	<tr height="20" class="tr_head">
		<td colspan='2' align="left" class="td_5">
			<spring:message code='CAMTBLTL031'/> (<a href="JavaScript:goMailHeader();"><spring:message code='COMBTN003'/></a>)<!-- 메일헤더 정보설정 --><!-- 초기화 -->
		</td>
	</tr>
	<tr height="20" >
		<td width='45%' class="td_title"><spring:message code='CAMTBLTL018'/></td><!-- 발송자 성명 -->
		<td width='55%' class="td_body"><input type='text' id="mailFromNm" name='mailFromNm' size="25"></td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL019'/></td><!-- 발송자 이메일 -->
		<td class="td_body"><input type='text' id="mailFromEm" name='mailFromEm' size="25"></td>
	</tr>
	<tr height="20" >
		<td class="td_title"><spring:message code='CAMTBLTL034'/></td><!-- 반송 이메일 -->
		<td class="td_body"><input type='text' id="replyToEm" name='replyToEm' size="25"></td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL046'/></td><!-- 리턴 이메일 -->
		<td class="td_body"><input type='text' id="returnEm" name='returnEm' size="25"></td>
	</tr>
</table>

<table style="width:340px; margin:10px auto; border:none;" cellspacing="1" cellpadding="0" class="table_line_outline">
	<tr height="20" class="tr_head">
		<td colspan='2' align="left" class="td_5">
			<spring:message code='CAMTBLTL032'/> (<a href="JavaScript:goEnc();"><spring:message code='COMBTN003'/></a>)<!-- 인코딩 환경 설정 --><!-- 초기화 -->
		</td>
	</tr>
	<tr height="20" >
		<td width='45%' class="td_title"><spring:message code='CAMTBLTL037'/></td><!-- 헤더 인코딩 -->
		<td width='55%' class="td_body">
			<select id="headerEnc" name="headerEnc">
				<c:if test="${fn:length(encodingList) > 0}">
					<c:forEach items="${encodingList}" var="encoding">
						<option value="<c:out value='${encoding.cd}'/>"><c:out value='${encoding.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL038'/></td><!-- 바디 인코딩 -->
		<td class="td_body">
			<select id="bodyEnc" name="bodyEnc">
				<c:if test="${fn:length(encodingList) > 0}">
					<c:forEach items="${encodingList}" var="encoding">
						<option value="<c:out value='${encoding.cd}'/>"><c:out value='${encoding.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL039'/></td><!-- 문자셋 -->
		<td class="td_body">
			<select id="charset" name="charset">
				<c:if test="${fn:length(charsetList) > 0}">
					<c:forEach items="${charsetList}" var="charset">
						<option value="<c:out value='${charset.cd}'/>"><c:out value='${charset.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
</table>

<table style="width:340px; border:none; margin:10px auto;" cellspacing="1" cellpadding="0" class="table_line_outline">
	<tr height="20" class="tr_head">
		<td colspan='2' align="left" class="td_5">
			<spring:message code='CAMTBLTL033'/> (<a href="JavaScript:goSendMode();"><spring:message code='COMBTN003'/></a>)<!-- 발송 환경 설정 --><!-- 초기화 -->
		</td>
	</tr>
	<tr height="20" >
		<td width='45%' class="td_title">Socket Timeout</td>
		<td width='55%' class="td_body"><input type='text' id="socketTimeout" name='socketTimeout' size="25"></td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL035'/></td><!-- Connection 당 발송수 -->
		<td class="td_body"><input type='text' id="connPerCnt" name='connPerCnt' size="25"></td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL036'/></td><!-- 재발송수 -->
		<td class="td_body"><input type='text' id="retryCnt" name='retryCnt' size="25"></td>
	</tr>
	<tr height="20">
		<td class="td_title"><spring:message code='CAMTBLTL040'/></td><!-- 발송 모드 -->
		<td class="td_body">
			<select id="sendMode" name="sendMode">
				<c:if test="${fn:length(sendModeList) > 0}">
					<c:forEach items="${sendModeList}" var="sendMode">
						<option value="<c:out value='${sendMode.cd}'/>"><c:out value='${sendMode.cdNm}'/></option>
					</c:forEach>
				</c:if>
			</select>
		</td>
	</tr>
</table>
<table width="340" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height='30' align='right'>
			<input type="button" class="btn_style" value="<spring:message code='COMBTN005'/>" onClick="goSave()"><!-- 등록 -->
			<input type="button" class="btn_style" value="<spring:message code='COMBTN001'/>" onClick="window.close()"><!-- 닫기 -->
		</td>
	</tr>
</table>
</form>

</body>
</html>
