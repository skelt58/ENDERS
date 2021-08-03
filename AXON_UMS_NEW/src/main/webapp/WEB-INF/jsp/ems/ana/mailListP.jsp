<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 메일별분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.tab {
	background-color:#cccccc;
}
</style>

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
});

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
	if( $("#searchStartDt").val() > $("#searchEndDt").val() ) {
		alert("<spring:message code='COMJSALT017'/>");		//검색 시 시작일은 종료일보다 클 수 없습니다.
		return;
	}
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/ana/mailListP.ums'/>").submit();
}

// 초기화 버튼 클릭시
function goReset(obj) {
	$("#searchForm")[0].reset();
}

// 목록에서 전체선택 클릭시
function goAll() {
	$("#listForm input[name='taskNo']").each(function(idx,item){
		$(item).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
		$("#listForm input[name='subTaskNo']").eq(idx).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
	});
}


// 탭 관련 변수
var curTab = "";
var curTaskNo = "";
var curSubTaskNo = "";
var curDmGrpCd = "";

// 목록에서 메일명 클릭시
function goOz(tabNm, target, taskNo,subTaskNo) {
	curTaskNo = taskNo;
	curSubTaskNo = subTaskNo;
	goOzTab(tabNm, target);
}

// 탭 실행
function goOzTab(tabNm, target) {
	if(curTaskNo == "" || curSubTaskNo == "") {
		alert("<spring:message code='ANAJSALT002'/>");		// 메일을 선택하세요.
		return;
	}

	//탭을 보여주고 폼 초기화
	if($("#tab").css("display") == "none") {
		$("#tab").show();
		$("#notab").hide();
		$("#listForm")[0].reset();
	}

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

	curTab = tabNm;		//현재 클릭한 탭 설정

	//클릭한 탭을 보여줌
	switch(tabNm) {
		case 'tab1' :	$("#tab1").hide(); $("#click_tab1").show(); $("#saveNm").val( "mail_summ_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab2' :	$("#tab2").hide(); $("#click_tab2").show(); $("#saveNm").val( "mail_error_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab3' :	$("#tab3").hide(); $("#click_tab3").show(); $("#saveNm").val( "mail_domain" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab4' :	$("#tab4").hide(); $("#click_tab4").show(); $("#saveNm").val( "mail_send_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab5' :	$("#tab5").hide(); $("#click_tab5").show(); $("#saveNm").val( "mail_resp_" + curTaskNo + "_" + curSubTaskNo ); break;
		case 'tab6' :	$("#tab6").hide(); $("#click_tab6").show(); break;
		case 'tab7' :	$("#tab7").hide(); $("#click_tab7").show(); break;
	}


	//고객분석 메뉴 처리
	custBtnNone(this.curDmGrpCd);
	$("#custMenu").hide();
	
/* 	var param ="taskNo=" + curTaskNo + "&subTaskNo=" + curSubTaskNo;
	$.ajax({
		type : "GET",
		url : target + "?" + param,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#divReportView").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
 */	
	iFrmReport.location.href = target + "?taskNo=" + curTaskNo + "&subTaskNo=" + curSubTaskNo;
/* 	$("#iFrmReport").ready(function(){
		var body = $("#iFrmReport").contents().find("body");
		body.append(target);
	}); */
}

function custBtnNone(curDmGrpCd) {
	switch(curDmGrpCd) {
		case '01' :	$("#click_age").hide(); $("#age").show(); break;
		case '02' :	$("#click_wedding").hide(); $("#wedding").show(); break;
		case '03' :	$("#click_gender").hide(); $("#gender").show(); break;
		case '04' :	$("#click_zip").hide(); $("#zip").show(); break;
		case '05' :	$("#click_job").hide(); $("#job").show(); break;
		case '06' :	$("#click_regyr").hide(); $("#regyr").show(); break;
		case '07' :	$("#click_regst").hide(); $("#regst").show(); break;
		case '08' :	$("#click_phmk").hide(); $("#phmk").show(); break;
		case '09' :	$("#click_cyonphmd").hide(); $("#cyonphmd").show(); break;
		case '10' :	$("#click_wowphmd").hide(); $("#wowphmd").show(); break;
		case '11' :	$("#click_telcom").hide(); $("#telcom").show(); break;
		case '12' :	$("#click_bizty").hide(); $("#bizty").show(); break;
		case '13' :	$("#click_mlvl").hide(); $("#mlvl").show(); break;
	}
}






// 페이징
function goPageNum(page) {
	$("#page").val(page);
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/ana/mailListP.ums'/>").submit();
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
			
			
			<!------------------------------------------	TITLE	START	---------------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><p class="title_default"><spring:message code='ANATBLTL001'/></p></td><!-- 메일별분석 -->
				</tr>
				<tr>
				<td height="16"></td>
				</tr>
			</table>
			<!------------------------------------------	TITLE	END		---------------------------------------------->

			<!------------------------------------------	SEARCH	START	---------------------------------------------->
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" id="page" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" id="taskNo" name="taskNo" value="<c:out value='${searchVO.taskNo}'/>">
			<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
				<tr>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;"  name="searchTaskNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchTaskNm}'/>">
					</td>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL006'/></td><!-- 캠페인 -->
					<td width="22%" colspan=3 class="td_body">
						<select id="searchCampNo" name="searchCampNo" style="width: 140px;" class="select">
							<option value="0">::: <spring:message code='ANATBLLB001'/> :::</option><!-- 캠페인 선택 -->
							<c:if test="${fn:length(campList) > 0}">
								<c:forEach items="${campList}" var="camp">
									<option value="<c:out value='${camp.campNo}'/>"<c:if test="${camp.campNo == searchVO.searchCampNo}"> selected</c:if>><c:out value='${camp.campNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<td width="10%" class="td_title"><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
					<td width="22%" class="td_body">
						<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMdd"/>
						<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy-MM-dd"/> 
						<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMdd"/>
						<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy-MM-dd"/> 
						<input type="text" id="searchStartDt"  name="searchStartDt" class="readonly_style" style="border:1px solid #c0c0c0;width:80px;" value="<c:out value='${searchStartDt}'/>" readonly> ~
						<input type="text" id="searchEndDt"  name="searchEndDt" class="readonly_style" style="border:1px solid #c0c0c0;width:80px;" value="<c:out value='${searchEndDt}'/>" readonly>
					</td>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
					<td width="22%" class="td_body">
						<!-- 관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함 -->
						<c:if test="${'Y' eq NEO_ADMIN_YN}">
							<select name="searchDeptNo" style="width: 140px;" class="select" onchange="javascript:getUserList(this.value);">
								<option value="0">:: <spring:message code='COMTBLLB004'/> ::</option><!-- 그룹 선택 -->
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
						<c:if test="${'N' eq NEO_ADMIN_YN}">
							<select id="searchDeptNo" name="searchDeptNo" style="width: 140px;" class="select">
								<c:if test="${fn:length(deptList) > 0}">
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>" selected><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</c:if>
					</td>
					<td width="10%" class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
					<td width="22%" class="td_body">
						<select id="searchUserId" name="searchUserId"  style="width: 140px;" class="select">
							<option value=''>:: <spring:message code='COMTBLLB005'/> ::</option><!-- 사용자 선택 -->
							<c:if test="${fn:length(userList) > 0}">
								<c:forEach items="${userList}" var="user">
									<option value="<c:out value='${user.userId}'/>"<c:if test="${user.userId eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
								</c:forEach>
							</c:if>
						</select>

					</td>
				</tr>
			</table>
			</form>

			<!--검색/초기화 버튼-->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="3"></td>
				</tr>
				<tr>
					<td align="right">
						<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_typeC" onClick="goSearch()"><!-- 검색 -->
						<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset(this.form)"><!-- 초기화 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			<!------------------------------------------	SEARCH	END		---------------------------------------------->
			
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" height=3></td>
				</tr>
				<c:if test="${searchVO.taskNo != 0}">
					<tr>
						<td align="right" height=20>
							<input type="button" value="<spring:message code='ANATBLTL002'/>" class="btn_style" style="width:80px" onClick="goTask()"><!-- 정기메일분석 -->
						</td>
					</tr>
				</c:if>
				<tr>
					<td align="right" height=3>
				</td>
				</tr>
			</table>
			
			
			<!------------------------------------------	LIST	START	---------------------------------------------->
			<form id="listForm" name="listForm" method="post">
			<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
				<tr class="tr_head">
					<td width="3%"><input type="checkbox" name="isAll" onclick='goAll()' style="border:0"></td>
					<td width="10%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
					<td width="19%"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="10%"><spring:message code='ANATBLTL009'/></td><!-- 단발/정기 -->
					<td width="19%"><spring:message code='ANATBLTL010'/></td><!-- 발송그룹명 -->
					<td width="11%"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
					<td width="14%"><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
					<td width="11%"><spring:message code='ANATBLTL011'/></td><!-- 발송상태 -->
				</tr>
				<c:if test="${fn:length(mailList) > 0}">
					<c:forEach items="${mailList}" var="mail">
						<tr class="tr_body">
							<td>
								<input type="checkbox" name="taskNo" value="<c:out value='${mail.taskNo}'/>" style="border:0">
								<input type="checkbox" name="subTaskNo" value="<c:out value='${mail.subTaskNo}'/>" style="display:">
							</td>
							<td><c:out value='${mail.campNm}'/></td>
							<td>
								<c:set var="strTh" value=""/>
								<c:if test="${'001' eq mail.sendRepeat}"><c:set var="strTh" value="[${mail.subTaskNo}차]"/></c:if>
								<div style="width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<c:out value='${strTh}${mail.taskNm}'/>">
								<a href="javascript:goOz('tab1','<c:url value='/ems/ana/mailSummP.ums'/>','<c:out value='${mail.taskNo}'/>','<c:out value='${mail.subTaskNo}'/>')"><c:out value='${strTh}${mail.taskNm}'/></a>
								</div>
							</td>
							<td><c:out value='${mail.sendRepeatNm}'/></td>
							<td><c:out value='${mail.segNm}'/></td>
							<td><c:out value='${mail.userNm}'/></td>
							<td>
								<fmt:parseDate var="sendDt" value="${mail.sendDt}" pattern="yyyyMMddHHmm"/>
								<fmt:formatDate var="mailSendDt" value="${sendDt}" pattern="yyyy-MM-dd HH:mm"/>
								<c:out value='${mailSendDt}'/>
							</td>
							<td><c:out value='${mail.statusNm}'/></td>
						</tr>
					</c:forEach>
				</c:if>
				<c:set var="emptyCnt" value="${searchVO.rows - fn:length(mailList)}"/>
				<c:if test="${emptyCnt > 0}">
					<c:forEach var="i" begin="1" end="${emptyCnt}">
						<tr class="tr_body">
							<td>&nbsp;</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</c:forEach>
				</c:if>
			</table>
			</form>
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" height=25>${pageUtil.pageHtml}</td>
			</tr>
			</table>
			<!------------------------------------------	LIST	END		---------------------------------------------->
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=30>
						<input type="button" value="<spring:message code='ANABTN002'/>" class="btn_typeC" onClick="goJoin()"><!-- 병합분석 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	OZREPORT	START		-------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="tab">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="90">
										<div id="click_tab1" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN003'/></td><!-- 결과요약 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab1" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab1','<c:url value='/ems/ana/mailSummP.ums'/>')"><spring:message code='ANABTN003'/></a><!-- 결과요약 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab2" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN004'/></td><!-- 세부에러 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab2" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab2','<c:url value='/ems/ana/mailErrorP.ums'/>')"><spring:message code='ANABTN004'/></a><!-- 세부에러 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab3" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN005'/></td><!-- 도메인별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab3" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab3','<c:url value='/ems/ana/mailDomainP.ums'/>')"><spring:message code='ANABTN005'/></a><!-- 도메인별 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab4" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN006'/></td><!-- 발송시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab4" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab4','<c:url value='/ems/ana/mailSendP.ums'/>')"><spring:message code='ANABTN006'/></a><!-- 발송시간별 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab5" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN007'/></td><!-- 응답시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab5" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab5','<c:url value='/ems/ana/mailRespP.ums'/>')"><spring:message code='ANABTN007'/></a><!-- 응답시간별 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="90">
										<div id="click_tab6" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN015'/></td><!-- 고객별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab6" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center">
														<a href="javascript:goOzTab('tab6','<c:url value='/ems/ana/logListP.ums'/>')"><spring:message code='ANABTN015'/></a><!-- 고객별 -->
													</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td align="right">&nbsp;
										<c:if test="${'Y' eq WIZ_USE_YN && 'Y' eq WIZ_DISPLAY_YN}">
											<a href="javascript:reportScript(ifrm_report.report_form,'print')"><spring:message code='ANAJSALT003'/></a><!-- 출력 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><spring:message code='ANAJSALT004'/></a><!-- 저장 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><spring:message code='ANAJSALT005'/></a><!-- 이전페이지 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><spring:message code='ANAJSALT006'/></a><!-- 다음페이지 -->
										</c:if>
									</td>
								</tr>
							</table>
						</div>
						<div id="notab" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">&nbsp;
										<c:if test="${'Y' eq WIZ_USE_YN && 'Y' eq WIZ_DISPLAY_YN}">
											<a href="javascript:reportScript(ifrm_report.report_form,'print')"><spring:message code='ANAJSALT003'/></a><!-- 출력 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><spring:message code='ANAJSALT004'/></a><!-- 저장 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><spring:message code='ANAJSALT005'/></a><!-- 이전페이지 -->
											<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><spring:message code='ANAJSALT006'/></a><!-- 다음페이지 -->
										</c:if>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td height=5></td>
				</tr>
				<tr>
					<td>
						<div id="custMenu" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="click_age" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">AGE</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="age" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('01')" class="tab" title='age'>AGE</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_wedding" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">WEDDING</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="wedding" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('02')" class="tab" title='wedding'>WEDDING</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_gender" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">GENDER</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="gender" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('03')" class="tab" title='gender'>GENDER</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_zip" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">ZIP</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="zip" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('04')" class="tab" title='zip'>ZIP</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_job" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">JOB</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="job" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('05')" class="tab" title='job'>JOB</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_regyr" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">REGYR</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="regyr" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('06')" class="tab" title='registration year'>REGYR</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_regst" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">REGST</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="regst" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('07')" class="tab" title='first registration site'>REGST</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_phmk" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">PHMK</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="phmk" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('08')" class="tab" title='phone maker'>PHMK</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_cyonphmd" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">CYONPHMD</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="cyonphmd" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('09')" class="tab" title='cyon phone model'>CYONPHMD</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_wowphmd" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">WOWPHMD</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="wowphmd" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('10')" class="tab" title='wowlg phone model'>WOWPHMD</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_telcom" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">TELCOM</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="telcom" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('11')" class="tab" title='telecom'>TELCOM</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_bizty" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">BIZTY</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="bizty" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('12')" class="tab" title='business type'>BIZTY</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td>
										<div id="click_mlvl" style="display=none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab">MLVL</td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="mlvl" style="display=">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzCustTab('13')" class="tab" title='member level'>MLVL</a></td>
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!-- <div id="divReportView" style="width:100%;height:1000px;overflow:auto;"></div> -->
						<iframe name="iFrmReport" border='0' frameborder='1' scrolling='no' width='100%' height='1070'></iframe>
					</td>
				</tr>
			</table>
			<!------------------------------------------	OZREPORT	END		------------------------------------------>
			<!------------------------------------------------------------------------------------------------------------>

			<form name="formReport">
			<input type="hidden" id="saveNm" name="saveNm" value="">
			</form>
			
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
