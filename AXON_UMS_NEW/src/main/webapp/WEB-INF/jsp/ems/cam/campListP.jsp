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

<script type="text/javascript">
var curEvent = "";

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
			var option = new Option(item.cdNm,item.cd);
			$("#" + formId + " select[name='" + userObjectId + "']").append(option);
		});
	});
}

// 검색 버튼 클릭
function goSearch() {
	if($("#searchStartDt").val() > $("#searchEndDt")) {
		alert("<spring:message code='COMJSALT017'/>");	// 검색 시 시작일은 종료일보다 클 수 없습니다.
		return;
	}
	$("#searchFrom input[name='page']").val("1");
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/campListP.ums'/>").submit();
}

// 초기화 버튼 클릭
function goReset(formName) {
	if(formName == "searchForm") {			//폼이 검색폼일 경우
		$("#searchCampNm").val("");		//obj.p_camp_nm.value = "";
		$("#searchCampTy").val("");		//obj.p_camp_ty.selectedIndex = 0;
		$("#searchStatus").val("");		//obj.p_status.selectedIndex = 0;
		$("#searchDeptNo").val("0");	//obj.p_dept_no.selectedIndex = 0;
		$("#searchUserId").val("");		//obj.p_user_id.selectedIndex = 0;
		$("#searchStartDt").val("<c:out value='${searchStartDt}'/>");		//obj.p_stdt.value = "";
		$("#searchEndDt").val("<c:out value='${searchEndDt}'/>");		//obj.p_eddt.value = "";
	} else if(formName == "campaignInfoForm") {		//폼이 입력폼일 경우
		if(curEvent == "goNew") {				//현재 EVENT가 새캠페인정의이면 NULL 값으로 폼 세팅
			nullForm();
		} else if(curEvent == "goSelect") {
			var campNo = $("#campNo").val();
			goSelect(campNo);
		} else {
			initForm();	//폼 초기화
		}
	}
}

//NULL 값으로 폼세팅
function nullForm() {
	$("#campNo").val("0");			//obj.p_camp_no.value = "";
	$("#campNm").val("");			//obj.p_camp_nm.value = "";
	$("#campDesc").val("");			//obj.p_camp_desc.value = "";
	$("#campTy").val("");			//obj.p_camp_ty.selectedIndex = 0;
	$("#status").val("");			//obj.p_status.selectedIndex = 0;
	$("#deptNo").val("0");			//obj.p_dept_no.selectedIndex = 0;
	$("#userid").val("");			//obj.p_user_id.selectedIndex = 0;
	$("#regDt").val("");			//obj.p_reg_dt.value = "";
	$("#regNm").val("");			//obj.p_reg_nm.value = "";

	getUserList('campaignInfoForm',$("#deptNo").val(),'userId');	//그룹별 사용자 초기화
}

//폼 초기화
function initForm() {
	$("#campaignInfoForm")[0].reset();													//폼 초기화
	getUserList('campaignInfoForm',$("#deptNo").val(),'userId');	//그룹별 사용자 초기화
}

// 템플릿명 클릭시
function goSelect(campNo) {
	curEvent = "goSelect";
	
	$("#campNo").val(campNo);
	
	//템플릿명 클릭시 숨겨진 폼을 보여줌
	$("#trDetail").show();
	//템플릿명 클릭시 등록 버튼은 숨기고 수정버튼은 보여줌
	$("#btnAdd").hide();
	$("#btnUpdate").show();

	$.getJSON("<c:url value='/ems/cam/campInfo.json'/>?campNo=" + campNo, function(data) {
		if(data) {
			$("#campNo").val(data.campaign.campNo);
			$("#campNm").val(data.campaign.campNm);
			$("#campDesc").val(data.campaign.campDesc);
			$("#campTy").val(data.campaign.campTy);
			$("#status").val(data.campaign.status);
			$("#deptNo").val(data.campaign.deptNo);
			$("#regNm").val(data.campaign.regNm);
			var regDt = data.campaign.regDt;
			regDt = regDt.substring(0,4) + "-" + regDt.substring(4,6) + "-" + regDt.substring(6,8)
			$("#regDt").val(regDt);
			
			getUserList("campaignInfoForm",data.campaign.deptNo, "userId");
			setTimeout(function(){
				$("#userId").val(data.campaign.userId);
			},500);
		}
	});
	/*
		cur_event = "clickRadio";
		cur_camp_no = camp_no;
		getUserList("crud_form",'p_user_id',dept_no,'true');

		var obj = document.crud_form;
		obj.p_camp_no.value = camp_no;
		obj.p_camp_nm.value = camp_nm;
		obj.p_camp_desc.value = camp_desc;
		obj.p_camp_ty.value = camp_ty;
		obj.p_status.value = status;
		obj.p_dept_no.value = dept_no;
		obj.p_reg_nm.value = reg_nm;
		obj.p_reg_dt.value = reg_dt;

		this.p_user_id = user_id
	*/
}

