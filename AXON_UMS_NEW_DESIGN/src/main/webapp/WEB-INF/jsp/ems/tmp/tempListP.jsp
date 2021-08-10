<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMdd"/>
<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy-MM-dd"/> 
<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMdd"/>
<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy-MM-dd"/> 

<script type="text/javascript" src="<c:url value='/smarteditor/js/HuskyEZCreator.js'/>" charset="utf-8"></script>
<script type="text/javascript">
var curEvent = "goSearch";

$(document).ready(function() {
	// 조회기간 시작일 설정
	$("#searchStartDt").datepicker({
		//showOn:"button",
		minDate:"2021-01-01",
		maxDate:$("#searchEndDt").val(),
		onClose:function(selectedDate) {
			$("#searchEndDt").datepicker("option", "minDate", selectedDate);
		}
	});
	
	// 조회기간 종료일 설정
	$("#searchEndDt").datepicker({
		//showOn:"button",
		minDate:$("#searchStartDt").val(),
		onClose:function(selectedDate) {
			$("#searchStartDt").datepicker("option", "maxDate", selectedDate);
		}
	});
});

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(formId, deptNo, userObjectId) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#" + formId + " select[name='" + userObjectId + "']").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#" + formId + " select[name='" + userObjectId + "']").append(option);
		});
	});
}

//검색 버튼 클릭
function goSearch() {
	if($("#searchStartDt").val() > $("#searchEndDt")) {
		alert("<spring:message code='COMJSALT017'/>");	// 검색 시 시작일은 종료일보다 클 수 없습니다.
		return;
	}
	$("#searchFrom input[name='page']").val("1");
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/tmp/tempListP.ums'/>").submit();
}

// 초기화 버튼 클릭
function goReset(formName) {
	if(formName == "searchForm") {			//폼이 검색폼일 경우
		$("#searchTempNm").val("");				//obj.p_temp_nm.value = "";
		//obj.p_channel.selectedIndex = 0;
		$("#searchStatus").val("ALL");				//obj.p_status.selectedIndex = 0;
		$("#searchDeptNo").val("0");			//obj.p_dept_no.selectedIndex = 0;
		$("#searchUserId").val("");				//obj.p_user_id.selectedIndex = 0;
		$("#searchStartDt").val("<c:out value='${searchStartDt}'/>");		//obj.p_stdt.value = "";
		$("#searchEndDt").val("<c:out value='${searchEndDt}'/>");			//obj.p_eddt.value = "";
	} else if(formName == "templateInfoForm") {		//폼이 입력폼일 경우
		if(curEvent == "goNew") {				//현재 EVENT가 신규등록이면 NULL 값으로 폼 세팅
			nullForm();
		} else if(curEvent == "goSelect") {	//템플릿을 선택했다면
			var tempNo = $("#tempNo").val();
			goSelect(tempNo);
		} else {
			initForm();	//폼 초기화
		}
	}
}

//폼 초기화
function initForm() {
	$("#templateInfoForm")[0].reset();		//obj.reset();						//폼 초기화
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);
	getUserList('templateInfoForm',$("#deptNo").val(),"userId");	//그룹별 사용자 초기화
}

//NULL 값으로 폼세팅
function nullForm() {
	$("#tempNo").val("0");				//obj.p_temp_no.value = "";
	$("#tempNm").val("");				//obj.p_temp_nm.value = "";
	$("#tempDesc").val("");				//obj.p_temp_desc.value = "";	
	//obj.p_channel.selectedIndex = 0;
	$("#status").val("");				//obj.p_status.selectedIndex = 0;
	$("#deptNo").val("0");				//obj.p_dept_no.selectedIndex = 0;
	$("#userId").val("");				//obj.p_user_id.selectedIndex = 0;

	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);

	$("#regDt").val("");				//obj.p_reg_dt.value = "";
	$("#regNm").val("");				//obj.p_reg_nm.value = "";
	
	getUserList('templateInfoForm',$("#deptNo").val(),'userId');	//그룹별 사용자 초기화
}

