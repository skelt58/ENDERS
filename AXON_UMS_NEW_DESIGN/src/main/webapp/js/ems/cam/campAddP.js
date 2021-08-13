$(document).ready(function(){
	$("#eaiCampNo").on("keyup", function() {
		$(this).val( $(this).val().replace(/[^A-Z0-9]/gi,"") );
		$(this).val( $(this).val().toUpperCase() );
	});
});

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("../../com/getUserList.json?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#userId").append(option);
		});
	});
}

// 등록 클릭시
function goAdd() {
	// 입력 폼 검사
	if(checkForm()) {
		return;
	}
	
	var param = $("#campaignInfoForm").serialize();
	$.getJSON("./campAdd.json?" + param, function(data) {
		if(data.result == "Success") {
			alert("등록 성공");		// COMJSALT008
			document.location.href= "./campListP.ums";
		} else {
			alert("등록 실패");		// COMJSALT009
		}
	});
}

// 입력 폼 검사
function checkForm() {
	var errstr = "";
	var errflag = false;
	if($("#campNm").val() == "") {
		errstr += "[캠페인명]";		// CAMTBLTL007
		errflag = true;
	}
	if($("#campTy").val() == "") {
		errstr += "[캠페인목적]";		// CAMTBLTL008
		errflag = true;
	}
	if($("#status").val() == "") {
		errstr += "[상태]";		// COMTBLTL001
		errflag = true;
	}
	if($("#deptNo").val() == "") {
		errstr += "[사용자그룹]";		// COMTBLTL004
		errflag = true;
	}
	if($("#userId").val() == "") {
		errstr += "[사용자]";		// COMTBLTL005
		errflag = true;
	}
	if(errflag) {
		alert("다음 정보를 확인하세요.\n" + errstr);		// COMJSALT016
	}
	return errflag;
}

//  취소 클릭시(리스트로 이동)
function goCancel() {
	document.location.href= "./campListP.ums";
}
