<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
.tArea { width:700px;height:50px; }
</style>

<div class="ex-layout">
	<div class="gnb">
		<!-- 상단메뉴화면 -->
		<%@ include file="/WEB-INF/jsp/inc/menu.jsp" %>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		
			<!-- 메인 컨텐츠 Start -->
			
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" name="searchSegNm" value="<c:out value='${searchVO.searchSegNm}'/>">
			<input type="hidden" name="searchDeptNo" value="<c:out value='${searchVO.searchDeptNo}'/>">
			<input type="hidden" name="searchUserId" value="<c:out value='${searchVO.searchUserId}'/>">
			<input type="hidden" name="searchCreateTy" value="<c:out value='${searchVO.searchCreateTy}'/>">
			<input type="hidden" name="searchStatus" value="<c:out value='${searchVO.searchStatus}'/>">
			<input type="hidden" name="searchStartDt" value="<c:out value='${searchVO.searchStartDt}'/>">
			<input type="hidden" name="searchEndDt" value="<c:out value='${searchVO.searchEndDt}'/>">
			<input type="hidden" name="dbConnNo" value="<c:out value='${searchVO.dbConnNo}'/>">
			</form>
			<form id="segInfoForm" name="segInfoForm">
			<input type="hidden" id="segNo"    name="segNo"    value="<c:out value='${segmentInfo.segNo}'/>">
			<input type="hidden" id="dbConnNo" name="dbConnNo" value="<c:out value='${segmentInfo.dbConnNo}'/>">
			<input type="hidden" id="status"   name="status"   value="<c:out value='${segmentInfo.status}'/>">
			<input type="hidden" id="mergeKey" name="mergeKey" value="<c:out value='${segmentInfo.mergeKey}'/>">
			<input type="hidden" id="mergeCol" name="mergeCol" value="<c:out value='${segmentInfo.mergeCol}'/>">
			<input type="hidden" id="createTy" name="createTy" value="<c:out value='${segmentInfo.createTy}'/>">
			<input type="hidden" id="testType" name="testType">
			
			<p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
			
			<div class="cWrap">
			<div id="divMenu1">
				<table class="nTab">
					<tr>
						<td align="center" id="td_tab1" ><spring:message code='SEGBTN001'/></td><!-- 추출도구이용 -->
						<td align="center" id="td_tab2" class='on'><spring:message code='SEGBTN003'/></td><!-- 직접 SQL 이용 -->
						<td align="center" id="td_tab3"><spring:message code='SEGBTN004'/></td><!-- 파일연동 -->
						<td align="center" id="td_tab4"><spring:message code='SEGBTN005'/></td><!-- 연계서비스지정 -->
					</tr>
				</table>
			</div>
			<div class="nTwrap">
				<table border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<colgroup>
						<col style="width:15%;" />
						<col style="width:35%;" />
						<col style="width:15%;" />
						<col style="width:35%;" />
					</colgroup>
					<!-- DB Connection -->
					<tr>
						<td class="td_title" width="100" align=right>Connection&nbsp;</td>
						<td class="td_body" width="300">
							<c:set var="dbConnNm" value=""/>
							<c:if test="${fn:length(dbConnList) > 0}">
								<c:forEach items="${dbConnList}" var="dbConn">
									<c:if test="${segmentInfo.dbConnNo == dbConn.dbConnNo}">
										<c:set var="dbConnNm" value="${dbConn.dbConnNm}"/>
									</c:if>
								</c:forEach>
							</c:if>
							<c:out value="${dbConnNm}"/>
			
						</td>
						<td class="td_title" width="100" align=right><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
						<td class="td_body" width="300">
							<input type="text" id="segNm" name="segNm" value="<c:out value='${segmentInfo.segNm}'/>">
						</td>
					</tr>
					<c:if test="${'Y' eq NEO_ADMIN_YN}">
						<tr>
							<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
							<td class="td_body">
								<select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
									<option value='0'>::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
									<c:if test="${fn:length(deptList) > 0}">
										<c:forEach items="${deptList}" var="dept">
											<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${segmentInfo.deptNo == dept.deptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자 -->
							<td class="td_body">
								<select id="userId" name="userId">
									<option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
										<c:if test="${fn:length(userList) > 0}"></c:if>
											<c:forEach items="${userList}" var="user">
												<option value="<c:out value='${user.cd}'/>"<c:if test="${segmentInfo.userId eq user.cd}"> selected</c:if>><c:out value='${user.cdNm}'/></option>
											</c:forEach>
								</select>
							</td>
						</tr>
					</c:if>
					<!-- DB Connection -->
					<tr align="center">
						<td colspan="4" class="inTable">
						
			                <!-- 연결된 테이블/컬럼 설정 -->
			                <div id="divMetaTableInfo" style="width:985px;height:250px;overflow:auto;"></div>
			                <!-- 연결된 테이블/컬럼 설정 -->			                
							
						</td>
					</tr>
				</table>
			
				<table width="800" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div id="divConditional"></div>
						</td>
					</tr>
				</table>
				<!-- 조건 선택 -->
			
				<!-- 커리문 -->
				<table width="800" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
								<tr>
									<td class="td_title" width="150">Select</td>
									<td class="td_body">
										<div id='divSelect'><textarea id="query" name="query" style="width:870;height:200;"><c:out value="${segmentInfo.query}"/></textarea></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				
				<!-- 커리문 -->
				<div class="btn">
					<div class="left">
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
						<input type="text" id="totCnt" name="totCnt" value="<c:out value='${segmentInfo.totCnt}'/>" size="9" readonly>
					</div>
					<div class="right">
						<input type="button" class="btn_typeC" value="QUERY TEST" onClick="goQueryTest('000')">
						<c:if test="${'002' eq segmentInfo.stauts}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goQueryTest('003')"><!-- 수정 -->
						</c:if>
						<c:if test="${'001' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN013'/>" onClick="goEnable()"><!-- 복구 -->
						</c:if>
						<c:if test="${'000' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN006'/>" onClick="goDisable()"><!-- 사용중지 -->
						</c:if>
						
						<c:if test="${'002' ne segmentInfo.status}">
						<input type="button" class="btn_style" value="<spring:message code='COMBTN008'/>" onClick="goDelete()"><!-- 삭제 -->
						</c:if>
			
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN007'/>" onClick="goQueryTest('002')"><!-- 대상자보기 -->
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
					</div>
				</div>
			
			</div>
			</div>
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
