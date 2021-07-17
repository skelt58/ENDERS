<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 부서관리 메인 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
var deptInfoDialog;
var userInfoDialog;

$(document).ready(function() {
	// 그룹명 입력란에서 엔터키를 누르는 경우
    $("#searchDeptNm").keydown(function (e) {
        if(e.keyCode == 13){
        	e.preventDefault();
        	showDeptGrid();
        }
    });
	
	// 검색 버튼 클릭
	$("#btnSearch").click(function(e) {
		e.preventDefault();
		showDeptGrid();
	});
	
	// 초기화 버튼 클릭
	$("#btnClear").click(function(e) {
		e.preventDefault();
		$("#searchForm")[0].reset();
	});
	
	// 부서 신규등록 버튼 클릭
	$("#btnPopDeptAdd").click(function(e) {
		deptInfoDialog = $("#divDeptInfo").dialog({
			title:"부서 신규 등록",
			width:800,
			height:400,
			modal:true,
			buttons: {
				"등록": insertDeptInfo,
				"취소": function() {
					deptInfoDialog.dialog("close");
				}
			},
			close: function() {
				$("#deptInfoForm")[0].reset();
			}
		});
	});
	
	// 사용자 신규등록 버튼 클릭
	$("#btnPopUserAdd").click(function(e) {
		// 처리모드(등록)
		$("#procMode").val("I");
		
		userInfoDialog= $("#divUserInfo").dialog({
			title:"사용자 신규 등록",
			width:1000,
			height:500,
			modal:true,
			buttons: {
				"등록": procUserInfo,
				"취소": function() {
					userInfoDialog.dialog("close");
				}
			},
			close: function() {
				$("#userInfoForm")[0].reset();
			}
		});
		
		$("#userId").css('backgroundColor', '#ffffff');
		$("#userId").attr("readonly",false);
		$("#userId").focus();
		
		$("#userPwd").attr("placeholder","");
		$("#userPwdConf").attr("placeholder","");
		
		// 그룹(부서) 선택
		$('#selDeptNo option').each(function(){
			if($(this).val() == $("#userDeptNo").val()) {
				$(this).prop('selected', true);
			}
		});

	});
	
	// 사용자입력 Blur
	$("#userId").blur(function(e) {
		// 사용자 아이디 중복 체크
		if($("#procMode").val() == "I" && $("#userId").val() != "") {
			checkUserId();
		}
	});
	
	// jqGrid 실행
	showDeptGrid();
});

/********************************************************************************************************************
 * 부서 정보 처리
 ********************************************************************************************************************/
