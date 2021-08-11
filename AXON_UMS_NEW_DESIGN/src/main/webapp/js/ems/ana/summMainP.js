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

// 초기화 클릭시
function goReset(obj) {
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

	$("#searchForm").attr("target","iFrmReport").attr("action", target).submit();
}

//검색버튼 클릭시 EVENT 구현
function goOz() {
	var obj = document.search_form;
	var p_stdt = obj.p_stdt.value;
	var p_eddt = obj.p_eddt.value;
	var errstr = "";
	var errflag = false;
	if(p_stdt == "") {
		errstr += "[<%=tbltl_term%>]";
		errflag = true;
	}
	if(p_eddt == "") {
		errstr += "[<%=tbltl_term%>]";
		errflag = true;
	}
	if(errflag) {
		alert("<%=jsalt_msg%>\n" + errstr);
		return errflag;
	}
	if( p_stdt > p_eddt) {
		alert("<%=jsalt_cal%>");
		return;
	}
	if(this.cur_tab) {
		goOzTab(this.cur_tab,this.cur_target);
	} else {
		goOzTab('tab7','/ana/summMonthP.jsp');
	}
}