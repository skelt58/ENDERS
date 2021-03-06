<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.16
	*	설명 : 캠페인 목적 관리 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
var userCodeDialog;

$(document).ready(function() {
	$("#btnPopCodeAdd").click(function(e){
		e.preventDefault();
		userCodeDialog = $("#divUserCodeInsert").dialog({
			title:"캠페인목적 등록",
			width:900,
			height:300,
			modal:true,
			buttons: {
				"등록": inserUserCodeInfo,
				"취소": function() {
					userCodeDialog.dialog("close");
				}
			},
			close: function() {
				$("#userCodeInsert")[0].reset();
			}
		});
	});
});

function inserUserCodeInfo() {
	var errflag = false;
	var errstr = "";
	
	if($("#userCodeInsert input[name='cdGrp']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL007'/>] ";	// 코드그룹ID
	}
	if($("#userCodeInsert input[name='cd']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL014'/>] ";	// 코드
	}
	if($("#userCodeInsert select[name='useYn']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL011'/>] ";	// 사용여부
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}
	
	// 사용중인 코드 확인
	var userCode = $("#userCodeInsert input[name='cd']").val();
	var dupCheck = false;
	$("#userCodeForm input[name='cd']").each(function(idx,item){
		if($(item).val() == userCode) {
			dupCheck = true;
		}
	});
	if(dupCheck) {
		alert("<spring:message code='COMJSALT019'/>");
		return;
	}
	
	var param = $("#userCodeInsert").serialize();
	$.getJSON("<c:url value='/ems/sys/usercodeAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			userCodeDialog.dialog("close");
			window.location.href = "<c:url value='/ems/sys/usercodeMainP.ums'/>";
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});	
}

function goUserCodeUpdate(pos) {
	$("#userCodeData input[name='uilang']").val( $("#userCodeForm input[name='uilang']").eq(pos).val() );
	$("#userCodeData input[name='cd']").val( $("#userCodeForm input[name='cd']").eq(pos).val() );
	$("#userCodeData input[name='cdNm']").val( $("#userCodeForm input[name='cdNm']").eq(pos).val() );
	$("#userCodeData input[name='cdDtl']").val( $("#userCodeForm input[name='cdDtl']").eq(pos).val() );
	$("#userCodeData input[name='useYn']").val( $("#userCodeForm select[name='useYn']").eq(pos).val() );
	
	var param = $("#userCodeData").serialize();
	$.getJSON("<c:url value='/ems/sys/usercodeUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			window.location.href = "<c:url value='/ems/sys/usercodeMainP.ums'/>";
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

function goUserCodeDelete(pos) {
	if(!confirm("<spring:message code='SYSJSALT020'/>")) {
		return;
	}

	$("#userCodeData input[name='uilang']").val( $("#userCodeForm input[name='uilang']").eq(pos).val() );
	$("#userCodeData input[name='cd']").val( $("#userCodeForm input[name='cd']").eq(pos).val() );
	$("#userCodeData input[name='cdNm']").val( $("#userCodeForm input[name='cdNm']").eq(pos).val() );
	$("#userCodeData input[name='cdDtl']").val( $("#userCodeForm input[name='cdDtl']").eq(pos).val() );
	$("#userCodeData input[name='useYn']").val( $("#userCodeForm select[name='useYn']").eq(pos).val() );
	
	var param = $("#userCodeData").serialize();
	$.getJSON("<c:url value='/ems/sys/usercodeDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			window.location.href = "<c:url value='/ems/sys/usercodeMainP.ums'/>";
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}
</script>

<div class="ex-layout">
	<div class="gnb">
		<!-- 상단메뉴화면 -->
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			<p class="title_default"><c:out value="${codeGrpInfo.cdGrpNm}"/></p>
			<br/>
			<div style="width:900px;text-align:right;align:right;">
				<input type="button" id="btnPopCodeAdd" value="<spring:message code='COMBTN004'/>"/><!-- 신규등록 -->
			</div>
			<br/>
			
			<form id="userCodeData" name="userCodeData">
			<input type="hidden" name="cdGrp" value="<c:out value='${cdGrp}'/>">
			<input type="hidden" name="uilang" value="<c:out value='${uilang}'/>">
			<input type="hidden" name="cd">
			<input type="hidden" name="cdNm">
			<input type="hidden" name="cdDtl">
			<input type="hidden" name="useYn">
			</form>
			
			<form id="userCodeForm" name="userCodeForm">
			<table border="1" cellspacing="0" class="table_line_outline" style="width:900px">
				<colgroup>
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:20%">
					<col />
					<col style="width:13%">
					<col style="width:10%">
					<col style="width:10%">
				</colgroup>
				<tr class="tr_head" align="center">
					<td><spring:message code='SYSTBLTL006'/></td><!-- 언어권 -->
					<td><spring:message code='SYSTBLTL014'/></td><!-- 코드 -->
					<td><spring:message code='SYSTBLTL015'/></td><!-- 코드명 -->
					<td><spring:message code='SYSTBLTL016'/></td><!-- 코드설명 -->
					<td><spring:message code='SYSTBLTL011'/></td><!-- 사용여부 -->
					<td><spring:message code='SYSTBLTL012'/></td><!-- 수정처리 -->
					<td><spring:message code='SYSTBLTL013'/></td><!-- 삭제처리 -->
				</tr>
				<c:if test="${fn:length(userCodeList) > 0}">
					<c:forEach items="${userCodeList}" var="userCode" varStatus="status">
						<input type="hidden" name="uilang" value="<c:out value='${userCode.uilang}'/>"/>
						<tr height="20">
							<td align="center">
								<c:out value="${userCode.uilangNm}"/>
							</td>
							<td align="center">
								<input type="text" name="cd" maxlength="3" size="3" value="<c:out value='${userCode.cd}'/>" readOnly class="readonly_style">
							</td>
							<td align="center">
								<input type="text" name="cdNm" value="<c:out value='${userCode.cdNm}'/>" maxlength="30" size="20">
							</td>
							<td align="center">
								<input type="text" name="cdDtl" value="<c:out value='${userCode.cdDtl}'/>" maxlength="200" size="40" >
							</td>
							<td align="center">
								<select name="useYn">
									<option value="Y"<c:if test="${'Y' eq userCode.useYn}"> selected</c:if>><spring:message code="SYSTBLLB002"/></option><!-- 사용 -->
									<option value="N"<c:if test="${'N' eq userCode.useYn}"> selected</c:if>><spring:message code="SYSTBLLB004"/></option><!-- 사용안함 -->
								</select>
							</td>
							<td align="center">
								<input type="button" value="<spring:message code='COMBTN007'/>" onClick="goUserCodeUpdate(<c:out value='${status.index}'/>)"  class="btn_style"><!-- 수정 -->
							</td>
							<td align="center">
								<input type="button" value="<spring:message code='COMBTN008'/>" onClick="goUserCodeDelete(<c:out value='${status.index}'/>)"  class="btn_style"><!-- 삭제 -->
							</td>
						</tr>
					</c:forEach>
				</c:if>
			</table>
			</form>
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

<!-- 캠페인 목적 등록 화면 -->
<div id="divUserCodeInsert" style="display:none;">
<form id="userCodeInsert" name="userCodeInsert">
<input type="hidden" name="cdGrp" value="<c:out value='${cdGrp}'/>">
<table border="1" cellspacing="0" style="width:850px;">
	<colgroup>
		<col style="width:15%" />
		<col style="width:35%" />
		<col style="width:15%" />
		<col style="width:35%" />
	</colgroup>
	<tr>
		<td class="td_title"><spring:message code='SYSTBLTL014'/></td><!-- 코드 -->
		<td class="td_body">
			&nbsp;&nbsp;<input type="text" name="cd" maxlength="3" size="3" class="wBig">
		</td>
		<td class="td_title"><spring:message code='SYSTBLTL011'/></td><!-- 사용여부 -->
		<td class="td_body">
			&nbsp;&nbsp;
			<select name="useYn" class="wBig">
				<option value="Y"><spring:message code='SYSTBLLB002'/></option><!-- 사용 -->
				<option value="N"><spring:message code='SYSTBLLB004'/></option><!-- 사용안함 -->
			</select>
		</td>
	</tr>
	<tr class="tr_head" align="center">
		<td><spring:message code='SYSTBLTL006'/></td><!-- 언어권 -->
		<td><spring:message code='SYSTBLTL015'/></td><!-- 코드명 -->
		<td colspan="2"><spring:message code='SYSTBLTL016'/></td><!-- 코드설명 -->
	</tr>
	<c:if test="${fn:length(uilangList) > 0}">
		<c:forEach items="${uilangList}" var="uilang">
			<tr>
				<td class="td_title" bgcolor="white">
					<input type="hidden" name="uilang" class="wBig" value="<c:out value='${uilang.cd}'/>"> <c:out value="${uilang.cdNm}"/>
				</td>
				<td bgcolor="white">
					<input type="text" name="cdNm" class="wBig" maxlength="30" size="20">
				</td>
				<td bgcolor="white" colspan="2">
					<input type="text" name="cdDtl" class="wBig" maxlength="200" size="50">
				</td>
			</tr>
		</c:forEach>
	</c:if>
</table>
</form>
</div>

</body>
</html>
