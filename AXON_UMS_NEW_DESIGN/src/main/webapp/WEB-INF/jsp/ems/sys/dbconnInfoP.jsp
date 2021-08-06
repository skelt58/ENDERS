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
	
	// 권한관리 탭 실행
	goTab(1);
});

/***************************************************** DB Connection 정보 처리 ***********************************************************/
// 연결 테스트
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

// DB Connection 정보 수정
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
			alert("수정성공");	
			
			// 수정된 값으로 세팅
			$("#upId").val(data.dbConnInfo.upId);
			$("#upDt").val(data.dbConnInfo.upDt);
			
			$("#dbConnInfoForm").attr("action","<c:url value='/ems/sys/dbconnInfoP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("수정실패");	
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

// 탭 클릭시 컨텐츠
function goTab(idx) {
	if(idx == 1) {
		$("#td_tab1").css({"background":"#cccccc","font-weight":"bold"});
		$("#td_tab2").css({"background":"#ffffff","font-weight":"normal"});
		$("#td_tab3").css({"background":"#ffffff","font-weight":"normal"});
	} else if(idx == 2) {
		$("#td_tab1").css({"background":"#ffffff","font-weight":"normal"});
		$("#td_tab2").css({"background":"#cccccc","font-weight":"bold"});
		$("#td_tab3").css({"background":"#ffffff","font-weight":"normal"});
	} else if(idx == 3) {
		$("#td_tab1").css({"background":"#ffffff","font-weight":"normal"});
		$("#td_tab2").css({"background":"#ffffff","font-weight":"normal"});
		$("#td_tab3").css({"background":"#cccccc","font-weight":"bold"});
	}
	
	$("#tabIdx").val(idx);
	
	getContentPageHtml(idx);
}

function getContentPageHtml(idx) {
	// 컨텐츠 초기화
	$("#divTabContent").empty();
	
	var url = "";
	if(idx == 1) {
		url = 	"<c:url value='/ems/sys/dbconnpermuserListP.ums'/>";
	} else if(idx == 2) {
		url = 	"<c:url value='/ems/sys/dbconnmetaMainP.ums'/>";
	} else if(idx == 3) {
		url = 	"<c:url value='/ems/sys/metajoinMainP.ums'/>";
	}
	
	var dbConnNo = $("#dbConnNo").val();
	$.ajax({
		type : "GET",
		url : url + "?dbConnNo=" + dbConnNo,
		dataType : "html",
		async: false,
		success : function(pageHtml){
			$("#divTabContent").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}


/***************************************************** DB 사용 권한 정보 처리 ***********************************************************/
// 전체 사용자 선택
function setAllUser(deptNo, chkYn) {
	$("input[name='deptNo']").each(function(index, item){
		if($(item).val() == deptNo) {
			$("input[name='userId']")[index].checked = chkYn;
		}		
	});
}

// DB 사용 권한 정보 저장
function goConnPermAdd() {
	var param = $("#dbConnPermForm").serialize();
	$.getJSON("<c:url value='/ems/sys/dbconnpermAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			
			getContentPageHtml(1);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}




/***************************************************** 메타 테이블 정보 처리 ***********************************************************/
//메타 테이블 입력 화면 호출
function goMetaTableForm(tableName) {
	$("#divMetaTableInfo").show();
	$("#divMetaTableInsertBtn").show();
	$("#divMetaTableUpdateBtn").hide();
	$("#tblNm").val(tableName);
	$("#tblAlias").val("");
	$("#tblDesc").val("");
	
	// 메터 컬럼 출력 화면 숨김
	$("#divMetaColumnInfo").empty();
	$("#divMetaColumnInfo").hide();
	
	// 메타 관계식,관계값 화면 숨김
	$("#divMetaOperValueInfo").empty();
	$("#divMetaOperValueInfo").hide();
}

// 메타 테이블 정보 조회
function goMetaTableInfo(tableNo,tableName) {
	$("#divMetaTableInfo").show();
	$("#divMetaTableInsertBtn").hide();
	$("#divMetaTableUpdateBtn").show();
	$("#tblNo").val(tableNo);
	
	$("#hiddenTblNo").val(tableNo);
	$("#hiddenTblNm").val(tableName);
	
	// 메타 관계식,관계값 화면 숨김
	$("#divMetaOperValueInfo").empty();
	$("#divMetaOperValueInfo").hide();
	
	// 메타 테이블 정보 조회
	var param = $("#metaTableInfo").serialize();
	$.getJSON("<c:url value='/ems/sys/metatableInfo.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			
			$("#tblNm").val(data.metaTableInfo.tblNm);
			$("#tblAlias").val(data.metaTableInfo.tblAlias);
			$("#tblDesc").val(data.metaTableInfo.tblDesc);
			
			showMetaColumnInfo(tableNo, tableName);
		} else if(data.result == "Fail") {
			alert("데이터 조회 실패");
		}
	});
	
}

// 메타 컬럼 정보 표시
function showMetaColumnInfo(tblNo, tblNm) {
	$("#hiddenTblNo").val(tblNo);
	$("#hiddenTblNm").val(tblNm);
	
	$("#divMetaColumnInfo").empty();
	$("#divMetaColumnInfo").show();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/sys/metacolumnListP.ums'/>?dbConnNo=<c:out value='${dbConnInfo.dbConnNo}'/>&tblNo=" + tblNo + "&tblNm=" + tblNm,
		dataType : "html",
		async: false,
		success : function(pageHtml){
			$("#divMetaColumnInfo").html(pageHtml);
		},
		error : function(){
			alert("Error(showMetaColumnInfo)!");
		}
	});
}

// 메타 테이블 정보 등록
function goMetaTableAdd() {
	var errflag = false;
	var errstr = "";
	
	if($("#tblNm").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL061'/>] ";	// 테이블명
	}
	
	if($("#tblAlias").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL062'/>] ";	// 별칭
	}
	
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#metaTableInfo").serialize();
	$.getJSON("<c:url value='/ems/sys/metatableAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			$("#hiddenTblNo").val(data.tblNo);
			$("#hiddenTblNm").val($("#tblNm").val());
			
			// 메타테이블 다시 조회
			reloadMetaTableInfo("I");
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}

//메타 테이블 정보 수정
function goMetaTableUpdate() {
	var errflag = false;
	var errstr = "";
	
	if($("#tblNm").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL061'/>] ";	// 테이블명
	}
	
	if($("#tblAlias").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL062'/>] ";	// 별칭
	}
	
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#metaTableInfo").serialize();
	$.getJSON("<c:url value='/ems/sys/metatableUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			$("#hiddenTblNo").val(data.tblNo);
			$("#hiddenTblNm").val($("#tblNm").val());
			
			// 메타테이블 다시 조회
			reloadMetaTableInfo("U");
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

//메타 테이블 정보 삭제
function goMetaTableDelete() {
	var param = $("#metaTableInfo").serialize();
	$.getJSON("<c:url value='/ems/sys/metatableDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			$("#hiddenTblNo").val(data.tblNo);
			$("#hiddenTblNm").val($("#tblNm").val());
			
			// 메타테이블 다시 조회
			reloadMetaTableInfo("D");
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}

function reloadMetaTableInfo(mode) {
	getContentPageHtml(2);
	if(mode == "D") {
		//goMetaTableForm($("#hiddenTblNm").val());
		$("#divMetaTableInfo").hide();
		$("#divMetaColumnInfo").hide();
	} else {
		goMetaTableInfo($("#hiddenTblNo").val(), $("#hiddenTblNm").val());
	}
}


/***************************************************** 메타 컬럼 정보 처리 ***********************************************************/
// 메타 컬럼정보 등록 및 수정
function goMetaColumnUpdate(colNo, pos, cnt) {
	var tblNo = $("#hiddenTblNo").val();
	var tblNm = $("#hiddenTblNm").val();

	//alert($("#metaColumnForm input[name='colNm']").eq(pos).val());
	$("#metaColumnDataForm input[name='colNo']").val(colNo == ""?"0":colNo);
	$("#metaColumnDataForm input[name='colDataTyJdbc']").val($("#metaColumnForm input[name='colDataTyJdbc']").eq(pos).val());
	$("#metaColumnDataForm input[name='colNm']").val($("#metaColumnForm input[name='colNm']").eq(pos).val());
	$("#metaColumnDataForm input[name='colAlias']").val($("#metaColumnForm input[name='colAlias']").eq(pos).val());
	$("#metaColumnDataForm input[name='colDataTy']").val($("#metaColumnForm input[name='colDataTy']").eq(pos).val());
	$("#metaColumnDataForm input[name='colDesc']").val($("#metaColumnForm textarea[name='colDesc']").eq(pos).val());
	
	var errflag = false;
	var errstr = "";
	
	if($("#metaColumnDataForm input[name='dbConnNo']").val() == "") {
		errflag = true;
		errstr += " [DB CONNECTION ID] ";
	}
	if($("#metaColumnDataForm input[name='tblNm']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL061'/>] ";		// 테이블명
	}
	if($("#metaColumnDataForm input[name='tblNo']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL070'/> ID] ";	// 테이블
	}
	if($("#metaColumnDataForm input[name='colNm']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL063'/>] ";	// 컬럼명
	}
	if($("#metaColumnDataForm input[name='colAlias']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL062'/>] ";	// 별칭
	}
	if($("#metaColumnDataForm input[name='colDataTy']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL072'/> <spring:message code='SYSTBLTL055'/>] ";	// 컬럼, 유형
	}
	if($("#metaColumnDataForm input[name='colDataTyJdbc']").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL072'/> JDBC <spring:message code='SYSTBLTL055'/>] ";	// 컬럼, 유형
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#metaColumnDataForm").serialize();
	$.getJSON("<c:url value='/ems/sys/metacolumnUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			$("#hiddenTblNo").val(data.tblNo);
			$("#hiddenTblNm").val($("#tblNm").val());
			
			// 메타 컬럼 다시 조회
			showMetaColumnInfo(tblNo, tblNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

function goMetaColumnDelete(colNo) {
	var tblNo = $("#hiddenTblNo").val();
	var tblNm = $("#hiddenTblNm").val();
	
	$.getJSON("<c:url value='/ems/sys/metacolumnDelete.json'/>?colNo=" + colNo, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			$("#hiddenTblNo").val(data.tblNo);
			$("#hiddenTblNm").val($("#tblNm").val());
			
			// 메타 컬럼 다시 조회
			showMetaColumnInfo(tblNo, tblNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}



/***************************************************** 메타 관계식 정보 처리 ***********************************************************/
// 메타 관계식/관계값 화면 호출
function goMetaOperation(colNo, colNm) {
	
	$("#divMetaOperValueInfo").empty();
	$("#divMetaOperValueInfo").show();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/sys/metaoperMainP.ums'/>?colNo=" + colNo + "&colNm=" + colNm,
		dataType : "html",
		async: false,
		success : function(pageHtml){
			$("#divMetaOperValueInfo").html(pageHtml);
		},
		error : function(){
			alert("Error(goMetaOperation)!");
		}
	});
}

function goMetaOperUpdate() {
	var colNo = $("#metaOperatorForm input[name='colNo']").val();
	var colNm = $("#metaOperatorForm input[name='colNm']").val();
	
	var param = $("#metaOperatorForm").serialize();
	$.getJSON("<c:url value='/ems/sys/metaoperUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			
			// 메타 컬럼 다시 조회
			goMetaOperation(colNo, colNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}


/***************************************************** 메타 관계값 정보 처리 ***********************************************************/
// 메타 관계값 등록
function goMetaValueAdd() {
	var colNo = $("#metaValueForm input[name='colNo']").val();
	var colNm = $("#metaValueForm input[name='colNm']").val();
	
	var isValid = false;
	for(var i=0;i<2;i++) {
		if($("#metaValueForm input[name='valueNm']").eq(i).val() != "") {
			isValid = true;
			if($("#metaValueForm input[name='valueAlias']").eq(i).val() == "") {
				alert("<spring:message code='SYSJSALT005'/>"); 	// VALUE 값에 대한 ALIAS를 설정하십시요.
				return;
			}
		}
	}
	
	if(!isValid) {
		alert("VALUE 값을 입력하세요.");
		return;
	}
	
	var param = $("#metaValueForm").serialize();
	$.getJSON("<c:url value='/ems/sys/metavalAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			
			// 메타 컬럼 다시 조회
			goMetaOperation(colNo, colNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}

function goMetaValueUpdate(valueNo, pos, cnt) {
	$("#metaValueUpdate input[name='valueNo']").val(valueNo);
	$("#metaValueUpdate input[name='valueNm']").val($("#metaValueList input[name='valueNm']").eq(pos).val());
	$("#metaValueUpdate input[name='valueAlias']").val($("#metaValueList input[name='valueAlias']").eq(pos).val());

	
	var colNo = $("#metaValueUpdate input[name='colNo']").val();
	var colNm = $("#metaValueUpdate input[name='colNm']").val();

	
	var param = $("#metaValueUpdate").serialize();
	$.getJSON("<c:url value='/ems/sys/metavalUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			
			// 메타 컬럼 다시 조회
			goMetaOperation(colNo, colNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

function goMetaValueDelete(valueNo) {
	$("#metaValueUpdate input[name='valueNo']").val(valueNo);

	var colNo = $("#metaValueUpdate input[name='colNo']").val();
	var colNm = $("#metaValueUpdate input[name='colNm']").val();
	
	var param = $("#metaValueUpdate").serialize();
	$.getJSON("<c:url value='/ems/sys/metavalDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			
			// 메타 컬럼 다시 조회
			goMetaOperation(colNo, colNm);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 수정 실패
		}
	});

}


/***************************************************** 메타 조인 정보 처리 ***********************************************************/
// 
function setTableColumn(target, tblNm) {
	var dbConnNo = $("#metaJoinInsertForm input[name='dbConnNo']").val();

	$.getJSON("<c:url value='/ems/sys/getColumnList.json'/>?dbConnNo=" + dbConnNo + "&tblNm=" + tblNm, function(data) {
		/*
		if(target == 'mstColNm') {
			$("#metaJoinInsertForm select[name='mstColNm']").children("option:not(:first)").remove();
			$.each(data.realColumnList, function(idx,item){
				var option = new Option(item.colNm,item.colNm);
				$("#metaJoinInsertForm select[name='mstColNm']").append(option);
			});
		} else if(target == 'forColNm') {
			$("#metaJoinInsertForm select[name='forColNm']").children("option:not(:first)").remove();
			$.each(data.realColumnList, function(idx,item){
				var option = new Option(item.colNm,item.colNm);
				$("#metaJoinInsertForm select[name='forColNm']").append(option);
			});
		}
		*/
		
		$("#metaJoinInsertForm select[name='" + target + "']").children("option:not(:first)").remove();
		$.each(data.realColumnList, function(idx,item){
			var option = new Option(item.colNm,item.colNm);
			$("#metaJoinInsertForm select[name='" + target +"']").append(option);
		});
		
	});
}

function goMetaJoinAdd() {
	var dbConnNo = $("#metaJoinInsertForm input[name='dbConnNo']").val();

	var errflag = false;
	var errstr = "";
	if($("#metaJoinInsertForm select[name='mstTblNm'] option:selected").val() == "") {
		errflag = true;
		errstr += " [MASTER <spring:message code='SYSTBLTL061'/>] ";		// 테이블명
	}
	if($("#metaJoinInsertForm select[name='mstColNm'] option:selected").val() == "") {
		errflag = true;
		errstr += " [MASTER <spring:message code='SYSTBLTL063'/>] ";		// 컬럼명
	}
	if($("#metaJoinInsertForm select[name='joinTy'] option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL063'/>] ";	// 조인유형
	}

	if($("#metaJoinInsertForm select[name='relTy'] option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL069'/>] ";	// 관계유형
	}
	if($("#metaJoinInsertForm select[name='forTblNm'] option:selected").val() == "") {
		errflag = true;
		errstr += " [FORIGN <spring:message code='SYSTBLTL061'/>] ";	// 테이블명
	}
	if($("#metaJoinInsertForm select[name='forColNm'] option:selected").val() == "") {
		errflag = true;
		errstr += " [FORIGN <spring:message code='SYSTBLTL063'/>] ";	// 컬럼명
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}

	var param = $("#metaJoinInsertForm").serialize();
	$.getJSON("<c:url value='/ems/sys/metajoinAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
			
			// 메타 조인 다시 조회
			getContentPageHtml(3);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
		}
	});
}

function goMetaJoinUpdate(joinNo, pos, cnt) {
	$("#metaJoinUpdateData input[name='joinNo']").val( joinNo );
	$("#metaJoinUpdateData input[name='mstTblNm']").val( $("#metaJoinUpdateForm input[name='mstTblNm']").eq(pos).val() );
	$("#metaJoinUpdateData input[name='mstColNm']").val( $("#metaJoinUpdateForm input[name='mstColNm']").eq(pos).val() );
	$("#metaJoinUpdateData input[name='forTblNm']").val( $("#metaJoinUpdateForm input[name='forTblNm']").eq(pos).val() );
	$("#metaJoinUpdateData input[name='forColNm']").val( $("#metaJoinUpdateForm input[name='forColNm']").eq(pos).val() );
	$("#metaJoinUpdateData input[name='joinTy']").val( $("#metaJoinUpdateForm select[name='joinTy']").eq(pos).val() );
	$("#metaJoinUpdateData input[name='relTy']").val( $("#metaJoinUpdateForm select[name='relTy']").eq(pos).val() );
	
	var param = $("#metaJoinUpdateData").serialize();
	$.getJSON("<c:url value='/ems/sys/metajoinUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
			
			// 메타 조인 다시 조회
			getContentPageHtml(3);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
		}
	});
}

function goMetaJoinDelete(joinNo) {
	$("#metaJoinUpdateData input[name='joinNo']").val( joinNo );
	
	var param = $("#metaJoinUpdateData").serialize();
	$.getJSON("<c:url value='/ems/sys/metajoinDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			
			// 메타 조인 다시 조회
			getContentPageHtml(3);
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}
</script>
<form id="hiddenForm" name="hiddenForm" style="display:none;">
<input type="hidden" id="tabIdx" value="1"/>
<input type="hidden" id="hiddenTblNo" value="0"/>
<input type="hidden" id="hiddenTblNm" value=""/>
</form>
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
			
			<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline" style="width: 1015px;">
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
			<table width="800" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
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
			<br/>
			<br/>
			
			
			<!-- TAB Start -->
			<div id="divMenu1" style="width: 1015px;">
			     <table class="nTab dbconn">
				     <tr>
			         	<td align="center" id="td_tab1"><a href="javascript:goTab(1)"><spring:message code='SYSBTN004'/></a></td><!-- 권한관리 -->
			         	<td align="center" id="td_tab2"><a href="javascript:goTab(2)"><spring:message code='SYSBTN005'/></a></td><!-- 메타정보관리 -->
				     	<td align="center" id="td_tab3"><a href="javascript:goTab(3)"><spring:message code='SYSBTN006'/></a></td><!-- 조인정보관리 -->
				     </tr>
			     </table>
			</div>
			
			<!-- Tab Content Start -->
			<div id="divTabContent">
			</div>
			<!-- Tab Content End -->

			<!-- TAB End -->
			
			<br/>
			<br/>
			<br/>
			<!-- 메인 컨텐츠 End -->
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