// 메일보기 클릭시
function goMail(campNo) {
	alert("메일 프로그램 완료 후 작성");
	/*
	if(p_camp_no) {
		var obj = document.search_form;
		obj.reset();
		obj.p_camp_no.value = p_camp_no;
		obj.action = "/cam/mailMainFrmP.jsp";
		obj.submit();
	} else {
		alert("<spring:message code='CAMTBLLB007'/>");		// 캠페인 선택
	}
	*/
}

// 등록 버튼 클릭시
function goAdd() {
	// 입력 폼 검사
	if(checkForm()) {
		return;
	}
	
	var param = $("#campaignInfoForm").serialize();
	$.getJSON("<c:url value='/ems/cam/campAdd.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT008'/>");		// 등록 성공
			$("#page").val("1");
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/campListP.ums'/>").submit();
		} else {
			alert("<spring:message code='COMJSALT009'/>");		// 등록 실패
		}
	});
}

//수정 EVENT 구현
function goUpdate() {
	if($("#campNo").val() != "0") {
		// 입력 폼 검사
		if(checkForm()) {
			return;
		}
		
		var param = $("#campaignInfoForm").serialize();
		$.getJSON("<c:url value='/ems/cam/campUpdate.json'/>?" + param, function(data) {
			if(data.result == "Success") {
				alert("<spring:message code='COMJSALT010'/>");		// 수정 성공
				$("#page").val("1");
				$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/campListP.ums'/>").submit();
			} else {
				alert("<spring:message code='COMJSALT011'/>");		// 수정 실패
			}
		});
	} else {
		alert("<spring:message code='CAMTBLLB007'/>");				// 캠페인 선택
	}
}

