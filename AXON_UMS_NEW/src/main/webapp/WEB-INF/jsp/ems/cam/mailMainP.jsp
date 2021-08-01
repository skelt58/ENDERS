<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.27
	*	설명 : 메일관리 목록 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMdd"/>
<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy-MM-dd"/> 
<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMdd"/>
<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy-MM-dd"/> 

<script type="text/javascript">
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
	
	// 메일 목록 화면 호출
	getMailList();
});

//메일 목록 조회
function getMailList() {
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/cam/mailListP.ums'/>?" + param,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#divMailList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

//사용자그룹 선택시 사용자 목록 조회 
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#searchUserId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
			$("#searchUserId").append(option);
		});
	});
}

// 검색 버튼 클릭시
function goSearch() {
	$("#page").val(1);
	getMailList();
}

// 초기화 버튼 클릭시
function goInit() {
	var deptNo = "<c:if test="${'Y' eq NEO_ADMIN_YN}">0</c:if><c:if test="${'N' eq NEO_ADMIN_YN}"><c:out value="${NEO_DEPT_NO}"/></c:if>";
	$("#searchTaskNm").val("");
	$("#searchCampNo").val("0");
	$("#searchDeptNo").val(deptNo);
	$("#searchUserId").val("");
	$("#searchStatus").val("000");
	$("#searchStartDt").val("<c:out value='${searchStartDt}'/>");
	$("#searchEndDt").val("<c:out value='${searchEndDt}'/>");
	$("#searchWorkStatus").val("");
}

// 목록에서 전체 선택
function goAll() {
	if($("#mailListForm input[name='isAll']").is(":checked") == true) {
		$("#mailListForm input[name='taskNos']").prop("checked", true);
		$("#mailListForm input[name='subTaskNos']").prop("checked", true);
		$("#mailListForm input[name='workStatus']").prop("checked", true);
	} else {
		$("#mailListForm input[name='taskNos']").prop("checked", false);
		$("#mailListForm input[name='subTaskNos']").prop("checked", false);
		$("#mailListForm input[name='workStatus']").prop("checked", false);
	}
}

// 목록에서 체크박스 클릭시 taskNo와 subTaskNo, workStatus를 같이 체크해 준다.
function goTaskNo(i) {
	var isChecked = $("#mailListForm input[name='taskNos']").eq(i).is(":checked");
	$("#mailListForm input[name='subTaskNos']").eq(i).prop("checked", isChecked);
	$("#mailListForm input[name='workStatus']").eq(i).prop("checked", isChecked);
}

// 삭제된 목록의 체크박스 클릭시..
function goDeleteClick() {
    alert("<spring:message code='CAMJSALT019'/>");	// 삭제된 목록은 선택할 수 없습니다.
    return false;
}

// 목록에서 메일명 클릭시 (메일 수정 화면으로 이동)
function goUpdatef(taskNo, subTaskNo) {
	$("#taskNo").val(taskNo);
	$("#subTaskNo").val(subTaskNo);
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailUpdateP.ums'/>").submit();
}

// 목록에서 발송대상그룹 클릭시 (미리보기)
function goSegInfo(segNo) {
    window.open("","segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
    $("#searchForm").attr("target","segInfo").attr("action","<c:url value='/ems/seg/segInfoP.ums'/>?segNo=" + segNo).submit();
}

// 목록에서 발송상태(발송대기) 클릭시 -> 발송승인
function goAdmit(i) {
	$("#taskNo").val( $("#mailListForm input[name='taskNos']").eq(i).val() );
	$("#subTaskNo").val( $("#mailListForm input[name='subTaskNos']").eq(i).val() );

	var a = confirm("<spring:message code='CAMJSALT020'/>");	// 승인 완료 실행을 하겠습니까?
	if ( a ) {
		var param = $("#searchForm").serialize();
		$.getJSON("<c:url value='/ems/cam/mailAdmit.json'/>?" + param, function(data) {
			if(data.result == "Success") {
				alert("<spring:message code='CAMJSALT008'/>");	// 승인 성공
				
				// 메일 목록 재조회;
				getMailList();
			} else if(data.result == "Fail") {
				alert("<spring:message code='CAMJSALT009'/>");	// 승인 실패
			}
		});
	} else return;
}

// 목록에서 발송상태(발송실패) 클릭시
function goFail(str) {
    alert(str);
    return;
}

//등록 버튼 클릭
function goMailAdd() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/cam/mailAddP.ums'/>").submit();
}