// 부서목록 jqGrid 조회
function showDeptGrid() {
	// 부서 목록 초기화
	$("#deptList").jqGrid("GridUnload");
	
	// 사용자 목록 숨김
	$("#divUserList").hide();

	// Grid 데이터 조회 및 설정
	var param = $("#searchForm").serialize();
	$("#deptList").jqGrid({
		url          :"<c:url value='/ems/sys/deptList.json'/>?" + param,
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
                        {name:'deptNo'		,index:'deptNo'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL017"/>'},	// 그룹번호
                        {name:'deptNm'		,index:'deptNm'		,width:300	,align:'left'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL018"/>', formatter:deptInfo},	// 그룹명
                        {name:'statusNm'	,index:'statusNm'	,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL020"/>'},	// 그룹상태
                        {name:'regId'		,index:'regId'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL021"/>'},	// 등록자
                        {name:'regDt'		,index:'regDt'		,width:200	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL022"/>'},	// 등록일
                        {name:'pDeptNo'		,index:'pDeptNo'	,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL024"/>', formatter:userList}	// 사용자보기
					  ],
		rowNum       : "10",
		rownumbers	 : false,
		autowidth    : false,
		viewrecords  : true,
		loadonce     : false,
		pager		 : "#pagerDept",
		multiselect  : false,
		cmTemplate	 : { sortable: false },
		autoencode   : true,
		cellEdit     : false
	});
}

// 부서(그룹) 그리드에서 그룹명 클릭 함수정의
function deptInfo(cellvalue, options, rowObject) {
	return '<a href="#" onclick="getDeptInfo(' + options.rowId + '); return false;">' + $.jgrid.htmlEncode(cellvalue) + '</a>';
}

//부서(그룹) 그리드에서 그룹명 클릭 함수정의
function userList(cellvalue, options, rowObject) {
	return '<a href="#" onclick="getUserList(' + options.rowId + '); return false;"><spring:message code="SYSBTN001"/></a>';
}

// 부서(그룹) 정보 조회
function getDeptInfo(rowId) {
	var deptNo = $("#deptList").jqGrid('getRowData',rowId).deptNo;
	$.getJSON("<c:url value='/ems/sys/deptInfo.json'/>?deptNo=" + deptNo, function(data) {
		if(data) {
			$("#deptInfoReg").show();
			
			var frm = $("#deptInfoForm")[0];
			$(frm.deptNo).val(data.deptInfo.deptNo);
			$(frm.deptNm).val(data.deptInfo.deptNm);
			$(frm.deptDesc).val(data.deptInfo.deptDesc);
			$(frm.regId).val(data.deptInfo.regId);
			$(frm.regDt).val(data.deptInfo.regDt);
			$(frm.upId).val(data.deptInfo.upId);
			$(frm.upDt).val(data.deptInfo.upDt);
			
			var status = data.deptInfo.status;
			$('#status option').each(function(){
				if($(this).val() == status) {
					$(this).prop('selected', true);
				}
			});
			
			deptInfoDialog = $("#divDeptInfo").dialog({
				title:"그룹 정보 수정",
				width:800,
				height:400,
				modal:true,
				buttons: {
					"수정": updateDeptInfo,
					"취소": function() {
						deptInfoDialog.dialog("close");
					}
				},
				close: function() {
					$("#deptInfoReg").hide();
					$("#deptInfoForm")[0].reset();
				}
			});
			
		}
	});
}

//부서(그룹) 정보 등록
function insertDeptInfo() {
	var frm = $("#deptInfoForm")[0];
	var errflag = false;
	var errstr = "";
	if($(frm.deptNm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL018'/>] "; // 그룹명
	}

	if($("#status option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL028'/>] "; // 상태
	}

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr); // 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#deptInfoForm").serialize();
	$.getJSON("<c:url value='/ems/sys/deptAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");
			deptInfoDialog.dialog("close");
			
			// jqGrid 새로고침
			showDeptGrid();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT009'/>");
		}
	});
}

// 부서(그룹) 정보 수정
function updateDeptInfo() {
	var frm = $("#deptInfoForm")[0];
	var errflag = false;
	var errstr = "";
	if($(frm.deptNm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL018'/>] "; // 그룹명
	}

	if($("#status option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL028'/>] "; // 상태
	}

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr); // 다음 정보를 확인하세요.
		return;
	}
	
	var param = $("#deptInfoForm").serialize();
	$.getJSON("<c:url value='/ems/sys/deptUpdate.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT010'/>");
			deptInfoDialog.dialog("close");
			
			// jqGrid 새로고침
			showDeptGrid();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT011'/>");
		}
	});
}


/********************************************************************************************************************
 * 사용자 정보 처리
 ********************************************************************************************************************/
// 사용자 그리드 
function getUserList(rowId) {
	var deptNo = $("#deptList").jqGrid('getRowData',rowId).deptNo;
	getUserListGrid(deptNo);
}

