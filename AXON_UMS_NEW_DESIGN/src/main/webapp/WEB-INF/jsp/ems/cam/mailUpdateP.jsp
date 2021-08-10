<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.31
	*	설명 : 메일 업데이트 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript" src="<c:url value='/smarteditor/js/HuskyEZCreator.js'/>" charset="utf-8"></script>
<script type="text/javascript">
$(document).ready(function() {
	// 예약시간
	$("#sendYmd").datepicker();
	
	// 정기발송 종료일
	$("#sendTermEndDt").datepicker();
	
	showBtn();
	
	// 캠페인 목적 설정
	//setTimeout(function(){
		goCamp();
	//},100);
	
	// 머지 설정
	//setTimeout(function(){
	    goMerge();
	//},100);
	
	// 편집모드 설정 ====> 추후 화면 확정 단계에서 변경될 가능성이 높다.
	setTimeout(function() {
	    if($("#mailInfoForm input[name='contTy']").val() == "000") {      // HTML
	        goEditSetting('000');
	    } else {   // TEXT
	    	goEditSetting('001');
	    }
	},400);
});

//히스토리 이동 버튼 전시 구현
function showBtn() {
	var obj = document.mailform;
	if(window.name == "cam_frm" && parent.parent) {
		$("#btnCampList").show();
		$("#btnMailList").show();
	} else if(window.name == "sch_frm" && parent) {
		$("#btnWeekList").show();
	} else {
		$("#btnMailList").show();
	}
}

//에디터 초기 설정(TEXT, HTML)
function goEditSetting(mode) {
    var obj = document.mailform;
    if(mode=='001') {       // 텍스트
        // 수신여부, 수신거부, 수신확인 추적기간을 선택하지 못하도록 한다.
        $("#respYn").prop("checked", false);
        $("#linkYn").prop("checked", false);
        $("#respLog").val("0");

        $("#respYn").prop("disabled", true);
        $("#linkYn").prop("disabled", true);
        $("#isReject").prop("disabled", true);
        $("#respLog").prop("disabled", true);
    } else {                // HTML
        $("#respYn").prop("disabled", false);
        $("#linkYn").prop("disabled", false);
        $("#isReject").prop("disabled", false);
        $("#respLog").prop("disabled", false);
    }
}

// 메일 내용 설정
function getCompVal() {
    if($("input[name='contTy']").eq(0).is(":checked")) {  // HTML
		//-- 템플릿경로 삽입 시작 ----------------------------------------------------------------------
		$.getJSON("<c:url value='/ems/tmp/contFileView.json'/>?tempFlPath=" + $("#tempFlPath").val(), function(res) {
			if(res.result == 'Success') {
                  oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
				  oEditors.getById["ir1"].exec("PASTE_HTML", [res.tempVal]);   //스마트에디터 내용붙여넣기
			} else {
				alert("Content File Read Error!!");
			}
		});
		//-- 템플릿경로 삽입 끝 ----------------------------------------------------------------------
    } else {        // Text
        alert("<spring:message code='CAMJSALT032'/>");	// 텍스트 모드에서는 처리할 수 없습니다.
    }
}

//에디터 변경(TEXT, HTML)
function goEditMode(mode) {
    var obj = document.mailform;
    if(mode=='001') {       // 텍스트
    	var changeOK = oEditors.getById["ir1"].exec("EVENT_CHANGE_EDITING_MODE_CLICKED", ["TEXT", false]);		// WYSIWYG(Editor), HTMLSrc(HTML), TEXT(TEXT) 
    	if(changeOK == false) {
    		$("#mailInfoForm input[name='contTy']").eq(0).prop("checked",true);
        	return;
        }

        // 수신여부, 수신거부, 수신확인 추적기간을 선택하지 못하도록 한다.
        $("#respYn").prop("checked", false);
        $("#linkYn").prop("checked", false);
        $("#respLog").val("0");

        $("#respYn").prop("disabled", true);
        $("#linkYn").prop("disabled", true);
        $("#isReject").prop("disabled", true);
        $("#respLog").prop("disabled", true);
    } else {                // HTML
        oEditors.getById["ir1"].exec("EVENT_CHANGE_EDITING_MODE_CLICKED", ["WYSIWYG", false]);		// WYSIWYG(Editor), HTMLSrc(HTML), TEXT(TEXT)

        $("#respYn").prop("disabled", false);
        $("#linkYn").prop("disabled", false);
        $("#isReject").prop("disabled", false);
        $("#respLog").prop("disabled", false);
    }
}

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#userId").append(option);
		});
	});
}

// 캠페인을 선택하였을 때 발생하는 이벤트
function goCamp() {
    if($("#campInfo").val() == "") {
        $("#campNo").val("");
        $("#campTy").val("");
        $("#divCampTy").html("");
    } else {
    	var tmp = $("#campInfo").val();
        var campNo = tmp.substring(0, tmp.indexOf("|"));
        tmp = tmp.substring(tmp.indexOf("|") + 1);
        var campTy = tmp.substring(0, tmp.indexOf("|"));
        var campTyNm = tmp.substring(tmp.indexOf("|") + 1);

        $("#campNo").val( campNo );
        $("#campTy").val( campTy );

        $("#divCampTy").html( campTyNm );
    }
}