// 사용중지 클릭시
function goDisable() {
	var isChecked = false;
	$("#mailListForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) isChecked = true;
	});
    
    if(!isChecked) {
        alert("<spring:message code='CAMJSALT013'/>!!");		// 사용중지 할 목록을 선택해 주세요.
        return;
    }

    $("#status").val("001");
	var param = $("#mailListForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='CAMJSALT028'/>");	// 사용중지성공
			
			// 메일 목록 재조회;
			getMailList();
		} else if(data.result == "Fail") {
			alert("<spring:message code='CAMJSALT030'/>");	// 사용중지실패
		}
	});
}

// 삭제 클릭시
function goDelete() {
	var isChecked = false;
	$("#mailListForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) isChecked = true;
	});
    
    if(!isChecked) {
        alert("<spring:message code='CAMJSALT025'/>!!");		// 삭제할 목록을 선택해 주세요!!
        return;
    }

    $("#status").val("002");
	var param = $("#mailListForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailDelete.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='COMJSALT012'/>");	// 삭제 성공
			
			// 메일 목록 재조회;
			getMailList();
		} else if(data.result == "Fail") {
			alert("<spring:message code='COMJSALT013'/>");	// 삭제 실패
		}
	});
}

// 복사 클릭시
function goCopy() {
	var checkedCount = 0;
	
	$("#mailListForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) checkedCount++;
	});
    
    if(checkedCount == 0 || checkedCount > 1) {
        alert("<spring:message code='CAMJSALT014'/>!!");		// 복사할 목록을 하나만 선택해 주세요.
        return;
    }

    $("#status").val("002");
	var param = $("#mailListForm").serialize();
	$.getJSON("<c:url value='/ems/cam/mailCopy.json'/>?" + param, function(data) {
		if(data.result == "Success") {
			alert("<spring:message code='CAMJSALT011'/>");	// 복사 성공
			
			// 메일 목록 재조회;
			getMailList();
		} else if(data.result == "Fail") {
			alert("<spring:message code='CAMJSALT012'/>");	// 복사 실패
		}
	});
}

// 테스트발송 클릭시
function goTestSend(){
	var checkedCount = 0;
	var statusError = false;
	
	$("#mailListForm input[name='taskNos']").each(function(idx,item){
		if($(item).is(":checked")) {
			if($("#mailListForm input[name='workStatus']").eq(idx).val() != "000") {
				$("#mailListForm input[name='taskNos']").eq(idx).prop("checked", false);
				$("#mailListForm input[name='subTaskNos']").eq(idx).prop("checked", false);
				$("#mailListForm input[name='workStatus']").eq(idx).prop("checked", false);
				statusError = true;
			}
			checkedCount++;
		}
	});
	
	if(statusError) {
		alert("<spring:message code='CAMJSALT015'/>");			// 테스트 발송은 발송대기 상태만 가능합니다.
		return;
	}
	
    if(checkedCount == 0 || checkedCount > 1) {
        alert("<spring:message code='CAMJSALT017'/>!!");		// 테스트 발송할 목록을 하나만 선택해 주세요.
        return;
    }

	window.open("","preView", " width=1012, height=230, scrollbars=yes");
	$("#mailListForm").attr("target","preView").attr("action","/ems/cam/mailTestListP.ums").submit();
}


