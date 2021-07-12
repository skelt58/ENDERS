<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	// 조회기간 시작일 설정
	$("#searchLgnStdDt").datepicker({
		//showOn:"button",
		//buttonImage: contextPath + "/images/ico_datepicker.gif",
		//buttonImageOnly:true,
		minDate:"2020-01-01",
		maxDate:$("#searchLgnEndDt").val(),
		onClose:function(selectedDate) {
			$("#searchLgnEndDt").datepicker("option", "minDate", selectedDate);
		}
	});
	
	// 조회기간 종료일 설정
	$("#searchLgnEndDt").datepicker({
		//showOn:"button",
		//buttonImage: contextPath + "/images/ico_datepicker.gif",
		//buttonImageOnly:true,
		minDate:$("#searchLgnStdDt").val(),
		onClose:function(selectedDate) {
			$("#searchLgnStdDt").datepicker("option", "maxDate", selectedDate);
		}
	});
	
	$("#btnSearch").click(function(e){
		e.preventDefault();
		showLoginHistGrid();
	});
	$("#btnClear").click(function(e){
		e.preventDefault();
		$("#searchForm")[0].reset();
	});
	
	// 로그인 이력 목록 jqGrid 조회
	showLoginHistGrid();
});

// 로그인 이력 목록 jqGrid 조회
function showLoginHistGrid() {
	// 부서 목록 초기화
	$("#loginHistList").jqGrid("GridUnload");
	
	// Grid 데이터 조회 및 설정
	var param = $("#searchForm").serialize();
	$("#loginHistList").jqGrid({
		url          :"<c:url value='/ems/sys/lgnhstList.json'/>?" + param,
		mtype        :"POST",
		datatype     :"json",
		jsonReader   : {
						page   : "page",
						total  : "total",
						root   : "rows",
						records: "records",
						repeatitems: false,
						id     : "id"
				       },
		height       : "250",
		width        : "900",
		colModel     :[
                        {name:'deptNm'	,index:'deptNm'	,width:200	,align:'center'	,hidden:false	,title:true		,label:'그룹명'},	// 그룹명
                        {name:'userId'	,index:'userId'	,width:200	,align:'center'	,hidden:false	,title:true		,label:'사용자ID '},	// 사용자ID  
                        {name:'lgnDt'	,index:'lgnDt'	,width:300	,align:'center'	,hidden:false	,title:true		,label:'로그인 시간 '},	// 로그인 시간 
                        {name:'lgnIp'	,index:'lgnIp'	,width:200	,align:'center'	,hidden:false	,title:true		,label:'로그인 IP '}	// 로그인 IP 
					  ],
		rowNum       : "10",
		rownumbers	 : false,
		autowidth    : false,
		viewrecords  : true,
		loadonce     : false,
		pager		 : "#pager",
		multiselect  : false,
		cmTemplate	 : { sortable: false },
		autoencode   : true,
		cellEdit     : false
	});
}

function dbConnInfo(cellvalue, options, rowObject) {
	return '<a href="#" onclick="getDbConnInfo(' + options.rowId + '); return false;">' + $.jgrid.htmlEncode(cellvalue) + '</a>';
}

function getDbConnInfo(rowId) {
	var dbConnNo = $("#dbConnList").jqGrid('getRowData',rowId).dbConnNo;
	$("#searchDbConnNo").val(dbConnNo);
	
	$("#page").val($('#dbConnList').getGridParam('page'));
	
	$("#searchForm").attr("action","<c:url value='/ems/sys/dbconnInfoP.ums'/>").submit();
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
			
			<p class="title_default">사용자 로긴 정보</p>
			
			<div class="cWrap">
				<form id="searchForm" name="searchForm">
				<table class="table_line_outline">
					<colgroup>
					    	<col style="width:15%" />
					    	<col style="width:35%" />
					    	<col style="width:15%" />
					    	<col style="width:35%" />
					</colgroup>
					<tr>
						<td class="td_title"><spring:message code='SYSTBLTL018'/></td><!-- 그룹명 -->
						<td class="td_body">
							<input type="text" size="15" maxlength="20" id="searchDeptNm" name="searchDeptNm" class="wBig">
						</td>
						<td class="td_title">
							사용자 ID
						</td>
						<td class="td_body">
							<input type="text" size="15" maxlength="20" id="searchUserId" name="searchUserId" class="wBig">
						</td>
					</tr>
					<tr>	
						<td class="td_title">로긴시간</td>
						<td class="td_body" colspan="3">
							<input type="text" id="searchLgnStdDt" name="searchLgnStdDt" value="<c:out value='${searchLgnStdDt}'/>" readonly>
							&nbsp;&nbsp;~&nbsp;&nbsp;
							<input type="text" id="searchLgnEndDt" name="searchLgnEndDt" value="<c:out value='${searchLgnEndDt}'/>" readonly>
							<input type="button" id="btnSearch" value="<spring:message code='COMBTN002'/>"><!-- 검색 -->
							<input type="button" id="btnClear" value="<spring:message code='COMBTN003'/>"><!-- 초기화 -->
						</td>
					</tr>
				</table>
				</form>
				
				<!-- loginHistList jqGrid Start -->
				<table id="loginHistList" summary="로그인 이력 목록"></table>
				<div id="pager"></div>
				
				<!-- loginHistList jqGrid End -->
				
			
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
