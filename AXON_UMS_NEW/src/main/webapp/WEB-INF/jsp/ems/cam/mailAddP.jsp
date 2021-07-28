<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.28
	*	설명 : 메일 등록 화면
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
});

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

    if($("#segNo").val() == "0") {
        $("#divMerge").html("* <spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
        return;
    }

    var merge = $("#segNo").val().substring($("#segNo").val().indexOf("|")+1);

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

// 발송대상그룹 상세보기
function goSegInfo() {
	if($("#segNo").val() == "0") {
		alert("<spring:message code='CAMTBLLB006'/>!!");	// 발송대상그룹을 선택하세요.
		return;
	} else {
		var segNo = $("#segNo").val();
		segNo = segNo.substring(0, segNo.indexOf("|"));
		
	    window.open("<c:url value='/ems/seg/segInfoP.ums'/>?segNo=" + segNo,"segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
	}
}

// 템플릿을 선택하였을 경우 에디터에 템플릿 넣기
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

// 에디터 변경(TEXT, HTML)
function goEditMode(mode) {
    var obj = document.mailform;
    if(mode=='001') {       // 텍스트
        oEditors.getById["ir1"].exec("EVENT_CHANGE_EDITING_MODE_CLICKED", ["TEXT", false]);		// WYSIWYG(Editor), HTMLSrc(HTML), TEXT(TEXT) 

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
        $("#respLog option").eq(7).prop("selected", true);
    }
}

// 웹에이전트 클릭시
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
// 웹에이전트 내용 첨부
function setWebAgent(webAgentUrl) {
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	var contents = $("#ir1").val();
	contents = contents + "^:" + webAgentUrl + ":^";
	
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
	oEditors.getById["ir1"].exec("PASTE_HTML", [contents]);   //스마트에디터 내용붙여넣기
}

// 환경설성 클릭시(발송모드, 발송엔진셋팅, 인코딩 정보, 발신자 정보)
function goOption() {
    window.open("<c:url value='/ems/cam/mailOptionP.ums'/>", "mailOption", "width=350, height=600");
}

// 수신거부 클릭시
function goReject() {
    window.open("<c:url value='/ems/cam/mailRejectP.ums'/>", "mailReject", "width=450, height=200");
}
// 수신거부 내용추가
function setReject(rejectMsg) {
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	var contents = $("#ir1").val();
	contents = contents + rejectMsg;
	
	alert(rejectMsg);
	
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
	oEditors.getById["ir1"].exec("PASTE_HTML", [contents]);   //스마트에디터 내용붙여넣기	
}








// 화면에서 예약시간 시, 분을 처리한다.
function getDate(Date, selectedNum, minNum, maxNum, plusNum) {
    document.write("<select id='", Date," name='", Date, "'>");
    for(i = minNum; i <= maxNum; i += plusNum)
    	document.write("<option value=",i, i == selectedNum ? " selected>":">", i, "</option>");
    document.write("</select>");
}
</script>

<div class="ex-layout">
	<div class="gnb">
		<!-- 상단메뉴화면 -->
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			<!-- Search Form -->
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
			</form>
			<!-- Search Form -->
			
			<!-- new title -->
			<p class="title_default"><spring:message code='CAMTBLTL002'/></p><!-- 메일 -->
			<!-- //new title -->

			<div class="cWrap">
				<form id="mailInfoForm" name="mailInfoForm" method="post">
				<table class="table_line_outline">
					<colgroup>
						<col style="width: 15%;">
						<col style="width: 35%;">
						<col style="width: 15%;">
						<col style="width: 35%;">
					</colgroup>
					<!--- 관리자일 경우 처리 //관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
					<c:if test="${'Y' eq NEO_ADMIN_YN}">
						<tr>
							<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
							<td class="td_body">
								<select id="deptNo" name="deptNo" onchange="getUserList(this.value);" class="wBig">
									<option value='0'>::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
							<td class="td_body">
								<select id="userId" name="userId" class="wBig">
									<option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
								</select>
							</td>
						</tr>
					</c:if>
					<!--- 관리자일 경우 처리 -->

					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
						<td class="td_body">
							<select id="campInfo" name="campInfo" onchange='goCamp()' class="wBig">
								<option value=''>::::<spring:message code='CAMTBLLB007'/>::::</option><!-- 캠페인 선택 -->
								<c:if test="${fn:length(campList) > 0}">
									<c:forEach items="${campList}" var="camp">
										<option value="<c:out value='${camp.campNo}|${camp.campTy}|${camp.campTyNm}'/>"><c:out value='${camp.campNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<!-- 이전 소스 channel, nmMerge, idMerge, encoding 왜 이렇게 했는지 이해 안됨 -->
							<c:set var="channel" value=""/>
							<c:set var="nmMerge" value=""/>
							<c:set var="idMerge" value=""/>
							<c:set var="encoding" value=""/>
							<c:if test="${fn:length(channelList) > 0}">
								<c:forEach items="${channelList}" var="chnl" varStatus="chnlStatus">
									<c:if test="${chnlStatus.index == 0}">
										<c:set var="channel" value="${chnl.cd}"/>
									</c:if>
								</c:forEach>
							</c:if>
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
							<c:if test="${fn:length(encodingList) > 0}">
								<c:forEach items="${encodingList}" var="enc" varStatus="encStatus">
									<c:if test="${encStatus.index == 0}">
										<c:set var="encoding" value="${enc.cd}"/>
									</c:if>
								</c:forEach>
							</c:if>
							<input type='hidden' id="composerValue" name="composerValue">
							<input type='hidden' id="channel"         name='channel'         value='<c:out value='${channel}'/>'>
							<input type='hidden' id="campNo"          name='campNo'          value="0">
							<input type='hidden' id="campTy"          name='campTy'          value="">
							<input type='hidden' id="nmMerge"         name='nmMerge'         value="$:<c:out value='${nmMerge}'/>:$">
							<input type='hidden' id="idMerge"         name='idMerge'         value="$:<c:out value='${idMerge}'/>:$">
							<input type='hidden' id="aliasFileNm"     name='aliasFileNm'     value=""><!-- 옵션 -->
							<input type='hidden' id="sendMode"        name='sendMode'        value="001">
							<input type='hidden' id="replyToEm"       name='replyToEm'       value='<c:out value='${userInfo.replyToEm}'/>'>
							<input type='hidden' id="returnEm"        name='returnEm'        value='<c:out value='${userInfo.returnEm}'/>'>
							<input type='hidden' id="socketTimeout"   name='socketTimeout'   value='<c:out value='${SOCKET_TIME_OUT}'/>'>
							<input type='hidden' id="connPerCnt"      name='connPerCnt'      value='<c:out value='${CONN_PER_CNT}'/>'>
							<input type='hidden' id="retryCnt"        name='retryCnt'        value='<c:out value='${RETRY_CNT}'/>'>
							<input type='hidden' id="headerEnc"       name='headerEnc'       value='<c:out value='${MAIL_ENCODING}'/>'>
							<input type='hidden' id="bodyEnc"         name='bodyEnc'         value='<c:out value='${MAIL_ENCODING}'/>'>
							<input type='hidden' id="charset"         name='charset'         value='<c:out value='${userInfo.charset}'/>'><!-- 초기화에 사용 -->
							<input type='hidden' id="bsSendMode"      name='bsSendMode'      value='001'>
							<input type='hidden' id="bsMailFromNm"    name='bsMailFromNm'    value='<c:out value='${userInfo.mailFromNm}'/>'>
							<input type='hidden' id="bsMailFromEm"    name='bsMailFromEm'    value='<c:out value='${userInfo.mailFromEm}'/>'>
							<input type='hidden' id="bsReplyToEm"     name='bsReplyToEm'     value='<c:out value='${userInfo.replyToEm}'/>'>
							<input type='hidden' id="bsReturnEm"      name='bsReturnEm'      value='<c:out value='${userInfo.returnEm}'/>'>
							<input type='hidden' id="bsSocketTimeout" name='bsSocketTimeout' value='<c:out value='${SOCKET_TIME_OUT}'/>'>
							<input type='hidden' id="bsConnPerCnt"    name='bsConnPerCnt'    value='<c:out value='${CONN_PER_CNT}'/>'>
							<input type='hidden' id="bsRetryCnt"      name='bsRetryCnt'      value='<c:out value='${RETRY_CNT}'/>'>
							<input type='hidden' id="bsHeaderEnc"     name='bsHeaderEnc'     value='<c:out value='${encoding}'/>'>
							<input type='hidden' id="bsBodyEnc"       name='bsBodyEnc'       value='<c:out value='${encoding}'/>'>
							<input type='hidden' id="bsCharset"       name='bsCharset'       value='<c:out value='${userInfo.charset}'/>'> <!-- 초기화에 사용 --><!-- 옵션 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
						<td class="td_body">
							<div id="divCampTy"></div>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL014'/></td><!-- 발송대상그룹 -->
						<td class="td_body">
							<select id="segNo" name="segNo" onchange='goMerge()' class="wMiddle">
								<option value="0">::::<spring:message code='CAMTBLLB009'/>::::</option><!-- 발송그룹 선택 -->
								<c:if test="${fn:length(segList) > 0}">
									<c:forEach items="${segList}" var="seg">
										<option value="<c:out value='${seg.segNo}|${seg.mergeKey}'/>"><c:out value='${seg.segNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN008'/>" onClick="goSegInfo()"><!-- 상세보기 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL017'/></td><!-- 템플릿 -->
						<td class="td_body">
							<select id="tempFlPath" name="tempFlPath" class="wBig" onchange='goTemplate()'>
								<option value=''>::::<spring:message code='CAMTBLLB010'/>::::</option><!-- 템플릿 선택 -->
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
							<input type='text' id="mailFromNm" name='mailFromNm' class="wBig" value='<c:out value='${userInfo.mailFromNm}'/>'>
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL019'/></td><!-- 발송자 이메일 -->
						<td class="td_body">
							<input type='text' id="mailFromEm" name='mailFromEm' class="wBig" value='<c:out value='${userInfo.mailFromEm}'/>'>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL020'/></td><!-- 편집모드 -->
						<td class="td_body">
							<input type="radio" name="contTy" value="000" onclick="goEditMode('000')" checked>
							<label>HTML</label>
							<input type="radio" name="contTy" value="001" onclick="goEditMode('001')">
							<label> TEXT</label>
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
							<input type=checkbox id="respYn" name="respYn" value="Y" checked> <spring:message code='CAMTBLLB001'/><!-- 수신확인 -->
							<input type=checkbox id="linkYn" name="linkYn" value="Y"> <spring:message code='CAMTBLLB003'/><!-- 링크클릭 -->
							<input type=button id="isReject" name="isReject" value="<spring:message code='CAMTBLLB002'/>" onClick="javascript:goReject();" class="btn_style"><!-- 수신거부 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL023'/></td><!-- 머지입력 -->
						<td class="td_body">
							<div id="divMerge" style="color: red; font-size: 11px; padding: 5px;">
							* <spring:message code='CAMTBLLB006'/>!!<!-- 발송대상그룹을 선택하세요. -->
							</div>
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN004'/>" onClick="goTitleMerge()"><!-- 제목 -->
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN005'/>" onClick="goContMerge()"><!-- 본문 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL024'/></td><!-- 메일명 -->
						<td class="td_body" colspan='3'>
							<input type='text' id="taskNm" name='taskNm' size='130'>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL025'/></td><!-- 메일제목 -->
						<td class="td_body" colspan='3'>
							<input type='text' id="mailTitle" name='mailTitle' size='130'>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL026'/></td><!-- 예약시간 -->
						<td class="td_body">
							<jsp:useBean id="currTime" class="java.util.Date"/>
							<fmt:formatDate var="ymd" value="${currTime}" pattern="yyyy-MM-dd"/>
							<fmt:formatDate var="hour" value="${currTime}" pattern="HH"/>
							<fmt:formatDate var="min" value="${currTime}" pattern="mm"/>
							<input type="text" id="sendYmd" name="sendYmd" class="wSmall" value="<c:out value='${ymd}'/>" readonly>
							<script type="text/javascript">getDate('sendHour', '<c:out value='${hour}'/>', 00, 23, 1);</script><spring:message code='CAMTBLLB016'/><!-- 시 -->
							<script type="text/javascript">getDate('sendMin', '<c:out value='${min}'/>', 00, 59, 1);</SCRIPT><spring:message code='CAMTBLLB017'/><!-- 분 -->
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL027'/></td><!-- 수신확인추적기간 -->
						<td class="td_body"><spring:message code='CAMTBLLB004'/><!-- 발송일로부터 -->
							<select id="respLog" name="respLog" class="select">
								<option value="0">∞</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7" selected>7</option>
								<option value="8">8</option>
								<option value="9">9</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15">15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="24">24</option>
								<option value="25">25</option>
								<option value="26">26</option>
								<option value="27">27</option>
								<option value="28">28</option>
								<option value="29">29</option>
								<option value="30">30</option>
							</select><spring:message code='CAMTBLLB005'/><!-- 일까지 추적 -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL028'/></td><!-- 정기발송종료일 -->
						<td class="td_body">
							<input type="checkbox" id="sendTerm" name="sendTerm" value="Y">
							<input type="text" id="sendTermEndDt" name="sendTermEndDt" style="width: 70;" class="readonly_style" value="<c:out value='${ymd}'/>" readonly>
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL029'/></td><!-- 정기발송주기 -->
						<td class="td_body">
							<input type="text" id="sendTermLoop" name="sendTermLoop" class="input" value="1">
							<select id="" name="sendTermLoopTy" class="select">
								<c:if test="${fn:length(periodList) > 0}">
									<c:forEach items="${periodList}" var="period">
										<option value="<c:out value='${period.cd}'/>"><c:out value='${period.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="4" class="typeBB" style="margin-top: 10px; padding: 0px;">
							<!-- HTML 에디터  -->
							<!--
							<div id="divComposer">
								<script >
								editor("<c:out value='${TAGFREE_CLASSID}'/>", "<c:out value='${TAGFREE_CODEBASE}'/>", "<c:out value='${NEO_UILANG}'/>", "<c:out value='${MP_FULL_URL}'/>");
								</script>
							</div>
							<div id="divTextarea" style="display:none">
								<textarea name='txtContent' style="width:800;height:350"></textarea>
							</div>
							-->
							<textarea name="ir1" id="ir1" rows="10" cols="100" style="text-align: center; width: 1013px; height: 412px; display: none; border: none;"></textarea>
							<!-- //HTML 에디터  -->
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL030'/></td><!-- 파일첨부 -->
						<td class="td_body" colspan="3">
							<select id="attachNm" name="attachNm" class="wTbig" multiple></select>
							<select id="attachPath" name="attachPath" style="display:none;" size="4" multiple></select>
							<p class="right">
								<input type="button" class="btn_style" value="<spring:message code='CAMBTN006'/>" onClick="uploadFile('attachPath','attachNm')"><!-- 추가 -->
								<input type="button" class="btn_style" value="<spring:message code='CAMBTN007'/>" onClick="deleteFile('attachPath','attachNm')"><!-- 제거 -->
							</p>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn">
					<div class="btnR">
						<input type="button" class="btn_style" value="<spring:message code='COMBTN005'/>" onClick="goAdd()"><!-- 등록 -->
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
					</div>
				</div>

				<script type="text/javascript">
				var oEditors = [];
	
				// 추가 글꼴 목록
				//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
				nhn.husky.EZCreator.createInIFrame({
					oAppRef : oEditors,
					elPlaceHolder : "ir1",
					sSkinURI: "<c:url value='/smarteditor/SmartEditor2Skin.html'/>",	
					htParams : {
						bUseToolbar : true, // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseVerticalResizer : true, // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
						bUseModeChanger : true, // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
						//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
						fOnBeforeUnload : function() {
							//alert("완료!");
						}
					}, //boolean
					fOnAppLoad : function() {
						//예제 코드
						//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
					},
					fCreator : "createSEditor2"
				});
	
				function pasteHTML(obj) {
					var sHTML = "<img src='/img/upload/"+obj+"'>";
					oEditors.getById["ir1"].exec("PASTE_HTML", [ sHTML ]);
				}
	
				function showHTML() {
					var sHTML = oEditors.getById["ir1"].getIR();
					alert(sHTML);
				}
	
				function submitContents(elClickedObj) {
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []); // 에디터의 내용이 textarea에 적용됩니다.
		
					// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("ir1").value를 이용해서 처리하면 됩니다.
		
					try {
						elClickedObj.form.submit();
					} catch (e) {
					}
				}
	
				function setDefaultFont() {
					var sDefaultFont = '궁서';
					var nFontSize = 24;
					oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
				}
				</script>
			</div>
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
