$(document).ready(function() {
	// 예약일 시작일 설정
	$("#searchStartDt").datepicker({
		//showOn:"button",
		minDate:"2021-01-01",
		maxDate:$("#searchEndDt").val(),
		onClose:function(selectedDate) {
			$("#searchEndDt").datepicker("option", "minDate", selectedDate);
		}
	});
	
	// 예약일 종료일 설정
	$("#searchEndDt").datepicker({
		//showOn:"button",
		minDate:$("#searchStartDt").val(),
		onClose:function(selectedDate) {
			$("#searchStartDt").datepicker("option", "maxDate", selectedDate);
		}
	});
	
	goSearch();
});

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("../../com/getUserList.json?deptNo=" + deptNo, function(data) {
		$("#searchUserId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#searchUserId").append(option);
		});
	});
}

// 검색 버튼 클릭시
function goSearch() {
	if( $("#searchStartDt").val() > $("#searchEndDt").val() ) {
		alert("검색 시 시작일은 종료일보다 클 수 없습니다.");		// <spring:message code='COMJSALT017'/>
		return;
	}
	
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./mailList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divMailList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
	
	//$("#searchForm").attr("target","").attr("action","./mailListP.ums").submit();
}

// 초기화 버튼 클릭시
function goReset(obj) {
	$("#searchTaskNm").val("");
	$("#searchCampNo").val("0");
	$("#searchDeptNo").val("0");
	$("#searchUserId").val("");
	//$("#searchForm")[0].reset();
}

// 목록에서 전체선택 클릭시
function goAll() {
	$("#listForm input[name='taskNos']").each(function(idx,item){
		$(item).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
		$("#listForm input[name='subTaskNos']").eq(idx).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
	});
}


// 탭 관련 변수
var curTab = "";
var curTaskNo = "";
var curSubTaskNo = "";
var curDmGrpCd = "";

// 목록에서 메일명 클릭시
function goOz(tabNm, target, taskNo,subTaskNo) {
	curTaskNo = taskNo;
	curSubTaskNo = subTaskNo;
	goOzTab(tabNm, target);
}

// 탭 실행
function goOzTab(tabNm, target) {
	if(curTaskNo == "" || curSubTaskNo == "") {
		alert("메일을 선택하세요.");		// <spring:message code='ANAJSALT002'/>
		return;
	}

	//탭을 보여주고 폼 초기화
	if($("#tab").css("display") == "none") {
		$("#tab").show();
		$("#notab").hide();
		$("#listForm")[0].reset();
	}

	//기존 클릭한 탭을 숨김
	switch(curTab) {
		case 'tab1' :	$("#click_tab1").hide(); $("#tab1").show(); break;
		case 'tab2' :	$("#click_tab2").hide(); $("#tab2").show(); break;
		case 'tab3' :	$("#click_tab3").hide(); $("#tab3").show(); break;
		case 'tab4' :	$("#click_tab4").hide(); $("#tab4").show(); break;
		case 'tab5' :	$("#click_tab5").hide(); $("#tab5").show(); break;
		case 'tab6' :	$("#click_tab6").hide(); $("#tab6").show(); break;
		case 'tab7' :	$("#click_tab7").hide(); $("#tab7").show(); break;
	}

	curTab = tabNm;		//현재 클릭한 탭 설정

	//클릭한 탭을 보여줌
	switch(tabNm) {
		case 'tab1' :	$("#tab1").hide(); $("#click_tab1").show(); $("#saveNm").val( "mail_summ_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab2' :	$("#tab2").hide(); $("#click_tab2").show(); $("#saveNm").val( "mail_error_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab3' :	$("#tab3").hide(); $("#click_tab3").show(); $("#saveNm").val( "mail_domain" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab4' :	$("#tab4").hide(); $("#click_tab4").show(); $("#saveNm").val( "mail_send_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab5' :	$("#tab5").hide(); $("#click_tab5").show(); $("#saveNm").val( "mail_resp_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab6' :	$("#tab6").hide(); $("#click_tab6").show(); break;
		case 'tab7' :	$("#tab7").hide(); $("#click_tab7").show(); break;
	}
	
	iFrmReport.location.href = target + "?taskNo=" + curTaskNo + "&subTaskNo=" + curSubTaskNo;
}

// 병합분석 클릭시
function goJoin() {
	var checkCnt = 0;
	
	$("#listForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) {
			$("#listForm input[name='subTaskNos']").eq(idx).prop("checked", true);
			checkCnt++;
		} else {
			$("#listForm input[name='subTaskNos']").eq(idx).prop("checked", false);
		}
	});
	
	if(checkCnt < 2) {
        alert("병합할 대상을 2개이상 선택하세요.");		// <spring:message code='ANAJSALT001'/>
    } else {
		//탭을 숨김
		$("#tab").hide();
		$("#notab").show();
		
		$("#listForm").attr("target","iFrmReport").attr("action","./mailJoinP.ums").submit();
	}
}


// 페이징
function goPageNum(page) {
	$("#page").val(page);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./mailList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divMailList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}