// 입력 폼 검사
function checkForm() {
	var errstr = "";
	var errflag = false;
	if($("#campNm").val() == "") {
		errstr += "[<spring:message code='CAMTBLTL007'/>]";		// 캠페인명
		errflag = true;
	}
	if($("#campTy").val() == "") {
		errstr += "[<spring:message code='CAMTBLTL008'/>]";		// 캠페인목적
		errflag = true;
	}
	if($("#status").val() == "") {
		errstr += "[<spring:message code='COMTBLTL001'/>]";		// 상태
		errflag = true;
	}
	if($("#deptNo").val() == "") {
		errstr += "[<spring:message code='COMTBLTL004'/>]";		// 사용자그룹
		errflag = true;
	}
	if($("#userId").val() == "") {
		errstr += "[<spring:message code='COMTBLTL005'/>]";		// 사용자
		errflag = true;
	}
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);		// 다음 정보를 확인하세요.
	}
	return errflag;
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
			

			<!-- new title -->
			<p class="title_default"><spring:message code='CAMTBLTL001'/></p><!-- Campaign -->
			<!-- //new title -->
			
			<div class="cWrap">
			
				<form id="searchForm" name="searchForm" method="post">
				<input type="hidden" id="page" name="page" value="1">
				<input type="hidden" name="campNo" value="0">
				<table class="table_line_outline">
					<colgroup>
						<col style="width:15%" />
						<col style="width:35%" />
						<col style="width:15%" />
						<col style="width:35%" />
					</colgroup>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
						<td class="td_body">
							<input type="text" id="searchCampNm" name="searchCampNm" class="input wBig" value="<c:out value='${searchVO.searchCampNm}'/>">
						</td>
						<td class="td_title"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
						<td class="td_body">
							<select id="searchCampTy" name="searchCampTy" class="select wBig">
								<option value=''>:: <spring:message code='COMTBLLB002'/> ::</option><!-- 목적 선택 -->
								<c:if test="${fn:length(campTyList) > 0}">
									<c:forEach items="${campTyList}" var="campTy">
										<option value="<c:out value='${campTy.cd}'/>"<c:if test="${campTy.cd eq searchVO.searchCampTy}"> selected</c:if>><c:out value='${campTy.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td class="td_body">
							<select id="searchStatus" name="searchStatus" class="select wBig">
								<option value='ALL'>:: <spring:message code='COMTBLLB003'/> ::</option><!-- 상태 선택 -->
								<c:if test="${fn:length(statusList) > 0}">
									<c:forEach items="${statusList}" var="status">
										<option value="<c:out value='${status.cd}'/>"<c:if test="${status.cd eq searchVO.searchStatus}"> selected</c:if>><c:out value='${status.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
						<td class="td_body">
							<input type="text" id="searchStartDt" name="searchStartDt" class="readonly_style wSmall" value="<c:out value='${searchStartDt}'/>" readonly> ~ 
							<input type="text" id="searchEndDt" name="searchEndDt" class="readonly_style wSmall" value="<c:out value='${searchEndDt}'/>" readonly>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td class="td_body">
							<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
							<c:if test="${'Y' eq NEO_ADMIN_YN}">
								<select id="searchDeptNo" name="searchDeptNo" onchange="getUserList('searchForm', this.value, 'searchUserId')">
									<option value="0">:: <spring:message code='COMTBLLB004'/> ::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo eq searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
							<c:if test="${'N' eq NEO_ADMIN_YN}">
								<select id="searchDeptNo" name="searchDeptNo" onchange="getUserList('searchForm', this.value, 'searchUserId')">
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<c:if test="${dept.deptNo == searchVO.searchDeptNo}">
												<option value="<c:out value='${dept.deptNo}'/>" selected><c:out value='${dept.deptNm}'/></option>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
						<td class="td_body">
							<select id="searchUserId" name="searchUserId" class="select wSmall">
								<option value=''>:: <spring:message code='COMTBLLB005'/> ::</option><!-- 사용자 선택 -->
								<c:if test="${fn:length(userList) > 0}">
									<c:forEach items="${userList}" var="user">
										<option value="<c:out value='${user.cd}'/>"<c:if test="${user.cd eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.cdNm}'/></option>
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
			
			
			
				<!------------------------------------------	LIST	START	---------------------------------------------->
				<form id="listForm" name="listForm">
				<table class="table_line_outline" border="1" cellspacing="0">
					<tr class="tr_head">
						<td><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
						<td><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
						<td><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
						<td><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
						<td><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
						<td><spring:message code='CAMTBLTL009'/></td><!-- 메일보기 -->
					</tr>
					<c:if test="${fn:length(campaignList) > 0}">
						<c:forEach items="${campaignList}" var="campaign">
							<fmt:parseDate var="regDate" value="${campaign.regDt}" pattern="yyyyMMddHHmmss"/>
							<fmt:formatDate var="regDt" value="${regDate}" pattern="yyyy-MM-dd"/> 
							<tr class="tr_body">
								<td>
									<input type="checkbox" name="campNo" value="<c:out value='${campaign.campNo}'/>" style="display:none">
									<a href="javascript:goSelect('<c:out value='${campaign.campNo}'/>')"><c:out value='${campaign.campNm}'/></a>
								</td>
								<td><c:out value="${campaign.campTyNm}"/></td>
								<td><c:out value="${campaign.statusNm}"/></td>
								<td><c:out value="${campaign.deptNm}"/></td>
								<td><c:out value="${campaign.userNm}"/></td>
								<td><c:out value="${campaign.regNm}"/></td>
								<td><c:out value="${regDt}"/></td>
								<td><input type="button" value="<spring:message code='CAMBTN003'/>" class="btn_style" onClick="goMail('<c:out value='${campaign.campNo}'/>')"></td><!-- 메일보기 -->
							</tr>
						</c:forEach>
					</c:if>
				</table>
				</form>
				<div class="btn">
					<div class="btnR"></div>
				</div>
				<div class="center" style="padding-left:250px;">${pageUtil.pageHtml}</div>
				<!------------------------------------------	LIST	END		---------------------------------------------->
				
				<br/>
				
				<!------------------------------------------	CRUD	START	---------------------------------------------->
				<form id="campaignInfoForm" name="campaignInfoForm">
				<input type="hidden" id="campNo" name="campNo" value="0">
				<table class="table_line_outline" border="1" cellspacing="0">
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
						<td colspan=3 class="td_body">
							<input type="text" id="campNm" name="campNm" class="input wBig">
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL010'/></td><!-- 캠페인설명 -->
						<td colspan=3 class="td_body">
							<textarea id="campDesc" name="campDesc" class="input" style="width:690px;"></textarea>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='CAMTBLTL008'/></td><!-- 캠페인목적 -->
						<td class="td_body">
							<select id="campTy" name="campTy" class="select wBig">
								<option value=''>:::::::::: <spring:message code='COMTBLLB002'/> ::::::::::</option><!-- 목적 선택 -->
								<c:if test="${fn:length(campTyList) > 0}">
									<c:forEach items="${campTyList}" var="campTy">
										<option value="<c:out value='${campTy.cd}'/>"><c:out value='${campTy.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
						<td class="td_body">
							<select id="status" name="status" class="select wBig">
								<option value=''>::::::: <spring:message code='COMTBLLB003'/> :::::::</option><!-- 상태 선택 -->
								<c:if test="${fn:length(statusList) > 0}">
									<c:forEach items="${statusList}" var="status">
										<option value="<c:out value='${status.cd}'/>"><c:out value='${status.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
						<td class="td_body">
							<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
							<c:if test="${'Y' eq NEO_ADMIN_YN}">
								<select id="deptNo" name="deptNo" class="select wBig" onchange="getUserList('campaignInfoForm', this.value, 'userId');">
									<option value="0">::::::: <spring:message code='COMTBLLB004'/> :::::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</c:if>
							<c:if test="${'N' eq NEO_ADMIN_YN}">
								<select id="deptNo" name="deptNo" class="select wBig">
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
						<td class="td_body">
							<select id="userId" name="userId" class="select wBig">
								<option value=''>:::::::: <spring:message code='COMTBLLB005'/> ::::::::</option><!-- 사용자 선택 -->
								<c:if test="${fn:length(userList) > 0}">
									<c:forEach items="${userList}" var="user">
										<option value="<c:out value='${user.cd}'/>"><c:out value='${user.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr id="trDetail" style="display:none">
						<td class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
						<td class="td_body">
							<input type="text" id="regDt" name="regDt" class="readonly_style wBig" readonly>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
						<td class="td_body">
							<input type="text" id="regNm" name="regNm" class="readonly_style wBig" readonly>
						</td>
					</tr>
				</table>
				</form>
				
				<div class="btn">
					<div class="btnR">
						<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goAdd()" id="btnAdd"><!-- 등록 -->
						<input type="button" value="<spring:message code='COMBTN007'/>" class="btn_typeC" onClick="goUpdate()" id="btnUpdate" style="display:none"><!-- 수정 -->
						<input type="button" value="<spring:message code='COMBTN009'/>" class="btn_typeC" onClick="goReset('campaignInfoForm')"><!-- 재입력 -->
					</div>
				</div>
				<!------------------------------------------	CRUD	END		---------------------------------------------->
			
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
