$(document).ready(function() {
	goSearch("1");
});

// 사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("../../com/getUserList.json?deptNo=" + deptNo, function(data) {
		$("#searchForm select[name='searchUserId']").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#searchForm select[name='searchUserId']").append(option);
		});
	});
}

// 조회
function goSearch(pageNo) {
	$("#searchForm input[name='page']").val(pageNo);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./segList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divSegList").html(pageHtml);
		},
		error : function(){
			alert("List Data Error!!");
		}
	});
	//$("#searchForm").attr("target","").attr("action","./segMainP.ums.").submit();
}

// 검색조건을 초기화 함
function goInit() {
	$("#searchForm")[0].reset();
}

// 등록
function goAddf() {
	$("#searchForm").attr("target","").attr("action","./segFileAddP.ums").submit();
}

// 사용중지 EVENT 구현
function goDisable() {
    var checked = false;
    if($("input[name='segNos']").val() != "undefined") {
    	$("input[name='segNos']").each(function(idx,item) {
    		if($(item).is(":checked") == true) {
    			checked = true;
    		}
    	});
    }
    if(!checked) {
        alert("사용중지 할 목록을 선택해 주세요.");		// CAMJSALT013
        return;
    }

    $("#status").val("001");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("사용중지성공");		// CAMJSALT028
			goSearch("1");
			//$("#searchForm").attr("target","").attr("action","./segMainP.ums").submit();
		} else if(data.result == 'Fail') {
			alert("사용중지실패");		// CAMJSALT030
		}
	});
}

// 삭제 EVENT 구현
function goDelete() {
    var checked = false;
    if($("input[name='segNos']").val() != "undefined") {
    	$("input[name='segNos']").each(function(idx,item) {
    		if($(item).is(":checked") == true) {
    			checked = true;
    		}
    	});
    }
    if(!checked) {
        alert("삭제할 목록을 선택해 주세요!!");		// 삭제할 목록을 선택해 주세요!!CAMJSALT025
        return;
    }
	
    $("#status").val("002");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("삭제 성공");		// COMJSALT012
			goSearch("1");
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("삭제 실패");		// COMJSALT013
		}
	});
}

// 목록에서 전체 체크박스 클릭시
function goSelectAll() {
    if($("#searchForm input[name='isAll']").is(":checked")) {
    	$("#searchForm input[name='segNos']").each(function(idx,item){
    		$(item).prop("checked", true);
    	});
    } else {
    	$("#searchForm input[name='segNos']").each(function(idx,item){
    		$(item).prop("checked", false);
    	});
    }
}

// 삭제된 항목의 체크박스 클릭시
function goDeleteClick() {
    alert("삭제된 목록은 선택할 수 없습니다.");	// CAMJSALT019
    return false;
}

// 목록에서 발송대상(세그먼트) 클릭시 수정화면 이동
function goUpdatef(segNo,createTy,filePath) {
    $("#searchForm input[name='segNo']").val(segNo);
    $("#searchForm input[name='createTy']").val(createTy);
    
	var actionUrl = "";
    if(createTy == '000') actionUrl = "<c:url value='/ems/seg/segToolUpdateP.ums'/>";
    if(createTy == '001') actionUrl = "<c:url value='/ems/seg/segOneClickUpdateP.ums'/>";
    if(createTy == '002') actionUrl = "<c:url value='/ems/seg/segDirectSQLUpdateP.ums'/>";
    if(createTy == '003') actionUrl = "<c:url value='/ems/seg/segFileUpdateP.ums'/>";
    if(createTy == '004') { 
    	if(filePath.substring(0,4)=="PUSH")	actionUrl = "<c:url value='/ems/seg/segRemarketUpdatePushP.ums'/>";
    	else actionUrl = "./segRemarketUpdateP.ums";
    }

    $("#searchForm").attr("target","").attr("action",actionUrl).submit();
}

// 목록에서 질의문 클릭 시 대상자보기(미리보기)
function goSegInfo(segNo) {
    $("#searchForm input[name='segNo']").val(segNo);
    window.open("","segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
    $("#searchForm").attr("target","segInfo").attr("action","./segInfoP.ums").submit();
}

// 페이지 이동
function goPageNum(page) {
	goSearch(page);
	//$("#searchForm").attr("target","").attr("action","./segMainP.ums").submit();
}
