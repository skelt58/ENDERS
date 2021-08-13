var curEvent = "goSearch";

$(document).ready(function() {
	// 페이지 로딩시 리스트 
	goSearch("1");
});

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(formId, deptNo, userObjectId) {
	$.getJSON("../../com/getUserList.json?deptNo=" + deptNo, function(data) {
		$("#" + formId + " select[name='" + userObjectId + "']").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#" + formId + " select[name='" + userObjectId + "']").append(option);
		});
	});
}

//검색 버튼 클릭
function goSearch(pageNum) {
	if($("#searchStartDt").val() > $("#searchEndDt")) {
		alert("검색 시 시작일은 종료일보다 클 수 없습니다.");	// COMJSALT017
		return;
	}
	$("#searchForm input[name='page']").val(pageNum);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./tempList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divTempList").html(pageHtml);
		},
		error : function(){
			alert("List Data Error!!");
		}
	});
	//$("#searchForm").attr("target","").attr("action","<c:url value='/ems/tmp/tempListP.ums'/>").submit();
}

// 초기화 버튼 클릭
function goReset(formName) {
	if(formName == "searchForm") {			//폼이 검색폼일 경우
		$("#searchTempNm").val("");				//obj.p_temp_nm.value = "";
		//obj.p_channel.selectedIndex = 0;
		$("#searchStatus").val("ALL");				//obj.p_status.selectedIndex = 0;
		$("#searchDeptNo").val("0");			//obj.p_dept_no.selectedIndex = 0;
		$("#searchUserId").val("");				//obj.p_user_id.selectedIndex = 0;
		$("#searchStartDt").val("<c:out value='${searchStartDt}'/>");		//obj.p_stdt.value = "";
		$("#searchEndDt").val("<c:out value='${searchEndDt}'/>");			//obj.p_eddt.value = "";
	} else if(formName == "templateInfoForm") {		//폼이 입력폼일 경우
		if(curEvent == "goNew") {				//현재 EVENT가 신규등록이면 NULL 값으로 폼 세팅
			nullForm();
		} else if(curEvent == "goSelect") {	//템플릿을 선택했다면
			var tempNo = $("#tempNo").val();
			goSelect(tempNo);
		} else {
			initForm();	//폼 초기화
		}
	}
}

//폼 초기화
function initForm() {
	$("#templateInfoForm")[0].reset();		//obj.reset();						//폼 초기화
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);
	getUserList('templateInfoForm',$("#deptNo").val(),"userId");	//그룹별 사용자 초기화
}

//NULL 값으로 폼세팅
function nullForm() {
	$("#tempNo").val("0");				//obj.p_temp_no.value = "";
	$("#tempNm").val("");				//obj.p_temp_nm.value = "";
	$("#tempDesc").val("");				//obj.p_temp_desc.value = "";	
	//obj.p_channel.selectedIndex = 0;
	$("#status").val("");				//obj.p_status.selectedIndex = 0;
	$("#deptNo").val("0");				//obj.p_dept_no.selectedIndex = 0;
	$("#userId").val("");				//obj.p_user_id.selectedIndex = 0;

	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);

	$("#regDt").val("");				//obj.p_reg_dt.value = "";
	$("#regNm").val("");				//obj.p_reg_nm.value = "";
	
	getUserList('templateInfoForm',$("#deptNo").val(),'userId');	//그룹별 사용자 초기화
}

// 신규등록 클릭시
function goNew() {
	curEvent = "goNew";

	//등록시 필요없는 입력폼은 숨김
	$("#trDetail").hide();
	//등록시 등록버튼은 보여주고 수정버튼은 숨김
	$("#btnAdd").show();
	$("#btnUpdate").hide();

	nullForm();
}

//템플릿명 클릭시
function goSelect(tempNo) {
	curEvent = "goSelect";

	//템플릿명 클릭시 숨겨진 폼을 보여줌
	$("#trDetail").show();
	//템플릿명 클릭시 등록 버튼은 숨기고 수정버튼은 보여줌
	$("#btnAdd").hide();
	$("#btnUpdate").show();

	$.getJSON("<c:url value='/ems/tmp/tempInfo.json'/>?tempNo=" + tempNo, function(data) {
		if(data) {
			$("#tempNo").val(data.template.tempNo);
			$("#tempNm").val(data.template.tempNm);
			$("#tempDesc").val(data.template.tempDesc);
			$("#tempFlPath").val(data.template.tempFlPath);
			$("#status").val(data.template.status);
			$("#deptNo").val(data.template.deptNo);
			$("#regNm").val(data.template.regNm);
			var regDt = data.template.regDt;
			regDt = regDt.substring(0,4) + "-" + regDt.substring(4,6) + "-" + regDt.substring(6,8)
			$("#regDt").val(regDt);
			
			$.getJSON("<c:url value='/ems/tmp/tempFileView.json'/>?tempFlPath=" + data.template.tempFlPath, function(res) {
				if(res.result == 'Success') {
	                  oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
					  oEditors.getById["ir1"].exec("PASTE_HTML", [res.tempVal]);   //스마트에디터 내용붙여넣기
				} else {
					
				}
			});
			
			getUserList("templateInfoForm",data.template.deptNo, "userId");
			setTimeout(function(){
				$("#userId").val(data.template.userId);
			},500);
		}
	});
}

// 등록 버튼 클릭시
function goAdd() {
	if(checkForm()) return;
	
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#tempVal").val( $("#ir1").val() );
	
	// 등록 처리
	$("#templateInfoForm").attr("target","iFrmTemplate").attr("action","<c:url value='/ems/tmp/tempAddP.ums'/>").submit();
}

//수정 버튼 클릭시
function goUpdate() {
	if($("#tempNo").val() != "0") {
		if(checkForm()) return;
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	    $("#tempVal").val( $("#ir1").val() );
	    
		// 수정 처리
		$("#templateInfoForm").attr("target","iFrmTemplate").attr("action","<c:url value='/ems/tmp/tempUpdateP.ums'/>").submit();
		
	} else {
		alert("<spring:message code='CAMTBLLB010'/>");		// 템플릿 선택
	}
}

//입력폼 체크
function checkForm() {
	var errstr = "";
	var errflag = false;
	if($("#tempNm").val() == "") {
		errstr += "[<spring:message code='TMPTBLTL002'/>]";		// 템플릿명
		errflag = true;
	}
	if($("#status").val() == "") {
		errstr += "[<spring:message code='COMTBLTL001'/>]";		// 상태
		errflag = true;
	}
	if($("#deptNo").val() == "0") {
		errstr += "[<spring:message code='COMTBLTL004'/>]";		// 사용자그룹
		errflag = true;
	}
	if($("#userId").val() == "") {
		errstr += "[<spring:message code='COMTBLTL005'/>]";		// 사용자
		errflag = true;
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
	}
	return errflag;
}

//페이징
function goPageNum(pageNum) {
	goSearch(pageNum);
}
