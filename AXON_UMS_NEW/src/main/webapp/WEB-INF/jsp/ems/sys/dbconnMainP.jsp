<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.12
	*	설명 : 데이터베이스 연결 관리 메인 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
var dbConnInfoDialog;

$(document).ready(function() {
	// CONNECTION명 입력란에서 엔터키를 누르는 경우
    $("#searchDbConnNm").keydown(function (e) {
        if(e.keyCode == 13){
        	e.preventDefault();
        	showDbConnGrid();
        }
    });
	
	// 검색 버튼 클릭
	$("#btnSearch").click(function(e) {
		e.preventDefault();
		showDbConnGrid();
	});
	
	// 초기화 버튼 클릭
	$("#btnClear").click(function(e) {
		e.preventDefault();
		$("#searchForm")[0].reset();
	});
	
	$("#btnPopDbConnAdd").click(function(e){
		e.preventDefault();
		dbConnInfoDialog = $("#divDbConnInfo").dialog({
			title:"DB Connection 신규 등록",
			width:900,
			height:500,
			modal:true,
			buttons: {
				"연결테스트": testDbConn,
				"등록": insertDbConnInfo,
				"취소": function() {
					dbConnInfoDialog.dialog("close");
				}
			},
			close: function() {
				$("#dbConnInfoForm")[0].reset();
			}
		});
	});
	
	// DB Connetion 목록 조회
	showDbConnGrid();
	
	setDB('000');
});

/********************************************************************************************************************
 * DB Connection 정보 처리
 ********************************************************************************************************************/
