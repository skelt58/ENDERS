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

// 수정 클릭시
function goUpdate() {
	if($("#campNo").val() != "0") {
		// 입력 폼 검사
		if(checkForm()) {
			return;
		}
		
		var param = $("#campaignInfoForm").serialize();
		$.getJSON("./campUpdate.json?" + param, function(data) {
			if(data.result == "Success") {
				alert("수정 성공");		// COMJSALT010
				$("#page").val("1");
				$("#campaignInfoForm").attr("target","").attr("action","./campListP.ums").submit();
			} else {
				alert("수정 실패");		// COMJSALT011
			}
		});
	} else {
		alert("캠페인 선택");				// 캠페인 선택CAMTBLLB007
	}
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
	$("#campaignInfoForm").attr("target","").attr("action","./campListP.ums").submit();
}
