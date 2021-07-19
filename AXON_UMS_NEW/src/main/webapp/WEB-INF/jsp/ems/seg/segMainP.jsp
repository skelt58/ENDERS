<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.16
	*	설명 : 발송 대상자관리 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

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

function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#searchForm select[name='searchUserId']").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#searchForm select[name='searchUserId']").append(option);
		});
	});
}

function goSearch() {
	$("#searchForm input[name='page']").val("1");
	$("#searchForm").submit();
}

function goAddf() {
	
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
			<p class="title_default"><spring:message code="SEGTBLTL001"/></p><!-- 발송대상그룹 -->
			<br/>
			
			<!-- 검색 Start -->
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" name="page" value="${searchVO.page}"/>
			<table border="1" cellspacing="0" style="width:900px;">
				<colgroup>
					<col style="width:15%">
					<col style="width:35%">
					<col style="width:15%">
					<col style="width:35%">
				</colgroup>
				<tr>
					<!-- 발송대상그룹명 -->
					<td class="td_title"><spring:message code="SEGTBLTL002"/></td><!-- 발송대상그룹명 -->
					<td class="td_body"><input type="text" name="searchSegNm" value="${searchVO.searchSegNm}" class="wBig"></td>
					<!-- 발송대상그룹유형 -->
					<td class="td_title"><spring:message code="SEGTBLTL003"/></td><!-- 유형 -->
					<td class="td_body">
						<select name="searchCreateTy" class="wBig">
							<option value='' selected>::::<spring:message code="SEGTBLLB001"/>::::</option><!-- 유형 선택 -->
							<c:if test="${fn:length(createTyList) > 0}">
								<c:forEach items="${createTyList}" var="createTy">
									<option value="<c:out value='${createTy.cd}'/>"<c:if test="${createTy.cd eq searchVO.searchCreateTy}"> selected</c:if>><c:out value='${createTy.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>	
					<td class="td_title"><spring:message code="COMTBLTL001"/></td><!-- 상태 -->
					<td class="td_body"><select name="searchStatus" class="wBig">
							<option value='ALL' selected>::::<spring:message code="COMTBLLB003"/>::::</option><!-- 상태 선택 -->
							<c:if test="${fn:length(statusList) > 0}">
								<c:forEach items="${statusList}" var="status">
									<option value="<c:out value='${status.cd}'/>"<c:if test="${status.cd eq searchVO.searchStatus}"> selected</c:if>><c:out value='${status.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<td class="td_title"><spring:message code="COMTBLTL002"/></td><!-- 등록일 -->
					<td class="td_body">
						<fmt:parseDate var="startDt" value="${searchVO.searchStartDt}" pattern="yyyyMMddHHmmss"/>
						<fmt:formatDate var="searchStartDt" value="${startDt}" pattern="yyyy-MM-dd"/> 
						<input type="text" id="searchStartDt" name="searchStartDt" value="<c:out value='${searchStartDt}'/>" style="width:100px" readonly> ~ 
						<fmt:parseDate var="endDt" value="${searchVO.searchEndDt}" pattern="yyyyMMddHHmmss"/>
						<fmt:formatDate var="searchEndDt" value="${endDt}" pattern="yyyy-MM-dd"/> 
						<input type="text" id="searchEndDt" name="searchEndDt" value="<c:out value='${searchEndDt}'/>" style="width:100px" readonly>
					</td>
					</tr>
					<tr>
					<td class="td_title"><spring:message code="COMTBLTL004"/></td><!-- 사용자그룹 -->
					<td class="td_body">
						<!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
						<c:if test="${not empty deptList}">
							<c:if test="${NEO_ADMIN_YN eq 'Y'}">
								<select name="searchDeptNo" class="wBig" onchange="javascript:getUserList(this.value);">
									<option value='0'>::::<spring:message code="COMTBLLB004"/>::::</option><!-- 그룹 선택 -->
									<c:forEach items="${deptList}" var="dept">
										<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${dept.deptNo == searchVO.searchDeptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
									</c:forEach>
								</select>
							</c:if>
							<c:if test="${NEO_ADMIN_YN eq 'N'}">
								<select name="searchDeptNo" class="wBig">
									<c:forEach items="${deptList}" var="dept">
										<c:if test="${dept.deptNo eq NEO_DEPT_NO}">
											<option value="<c:out value='${dept.deptNo}'/>" selected><c:out value='${dept.deptNm}'/></option>
										</c:if>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
					</td>

					<td class="td_title"><spring:message code="COMTBLTL005"/></td><!-- 사용자 -->
					<td class="td_body">
						<select name="searchUserId" class="wMiddle">
							<option value=''>::::<spring:message code="COMTBLLB005"/>::::</option><!-- 사용자 선택 -->
							<c:if test="${fn:length(userList) > 0}">
								<c:forEach items="${userList}" var="user">
									<option value="<c:out value='${user.cd}'/>"<c:if test="${user.cd eq searchVO.searchUserId}"> selected</c:if>><c:out value='${user.cdNm}'/></option>
								</c:forEach>
							</c:if>
						</select> 
						<div style="float:right;">
						<input type="button" value="<spring:message code="COMBTN002"/>" class="btn_style" onClick="goSearch()"><!-- 검색 -->
						<input type="button" value="<spring:message code="COMBTN003"/>" class="btn_style" onClick="goInit()"><!-- 초기화 -->
						</div>	
					</td>
				</tr>
			</table>
			</form>
			<!-- 검색 End -->
			
			
			<br/>
			<br/>
			<br/>
			
			
			<!-- 목록 Start -->
		    <form name="segform">
		    <table  border="1" cellspacing="0" style="width:900px;">
			    <tr class="tr_head"  align="center">
			        <td>
			        	<c:if test="${fn:length(segmentList) > 0}">
			        		<input type="checkbox" name="isAll" onclick='goAll()'>
			        	</c:if>
			        </td>
			        <td><spring:message code="SEGTBLTL002"/></td><!-- 발송대상그룹명 -->
			        <td><spring:message code="SEGTBLTL004"/></td><!-- 질의문 -->
			        <td><spring:message code="SEGTBLTL003"/></td><!-- 유형 -->
			        <td><spring:message code="COMTBLTL005"/></td><!-- 사용자 -->
			        <td><spring:message code="SEGTBLTL006"/></td><!-- 테스트결과 -->
			        <td><spring:message code="COMTBLTL001"/></td><!-- 상태 -->
			    </tr>
			    <c:if test="${fn:length(segmentList) > 0}">
			    	<c:forEach items="${segmentList}" var="segment">
				    <tr>
				    	<td align="center">
					    	<c:choose>
					    		<c:when test="${segment.status eq '002'}">
					    			<input type="checkbox" name="segNoDelete" value="<c:out value='${segment.segNo}'/>" onclick="goDeleteClick();"/>
					    		</c:when>
					    		<c:otherwise>
					    			<input type="checkbox" name="segNo" value="<c:out value='${segment.segNo}'/>"/>
					    		</c:otherwise>
					    	</c:choose>
					    	<input type="hidden" name="createTy" value="<c:out value='${segment.createTy}'/>"/>
				    	</td>
				    	<td>
				    		<a href="#" onclick="goUpdatef('<c:out value='${segment.segNo}'/>','<c:out value='${segment.createTy}'/>','<c:out value='${segment.segFlPath}'/>')"><c:out value="${segment.segNm}"/></a>
				    	</td>
				    	<td>
		    				<div style="width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
				    		<c:choose>
				    			<c:when test="${segment.createTy eq '003'}">
				    				<a href="#" onclick="goSegInfo('<c:out value='${segment.segNo}'/>')" title="<c:out value='${segment.segFlPath}'/>">
		                			<c:out value='${segment.segFlPath}'/>
		            				</a>
				    			</c:when>
				    			<c:when test="${segment.createTy eq '002'}">
				    				<a href="#" onclick="goSegInfo('<c:out value='${segment.segNo}'/>')" title="<c:out value='${segment.query}'/>"><c:out value='${segment.query}'/></a>
				    			</c:when>
				    			<c:otherwise>
				    				<c:set var="query" value="SELECT ${segment.selectSql}"/>
				    				<c:set var="query" value="${query} FROM ${segment.fromSql}"/>
				    				<c:set var="query" value="${query} WHERE ${segment.whereSql}"/>
				    				<c:set var="query" value="${query} ORDER BY ${segment.orderbySql}"/>
				    				<a href="#" onclick="goSegInfo('<c:out value='${segment.segNo}'/>')" title="<c:out value='${query}'/>"><c:out value='${segment.query}'/></a>
				    			</c:otherwise>
				    		</c:choose>
				    		</div>
						</td>
						<td align="center"><c:out value='${segment.createTyNm}'/></td>
						<td align="center"><c:out value='${segment.userId}'/></td>
						<td align="center"><c:out value="${segment.totCnt}"/></td>
						<td align="center"><c:out value='${segment.statusNm}'/></td>
					</tr>

			    	
			    	</c:forEach>
			    </c:if>

		    </table>
		    <div class="center">페이징</div>
		    <div class="btnR">
		    	<input type="button" class="btn_typeC" value="<spring:message code="COMBTN005"/>" onClick="goAddf()"><!-- 등록 -->
		        <input type="button" class="btn_typeG" value="<spring:message code="COMBTN006"/>" onClick="goDisable()"><!-- 사용중지 -->
		        <input type="button" class="btn_typeG" value="<spring:message code="COMBTN008"/>" onClick="goDelete()"><!-- 수정 -->
		    </div>
		    </form>

			<!-- 목록 Start -->
			
			
			
			
			<!-- 메인 컨텐츠 End -->
			
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>
</html>
