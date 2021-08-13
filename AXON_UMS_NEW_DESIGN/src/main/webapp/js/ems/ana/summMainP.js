// 사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("../../com/getUserList.json?deptNo=" + deptNo, function(data) {
		$("#searchUserId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#searchUserId").append(option);
		});
	});
}

// 검색버튼 클릭시
function goOz() {
	var errstr = "";
	var errflag = false;
	if($("#searchStartDt").val() == "") {
		errstr += "[기간]";	// COMTBLTL006
		errflag = true;
	}
	if($("#searchEndDt").val() == "") {
		errstr += "[기간]";	// COMTBLTL006
		errflag = true;
	}
	if(errflag) {
		alert("다음 정보를 확인하세요.\n" + errstr);		// COMJSALT016
		return errflag;
	}
	if( $("#searchStartDt").val() > $("#searchEndDt").val()) {
		alert("검색 시 시작일은 종료일보다 클 수 없습니다.");		// COMJSALT017
		return;
	}
	if(curTab) {
		goOzTab(curTab, curTarget);
	} else {
		goOzTab('tab7','./summMonthP.ums');
	}
}

// 초기화 클릭시
function goReset() {
	$("#searchForm")[0].reset();
}

// 탭 클릭시
var curTab;			//현재 클릭한 탭
var curTarget;		//현재 클릭한 타겟
function goOzTab(tabNm, target) {
	if(curTab) {
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
	}

	curTab = tabNm;		//현재 클릭한 탭 설정
	curTarget = target;	//현재 클릭한 타겟 설정

	//클릭한 탭을 보여줌
	switch(tabNm) {
		case 'tab1' :	$("#click_tab1").show(); $("#tab1").hide(); break;
		case 'tab2' :	$("#click_tab2").show(); $("#tab2").hide(); break;
		case 'tab3' :	$("#click_tab3").show(); $("#tab3").hide(); break;
		case 'tab4' :	$("#click_tab4").show(); $("#tab4").hide(); break;
		case 'tab5' :	$("#click_tab5").show(); $("#tab5").hide(); break;
		case 'tab6' :	$("#click_tab6").show(); $("#tab6").hide(); break;
		case 'tab7' :	$("#click_tab7").show(); $("#tab7").hide(); break;
	}
	
	$("#searchCampNm").val($("#searchCampNo option:selected").text());
	$("#searchDeptNm").val($("#searchDeptNo option:selected").text());
	$("#searchUserNm").val($("#searchUserId option:selected").text());
	
	if($("#searchCampNo option").eq(0).is(":selected")) $("#searchCampNm").val("");
	if($("#searchDeptNo option").eq(0).is(":selected")) $("#searchDeptNm").val("");
	if($("#searchUserId option").eq(0).is(":selected")) $("#searchUserNm").val("");

	$("#searchForm").attr("target","iFrmReport").attr("action", target).submit();
}