// 발송대상그룹을 선택하였을 경우 머지부분 처리
function goMerge() {
    var obj = document.mailform;

    if($("#segNoc").val() == "0") {
        $("#divMerge").html("* <spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
        return;
    }

    var merge = $("#segNoc").val().substring($("#segNoc").val().indexOf("|")+1);

    var condHTML = "<select id='mergeKey' name='mergeKey'>";

    var pos = merge.indexOf(",");
    while(pos != -1) {
        condHTML += "<option value='$:"+merge.substring(0,pos)+":$'>"+merge.substring(0,pos)+"</option>";
        merge = merge.substring(pos+1);
        pos = merge.indexOf(",");
    }
    condHTML += "<option value='$:"+merge+":$'>"+merge+"</option>";
    condHTML += "</select>";
    $("#divMerge").html(condHTML);
}

//발송대상그룹 상세보기
function goSegInfo() {
	if($("#segNoc").val() == "0") {
		alert("<spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
		return;
	} else {
		var segNo = $("#segNoc").val();
		segNo = segNo.substring(0, segNo.indexOf("|"));
		
	    window.open("<c:url value='/ems/seg/segInfoP.ums'/>?segNo=" + segNo,"segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
	}
}

//템플릿을 선택하였을 경우 에디터에 템플릿 넣기
function goTemplate() {
    if($("#tempFlPath").val() == "") return;
    if($("input[name='contTy']").eq(0).is(":checked")) {  // HTML
		//-- 템플릿경로 삽입 시작 ----------------------------------------------------------------------
		$.getJSON("<c:url value='/ems/tmp/tempFileView.json'/>?tempFlPath=" + $("#tempFlPath").val(), function(res) {
			if(res.result == 'Success') {
                  oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
				  oEditors.getById["ir1"].exec("PASTE_HTML", [res.tempVal]);   //스마트에디터 내용붙여넣기
			} else {
				alert("Template Read Error!!");
			}
		});
		//-- 템플릿경로 삽입 끝 ----------------------------------------------------------------------
    } else {        // Text
        alert("<spring:message code='CAMJSALT032'/>");	// 텍스트 모드에서는 처리할 수 없습니다.
        $("#tempFlPath").val("");
    }
}

//웹에이전트 클릭시
function goWebAgent() {
    if($("input[name='contTy']").eq(1).is(":checked")) {  // Text 모드일 경우
        var a = confirm("<spring:message code='CAMJSALT026'/>");	// TEXT 모드에서는 웹에이젼트를 사용 불가능 합니다.\\nHTML 모드로 변경 하시겠습니까?
        if ( a ) {
        	$("input[name='contTy']").eq(0).prop("checked",true);
            goEditMode('000');

            window.open("<c:url value='/ems/cam/mailWebAgentP.ums'/>", "webAgent", "width=500, height=280");
        } else {
            return;
        }
    } else {
        window.open("<c:url value='/ems/cam/mailWebAgentP.ums'/>", "webAgent", "width=500, height=280");
    }
}
// 웹에이전트 내용 첨부(팝업 창에서 실행됨)
function setWebAgent(webAgentUrl) {
	var contents = "^:" + webAgentUrl + ":^";
	oEditors.getById["ir1"].exec("PASTE_HTML", [contents]);   //스마트에디터 내용붙여넣기
}

//환경설성 클릭시(발송모드, 발송엔진셋팅, 인코딩 정보, 발신자 정보)
function goOption() {
    window.open("<c:url value='/ems/cam/mailOptionP.ums'/>", "mailOption", "width=350, height=600");
}

//수신거부 클릭시
function goReject() {
    window.open("<c:url value='/ems/cam/mailRejectP.ums'/>", "mailReject", "width=450, height=200");
}
// 수신거부 내용추가(팝업 창에서 실행됨)
function setReject(rejectMsg) {
	oEditors.getById["ir1"].exec("PASTE_HTML", [rejectMsg]);   //스마트에디터 내용붙여넣기	
}

//제목 클릭시(메일제목 내용 추가)
function goTitleMerge() {
    if(typeof $("#mergeKey").val() == "undefined") {
    	alert("<spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
    	return;
    }
    
    $("#mailTitle").val( $("#mailTitle").val() + $("#mergeKey").val() );
}

//본문 클릭시(메일 내용 추가)
function goContMerge() {
	if(typeof $("#mergeKey").val() == "undefined") {
		alert("<spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
		return;
	}
	
	// 기존오류.. 내용 동일 적용
    if($("#contType").val() == "000") {  // HTML
		oEditors.getById["ir1"].exec("PASTE_HTML", [$("#mergeKey").val()]);   
    } else {
		oEditors.getById["ir1"].exec("PASTE_HTML", [$("#mergeKey").val()]);
    }

}

//첨부파일을 추가(파일 업로드 해준다. rFileName=attachPath,vFileName=attachNm)
function uploadFile(rFileName, vFileName){
    window.open("<c:url value='/com/uploadP.ums'/>?folder=attach&inputType=select&ext=&formName=mailInfoForm&title=&rFileName="+rFileName+"&vFileName="+vFileName, "", "width=640,height=135");
}
// 첨부파일리스트에 파일명을 추가해준다.(업로드 팝업창에서 실행됨)
function appendOption(form, oldFileUrl, newFileUrl, rFileName, vFileName) {
    var i = oldFileUrl.lastIndexOf("/");

    var oldOption = new Option(oldFileUrl.substring(i+1), oldFileUrl.substring(i+1));
    var newOption = new Option(newFileUrl.substring(i+1), newFileUrl.substring(i+1));

    $("#" + rFileName).append( newOption );
    $("#" + vFileName).append( oldOption );
}

// 첨부파일 삭제(리스트에서 파일명을 삭제한다. rFileName=attachPath,vFileName=attachNm)
function deleteFile(rFileName, vFileName) {
	var selected = false;
	$("#attachNm option:selected").each(function(idx,item) {
		selected = true;
	});
	
    if(!selected) {
        alert("<spring:message code='CAMJSALT001'/>");	// 삭제할 파일을 선택하세요.
        return;
    }
    
    for(var i = $("#attachNm option").length - 1; i>=0; i--) {
    	if($("#attachNm option").eq(i).is(":selected")) {
    		$("#attachNm option").eq(i).remove();
    		$("#attachPath option").eq(i).remove();
    	}
    }    
}

// 업데이트 클릭시(삭제된 메일인 경우)
function isStatus() {
    alert("<spring:message code='CAMJSALT021'/>.");		// 삭제된 메일입니다!!\\n삭제된 메일은 수정할 수 없습니다!!
}

// 업데이트 클릭시(발송대기, 발송승인 상태가 아닌 메일인 경우)
function isWorkStatus() {
    alert("<spring:message code='CAMJSALT022'/>.");		// 발송대기, 발송승인 메일만 수정할 수 있습니다.
}

//업데이트 클릭시
function goUpdate() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
        if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";		// 사용자
        }
    }
    if($("#campInfo").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL006'/> ] ";			// 캠페인
    }
    if($("#segNoc").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL014'/> ] ";			// 발송대상그룹
    }
    if($("#taskNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL011'/> ] ";			// 메일명
    }
    if($("#mailTitle").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL025'/> ] ";			// 메일제목
    }
    if($("#mailFromNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL018'/> ] ";			// 발송자 성명
    }
    if($("#mailFromEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL019'/> ] ";			// 발송자 이메일
    }
    if($("#replyToEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB002'/> ] ";			// 수신거부(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#returnEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB003'/> ] ";			// 링크클릭(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#socketTimeout").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB004'/> ] ";			// 발송일로부터(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#connPerCnt").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB005'/> ] ";			// 일까지 추적(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#retryCnt").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB006'/> ] ";			// 발송대상그룹을 선택하세요.(이전 소스 경고 메시지 잘못된 듯)
    }
    if(errflag) {
        alert("<spring:message code='COMJSALT001'/>.\n" + errstr);	// 입력값 에러\\n다음 정보를 확인하세요.
        return;
	}

	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#composerValue").val( $("#ir1").val() );

    // 첨부파일을 모두 선택되도록 함.
    $("#attachNm option").each(function(idx,item){
    	$(item).prop("selected", true);
    });
    $("#attachPath option").each(function(idx,item){
    	$(item).prop("selected", true);
    });
    
    $("#mailInfoForm").attr("target","iFrmMail").attr("action","<c:url value='/ems/cam/mailUpdate.ums'/>").submit();
}

// 복구 클릭시
function goEnable() {
    $("#status").val("000");
	var param = $("#searchForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='CAMJSALT027'/>");	// 복구성공
			
			// 메일 목록 페이지로 이동
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailMainP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='CAMJSALT029'/>");	// 복구실패
		}
	});
}

// 사용중지 클릭시
function goDisable() {
    $("#status").val("001");
	var param = $("#searchForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='CAMJSALT028'/>");	// 사용중지성공
			
			// 메일 목록 페이지로 이동
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailMainP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='CAMJSALT030'/>");	// 사용중지실패
		}
	});
}