//사용자목록 jqGrid 조회
function getUserListGrid(deptNo) {
	$("#divUserList").show();
	
	$("#userList").jqGrid("GridUnload");
	
	$("#userDeptNo").val(deptNo);
	
	// 입력값 설정
	var paramData = [];
	paramData.push({name:"deptNo",value:deptNo});
	if($("#userList").getGridParam("page")) {
		paramData.push({name:"page",value:$("#userList").getGridParam("page")});
	}
	
	var param = $("#userInfoForm").serialize();
	
	// Grid 데이터 조회 및 설정
	$("#userList").jqGrid({
		url          :"<c:url value='/ems/sys/userList.json'/>?" + param,
		mtype        :"POST",
		datatype     :"json",
		//postData     : paramData,
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
                        {name:'userId'		,index:'userId'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL025"/>'},	// 사용자ID
                        {name:'userNm'		,index:'userNm'		,width:300	,align:'left'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL026"/>', formatter:userInfo},	// 사용자명
                        {name:'statusNm'	,index:'statusNm'	,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL027"/>'},	// 사용자상태
                        {name:'uilangNm'	,index:'uilangNm'	,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL029"/>'},	// UI언어권
                        {name:'tzNm'		,index:'tzNm'		,width:100	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL030"/>'},	// 타임존
                        {name:'regId'		,index:'regId'		,width:200	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL021"/>'},	// 등록자
                        {name:'regDt'		,index:'regDt'		,width:200	,align:'center'	,hidden:false	,title:true		,label:'<spring:message code="SYSTBLTL022"/>'}	// 등록일
					  ],
		rowNum       : "10",
		rownumbers	 : false,
		autowidth    : false,
		viewrecords  : true,
		loadonce     : false,
		pager		 : "#pagerUser",
		multiselect  : false,
		cmTemplate	 : { sortable: false },
		autoencode   : true,
		cellEdit     : false
	});
}

// 사용자 그리드에서 사용자명 클릭 함수정의
function userInfo(cellvalue, options, rowObject) {
	return '<a href="#" onclick="getUserInfo(' + options.rowId + '); return false;">' + $.jgrid.htmlEncode(cellvalue) + '</a>';
}

// 사용자 정보 조회
function getUserInfo(rowId) {
	var userId = $("#userList").jqGrid('getRowData',rowId).userId;
	$.getJSON("<c:url value='/ems/sys/userInfo.json'/>?userId=" + userId, function(data) {
		if(data) {
			$("#userInfoReg").show();
			
			var frm = $("#userInfoForm")[0];
			$(frm.userId).val(data.userInfo.userId);
			$(frm.userId).attr("readonly",true);
			$("#userId").css('backgroundColor', '#cccccc');

			$(frm.userNm).val(data.userInfo.userNm);
			$(frm.userNm).focus();
			//$(frm.userStatus).val(data.userInfo.status);
			var status = data.userInfo.status;
			$('#userStatus option').each(function(){
				if($(this).val() == status) {
					$(this).prop('selected', true);
				}
			});
			$(frm.userPwd).attr("placeholder","비밀번호 수정시에만 입력");
			$(frm.userPwdConf).attr("placeholder","비밀번호 수정시에만 입력");
			//$(frm.userPwd).val(data.userInfo.userPwd);
			//$(frm.userPwdConf).val(data.userInfo.userPwd);
			var deptNo = data.userInfo.deptNo;
			$('#selDeptNo option').each(function(){
				if($(this).val() == deptNo) {
					$(this).prop('selected', true);
				}
			});
			$(frm.userEm).val(data.userInfo.userEm);
			$(frm.userTel).val(data.userInfo.userTel);
			$(frm.mailFromNm).val(data.userInfo.mailFromNm);
			$(frm.mailFromEm).val(data.userInfo.mailFromEm);
			$(frm.replyToEm).val(data.userInfo.replyToEm);
			$(frm.returnEm).val(data.userInfo.returnEm);
			var charset = data.userInfo.charset;
			$('#charset option').each(function(){
				if($(this).val() == charset) {
					$(this).prop('selected', true);
				}
			});
			var tzCd = data.userInfo.tzCd;
			$('#tzCd option').each(function(){
				if($(this).val() == tzCd) {
					$(this).prop('selected', true);
				}
			});
			var uilang = data.userInfo.uilang;
			$('#uilang option').each(function(){
				if($(this).val() == uilang) {
					$(this).prop('selected', true);
				}
			});
			$(frm.userDesc).val(data.userInfo.userDesc);
			
			$(frm.userRegId).val(data.userInfo.regId);
			$(frm.userRegDt).val(data.userInfo.regDt);
			$(frm.userUpId).val(data.userInfo.upId);
			$(frm.userUpDt).val(data.userInfo.upDt);
			
			// 사용자 프로그램 선택
			var userProgList = data.userProgList;
			$.each(userProgList,function(idx,row){
				var userProgId = userProgList[idx].progId;
				$(frm.progId).each(function() {
					if(userProgId == this.value) {
						this.checked = true;
					}
				});
			});

			$(frm.progId).each(function() {
				var progId = this.value;
			});
			
			// 처리모드(수정)
			$("#procMode").val("U");
			userInfoDialog = $("#divUserInfo").dialog({
				title:"사용자 정보 수정",
				width:1000,
				height:500,
				modal:true,
				buttons: {
					"수정": procUserInfo,
					"취소": function() {
						userInfoDialog.dialog("close");
					}
				},
				close: function() {
					$("#userInfoReg").hide();
					$("#userInfoForm")[0].reset();
				}
			});
			
		}
	});

}


// 사용자 정보 등록/수정
function procUserInfo() {
	
	// 입력값 유효성 검사
	var frm = $("#userInfoForm")[0];
	var errflag = false;
	var errstr = "";
	if($(frm.userId).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL025'/>] ";	// 사용자ID
	}
	if($("#selDeptNo option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL017'/>] ";	// 그룹
	}
	if($(frm.userNm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL026'/>] ";	// 사용자명
	}
	if($("#userStatus option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL028'/>] ";	// 상태
	}
	if($(frm.userEm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL032'/>] ";	// 이메일
	}
	if($(frm.userTel).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL033'/>] ";	// 연락처
	}
	if($("#charset option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL038'/>] ";	// 메일문자셋
	}
	if($("#tzCd option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL030'/>] ";	// 타임존
	}
	if($("#uilang option:selected").val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL029'/>] ";	// UI 언어권
	}
	if($(frm.mailFromNm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL034'/>] ";	// 발송자명
	}
	if($(frm.mailFromEm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL035'/>] ";	// 발송자이메일
	}
	if($(frm.replyToEm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL036'/>] ";	// 회신이메일
	}
	if($(frm.returnEm).val() == "") {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLTL037'/>] ";	// RETURN이메일
	}
	// 등록시에만 비밀번호 필수 입력, 수정시 입력하지 않으면 기존 비밀번호 유지
	if($("#procMode").val() == "I") {
		if($(frm.userPwd).val() == "") {
			errflag = true;
			errstr += " [<spring:message code='SYSTBLTL031'/>] ";	// 비밀번호
		}
	}
	if($(frm.userPwd).val() != $(frm.userPwdConf).val()) {
		errflag = true;
		errstr += " [<spring:message code='SYSTBLLB001'/>] ";	// 비밀번호확인
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}
	
	
	// 사용자 정보 등록 처리
	if($("#procMode").val() == "I") {
		var param = $("#userInfoForm").serialize();
		$.getJSON("<c:url value='/ems/sys/userAdd.json'/>?" + param, function(data) {
			if(data.result == "Success") {
				alert("<spring:message code='COMJSALT008'/>");
				userInfoDialog.dialog("close");
				
				// jqGrid 새로고침
				getUserListGrid($("#userDeptNo").val());
			} else if(data.result == "Fail") {
				alert("<spring:message code='COMJSALT009'/>");
			}
		});
	}
	
	// 사용자 정보 수정 처리
	if($("#procMode").val() == "U") {
		var param = $("#userInfoForm").serialize();
		$.getJSON("<c:url value='/ems/sys/userUpdate.json'/>?" + param, function(data) {
			if(data.result == "Success") {
				alert("<spring:message code='COMJSALT010'/>");
				userInfoDialog.dialog("close");
				
				// jqGrid 새로고침
				getUserListGrid($("#userDeptNo").val());
			} else if(data.result == "Fail") {
				alert("<spring:message code='COMJSALT011'/>");
			}
		});
	}
}

// 사용자 아이디 체크(중복 확인)
function checkUserId() {
	var userId = $("#userId").val();
	$.getJSON("<c:url value='/ems/sys/userIdCheck.json'/>?userId=" + userId, function(data) {
		if(data.result == "Success") {
			alert("사용가능한 아이디입니다.");
			$("#userId").css('backgroundColor', '#cccccc');
			$("#userId").attr("readonly",true);
			$("#userNm").focus();
			
		} else if(data.result == "Fail") {
			alert("이미 사용중인 아이디입니다.");
			$("#userId").val("");
			$("#userId").focus();
		}
	});
	
}
</script>

<div class="ex-layout">
	<!-- 상단메뉴 -->
	<div class="gnb">
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<!-- 좌측 메뉴 -->
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			<div><spring:message code='SYSTBLTL002'/></div><!-- 그룹/사용자관리 -->
			<div>
				<form id="searchForm" name="searchForm">
				<table>
					<colgroup>
						<col style="width:15%" />
						<col style="width:30%" />
						<col style="width:15%" />
						<col style="width:40%" />
					</colgroup>
					<tr>
						<td><spring:message code='SYSTBLTL018'/></td><!-- 그룹명 -->
						<td>
							<input id="searchDeptNm" name="searchDeptNm" type="text" size="20" maxlength="20">
						</td>
						<td><spring:message code='SYSTBLTL020'/></td><!-- 그룹상태 -->
						<td>
							<select id="searchStatus" name="searchStatus">
								<option value="">::: <spring:message code='SYSTBLLB005'/> :::</option><!-- 그룹상태선택 -->
								<c:if test="${fn:length(deptStatusList) > 0}">
									<c:forEach items="${deptStatusList}" var="statusVO">
										<c:choose>
											<c:when test="${statusVO.cd eq '000'}">
												<option value="<c:out value='${statusVO.cd}'/>" selected><c:out value="${statusVO.cdNm}"/></option>
											</c:when>
											<c:otherwise>
												<option value="<c:out value='${statusVO.cd}'/>"><c:out value="${statusVO.cdNm}"/></option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</c:if>
							</select>
							<input id="btnSearch" type="button" value="<spring:message code='COMBTN002'/>"><!-- 검색 -->
							<input id="btnClear" type="button" value="<spring:message code='COMBTN003'/>"><!-- 초기화 -->
						</td>
							
					</tr>
				</table>
				</form>
				<br/>
				<div style="width:900px;text-align:right;align:right;">
					<input type="button" id="btnPopDeptAdd" value="<spring:message code='COMBTN004'/>"/><!-- 신규등록 -->
				</div>
				
				<!-- 그룹 목록 jqGrid Start -->
				<table id="deptList" summary="그룹목록"></table>
				<div id="pagerDept"></div>
				<!-- 그룹 목록 jqGrid End -->
				<br/>
				
				<!-- 사용자목록 jqGrid Start -->
				<div id="divUserList" style="display:none;">
					<div style="width:900px;text-align:right;align:right;">
						<input type="button" id="btnPopUserAdd" value="<spring:message code='COMBTN004'/>"><!-- 신규등록 -->
					</div>
					<table id="userList" summary="사용자목록"></table>
					<div id="pagerUser"></div>
				</div>
				<!-- 사용자목록 jqGrid End -->
									
			</div>
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

<!-- 부서 정보 등록/수정용 화면 -->
<div id="divDeptInfo" style="display:none;">
	<form id="deptInfoForm" name="deptInfoForm">
	<input type="hidden" id="deptNo" name="deptNo" value="0"/>
	<table style="width:750px;">
		<colgroup>
		   	<col style="width:15%" />
		   	<col style="width:35%" />
		   	<col style="width:15%" />
		   	<col style="width:35%" />
		</colgroup>
		<tr>
		    <td><spring:message code='SYSTBLTL018'/></td><!-- 그룹명 -->
			<td class="td_body">
				<input type="text" id="deptNm" name="deptNm" class="wBig" value="" maxlength="30">
			</td>
		    <td><spring:message code='SYSTBLTL028'/></td><!-- 상태 -->
			<td class="td_body">
				<select id="status" name="status" class="wBig">
					<c:if test="${fn:length(deptStatusList) > 0}">
						<c:forEach items="${deptStatusList}" var="statusVO">
							<option value="<c:out value='${statusVO.cd}'/>"><c:out value="${statusVO.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
			<td><spring:message code='SYSTBLTL019'/></td><!-- 그룹설명 -->
			<td colspan="4">
				<textarea id="deptDesc" name="deptDesc" cols="50" rows="8"></textarea>
			</td>
		</tr>
	</table>
	
	<table id="deptInfoReg" style="width:750px;display:none;">
		<tr>
			<td width="10%"><spring:message code='SYSTBLTL021'/></td><!-- 등록자 -->
			<td class="td_body">
				<input type="text" id="regId" name="regId" maxlength="20" size="8" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL022'/></td><!-- 등록일 -->
			<td>
				<input type="text" id="regDt" name="regDt" maxlength="50" size="12" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL042'/></td><!-- 수정자 -->
			<td>
				<input type="text" id="upId" name="upId" maxlength="20" size="8" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL043'/></td><!-- 수정일 -->
			<td  class="td_body">
				<input type="text" id="upDt" name="upDt" maxlength="50" size="12" value="" readOnly>
			</td>
		</tr>
	</table>
	</form>
</div>

<!-- 사용자 정보 등록/수정용 화면 -->
<div id="divUserInfo" style="display:none;">

	<form id="userInfoForm" name="userInfoForm">
	<input type="hidden" id="procMode" name="procMode"/>
	<input type="hidden" id="userDeptNo" name="userDeptNo"/>
	<table>
		<colgroup>
		    	<col style="width:13%" />
		    	<col style="width:20%" />
		    	<col style="width:13%" />
		    	<col style="width:20%" />
		    	<col style="width:13%" />
		    	<col style="width:20%" />
		</colgroup>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL025'/></td><!-- 사용자ID -->
			<td class="td_body">
				<input type="text" id="userId" name="userId" maxlength="10">
				<!--<input type="button" value="<spring:message code='COMBTN012'/>" onClick="goIDCheck()" class="btn_style"> 찾기 -->
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL026'/></td><!-- 사용자명 -->
			<td class="td_body">
				<input type="text" id="userNm" name="userNm" maxlength="15" maxlength="30">
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL028'/></td><!-- 상태 -->
			<td  class="td_body">
				<select name="userStatus">
					<c:if test="${fn:length(userStatusList) > 0}">
						<c:forEach items="${userStatusList}" var="statusVO">
							<option value="<c:out value='${statusVO.cd}'/>"><c:out value="${statusVO.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL031'/></td><!-- 비밀번호 -->
			<td  class="td_body" colspan="3">
				<input type="password" id="userPwd" name="userPwd" maxlength="15">
				[<spring:message code='SYSTBLLB001'/>]<input type="password" id="userPwdConf" name="userPwdConf" maxlength="15">
			</td><!-- 비밀번호확인 -->
		    <td class="td_title"><spring:message code='SYSTBLTL017'/></td><!-- 그룹 -->
			<td  class="td_body">
				<select id="selDeptNo" name="selDeptNo">
					<c:if test="${fn:length(deptList) > 0}">
						<c:forEach items="${deptList}" var="dept">
							<option value="<c:out value='${dept.deptNo}'/>"><c:out value="${dept.deptNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL032'/></td><!-- 이메일 -->
			<td class="td_body">
				<input type="text" id="userEm" name="userEm"  maxlength="50">
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL033'/></td><!-- 연락처 -->
			<td class="td_body">
				<input type="text" id="userTel" name="userTel" maxlength="15">
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL034'/></td><!-- 발송자명 -->
			<td class="td_body">
				<input type="text" id="mailFromNm" name="mailFromNm" maxlength="20">
			</td>
		</tr>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL035'/></td><!-- 발송자이메일 -->
			<td class="td_body">
				<input type="text" id="mailFromEm" name="mailFromEm"  maxlength="50">
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL036'/></td><!-- 회신이메일 -->
			<td class="td_body">
				<input type="text" id="replyToEm" name="replyToEm" maxlength="50">
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL037'/></td><!-- RETURN이메일 -->
			<td class="td_body">
				<input type="text" id="returnEm" name="returnEm" maxlength="50">
			</td>
		</tr>
		<tr>
		    <td class="td_title"><spring:message code='SYSTBLTL038'/></td><!-- 메일문자셋 -->
			<td class="td_body">
				<select id="charset" name="charset">
					<c:if test="${fn:length(charsetList) > 0}">
						<c:forEach items="${charsetList}" var="charsetVO">
							<option value="<c:out value='${charsetVO.cd}'/>"><c:out value="${charsetVO.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL030'/></td><!-- 타임존 -->
			<td class="td_body">
				<select id="tzCd" name="tzCd">
					<c:if test="${fn:length(timezoneList) > 0}">
						<c:forEach items="${timezoneList}" var="timezoneVO">
							<option value="<c:out value='${timezoneVO.cd}'/>"><c:out value="${timezoneVO.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		    <td class="td_title"><spring:message code='SYSTBLTL029'/></td><!-- UI 언어권 -->
			<td class="td_body">
				<select id="uilang" name="uilang">
					<c:if test="${fn:length(uilangList) > 0}">
						<c:forEach items="${uilangList}" var="uilangVO">
							<option value="<c:out value='${uilangVO.cd}'/>"><c:out value="${uilangVO.cdNm}"/></option>
						</c:forEach>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL039'/></td><!-- 사용자설명 -->
			<td  class="td_body" colspan="5">
				<textarea id="userDesc" name="userDesc" cols="50" rows="5"></textarea>
			</td>
		</tr>
		<tr>
			<td class="td_title"><spring:message code='SYSTBLTL041'/></td><!-- 사용프로그램 -->
			<td class="td_body" colspan="5">
				<table>
					<c:if test="${fn:length(programList) > 0}">
						<tr>
							<c:forEach items="${programList}" var="programVO">
								<td>
									<input type="checkbox" id="progId" name="progId" value="<c:out value='${programVO.cd}'/>"> <c:out value="${programVO.cdNm}"/>
								</td>
							</c:forEach>
						</tr>
					</c:if>
				</table>
			</td>
		</tr>
	</table>

	<table id="userInfoReg" style="width:750px;display:none;">
		<tr>
			<td width="10%"><spring:message code='SYSTBLTL021'/></td><!-- 등록자 -->
			<td class="td_body">
				<input type="text" id="userRegId" name="regId" maxlength="20" size="8" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL022'/></td><!-- 등록일 -->
			<td>
				<input type="text" id="userRegDt" name="regDt" maxlength="50" size="12" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL042'/></td><!-- 수정자 -->
			<td>
				<input type="text" id="userUpId" name="upId" maxlength="20" size="8" value="" readOnly>
			</td>
			<td width="10%"><spring:message code='SYSTBLTL043'/></td><!-- 수정일 -->
			<td  class="td_body">
				<input type="text" id="userUpDt" name="upDt" maxlength="50" size="12" value="" readOnly>
			</td>
		</tr>
	</table>

	</form>

</div>

</body>

</html>
