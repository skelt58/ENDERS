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
		url : "./campList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divCampList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
	
	//$("#searchForm").attr("target","").attr("action","./mailListP.ums").submit();
}

// 초기화 버튼 클릭시
function goReset(obj) {
	$("#searchCampNm").val("");
	$("#searchCampTy").val("");
	$("#searchDeptNo").val("0");
	$("#searchUserId").val("");
}

// 목록에서 전체선택 클릭시
function goAll() {
	$("#listForm input[name='campNos']").each(function(idx,item){
		$(item).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
	});
}

// 목록에서 캠페인명 클릭시
function goOz(campNo, target) {
	iFrmReport.location.href = target + "?campNo=" + campNo;
}



// 페이징
function goPageNum(page) {
	$("#page").val(page);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./campList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divCampList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
	//$("#searchForm").attr("target","").attr("action","./mailListP.ums").submit();
}