// 신규등록 클릭시
function goNew() {
	curEvent = "goNew";

	//등록시 필요없는 입력폼은 숨김
	$("#trDetail").hide();
	//등록시 등록버튼은 보여주고 수정버튼은 숨김
	$("#btnAdd").show();
	$("#btnUpdate").hide();

	nullForm();
}

//템플릿명 클릭시
function goSelect(tempNo) {
	curEvent = "goSelect";

	//템플릿명 클릭시 숨겨진 폼을 보여줌
	$("#trDetail").show();
	//템플릿명 클릭시 등록 버튼은 숨기고 수정버튼은 보여줌
	$("#btnAdd").hide();
	$("#btnUpdate").show();

	$.getJSON("<c:url value='/ems/tmp/tempInfo.json'/>?tempNo=" + tempNo, function(data) {
		if(data) {
			$("#tempNo").val(data.template.tempNo);
			$("#tempNm").val(data.template.tempNm);
			$("#tempDesc").val(data.template.tempDesc);
			$("#tempFlPath").val(data.template.tempFlPath);
			$("#status").val(data.template.status);
			$("#deptNo").val(data.template.deptNo);
			$("#regNm").val(data.template.regNm);
			var regDt = data.template.regDt;
			regDt = regDt.substring(0,4) + "-" + regDt.substring(4,6) + "-" + regDt.substring(6,8)
			$("#regDt").val(regDt);
			
			$.getJSON("<c:url value='/ems/tmp/tempFileView.json'/>?tempFlPath=" + data.template.tempFlPath, function(res) {
				if(res.result == 'Success') {
	                  oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);    //스마트에디터 초기화
					  oEditors.getById["ir1"].exec("PASTE_HTML", [res.tempVal]);   //스마트에디터 내용붙여넣기
				} else {
					
				}
			});
			
			getUserList("templateInfoForm",data.template.deptNo, "userId");
			setTimeout(function(){
				$("#userId").val(data.template.userId);
			},500);
		}
	});
}

// 등록 버튼 클릭시
function goAdd() {
	if(checkForm()) return;
	
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#tempVal").val( $("#ir1").val() );
	
	// 등록 처리
	$("#templateInfoForm").attr("target","iFrmTemplate").attr("action","<c:url value='/ems/tmp/tempAddP.ums'/>").submit();
}

//수정 버튼 클릭시
function goUpdate() {
	if($("#tempNo").val() != "0") {
		if(checkForm()) return;
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	    $("#tempVal").val( $("#ir1").val() );
	    
		// 수정 처리
		$("#templateInfoForm").attr("target","iFrmTemplate").attr("action","<c:url value='/ems/tmp/tempUpdateP.ums'/>").submit();
		
	} else {
		alert("<spring:message code='CAMTBLLB010'/>");		// 템플릿 선택
	}
}

//입력폼 체크
function checkForm() {
	var errstr = "";
	var errflag = false;
	if($("#tempNm").val() == "") {
		errstr += "[<spring:message code='TMPTBLTL002'/>]";		// 템플릿명
		errflag = true;
	}
	if($("#status").val() == "") {
		errstr += "[<spring:message code='COMTBLTL001'/>]";		// 상태
		errflag = true;
	}
	if($("#deptNo").val() == "0") {
		errstr += "[<spring:message code='COMTBLTL004'/>]";		// 사용자그룹
		errflag = true;
	}
	if($("#userId").val() == "") {
		errstr += "[<spring:message code='COMTBLTL005'/>]";		// 사용자
		errflag = true;
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
	}
	return errflag;
}

