<%--
	/**********************************************************
	*	작성자 : 김준희
	*	작성일시 : 2021.08.05
	*	설명 : 메인화면(레이아웃 복사용)
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
			title:"사용자 코드 등록",
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
			window.location.href = "<c:url value='/ems/sys/userCodeListP.ums'/>";
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
			window.location.href = "<c:url value='/ems/sys/userCodeListP.ums'/>";
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
			window.location.href = "<c:url value='/ems/sys/userCodeListP.ums'/>";
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}
</script>

<body>
	<div id="wrap">

		<!-- lnb// -->
		<div id="lnb">
			<!-- LEFT MENU -->
			<%@ include file="/WEB-INF/jsp/inc/menu_sys.jsp" %>
			<!-- LEFT MENU -->
		</div>
		<!-- //lnb -->

		<!-- content// -->
		<div id="content">

			<!-- cont-head// -->
			<section class="cont-head">
				<div class="title">
					<h2><c:out value='${NEO_MENU_NM}'/></h2>
				</div>
				
				<!-- 공통 표시부// -->
				<%@ include file="/WEB-INF/jsp/inc/top.jsp" %>
				<!-- //공통 표시부 -->
				
			</section>
			<!-- //cont-head -->

			<!-- cont-body// -->
			<section class="cont-body">
 

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
			 




			</section>
			<!-- //cont-body -->
			
		</div>
		<!-- // content -->
	</div>

	<!-- 팝업// -->
	<%@ include file="/WEB-INF/jsp/inc/popup.jsp" %>
	<!-- //팝업 -->
</body>
</html>
