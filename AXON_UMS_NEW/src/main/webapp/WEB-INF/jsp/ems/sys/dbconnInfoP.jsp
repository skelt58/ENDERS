<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	$("#btnDbConnTest").click(function(e){
		e.preventDefault();
		testDbConn();
	});
	
	$("#btnUpdate").click(function(e){
		e.preventDefault();
		updateDbConnInfo();
	});
});

function testDbConn() {
	var errflag = false;
	var errstr = "";

	if($("#dbDriver").val() == "") {
		errflag = true;
		errstr += " [DRIVER] ";
	}

	if($("#dbUrl").val() == "") {
		errflag = true;
		errstr += " [URL] ";
	}

	if($("#loginId").val() == "") {
		errflag = true;
		errstr += " [DB ID] ";
	}

	if($("#loginPwd").val() == "") {
		errflag = true;
		errstr += " [DB PASSWORD] ";
	}

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr); // 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#dbConnInfoForm").serialize();
	$.getJSON("<c:url value='/ems/sys/dbconnTest.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='SYSJSALT002'/>");	// 연결 성공
		} else if(data.result == "Fail") {
			alert("<spring:message code='SYSJSALT022'/>\n" + data.errMsg);	// 연결 실패
		}
	});
}

function updateDbConnInfo() {
	var errflag = false;
	var errstr = "";
	
	if($("#dbConnNm").val() == "") {	// CONNECTION명
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL054'/>] ";
	}
	if($("#dbTy option:selected").val() == "") {	// DB종류
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL056'/>] ";
	}
	if($("#status option:selected").val() == "") {	// 상태
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL028'/>] ";
	}
	if($("#dbDriver").val() == "") {
		errflag = true;
		errstr += " [DRIVER] ";
	}
	if($("#dbUrl").val() == "") {
		errflag = true;
		errstr += " [URL] ";
	}
	if($("#dbCharSet option:selected").val() == "") {	// 문자타입
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL057'/>] ";
	}
	if($("#loginId").val() == "") {
		errflag = true;
		errstr += " [DB ID] ";
	}
	if($("#loginPwd").val() == "") {
		errflag = true;
		errstr += " [DB PASSWORD] ";
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr); // 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#dbConnInfoForm").serialize();
	$.getJSON("<c:url value='/ems/sys/dbconnUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			
			// 수정된 값으로 세팅
			$("#upId").val(data.dbConnInfo.upId);
			$("#upDt").val(data.dbConnInfo.upDt);
			
			
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}

//DB DRIVER, URL 설정 EVENT 구현
function setDB(dbTy) {
	var driver = "";
	var url = "";
	if(dbTy == "000") {			//ORACLE
		driver = "oracle.jdbc.driver.OracleDriver";
		url = "jdbc:oracle:thin:@[IP]:[PORT]:[SID]";
	} else if(dbTy == "001") {	//MSSQL
		driver = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
		url = "jdbc:microsoft:sqlserver://[IP]:[PORT];databaseName=[Database Name]";
	} else if(dbTy == "002") {	//INFORMIX
		driver = "com.informix.jdbc.IfxDriver";
		url = "jdbc:informix-sqli://[IP]:[PORT]/[DB명]:informixserver=[SERVER명]";
	} else if(dbTy == "003") {	//SYBASE
		driver = "com.sybase.jdbc2.jdbc.SybDriver";
		url = "jdbc:sybase:Tds:[IP]:[PORT]";
	} else if(dbTy == "004") {	//MYSQL
		driver = "com.mysql.jdbc.Driver";
		url = "jdbc:mysql://[IP]/[DB명]";
	} else if(dbTy == "005") {	//UNISQL
		driver = "unisql.jdbc.driver.UniSQLDriver";
		url = "jdbc:unisql:[IP]:[PORT]:[Database Name]:::";
	} else if(dbTy == "006") {	//INGRES
		driver = "ca.edbc.jdbc.EdbcDriver";
		url = "jdbc:edhc://[IP]:IM7/[Node Name]";
	} else if(dbTy == "007") {	//DB2
		driver = "COM.ibm.db2.jdbc.net.DB2Driver";
		url = "jdbc:db2://[IP]:[PORT]/[DB NAME]";
	} else if(dbTy == "008") {	//POSTGRES
		driver = "org.postgresql.Driver";
		url = "jdbc:postgresql://[IP]:[PORT]/[Database Name]";
	} else if(dbTy == "009") {	//CUBRID
		driver = "cubrid.jdbc.driver.CUBRIDDriver";
		url = "jdbc:cubrid:[IP]:30000:[Database Name]:::?charset=EUC-KR";
	}

	$("#dbDriver").val(driver);
	$("#dbUrl").val(url);
}

function goList() {
	$("#dbConnInfoForm").attr("action","<c:url value='/ems/sys/dbconnMainP.ums'/>").submit();
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
			<p class="title_default"><spring:message code='SYSTBLTL005'/></p><!-- DBCONNECTION관리 -->
			<br/>
			<div style="width:900px;text-align:right;align:right;">
				<input type="button" value="<spring:message code='COMBTN010'/>" class="btn_typeC" onClick="goList()"><!-- 리스트 -->
			</div>
			<form id="dbConnInfoForm" name="dbConnInfoForm" method="post">
			<input type="hidden" id="page" name="page" value="<c:out value='${searchInfo.page}'/>"/>
			<input type="hidden" id="searchDbConnNm" name="searchDbConnNm" value="<c:out value='${searchInfo.searchDbConnNm}'/>"/>
			<input type="hidden" id="searchDbTy" name="searchDbTy" value="<c:out value='${searchInfo.searchDbTy}'/>"/>
			<input type="hidden" id="searchStatus" name="searchStatus" value="<c:out value='${searchInfo.searchStatus}'/>"/>
			<input type="hidden" id="dbConnNo" name="dbConnNo" value="<c:out value='${dbConnInfo.dbConnNo}'/>"/>
			
			<table width="800" border="0" cellspacing="1" cellpadding="0" class="table_line_outline" style="width: 1015px;">
				<tr>
				    <td class="td_title"><spring:message code='SYSTBLTL054'/></td><!-- CONNECTION명 -->
					<td class="td_body">
						<input type="text" id="dbConnNm" name="dbConnNm" value="<c:out value='${dbConnInfo.dbConnNm}'/>" size="35" maxlength="35">
					</td>
				    <td class="td_title"><spring:message code='SYSTBLTL056'/></td><!-- DB종류 -->
					<td class="td_body">
						<select id="dbTy" name="dbTy" onChange="setDB(this.options[this.selectedIndex].value)">
							<c:if test="${fn:length(dbmsTypeList) > 0}">
								<c:forEach items="${dbmsTypeList}" var="dbmsType">
									<c:choose>
										<c:when test="${dbmsType.cd eq dbConnInfo.dbTy}">
											<option value="<c:out value='${dbmsType.cd}'/>" selected><c:out value="${dbmsType.cdNm}"/></option>
										</c:when>
										<c:otherwise>
											<option value="<c:out value='${dbmsType.cd}'/>"><c:out value="${dbmsType.cdNm}"/></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</c:if>

						</select>
					</td>
				    <td class="td_title"></td><!-- 상태 -->
					<td class="td_body">
						<select id="status" name="status">
							<c:if test="${fn:length(dbConnStatusList) > 0}">
								<c:forEach items="${dbConnStatusList}" var="dbConnStatus">
									<c:choose>
										<c:when test="${dbConnStatus.cd eq dbConnInfo.status}">
											<option value="<c:out value='${dbConnStatus.cd}'/>" selected><c:out value="${dbConnStatus.cdNm}"/></option>
										</c:when>
										<c:otherwise>
											<option value="<c:out value='${dbConnStatus.cd}'/>"><c:out value="${dbConnStatus.cdNm}"/></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
				    <td class="td_title">DB DRIVER</td>
					<td class="td_body" colspan="5">
						<input type="text" id="dbDriver" name="dbDriver" value="<c:out value="${dbConnInfo.dbDriver}"/>" size="70" maxlength="100">
					</td>
				</tr>
				<tr>
				    <td class="td_title">URL</td>
					<td class="td_body" colspan="5">
						<input type="text" id="dbUrl" name="dbUrl" value="<c:out value="${dbConnInfo.dbUrl}"/>" size="70" maxlength="100">
					</td>
				</tr>
				<tr>
				    <td class="td_title"><spring:message code='SYSTBLTL057'/></td><!-- 문자타입 -->
					<td class="td_body">
						<select id="dbCharSet" name="dbCharSet">
							<c:if test="${fn:length(dbCharSetList) > 0}">
								<c:forEach items="${dbCharSetList}" var="dbCharSet">
									<c:choose>
										<c:when test="${dbCharSet.cd eq dbConnInfo.dbCharSet}">
											<option value="<c:out value='${dbCharSet.cd}'/>" selected><c:out value="${dbCharSet.cdNm}"/></option>
										</c:when>
										<c:otherwise>
											<option value="<c:out value='${dbCharSet.cd}'/>"><c:out value="${dbCharSet.cdNm}"/></option>
										</c:otherwise>
									</c:choose>
									<option value="<c:out value='${dbCharSet.cd}'/>"><c:out value="${dbCharSet.cdNm}"/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				    <td class="td_title">DB ID</td>
					<td class="td_body">
						<input type="text" id="loginId" name="loginId" value="<c:out value="${dbConnInfo.loginId}"/>" size="10" maxlength="20">
					</td>
				    <td class="td_title">DB PASSWORD</td>
					<td class="td_body">
						<input type="password" id="loginPwd" name="loginPwd" value="<c:out value="${dbConnInfo.loginPwd}"/>" size="10" maxlength="20">
					</td>
				</tr>
				<tr>
					<td class="td_title"><spring:message code='SYSTBLTL058'/></td><!-- 설명 -->
					<td class="td_body" colspan="5">
						<textarea id="dbConnDesc" name="dbConnDesc" cols="100" rows="3"><c:out value="${dbConnInfo.dbConnDesc}"/></textarea>
					</td>
				</tr>
			</table>
			<div style="width:900px;text-align:right;align:right;">
		      	<input type="button" id="btnDbConnTest" class="btn_typeC" value="<spring:message code='SYSBTN003'/>"><!-- 연결테스트 -->
		      	<input type="button" id="btnUpdate" class="btn_typeC" value="<spring:message code='COMBTN007'/>"><!-- 수정 -->
		        <!--input type="reset" class="btn_typeC" value="<spring:message code='COMBTN009'/>"--><!-- 재입력 -->
			</div>
			<table width="800" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
				<tr>
					<td class="td_title"><spring:message code='SYSTBLTL021'/></td><!-- 등록자 -->
					<td class="td_body">
						<input type="text" id="regId" name="regId" maxlength="20" size="13" value="<c:out value="${dbConnInfo.regId}"/>" readOnly class="readonly_style">
					</td>
					<td class="td_title"><spring:message code='SYSTBLTL021'/></td><!-- 등록일 -->
					<td class="td_body">
						<input type="text" id="regDt" name="regDt" maxlength="50" size="20" value="<c:out value="${dbConnInfo.regDt}"/>" readOnly class="readonly_style">
					</td>
					<td class="td_title"><spring:message code='SYSTBLTL042'/></td><!-- 수정자 -->
					<td class="td_body">
						<input type="text" id="upId" name="upId" maxlength="20" size="13" value="<c:out value="${dbConnInfo.upId}"/>" readOnly class="readonly_style">
					</td>
					<td class="td_title"><spring:message code='SYSTBLTL043'/></td><!-- 수정일 -->
					<td class="td_body">
						<input type="text" id="upDt" name="upDt" maxlength="50" size="20" value="<c:out value="${dbConnInfo.upDt}"/>" readOnly class="readonly_style">
					</td>
				</tr>
			</table>
			
			</form>

			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