//페이징
function goPageNum(page) {
	$("#page").val(page);
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/tmp/tempListP.ums'/>").submit();
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




			<!------------------------------------------	TITLE	START	---------------------------------------------->
			<p class="title_default"><spring:message code='TMPTBLTL001'/></p><!-- 템플릿 -->
			<!------------------------------------------	TITLE	END		---------------------------------------------->

			<!------------------------------------------	SEARCH	START	---------------------------------------------->
			<div class="cWrap">
				<form id="searchForm" name="searchForm" method="post">
				<input type="hidden" id="page" name="page" value="<c:out value='${searchVO.page}'/>">
				<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<td class="td_title"><spring:message code='TMPTBLTL002'/></td><!-- 템플릿명 -->
						<td class="td_body">
							<input type="text" id="searchTempNm" name="searchTempNm" class="wBig" value="<c:out value='${searchVO.searchTempNm}'/>">
							<input type="hidden" id="searchChannel" name="searchChannel" value="000">
						</td>
						<td class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td class="td_body" colspan=3>
							<select id="searchStatus" name="searchStatus" class="wBig">
								<option value='ALL'>:::: <spring:message code='COMTBLLB003'/> ::::</option><!-- 상태 선택 -->
								<c:if test="${fn:length(statusList) > 0}">
									<c:forEach items="${statusList}" var="status">
										<option value="<c:out value='${status.cd}'/>"<c:if test="${status.cd eq searchVO.searchStatus}"> selected</c:if>><c:out value='${status.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
						<td class="td_body">
							<input type="text" id="searchStartDt" name="searchStartDt" class="readonly_style" class="wSmall" value="<c:out value='${searchStartDt}'/>" readonly> -
							<input type="text" id="searchEndDt" name="searchEndDt" class="wSmall" value="<c:out value='${searchEndDt}'/>" readonly>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td class="td_body">
							<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
							<c:if test="${'Y' eq NEO_ADMIN_YN}">
								<select id="searchDeptNo" name="searchDeptNo" class="wBig" onchange="getUserList('searchForm',this.value,'searchUserId');">
									<option value="0">:::: <spring:message code='COMTBLLB004'/> ::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
							<c:if test="${'N' eq NEO_ADMIN_YN}">
								<select id="searchDeptNo" name="searchDeptNo" class="select">
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<c:if test="${dept.deptNo == searchVO.searchDeptNo}">
												<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
						<td class="td_body" colspan="3">
							<select id="searchUserId" name="searchUserId" class="wBig">
								<option value=''>:: <spring:message code='COMTBLLB005'/> ::</option><!-- 사용자 선택 -->
								<c:if test="${fn:length(userList) > 0}">
									<c:forEach items="${userList}" var="user">
										<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_style" onClick="goSearch()"><!-- 검색 -->
							<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset('searchForm')"><!-- 초기화 -->
						</td>
					</tr>
				</table>
				</form>
				<!------------------------------------------	SEARCH	END		---------------------------------------------->
				
				<div class="btn">
					<p class="btnR">
						<input type="button" value="<spring:message code='COMBTN004'/>" class="btn_typeC" onClick="goNew()"><!-- 신규등록 -->	
					</p>
				</div>

				<!------------------------------------------	LIST	START	---------------------------------------------->
				<form id="listForm" name="listForm">
				<table class="table_line_outline" border="1" cellspacing="0" style="width:920px">
					<tr class="tr_head">
						<td><spring:message code='TMPTBLTL002'/></td><!-- 템플릿명 -->
						<td><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
						<td><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
						<td><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
					</tr>
					<c:set var="templateSize" value="${fn:length(templateList)}"/>
					<c:if test="${fn:length(templateList) > 0}">
						<c:forEach items="${templateList}" var="template">
							<fmt:parseDate var="regDate" value="${template.regDt}" pattern="yyyyMMddHHmmss"/>
							<fmt:formatDate var="regDt" value="${regDate}" pattern="yyyy-MM-dd"/> 
							<tr class="tr_body">
								<td><a href="javascript:goSelect('<c:out value='${template.tempNo}'/>')"><c:out value='${template.tempNm}'/></a></td>
								<td><c:out value="${template.statusNm}"/></td>
								<td><c:out value="${template.deptNm}"/></td>
								<td><c:out value="${template.userNm}"/></td>
								<td><c:out value="${template.regNm}"/></td>
								<td><c:out value="${regDt}"/></td>
							</tr>
						</c:forEach>
					</c:if>
				</table>
				</form>
				<div class="center">${pageUtil.pageHtml}</div>
				<!------------------------------------------	LIST	END		---------------------------------------------->
				
				<br/>
				
				<!------------------------------------------	CRUD	START	---------------------------------------------->
				<form id="templateInfoForm" name="templateInfoForm" method="post">
				<input type="hidden" id="tempNo" name="tempNo" value="0">
				<input type="hidden" id="tempVal" name="tempVal" value="">
				<input type="hidden" id="channel" name="channel" value="000">
				<table class="table_line_outline">
					<colgroup>
						<col style="width:15%">
						<col style="width:25%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
					</colgroup>

					<!------------------------	입력값	-------------------------->
					<tr>
						<td class="td_title" ><spring:message code='TMPTBLTL002'/></td><!-- 템플릿명 -->
						<td class="td_body" colspan="5">
							<input type="text" id="tempNm" name="tempNm" style="width:99%;" >
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='TMPTBLTL003'/></td><!-- 설명 -->
						<td class="td_body" colspan="5">
							<textarea id="tempDesc" name="tempDesc" style="width:99%; height:50px;"></textarea>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>	
						<td class="td_title" ><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td class="td_body" colspan="1">
							<select id="status" name="status" style="width:200" >
								<option value=''>:: <spring:message code='COMTBLLB003'/> ::</option><!-- 상태 선택 -->
								<c:if test="${fn:length(statusList) > 0}">
									<c:forEach items="${statusList}" var="status">
										<option value="<c:out value='${status.cd}'/>"><c:out value='${status.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td class="td_body" colspan="1">
							<c:if test="${'Y' eq NEO_ADMIN_YN}">
								<select id="deptNo" name="deptNo" style="width:95%;" onchange="getUserList('templateInfoForm',this.value,'userId');">
									<option value="0">:::: <spring:message code='COMTBLLB004'/> ::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
							<c:if test="${'N' eq NEO_ADMIN_YN}">
								<select id="deptNo" name="deptNo"  style="width:95%;">
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<c:if test="${dept.deptNo == searchVO.searchDeptNo}">
												<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
						<td class="td_body" colspan="1">
							<select id="userId" name="userId" class="select" style="width:95%;">
								<option value=''>:: <spring:message code='COMTBLLB005'/> ::</option><!-- 사용자 선택 -->
								<c:if test="${fn:length(userList) > 0}">
									<c:forEach items="${userList}" var="user">
										<option value="<c:out value='${user.userId}'/>"><c:out value='${user.userNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr id="trDetail" style="display:none;">
						<td class="td_title"><spring:message code='TMPTBLTL004'/></td><!-- 파일위치 -->
						<td class="td_body">
							<input type="text" id="tempFlPath" name="tempFlPath" style="width:95%;" readonly>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
						<td class="td_body">
							<input type="text" id="regDt" name="regDt"  style="width:95%" readonly>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
						<td class="td_body" >
							<input type="text" id="regNm" name="regNm" style="width:95%" readonly>
						</td>
					</tr>
				</table>
				</form>
				
				<!------------------------------------------	WEBEDITOR	START		-------------------------------------->
				<table>
					<tr>
						<td align="center" width="1015">
							<textarea name="ir1" id="ir1" rows="10" cols="100" style="text-align: center; width: 1007px; height: 412px; display: none; border: none;" ></textarea>
						</td>
					</tr>
				</table>
				<!------------------------------------------	WEBEDITOR	END		------------------------------------------>
				
				<div class="btn">
					<div class="btnR">
						<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goAdd()" id="btnAdd"><!-- 등록 -->
						<input type="button" value="<spring:message code='COMBTN007'/>" class="btn_typeG" onClick="goUpdate()" id="btnUpdate" style="display:none"><!-- 수정 -->
						<input type="button" value="<spring:message code='COMBTN009'/>" class="btn_typeG" onClick="goReset('templateInfoForm')"><!-- 재입력 -->
					</div>
				</div>
			<!------------------------------------------	CRUD	END		---------------------------------------------->
			
			
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
				//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
				//body_loaded();
			},
			fCreator: "createSEditor2"
			});

			function pasteHTML(obj) {
				var sHTML = "<img src='<c:url value='/images/upload'/>/"+obj+"'>";
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