// 삭제 클릭시
function goDelete() {
    $("#status").val("002");
	var param = $("#searchForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			
			// 메일 목록 페이지로 이동
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailMainP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}

// 복사 클릭시
function goCopy() {
	var param = $("#searchForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailCopy.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='CAMJSALT011'/>");	// 복사 성공
			
			// 메일 목록 페이지로 이동
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailMainP.ums'/>").submit();
		} else if(data.result == "Fail") {
			alert("<spring:message code='CAMJSALT012'/>");	// 복사 실패
		}
	});
}

// 테스트발송 클릭시
function goTestSend() {
	window.open("","preView", " width=1012, height=230, scrollbars=yes");
	$("#searchForm").attr("target","preView").attr("action","/ems/cam/mailTestListP.ums").submit();
}

//발송승인 클릭시
function goAdmit() {
    var errflag = false;
    var errstr = "";
    
    if(typeof $("#deptNo").val() != "undefined") {
        if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";		// 사용자
        }
    }
    if($("#campInfo").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL006'/> ] ";			// 캠페인
    }
    if($("#segNoc").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL014'/> ] ";			// 발송대상그룹
    }
    if($("#taskNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL011'/> ] ";			// 메일명
    }
    if($("#mailTitle").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL025'/> ] ";			// 메일제목
    }
    if($("#mailFromNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL018'/> ] ";			// 발송자 성명
    }
    if($("#mailFromEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLTL019'/> ] ";			// 발송자 이메일
    }
    if($("#replyToEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB002'/> ] ";			// 수신거부(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#returnEm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB003'/> ] ";			// 링크클릭(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#socketTimeout").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB004'/> ] ";			// 발송일로부터(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#connPerCnt").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB005'/> ] ";			// 일까지 추적(이전 소스 경고 메시지 잘못된 듯)
    }
    if($("#retryCnt").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='CAMTBLLB006'/> ] ";			// 발송대상그룹을 선택하세요.(이전 소스 경고 메시지 잘못된 듯)
    }
    if(errflag) {
        alert("<spring:message code='COMJSALT001'/>.\n" + errstr);	// 입력값 에러\\n다음 정보를 확인하세요.
        return;
	}
    
    
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#composerValue").val( $("#ir1").val() );

    // 첨부파일을 모두 선택되도록 함.
    $("#attachNm option").each(function(idx,item){
    	$(item).prop("selected", true);
    });
    $("#attachPath option").each(function(idx,item){
    	$(item).prop("selected", true);
    });
    
    $("#mailInfoForm").attr("target","iFrmMail").attr("action","<c:url value='/ems/cam/mailUpdateAdmit.ums'/>").submit();
}

// 테스트발송상세정보 클릭시
function goTestSendInfo(sendTestTaskNo, sendTestSubTaskNo) {
	$("#sendTestTaskNo").val(sendTestTaskNo);
	$("#sendTestSubTaskNo").val(sendTestSubTaskNo);
	
    window.open("","preView", "width=372, height=400, scrollbars=yes");
    $("#searchForm").attr("target","preView").attr("action","<c:url value='/ems/cam/mailTestTaskP.ums'/>").submit();
}

//리스트 클릭시
function goList() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailMainP.ums'/>").submit();
}

// 서비스으로이동 클릭시
function goCampList() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/campListP.ums'/>").submit();
}




