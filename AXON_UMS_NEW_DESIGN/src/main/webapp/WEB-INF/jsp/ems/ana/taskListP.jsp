<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 통계분석 정기메일분석 화면
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

//검색 버튼 클릭시
function goSearch() {
	if( $("#searchStartDt").val() > $("#searchEndDt").val() ) {
		alert("<spring:message code='COMJSALT017'/>");		//검색 시 시작일은 종료일보다 클 수 없습니다.
		return;
	}
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/ana/taskListP.ums'/>").submit();
}

// 초기화 버튼 클릭시
function goReset(obj) {
	$("#searchTaskNm").val("");
	$("#searchCampNo").val("0");
	$("#searchDeptNo").val("0");
	$("#searchUserId").val("");
	//$("#searchForm")[0].reset();
}

//목록에서 전체선택 클릭시
function goAll() {
	$("#listForm input[name='taskNos']").each(function(idx,item){
		$(item).prop("checked", $("#listForm input[name='isAll']").is(":checked"));
	});
}

//탭 관련 변수
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

	iFrmReport.location.href = target + "?taskNo=" + curTaskNo;
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
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><p class="title_default"><spring:message code='ANATBLTL002'/></p></td><!-- 정기메일분석 -->
				</tr>
				<tr>
					<td height="3"></td>
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
						<input type="text" style="border:1px solid #c0c0c0;" id="searchTaskNm" name="searchTaskNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchTaskNm}'/>">
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
					<td width="10%" class="td_title"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
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
							<select id="searchDeptNo" name="searchDeptNo" style="width: 140px;" class="select" onchange="javascript:getUserList(this.value);">
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
						<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset()"><!-- 초기화 -->
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			<!------------------------------------------	SEARCH	END		---------------------------------------------->
			
			
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" height=5></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	LIST	START	---------------------------------------------->
			<form id="listForm" name="listForm" method="post">
			<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
				<tr class="tr_head">
					<td width="3%"><input type="checkbox" name="isAll" onclick='goAll()' style="border:0"></td>
					<td width="10%"><spring:message code='ANATBLTL008'/></td><!-- 캠페인명 -->
					<td width="23%"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="24%"><spring:message code='ANATBLTL010'/></td><!-- 발송그룹명 -->
					<td width="10%"><spring:message code='COMTBLTL003'/></td><!-- 등록자 -->
					<td width="10%"><spring:message code='COMTBLTL002'/></td><!-- 등록일 -->
					<td width="10%"><spring:message code='ANATBLTL011'/></td><!-- 발송상태 -->
					<td width="10%"><spring:message code='ANATBLTL001'/></td><!-- 메일별분석 -->
				</tr>
				<c:if test="${fn:length(taskList) > 0}">
					<c:forEach items="${taskList}" var="mail">
						<tr class="tr_body">
							<td height="30"><input type="checkbox" name="taskNos" value="<c:out value='${mail.taskNo}'/>"></td>
							<td><c:out value='${mail.campNm}'/></td>
							<td><a href="javascript:goOz('tab1','<c:url value='/ems/ana/taskSummP.ums'/>','<c:out value='${mail.taskNo}'/>')"><c:out value='${mail.taskNm}'/></a></td>
							<td><c:out value='${mail.segNm}'/></td>
							<td><c:out value='${mail.userNm}'/></td>
							<td>
								<fmt:parseDate var="regDt" value="${mail.regDt}" pattern="yyyyMMddHHmmss"/>
								<fmt:formatDate var="mailRegDt" value="${regDt}" pattern="yyyy-MM-dd"/>
								<c:out value='${mailRegDt}'/>
							</td>
							<td><c:out value='${mail.statusNm}'/></td>
							<td><input type="button" value="<spring:message code='ANATBLTL001'/>" class="btn_style" onClick="goMail('<c:out value='${mail.taskNo}'/>')"></td><!-- 메일별분석 -->
						</tr>
					</c:forEach>
				</c:if>
				<c:set var="emptyCnt" value="${searchVO.rows - fn:length(taskList)}"/>
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
					<td height=10></td>
				</tr>
				<tr>
					<td height=30>
						<input type="button" value="<spring:message code='ANABTN002'/>" class="btn_typeC" onClick="goJoin()"><!-- 병합분석 -->
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
			</table>
			
			
			<!------------------------------------------	OZREPORT	START		-------------------------------------->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="tab">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100">
										<div id="click_tab1" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr height="23">
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN003'/></td><!-- 결과요약 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab1" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr height="23">
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab1','/ems/ana/taskSummP.ums')"><spring:message code='ANABTN003'/></a><!-- 결과요약 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab2" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN004'/></td><!-- 세부에러 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab2" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab2','/ems/ana/taskErrorP.ums')"><spring:message code='ANABTN004'/></a><!-- 세부에러 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab3" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN005'/></td><!-- 도메인별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab3" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab3','/ems/ana/taskDomainP.ums')"><spring:message code='ANABTN005'/></a><!-- 도메인별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab4" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN006'/></td><!-- 발송시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab4" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab4','/ems/ana/taskSendP.ums')"><spring:message code='ANABTN006'/></a><!-- 발송시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td width="1"></td>
									<td width="100">
										<div id="click_tab5" style="display : none">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center" class="tab"><spring:message code='ANABTN007'/></td><!-- 응답시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
										<div id="tab5" style="display:">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6"></td>
													<td width="110" align="center"><a href="javascript:goOzTab('tab5','/ems/ana/taskRespP.ums')"><spring:message code='ANABTN007'/></a><!-- 응답시간별 -->
													<td width="6"></td>
												</tr>
											</table>
										</div>
									</td>
									<td align="right">&nbsp;</td>
								</tr>
							</table>
						</div>
						<div id="notab" style="display:none">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">&nbsp;
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
						<iframe name="iFrmReport" border='0' frameborder='1' scrolling='no' width='100%' height='1100'></iframe>
					</td>
				</tr>
			</table>
			<!------------------------------------------	OZREPORT	END		------------------------------------------>





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
