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
			<p class="title_default"><spring:message code='TMPTBLTL001'/></p><!-- 템플릿 -->
			<!------------------------------------------	TITLE	END		---------------------------------------------->

			<!------------------------------------------	SEARCH	START	---------------------------------------------->
			<div class="cWrap">
				<form id="searchForm" name="searchForm" method="post">
				<input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>">
				<table border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
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
								<select id="searchDeptNo" name="searchDeptNo" class="wBig" onchange="getUserList('searchForm',this.value,'form');">
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
										<option value="<c:out value='${user.cd}'/>"<c:if test="${user.cd eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
							<input type="button" value="<spring:message code='COMBTN002'/>" class="btn_style" onClick="goSearch()"><!-- 검색 -->
							<input type="button" value="<spring:message code='COMBTN003'/>" class="btn_style" onClick="goReset(this.form)"><!-- 초기화 -->
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
				<table class="table_line_outline">
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
							<tr class="tr_body">
								<td><a href="javascript:goSelect('<c:out value='${template.tempNo}'/>')"><c:out value='${template.tempNm}'/></a></td>
								<td><c:out value="${template.statusNm}"/></td>
								<td><c:out value="${template.deptNm}"/></td>
								<td><c:out value="${template.userNm}"/></td>
								<td><c:out value="${template.regNm}"/></td>
								<td><c:out value="${template.regDt}"/></td>
							</tr>
						</c:forEach>
					</c:if>
				</table>
				</form>
				<div class="center">${pageUtil.pageHtml}</div>
				<!------------------------------------------	LIST	END		---------------------------------------------->

				<!------------------------------------------	CRUD	START	---------------------------------------------->
				<form id="templateInfoForm" name="templateInfoForm">
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
							<select name="p_status" style="width:200" >
								<option value=''>:: <spring:message code='COMTBLLB003'/> ::</option><!-- 상태 선택 -->
								<c:if test="${fn:length(statusList) > 0}">
									<c:forEach items="${statusList}" var="status">
										<option value="<c:out value='${status.cd}'/>"><c:out value='${status.cd}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td class="td_title"><spring:message code='COMTBLTL001'/></td><!-- 사용자그룹 -->
						<td class="td_body" colspan="1">
							<c:if test="${'Y' eq NEO_ADMIN_YN}">
								<select id="deptNo" name="deptNo" style="width:95%;" onchange="getUserList('templateInfoForm',this.value,'userId');">
									<option value=''>:::: <spring:message code='COMTBLLB004'/> ::::</option><!-- 그룹 선택 -->
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
										<option value="<c:out value='${user.cd}'/>"><c:out value='${user.cdNm}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr id="tr_detail" style="display:none;">
						<td class="td_title"><spring:message code='TMPTBLTL004'/></td><!-- 파일위치 -->
						<td class="td_body">
							<input type="text" id="flPath" name="flPath" style="width:95%;" readonly>
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
							<!--
							<script>
							editor("<c:out value='${TAGFREE_CLASSID}'/>", "<c:out value='${TAGFREE_CODEBASE}'/>", "<c:out value='${NEO_UILANG}'/>", "<c:out value='${MP_FULL_URL}'/>");
							</script>
							-->
							<textarea name="ir1" id="ir1" rows="10" cols="100" style="text-align: center; width: 1007px; height: 412px; display: none; border: none;" ></textarea>
						</td>
					</tr>
				</table>
				<!------------------------------------------	WEBEDITOR	END		------------------------------------------>
				
				<div class="btn">
					<div class="btnR">
						<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goAdd()" id="btn_add"><!-- 등록 -->
						<input type="button" value="<spring:message code='COMBTN007'/>" class="btn_typeG" onClick="goUpdate()" id="btn_update" style="display:none"><!-- 수정 -->
						<input type="button" value="<spring:message code='COMBTN009'/>" class="btn_typeG" onClick="goReset(document.crud_form)"><!-- 재입력 -->
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
			var sHTML = "<img src='/img/upload/"+obj+"'>";
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

			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
