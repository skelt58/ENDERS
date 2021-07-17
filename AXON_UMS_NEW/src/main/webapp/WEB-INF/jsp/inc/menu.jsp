<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 상단 메뉴 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	goMenu(<c:out value="${topMenuId}"/>);
});

function goMenu(pgmId) {
	var topMenuExec = $("#topMenuExec")[0];
	$(topMenuExec.topMenuId).val(pgmId);
	
	
	// 발송대상자관리  
	if(pgmId == 1) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='#' onclick=runMenu('<c:url value='/ems/seg/segMainP.ums'/>')>대상자관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ems/seg/segFileAddP.ums'/>'>대상자등록</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 발송
	} else if(pgmId == 2) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/cam/campListP.ums'/>'>캠페인관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/tmp/tempListP.ums'/>'>템플릿관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/cam/mailMainP.ums'/>'>메일관리</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 통계/분석
	} else if(pgmId == 3) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ana/mailListP.ums'/>'>메일별분석</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ana/taskListP.ums'/>'>정기메일분석</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ana/campListP.ums'/>'>캠페인별분석</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ana/summMainP.ums'/>'>누적분석</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/ana/pushStatsMainP.ums'/>'>PUSH분석</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 월간일정
	} else if(pgmId == 4) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/sch/scheMonthP.um'/>'>월간일정</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='<c:url value='/sch/scheWeekP.ums'/>'>주간일정</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 시스템관리
	} else if(pgmId == 5) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='#' onclick=runMenu('<c:url value="/ems/sys/deptMainP.ums"/>')>부서/사용자관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='#' onclick=runMenu('<c:url value="/ems/sys/dbconnMainP.ums"/>')>데이터베이스 연결 관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='#' onclick=runMenu('<c:url value="/ems/sys/lgnhstListP.ums"/>')>사용자 로그인 관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='#' onclick=runMenu('<c:url value="/ems/sys/usercodeMainP.ums"/>')>캠페인목적관리</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
	}
}

function runMenu(url) {
	$("#topMenuExec").attr("action",url).submit();
}

function goLogout() {
	if(confirm("로그아웃하시겠습니까?")) {
		document.location.href = "<c:url value='/lgn/logout.ums'/>";
	}
}
</script>
<!-- 사용자 프로그램 목록과 프로그램 전체 목록 비교 -->
<c:if test="${fn:length(menuList) > 0}">
   	<c:forEach items="${menuList}" var="menuVO">
   		<c:set var="checkId" value="N"/>
   		<c:if test="${fn:length(USER_PROG_LIST) > 0}">
   			<c:forEach items="${USER_PROG_LIST}" var="progVO">
   				<c:if test="${menuVO.progId eq progVO.progId}">
   					<c:set var="checkId" value="Y"/>
   				</c:if>
   			</c:forEach>
   		</c:if>
   		<c:if test="${checkId eq 'Y'}">
			<span onclick="goMenu(<c:out value='${menuVO.progId}'/>);"><b><c:out value="${menuVO.progNm}"/></b></span>
   		</c:if>
   		<c:if test="${checkId eq 'N'}">
			<span style="color:#aaaaaa;"><c:out value="${menuVO.progNm}"/></span>
   		</c:if>
	</c:forEach>
</c:if>

<span style="margin-left:420px;font-size:9pt;" onclick="goLogout();"><b>로그아웃</b></span>
<form id="topMenuExec" name="topMenuExec" method="post">
<input type="hidden" id="topMenuId" name="topMenuId" value="<c:out value='${topMenuId}'/>"/>
</form>
