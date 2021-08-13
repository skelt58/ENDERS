<%--
	/**********************************************************
	*	작성자 : 김준희
	*	작성일시 : 2021.08.05
	*	설명 : 코드목록 관리 
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript" src="<c:url value='/js/sys/cod/userCodeListP.js'/>"></script>

<body>
	<div id="wrap">

		<!-- lnb// -->
		<div id="lnb">
			<!-- LEFT MENU -->
			<%@ include file="/WEB-INF/jsp/inc/menu_sys.jsp" %>
			<!-- LEFT MENU -->
		</div>
		<!-- //lnb -->

		<!-- content// -->
		<div id="content">

			<!-- cont-head// -->
			<section class="cont-head">
				<div class="title">
					<h2><c:out value="${NEO_MENU_NM}"/></h2>
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
						<p class="title_default">공통코드 관리</p> 
					</tr>
			        <tr>
			          <td height="3"><img src="/img/com/Content_titlebar.gif" width="1000" height="1"></td>
			        </tr>
					<tr>
						<td height="16"></td>
					</tr>
				</table>
				<!------------------------------------------	TITLE	END		---------------------------------------------->
			
				<!------------------------------------------	SEARCH	START	---------------------------------------------->
				<form id="searchForm" name="searchForm" method="post">
				<%-- <input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>"> --%>
				<input type="hidden" id="page" name="page" value="${searchVO.page}">
				<table width="1000" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
					<tr>
						<td width="10%" class="td_title">분류코드</td>
						<td width="22%" class="td_body">
							<select id="searchCdGrp" name="searchCdGrp" style="width: 140px;" class="select" onchange="searchCdGrpSelect()">
								<option value=''>:: 선택 ::</option>
								<c:if test="${fn:length(cdGrpList) > 0}">
									<c:forEach items="#{cdGrpList}" var="cdGrp">
										<option value="<c:out value='${cdGrp.cd}'/>"<c:if test="${cdGrp.cd eq searchVO.searchCdGrp}"> selected</c:if>><c:out value='${cdGrp.cd}'/></option>
									</c:forEach>
								</c:if>
							</select>
						</td>		
						<td width="10%" class="td_title">분류명</td>
						<td width="22%" class="td_body">
							<input type="text" style="border:1px solid #c0c0c0;" id="searchCdGrpNm" name="searchCdGrpNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchCdGrpNm}'/>">
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
							<input type="button" value="<spring:message code='COMBTN005'/>" class="btn_typeC" onClick="goAdd()"><!-- 등록 -->
							<input type="button" value="재입력" class="btn_typeC" onClick="goAddReset()"><!-- 재입력 -->
							<input type="button" id="btnUpdate" value="<spring:message code='COMBTN007'/>" class="btn_typeC" onClick="goUpdate()"><!-- 수정 -->
							<input type="button" id="btnSelect" value="<spring:message code='COMBTN007'/>" class="btn_typeC" onClick="goSelect()"><!-- 선택 -->							
							<input type="button" id="btnDelete" value="<spring:message code='COMBTN008'/>" class="btn_typeC" onClick="goDelete()"><!-- 삭제 -->
						</td>
					</tr>
					<tr>
						<td height="10"></td>
					</tr>
				</table>
				<!------------------------------------------	SEARCH	END		---------------------------------------------->
				
				<table width="1000" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right" height=5>
						</td>
					</tr>
				</table>
				
				<!------------------------------------------	LIST	START	---------------------------------------------->
				<div id="divUserCodeList"></div>
				<!------------------------------------------	LIST	END		---------------------------------------------->
	
				<!------------------------------------------	CRUD	START	---------------------------------------------->
				<div id="divUserCodeInfo">				
					<form id="userCodeInfoForm" name="userCodeInfoForm">					
					<table class="table_line_outline" border="1" cellspacing="0">					
						<tr>
							<td class="td_title">공통코드</td>
							<td colspan=2 class="td_body">
								<input type="text" id="cd" name="cd" class="input wBig">
							</td>
							<td class="td_title">공통코드명</td>
							<td colspan=2 class="td_body">
								<input type="text" id="cdNm" name="cdNm" class="input wBig">
							</td>
						</tr>
						<tr>
							<td class="td_title">코드분류</td>
							<td class="td_body">
								<select id="cdGrp" name="cdGrp" class="select wBig" onchange="searchUpCdGrpSelect(this.value)">
									<option value=''>:::::::::: 선택 ::::::::::</option><!-- 코드의 분류 선택 -->
									<c:if test="${fn:length(cdGrpList) > 0}">
										<c:forEach items="${cdGrpList}" var="cdGrp">
											<option value="<c:out value='${cdGrp.cd}'/>"><c:out value='${cdGrp.cdNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td class="td_title">상위코드</td>	
							<td class="td_body">
								<select id="upCd" name="upCd" class="select wBig">
									<option value=''>:::::::::: 선택 ::::::::::</option><!-- 코드의 분류의 상위코드분류의 코드 선택 -->
									<c:if test="${fn:length(upCdList) > 0}">
										<c:forEach items="${upCdList}" var="upCd">
											<option value="<c:out value='${upCd.cd}'/>"><c:out value='${upCd.cdNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td> 
						</tr>		
						<tr>
							<td class="td_title">언어권</td>
							<td class="td_body" colspan=2>
								<select id="uiLang" name="ulLang" class="select wBig">
									<option value=''>:::::::::: 선택 ::::::::::</option><!-- 언어권 선택 -->
									<c:if test="${fn:length(uiLangList) > 0}">
										<c:forEach items="${uiLangList}" var="uiLang">
											<option value="<c:out value='${uiLang.cd}'/>"><c:out value='${uiLang.cdNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
 							<td class="td_title">사용여부</td>
							<td colspan=3 class="td_body">
								<select id="useYn" name="useYn" class="select wBig">
									<option value=''>:::::::::: 선택 ::::::::::</option><!-- 사용여부 선택 -->
									<option value="Y">예</option>
									<option value="N">아니오</option>
								</select>		
							</td>
						</tr>											
						<tr>
							<td class="td_title">설명</td>
							<td colspan=4 class="td_body">
								<input type="text" id="cdDtl" name="cdDtl" class="input wBig">
							</td>
						</tr> 
					</table>
					</form>
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