// DB Connection 목록 jqGrid 조회
function showDbConnGrid() {
	// 부서 목록 초기화
	$("#dbConnList").jqGrid("GridUnload");
	
	// Grid 데이터 조회 및 설정
	var param = $("#searchForm").serialize();
	$("#dbConnList").jqGrid({
		url          :"<c:url value='/ems/sys/dbconnList.json'/>?" + param,
		mtype        :"POST",
		datatype     :"json",
		jsonReader   : {
						page   : "page",
						total  : "total",
						root   : "rows",
						records: "records",
						repeatitems: false,
						id     : "id"
				       },
		height       : "250",
		width        : "900",
		colModel     :[
                        {name:'dbConnNo'	,index:'dbConnNo'	,width:100	,align:'center'	,hidden:true	,title:false	},	// CONNECTION 번호
                        {name:'dbConnNm'	,index:'dbConnNm'	,width:300	,align:'left'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL054"/>', formatter:dbConnInfo},	// CONNECTION명 
                        {name:'dbTyNm'		,index:'dbTyNm'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL055"/>'},	// 유형
                        {name:'statusNm'	,index:'statusNm'	,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL028"/>'},	// 상태
                        {name:'regId'		,index:'regId'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL021"/>'},	// 등록자
                        {name:'regDt'		,index:'regDt'		,width:200	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL022"/>'}	// 등록일
					  ],
		rowNum       : "10",
		rownumbers	 : false,
		autowidth    : false,
		viewrecords  : true,
		loadonce     : false,
		pager		 : "#pager",
		multiselect  : false,
		cmTemplate	 : { sortable: false },
		autoencode   : true,
		cellEdit     : false
	});
}

function dbConnInfo(cellvalue, options, rowObject) {
	return '<a href="#" onclick="getDbConnInfo(' + options.rowId + '); return false;">' + $.jgrid.htmlEncode(cellvalue) + '</a>';
}

function getDbConnInfo(rowId) {
	var dbConnNo = $("#dbConnList").jqGrid('getRowData',rowId).dbConnNo;
	$("#searchDbConnNo").val(dbConnNo);
	
	$("#page").val($('#dbConnList').getGridParam('page'));
	
	$("#searchForm").attr("action","<c:url value='/ems/sys/dbconnInfoP.ums'/>").submit();
}

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

function insertDbConnInfo() {
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
	$.getJSON("<c:url value='/ems/sys/dbconnAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			dbConnInfoDialog.dialog("close");
			
			// jqGrid 새로고침
			showDbConnGrid();
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
			
			<div><spring:message code='SYSTBLTL005'/></div><!-- DBCONNECTION관리 -->
			<div class="cWrap">
				<form id="searchForm" name="searchForm" method="post">
				<input type="hidden" id="page" name="page" value="<c:out value='${searchInfo.page}'/>"/>
				<input type="hidden" id="searchDbConnNo" name="searchDbConnNo" value="<c:out value='${searchInfo.searchDbConnNo}'/>"/>
				<table>
					<colgroup>
					    	<col style="width:15%" />
					    	<col style="width:35%" />
					    	<col style="width:15%" />
					    	<col style="width:35%" />
					</colgroup>
					<tr>
						<td class="td_title"><spring:message code='SYSTBLTL054'/></td><!-- CONNECTION명 -->
						<td class="td_body">
							<input type="text" size="20" maxlength="20" id="searchDbConnNm" name="searchDbConnNm" value="<c:out value='${searchInfo.searchDbConnNm}'/>" class="wBig">
						</td>
						<td class="td_title"><spring:message code='SYSTBLTL055'/></td><!-- 유형 -->
						<td class="td_body">
							<select id="searchDbTy" name="searchDbTy" class="wBig">
								<option value="">::: <spring:message code='SYSTBLLB007'/> :::</option><!-- 유형선택 -->
								<c:if test="${fn:length(dbmsTypeList) > 0}">
									<c:forEach items="${dbmsTypeList}" var="dbmsType">
										<c:choose>
											<c:when test="${dbmsType.cd eq searchInfo.searchDbTy}">
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
						</tr>
						<tr>
						<td class="td_title"><spring:message code='SYSTBLTL028'/></td><!-- 상태 -->
						<td class="td_body"  colspan="3">
							<select id="searchStatus" name="searchStatus" class="wBig">
								<option value="">::: <spring:message code='SYSTBLLB008'/> :::</option><!-- 상태선택 -->
								<c:if test="${fn:length(dbConnStatusList) > 0}">
									<c:forEach items="${dbConnStatusList}" var="dbConnStatus">
										<c:choose>
											<c:when test="${dbConnStatus.cd eq searchInfo.searchStatus}">
												<option value="<c:out value='${dbConnStatus.cd}'/>" selected><c:out value="${dbConnStatus.cdNm}"/></option>
											</c:when>
											<c:otherwise>
												<option value="<c:out value='${dbConnStatus.cd}'/>"><c:out value="${dbConnStatus.cdNm}"/></option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</c:if>
							</select>
							<input type="button" id="btnSearch" value="<spring:message code='COMBTN002'/>"><!-- 검색 -->
							<input type="button" id="btnClear" value="<spring:message code='COMBTN003'/>"><!-- 초기화 -->
						</td>
					</tr>
				</table>
				</form>
				<br/>
				<div style="width:900px;text-align:right;align:right;">
					<input type="button" id="btnPopDbConnAdd" value="<spring:message code='COMBTN004'/>"/><!-- 신규등록 -->
				</div>
				
				<!-- DB CONNECTION jqGrid Start -->
				<table id="dbConnList" summary="DB CONNECTION 목록"></table>
				<div id="pager"></div>
				
				<!-- DB CONNECTION jqGrid End -->
				
				
			</div>
						
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>


<!-- DB Connection 등록화면 -->
<div id="divDbConnInfo" style="display:none;">
	<form id="dbConnInfoForm" name="dbConnInfoForm">
	<table style="width:800px">
		<colgroup>
			<col style="width:15%">
			<col style="width:35%">
			<col style="width:15%">
			<col style="width:35%">
		</colgroup>
		<tbody>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL054'/></td><!-- CONNECTION명 -->
			<td class="td_body" colspan="3">
				<input type="text" id="dbConnNm" name="dbConnNm" value="" class="wBig" maxlength="35">
			</td>
		</tr>
		<tr>	
		    <td class="td_title"><spring:message code='SYSTBLTL056'/></td><!-- DB종류 -->
			<td class="td_body">
				<select id="dbTy" name="dbTy" class="wBig" onChange="setDB(this.options[this.selectedIndex].value)">
					<c:if test="${fn:length(dbmsTypeList) > 0}">
						<c:forEach items="${dbmsTypeList}" var="dbmsType">
							<option value="<c:out value='${dbmsType.cd}'/>"><c:out value="${dbmsType.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL028'/></td><!-- 상태 -->
			<td class="td_body">
				<select id="status" name="status" class="wBig">
					<c:if test="${fn:length(dbConnStatusList) > 0}">
						<c:forEach items="${dbConnStatusList}" var="dbConnStatus">
							<option value="<c:out value='${dbConnStatus.cd}'/>"><c:out value="${dbConnStatus.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
		    <td class="td_title">DB DRIVER</td>
			<td class="td_body" colspan="3">
				<input type="text" class="wBig" id="dbDriver" name="dbDriver" value=""  maxlength="100">
			</td>
		</tr>
		<tr>
		    <td class="td_title">URL</td>
			<td class="td_body" colspan="3">
				<input type="text" class="wBig" id="dbUrl" name="dbUrl" value=""  maxlength="100">
			</td>
		</tr>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL057'/></td><!-- 문자타입 -->
			<td class="td_body" colspan="3">
				<select id="dbCharSet" name="dbCharSet" class="wBig">
					<c:if test="${fn:length(dbCharSetList) > 0}">
						<c:forEach items="${dbCharSetList}" var="dbCharSet">
							<option value="<c:out value='${dbCharSet.cd}'/>"><c:out value="${dbCharSet.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
		    <td class="td_title">DB ID</td>
			<td class="td_body">
				<input type="text" class="wBig" id="loginId" name="loginId" value="" maxlength="20">
			</td>
		    <td  class="td_title">DB PASSWORD</td>
			<td class="td_body">
				<input type="password" class="wBig" id="loginPwd" name="loginPwd" value="" maxlength="20">
			</td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL058'/></td><!-- 설명 -->
			<td class="td_body" colspan="3">
				<textarea id="dbConnDesc" name="dbConnDesc" cols="80" rows="8"></textarea>
			</td>
		</tr>
		</tbody>
	</table>
	</form>

</div>


</body>

</html>