//화면에서 예약시간 시, 분을 처리한다.
function getDate(Date, selectedNum, minNum, maxNum, plusNum) {
    document.write("<select id='", Date,"' name='", Date, "'>");
    for(i = minNum; i <= maxNum; i += plusNum) {
    	document.write("<option value=",i, i == selectedNum ? " selected>":">", i, "</option>");
    }
    document.write("</select>");
}
</script>

<body>
	<div id="wrap">

		<!-- lnb// -->
		<div id="lnb">
			<!-- LEFT MENU -->
			<%@ include file="/WEB-INF/jsp/inc/menu_ems.jsp" %>
			<!-- LEFT MENU -->
		</div>
		<!-- //lnb -->

		<!-- content// -->
		<div id="content">

			<!-- cont-head// -->
			<section class="cont-head">
				<div class="title">
					<h2><c:out value='${NEO_MENU_NM}'/></h2>
				</div>
				
				<!-- 공통 표시부// -->
				<%@ include file="/WEB-INF/jsp/inc/top.jsp" %>
				<!-- //공통 표시부 -->
				
			</section>
			<!-- //cont-head -->

			<!-- cont-body// -->
			<section class="cont-body">




			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" id="page" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden"           name="campNo" value="<c:out value='${searchVO.campNo}'/>">
			<input type="hidden" id="searchTaskNm" name="searchTaskNm" value="<c:out value='${searchVO.searchTaskNm}'/>">
			<input type="hidden" id="searchCampNo" name="searchCampNo" value="<c:out value='${searchVO.searchCampNo}'/>">
			<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="<c:out value='${searchVO.searchDeptNo}'/>">
			<input type="hidden" id="searchUserId" name="searchUserId" value="<c:out value='${searchVO.searchUserId}'/>">
			<input type="hidden" id="searchStatus" name="searchStatus" value="<c:out value='${searchVO.searchStatus}'/>">
			<input type="hidden" id="searchStartDt" name="searchStartDt" value="<c:out value='${searchVO.searchStartDt}'/>">
			<input type="hidden" id="searchEndDt" name="searchEndDt" value="<c:out value='${searchVO.searchEndDt}'/>">
			<input type="hidden" id="searchWorkStatus" name="searchWorkStatus" value="<c:out value='${searchVO.searchWorkStatus}'/>">
			
			<input type='hidden' id="taskNos" name='taskNos' value="<c:out value='${searchVO.taskNo}'/>">
			<input type='hidden' id="subTaskNos" name='subTaskNos' value="<c:out value='${searchVO.subTaskNo}'/>">
			<input type='hidden' id="sendTestTaskNo" name='sendTestTaskNo' value="0">
			<input type='hidden' id="sendTestSubTaskNo" name='sendTestSubTaskNo' value="0">
			<input type="hidden" id="status" name="status">
			</form>
			
			<!-- new title -->
			<p class="title_default"><spring:message code='CAMTBLTL004'/></p><!-- 메일 -->
			<!-- //new title -->

			<form id="mailInfoForm" name="mailInfoForm" method="post">
			<div class="cWrap">
				<table class="table_line_outline" border="1" cellspacing="0">
					<colgroup>
						<col style="width:15%;">
						<col style="width:35%;">
						<col style="width:15%;">
						<col style="width:35%;">
					</colgroup>
					<!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
					<c:if test="${'Y' eq NEO_ADMIN_YN }">
						<tr>
							<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
							<td class="td_body">
								<select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
									<option value="0">::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == mailInfo.deptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
							<td class="td_body">
								<select id="userId" name="userId">
									<option value="">::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
										<c:if test="${fn:length(userList) > 0}">
											<c:forEach items="${userList}" var="user">
												<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq mailInfo.userId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
											</c:forEach>
										</c:if>
								</select>
							</td>
						</tr>
					</c:if>
					<tr>
						<td class="td_title" width="15%"><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
						<td class="td_body" width="35%">
							<select id="campInfo" name="campInfo" onchange='goCamp()'class="wBig" >
								<option value="">::::<spring:message code='CAMTBLLB007'/>::::</option><!-- 캠페인 선택 -->
								<c:if test="${fn:length(campList) > 0}">
									<c:forEach items="${campList}" var="camp">
										<option value="<c:out value='${camp.campNo}|${camp.campTy}|${camp.campTyNm}'/>"<c:if test="${camp.campNo == mailInfo.campNo}"> selected</c:if>><c:out value='${camp.campNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							
							<!-- 이전 소스 nmMerge, idMerge 왜 이렇게 했는지 이해 안됨 -->
							<c:set var="nmMerge" value=""/>
							<c:set var="idMerge" value=""/>
							<c:if test="${fn:length(mergeList) > 0}">
								<c:forEach items="${mergeList}" var="merge" varStatus="mergeStatus">
									<c:if test="${mergeStatus.index == 1}">
										<c:set var="nmMerge" value="${merge.cdNm}"/>
									</c:if>
									<c:if test="${mergeStatus.index == 2}">
										<c:set var="idMerge" value="${merge.cdNm}"/>
									</c:if>
								</c:forEach>
							</c:if>
							
							<input type='hidden' id="composerValue"   name="composerValue">
							<input type='hidden' id="taskNo"          name='taskNo'          value='<c:out value='${mailInfo.taskNo}'/>'>
							<input type='hidden' id="subTaskNo"       name='subTaskNo'       value='<c:out value='${mailInfo.subTaskNo}'/>'>
							<input type='hidden' id="contFlPath"      name='contFlPath'      value='<c:out value='${mailInfo.contFlPath}'/>'>
							<input type='hidden' id="channel"         name='channel'         value='<c:out value='${mailInfo.channel}'/>'>
							<input type='hidden' id="campNo"          name='campNo'          value="<c:out value='${mailInfo.campNo}'/>">
							<input type='hidden' id="campTy"          name='campTy'          value="<c:out value='${mailInfo.campTy}'/>">
							<input type='hidden' id="nmMerge"         name='nmMerge'         value="$:<c:out value='${nmMerge}'/>:$">
							<input type='hidden' id="idMerge"         name='idMerge'         value="$:<c:out value='${idMerge}'/>:$">
							<!-- 옵션 -->
							<input type='hidden' id="sendMode"        name='sendMode'        value="<c:out value='${mailInfo.sendMode}'/>">
							<input type='hidden' id="replyToEm"       name='replyToEm'       value='<c:out value='${mailInfo.replyToEm}'/>'>
							<input type='hidden' id="returnEm"        name='returnEm'        value='<c:out value='${mailInfo.returnEm}'/>'>
							<input type='hidden' id="socketTimeout"   name='socketTimeout'   value='<c:out value='${mailInfo.socketTimeout}'/>'>
							<input type='hidden' id="connPerCnt"      name='connPerCnt'      value='<c:out value='${mailInfo.connPerCnt}'/>'>
							<input type='hidden' id="retryCnt"        name='retryCnt'        value='<c:out value='${mailInfo.retryCnt}'/>'>
							<input type='hidden' id="headerEnc"       name='headerEnc'       value='<c:out value='${mailInfo.headerEnc}'/>'>
							<input type='hidden' id="bodyEnc"         name='bodyEnc'         value='<c:out value='${mailInfo.bodyEnc}'/>'>
							<input type='hidden' id="charset"         name='charset'         value='<c:out value='${mailInfo.charset}'/>'>
							<!-- 초기화에 사용 -->
							<input type='hidden' id="bsSendMode"      name='bsSendMode'      value='001'>
							<input type='hidden' id="bsMailFromNm"    name='bsMailFromNm'    value='<c:out value='${mailInfo.mailFromNm}'/>'>
							<input type='hidden' id="bsMailFromEm"    name='bsMailFromEm'    value='<c:out value='${mailInfo.mailFromEm}'/>'>
							<input type='hidden' id="bsReplyToEm"     name='bsReplyToEm'     value='<c:out value='${mailInfo.replyToEm}'/>'>
							<input type='hidden' id="bsReturnEm"      name='bsReturnEm'      value='<c:out value='${mailInfo.returnEm}'/>'>
							<input type='hidden' id="bsSocketTimeout" name='bsSocketTimeout' value='<c:out value='${mailInfo.socketTimeout}'/>'>
							<input type='hidden' id="bsConnPerCnt"    name='bsConnPerCnt'    value='<c:out value='${mailInfo.connPerCnt}'/>'>
							<input type='hidden' id="bsRetryCnt"      name='bsRetryCnt'      value='<c:out value='${mailInfo.retryCnt}'/>'>
							<input type='hidden' id="bsHeaderEnc"     name='bsHeaderEnc'     value='<c:out value='${mailInfo.headerEnc}'/>'>
							<input type='hidden' id="bsBodyEnc"       name='bsBodyEnc'       value='<c:out value='${mailInfo.bodyEnc}'/>'>
							<input type='hidden' id="bsCharset"       name='bsCharset'       value='<c:out value='${mailInfo.charset}'/>'>
							<!-- 초기화에 사용 -->
							<!-- 옵션 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
						<td class="td_body">
							<div id="divCampTy"></div>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL014'/></td><!-- 발송대상그룹 -->
						<td class="td_body">
							<select id="segNoc" name="segNoc" onchange='goMerge()' class="wMiddle">
								<option value="">::::<spring:message code='CAMTBLLB009'/>::::</option><!-- 발송그룹 선택 -->
								<c:if test="${fn:length(segList) > 0}">
									<c:forEach items="${segList}" var="seg">
										<option value="<c:out value='${seg.segNo}|${seg.mergeKey}'/>"<c:if test="${seg.segNo == mailInfo.segNo}"> selected</c:if>><c:out value='${seg.segNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN008'/>" onClick="goSegInfo()"><!-- 상세보기 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL017'/></td><!-- 템플릿 -->
						<td class="td_body">
							<select id="tempFlPath" name="tempFlPath" class="wBig"onchange='goTemplate()'>
								<option value="">::::<spring:message code='CAMTBLLB010'/>::::</option><!-- 템플릿 선택 -->
								<c:if test="${fn:length(tempList) > 0}">
									<c:forEach items="${tempList}" var="temp">
										<option value="<c:out value='${temp.tempFlPath}'/>"><c:out value='${temp.tempNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL018'/></td><!-- 발송자 성명 -->
						<td class="td_body">
							<input type='text' id="mailFromNm" name='mailFromNm' class="wBig" value='<c:out value='${mailInfo.mailFromNm}'/>' style="width:250;">
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL019'/></td><!-- 발송자 이메일 -->
						<td class="td_body">
							<input type='text' id="mailFromEm" name='mailFromEm' class="wBig" value='<c:out value='${mailInfo.mailFromEm}'/>' style="width:250;">
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL020'/></td><!-- 편집모드 -->
						<td class="td_body">
							<input type="radio" name="contTy" value="000" onclick="goEditMode('000')"<c:if test="${'000' eq mailInfo.contTy}"> checked</c:if>> <label> HTML</label>
							<input type="radio" name="contTy" value="001" onclick="goEditMode('001')"<c:if test="${'001' eq mailInfo.contTy}"> checked</c:if>> <label> TEXT</label>
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL021'/></td><!-- 옵션 -->
						<td class="td_body">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN009'/>" onClick="goWebAgent()"><!-- 웹에이전트 -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN011'/>" onClick="goOption()"><!-- 환경설정 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL022'/></td><!-- 수신여부 -->
						<td class="td_body">
							<input type=CHECKBOX id="respYn" name="respYn" value="Y"<c:if test="${'Y' eq mailInfo.respYn}"> checked</c:if>> <spring:message code='CAMTBLLB001'/><!-- 수신확인 -->
							<input type=CHECKBOX id="linkYn" name="linkYn" value="Y"<c:if test="${'Y' eq mailInfo.linkYn}"> checked</c:if>> <spring:message code='CAMTBLLB003'/><!-- 링크클릭 -->
							<input type=BUTTON id="isReject" name="isReject" value="<spring:message code='CAMTBLLB002'/>" onClick="javascript:goReject();" class="btn_style"><!-- 수신거부 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL023'/></td><!-- 머지입력 -->
						<td class="td_body">
							<div id="divMerge" style="color:red; font-size:11px; padding:5px;"><spring:message code='CAMTBLLB006'/>!!</div><!-- 발송대상그룹을 선택하세요. -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN004'/>" onClick="goTitleMerge()"><!-- 제목 -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN005'/>" onClick="goContMerge()"><!-- 본문 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL024'/></td><!-- 메일명 -->
						<td class="td_body" colspan='3'><input type='text' id="taskNm" name='taskNm' value='<c:out value='${mailInfo.taskNm}'/>' size='140'></td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL025'/></td><!-- 메일제목 -->
						<td class="td_body" colspan='3'><input type='text' id="mailTitle" name='mailTitle' value='<c:out value='${mailInfo.mailTitle}'/>' size='130'></td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL026'/></td><!-- 예약시간 -->
						<td class="td_body">
							<fmt:parseDate var="sendDate" value="${mailInfo.sendDt}" pattern="yyyyMMddHHmm"/>
							<fmt:formatDate var="sendYmd" value="${sendDate}" pattern="yyyy-MM-dd"/>
							<fmt:formatDate var="sendHour" value="${sendDate}" pattern="HH"/>
							<fmt:formatDate var="sendMin" value="${sendDate}" pattern="mm"/>

							<input type="text" id="sendYmd" name="sendYmd" value="<c:out value='${sendYmd}'/>" style="width:70;" readonly>
							<script type="text/javascript">getDate('sendHour', '<c:out value='${sendHour}'/>', 00, 23, 1);</script><spring:message code='CAMTBLLB016'/><!-- 시 -->
							<script type="text/javascript">getDate('sendMin', '<c:out value='${sendMin}'/>', 00, 59, 1);</script><spring:message code='CAMTBLLB017'/><!-- 분 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL027'/></td><!-- 수신확인추적기간 -->
						<td class="td_body"><spring:message code='CAMTBLLB004'/><!-- 발송일로부터 -->
							<select id="respLog" name="respLog" class="select">
								<c:set var="respLogChecked" value=""/>
								<c:forEach var="i" begin="0" end="30">
									<c:if test="${i == 0}"><option value="<c:out value='${i}'/>"<c:if test="${i == mailInfo.respLog}"> selected</c:if>>∞</option></c:if>
									<c:if test="${i > 0}"><option value="<c:out value='${i}'/>"<c:if test="${i == mailInfo.respLog}"> selected</c:if>><c:out value='${i}'/></option></c:if>
								</c:forEach>
							</select><spring:message code='CAMTBLLB005'/><!-- 일까지 추적 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL028'/></td><!-- 정기발송종료일 -->
						<td class="td_body">
							<input type="checkbox" id="isSendTerm" name="isSendTerm" value="Y"<c:if test="${not empty mailInfo.sendTermEndDt}"> checked</c:if>>
							<c:set var="sendTermEndDt" value="${mailInfo.sendTermEndDt}"/>
							<c:choose>
								<c:when test="${empty sendTermEndDt}">
									<jsp:useBean id="currTime" class="java.util.Date"/>
									<fmt:formatDate var="ymd" value="${currTime}" pattern="yyyy-MM-dd"/>
									<c:set var="sendTermEndDt" value="${ymd}"/>
								</c:when>
								<c:otherwise>
									<fmt:parseDate var="endDt" value="${sendTermEndDt}" pattern="yyyyMMddHHmm"/>
									<fmt:formatDate var="termEndDt" value="${endDt}" pattern="yyyy-MM-dd"/> 
									<c:set var="sendTermEndDt" value="${termEndDt}"/>
								</c:otherwise>
							</c:choose>
							
							<input type="text" id="sendTermEndDt" name="sendTermEndDt" value="<c:out value='${sendTermEndDt}'/>" style="width:70;cursor:hand" readonly>
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL029'/></td><!-- 정기발송주기 -->
						<td class="td_body">
							<c:set var="sendTermLoop" value="1"/>
							<c:if test="${empty mailInfo.sendTermLoop}"><c:set var="sendTermLoop" value="${mailInfo.sendTermLoop}"/></c:if>
							<input type="text" id="sendTermLoop" name="sendTermLoop" style="width:20;" value="<c:out value='${sendTermLoop}'/>">
							<select id="sendTermLoopTy" name="sendTermLoopTy" class="select">
								<c:if test="${fn:length(periodList) > 0}">
									<c:forEach items="${periodList}" var="period">
										<option value="<c:out value='${period.cd}'/>"<c:if test="${period.cd eq mailInfo.sendTermLoopTy}"> selected</c:if>><c:out value='${period.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="4" class="typeBB" style="margin-top:10px; padding:0px;">
							<!-- HTML 에디터  -->
							<textarea name="ir1" id="ir1" rows="10" cols="100" style="text-align:center; width:1013px; height:412px; display:none; border:none;" ></textarea>
							<!-- //HTML 에디터  -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL030'/></td><!-- 파일첨부 -->
						<td class="td_body" colspan="3">
							<select id="attachNm" name="attachNm" style="width:600px;height:40px;" class="wTbig" multiple>
								<c:if test="${fn:length(attachList) > 0}">
									<c:forEach items="${attachList}" var="attach">
										<option value="<c:out value='${attach.attNm}'/>"><c:out value='${attach.attNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<select id="attachPath" name="attachPath" style="width:600px;height:40px;" size="4" multiple>
								<c:if test="${fn:length(attachList) > 0}">
									<c:forEach items="${attachList}" var="attach">
										<c:set var="attFlPath" value="${fn:substring(attach.attFlPath, fn:indexOf(attach.attFlPath,'/')+1, fn:length(attach.attFlPath))}"/>
										<option value="<c:out value='${attFlPath}'/>"><c:out value='${attFlPath}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<p class="right">
								<input type="button" class="btn_style" value="<spring:message code='CAMBTN006'/>" onClick="uploadFile('attachPath','attachNm')"><!-- 추가 -->
								<input type="button" class="btn_style" value="<spring:message code='CAMBTN007'/>" onClick="deleteFile('attachPath','attachNm')"><!-- 제거 -->
							</p>
						</td>
					</tr>
				</table>

				<div class="btn">
					<div class="btnR">
						<c:choose>
							<c:when test="${'002' eq mailInfo.status}">
								<input type="button" class="btn_style" value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
							</c:when>
							<c:when test="${'000' ne mailInfo.workStatus && '001' ne mailInfo.workStatus}">
								<input type="button" class="btn_style" value="<spring:message code='COMBTN007'/>" onClick="isWorkStatus()"><!-- 수정 -->
							</c:when>
							<c:otherwise>
								<input type="button" class="btn_style" value="<spring:message code='COMBTN007'/>" onClick="goUpdate()"><!-- 수정 -->
							</c:otherwise>
						</c:choose>
						
						<c:if test="${'001' eq mailInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN013'/>" onClick="goEnable()"><!-- 복구 -->
						</c:if>
						<c:if test="${'000' eq mailInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN006'/>" onClick="goDisable()"><!-- 사용중지 -->
						</c:if>
						
						<c:if test="${'002' ne mailInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN008'/>" onClick="goDelete()"><!-- 삭제 -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN001'/>" onClick="goCopy()"><!-- 복사 -->
						</c:if>
						<c:if test="${'000' eq mailInfo.workStatus}">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN002'/>" onClick="goTestSend()"><!-- 테스트발송 -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN014'/>" onClick="goAdmit()"><!-- 발송승인 -->
						</c:if>

						<c:if test="${mailInfo.testCnt > 0}">
						<input type="button" class="btn_style" value="<spring:message code='CAMBTN015'/>" onClick="goTestSendInfo('<c:out value='${mailInfo.taskNo}'/>','<c:out value='${mailInfo.subTaskNo}'/>')"><!-- 테스트발송상세정보 -->
						</c:if>
			
						<!------------------	MODIFY BY SEO CHANG HOON	START	------------------>
						<input type="button" id="btnMailList" name="btnMailList" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()" style="display:none;"><!-- 리스트 -->
						<c:if test="${searchVO.campNo > 0}">
						<input type="button" id="btnCampList" name="btnCampList" class="btn_style" value="<spring:message code='CAMBTN012'/>" onClick="goCampList()"><!-- 서비스으로 이동 -->
						</c:if>
						<input type="button" id="btnWeekList" name="btnWeekList" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goWeekList()" style="display:none;"><!-- 리스트 -->
						<!------------------	MODIFY BY SEO CHANG HOON	END		------------------>
					</div>
				</div>


				<script type="text/javascript">
				var oEditors = [];
	
				// 추가 글꼴 목록
				//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
				nhn.husky.EZCreator.createInIFrame({
					oAppRef: oEditors,
					elPlaceHolder: "ir1",
					sSkinURI: "<c:url value='/smarteditor/SmartEditor2Skin.html'/>",
					htParams : {
						bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
						//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
						fOnBeforeUnload : function(){
							//alert("완료!");
						}
					}, //boolean
					fOnAppLoad : function(){
						//예제 코드
						oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
						//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
						oEditors.getById["ir1"].exec("PASTE_HTML", ["${compVal}"]);
					},
					fCreator: "createSEditor2"
				});
	
				function pasteHTML(obj) {
					var sHTML = "<img src='/images/upload/"+obj+"'>";
					oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
				}
	
				function showHTML() {
					var sHTML = oEditors.getById["ir1"].getIR();
					alert(sHTML);
				}
	
				function submitContents(elClickedObj) {
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
	
					// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("ir1").value를 이용해서 처리하면 됩니다.
					try {
						elClickedObj.form.submit();
					} catch(e) {}
				}
		
				function setDefaultFont() {
					var sDefaultFont = '궁서';
					var nFontSize = 24;
					oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
				}
				</script>
			</div>
			</form>




			</section>
			<!-- //cont-body -->
			
		</div>
		<!-- // content -->
	</div>

	<!-- 팝업// -->
	<%@ include file="/WEB-INF/jsp/inc/popup.jsp" %>
	<!-- //팝업 -->
</body>
</html>