// 페이징
function goPageNum(page) {
	$("#page").val(page);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/cam/mailListP.ums'/>?" + param,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#divMailList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
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
			<p class="title_default"><spring:message code='CAMTBLTL002'/></p><!-- 메일 -->
			<!-- //new title -->
			
			<div class="cWrap">
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" id="page" name="page" value="1">
			<input type="hidden" id="taskNo" name="taskNo" value="0">
			<input type="hidden" id="subTaskNo" name="subTaskNo" value="0">
			<table border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
				<colgroup>
					<col style="width:15%" />
					<col style="width:35%" />
					<col style="width:15%" />
					<col style="width:35%" />
				</colgroup>
				<tr>
					<td class="td_title"><spring:message code='CAMTBLTL011'/></td><!-- 메일명 -->
					<td class="td_body">
						<input type="text" id="searchTaskNm" name="searchTaskNm" value="<c:out value='${searchVO.searchTaskNm}'/>"  class="wBig">
					</td>
					<td class="td_title"><spring:message code='CAMTBLTL006'/></td><!-- 캠페인 -->
					<td class="td_body">
						<select id="searchCampNo" name="searchCampNo" class="wBig">
							<option value="0">::::<spring:message code='CAMTBLLB007'/>::::</option><!-- 캠페인 선택 -->
							<c:if test="${fn:length(campaignList) > 0}">
								<c:forEach items="${campaignList}" var="camp">
									<option value="<c:out value='${camp.campNo}'/>"<c:if test="${camp.campNo == searchVO.searchCampNo}"> selected</c:if>><c:out value='${camp.campNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
					<td class="td_body">
						<!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
						<c:if test="${'Y' eq NEO_ADMIN_YN}">
							<select id="searchDeptNo" name="searchDeptNo" onchange="getUserList(this.value);" class="wBig">
								<option value="0">::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
						<c:if test="${'N' eq NEO_ADMIN_YN}">
							<select id="searchDeptNo" name="searchDeptNo" class="wBig">
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
						<select id="searchUserId" name="searchUserId" class="wMiddle">
							<option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
							<c:if test="${fn:length(userList) > 0}">
								<c:forEach items="${userList}" var="user">
									<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
						<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_style" onClick="goSearch()"><!-- 검색 -->
						<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goInit()"><!-- 초기화 -->
					</td>
				</tr>
				<tr>
					<td class="td_title"><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
					<td class="td_body">
						<input type="text" id="searchStartDt" name="searchStartDt" class="wSmall" value="<c:out value='${searchStartDt}'/>" readonly> -
						<input type="text" id="searchEndDt" name="searchEndDt" class="wSmall" value="<c:out value='${searchEndDt}'/>" readonly>
					</td>
					<td class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
					<td class="td_body">
						<select id="searchStatus" name="searchStatus" class="wBig">
							<option value="ALL">::::<spring:message code='COMTBLLB003'/>::::</option><!-- 상태 선택 -->
							<c:if test="${fn:length(statusList) > 0}">
								<c:forEach items="${statusList}" var="status">
									<option value="<c:out value='${status.cd}'/>"<c:if test="${status.cd eq searchVO.searchStatus}"> selected</c:if>><c:out value='${status.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td_title"><spring:message code='CAMTBLTL012'/></td><!-- 발송상태 -->
					<td class="td_body" colspan="3">
						<select id="searchWorkStatus" name="searchWorkStatus" class="wBig">
							<option value=''>::::<spring:message code='CAMTBLLB008'/>::::</option><!-- 발송상태 선택 -->
							<option value='000'<c:if test="${'000' eq searchVO.searchWorkStatus}"> selected</c:if>><spring:message code='CAMTBLLB011'/></option><!-- 발송대기 -->
							<option value='001'<c:if test="${'001' eq searchVO.searchWorkStatus}"> selected</c:if>><spring:message code='CAMTBLLB012'/></option><!-- 발송승인 -->
							<option value='002'<c:if test="${'002' eq searchVO.searchWorkStatus}"> selected</c:if>><spring:message code='CAMTBLLB013'/></option><!-- 발송중... -->
							<option value='003'<c:if test="${'003' eq searchVO.searchWorkStatus}"> selected</c:if>><spring:message code='CAMTBLLB014'/></option><!-- 발송완료 -->
							<option value='004'<c:if test="${'004' eq searchVO.searchWorkStatus}"> selected</c:if>><spring:message code='CAMTBLLB015'/></option><!-- 발송실패 -->
						</select>
					</td>
				</tr>
			</table>
			</form>

			<!-- 하단 프레임 -->
			<table width="1035" border="0" cellspacing="0" cellpadding="0">
				<tr><td height="10"></td></tr>
				<tr>
					<td>
						<div id="divMailList" style="width:1000px;height:800px;overflow:auto;"></div>
					</td>
				</tr>
			</table>
			</div>
			<!-- // 프레임 -->
			
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
