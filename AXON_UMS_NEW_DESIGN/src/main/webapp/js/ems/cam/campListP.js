
$(document).ready(function() {
	// 화면 로딩시 검색 실행
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

// 검색 버튼 클릭
function goSearch(pageNo) {
	if($("#searchStartDt").val() > $("#searchEndDt")) {
		alert("검색 시 시작일은 종료일보다 클 수 없습니다.");	// COMJSALT017
		return;
	}
	$("#searchForm input[name='page']").val(pageNo);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./campList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divCampList").html(pageHtml);
		},
		error : function(){
			alert("List Data Error!!");
		}
	});
	//$("#searchForm").attr("target","").attr("action","./campListP.ums").submit();
}

// 초기화 버튼 클릭
function goReset() {
	$("#searchForm")[0].reset();
}

// 캠페인명 클릭시
function goUpdate(campNo) {
	$("#campNo").val(campNo);
	$("#searchForm").attr("target","").attr("action","./campUpdateP.ums").submit();
}

// 메일보기 클릭시
function goMail(campNo) {
	if(campNo) {
		$("#searchForm input[name='campNo']").val(campNo);
		$("#searchForm").attr("target","").attr("action","./mailMainP.ums").submit();
	} else {
		alert("캠페인 선택");		// CAMTBLLB007
	}
}

// 신규등록 클릭시
function goAdd() {
	document.location.href = "./campAddP.ums";
}

//페이징
function goPageNum(page) {
	goSearch(page);
}
