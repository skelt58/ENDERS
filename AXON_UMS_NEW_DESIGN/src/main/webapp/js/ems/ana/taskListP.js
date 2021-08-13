$(document).ready(function() {
	goSearch("1");
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

//검색 버튼 클릭시
function goSearch(pageNum) {
	if( $("#searchStartDt").val() > $("#searchEndDt").val() ) {
		alert("검색 시 시작일은 종료일보다 클 수 없습니다.");		// <spring:message code='COMJSALT017'/>
		return;
	}
	
	$("#searchForm input[name='page']").val(pageNum);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./taskList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divTaskList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

// 초기화 버튼 클릭시
function goReset(obj) {
	//$("#searchTaskNm").val("");
	//$("#searchCampNo").val("0");
	//$("#searchDeptNo").val("0");
	//$("#searchUserId").val("");
	$("#searchForm")[0].reset();
}

// 목록에서 전체선택 클릭시
function goAll() {
	$("#listForm input[name='taskNos']").each(function(idx,item){
		$(item).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
	});
}

// 메일별분석 클릭시 EVENT 구현
function goTaskStep(taskNo) {
	$("#page").val("1");
	$("#searchCampNo").val("0");
	$("#searchTaskNm").val("");
	$("#searchDeptNo").val("0");
	$("#searchUserId").val("");
	$("#taskNo").val(taskNo);
	
	$("#searchForm").attr("target","").attr("action","./taskStepListP.ums").submit();
}

// 병합분석 클릭시
function goJoin() {
	var checkCnt = 0;
	
	$("#listForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) {
			checkCnt++;
		}
	});
	
	if(checkCnt < 2) {
		alert("병합할 대상을 2개이상 선택하세요.");		// ANAJSALT001
	} else {
		//탭을 숨김
		$("#tab").hide();
		$("#notab").show();
		
		$("#listForm").attr("target","iFrmReport").attr("action","./taskJoinP.ums").submit();
	}
}


//탭 관련 변수
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
		alert("메일을 선택하세요.");		// ANAJSALT002
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
		case 'tab1' :	$("#tab1").hide(); $("#click_tab1").show(); break;
		case 'tab2' :	$("#tab2").hide(); $("#click_tab2").show(); break;
		case 'tab3' :	$("#tab3").hide(); $("#click_tab3").show(); break;
		case 'tab4' :	$("#tab4").hide(); $("#click_tab4").show(); break;
		case 'tab5' :	$("#tab5").hide(); $("#click_tab5").show(); break;
		case 'tab6' :	$("#tab6").hide(); $("#click_tab6").show(); break;
		case 'tab7' :	$("#tab7").hide(); $("#click_tab7").show(); break;
	}

	iFrmReport.location.href = target + "?taskNo=" + curTaskNo;
}

// 페이징
function goPageNum(pageNum) {
	goSearch(pageNum);
}