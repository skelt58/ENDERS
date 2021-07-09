<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<style>
.ex-layout{
	width: 1200px;
}
.ex-layout .gnb{
	padding: 15px;
	background-color: skyblue;
}
.ex-layout .main{
	background-color: white;
}
.ex-layout .main:after{ clear: both; display: block; content: '' }

.ex-layout .main .lnb{
	float: left;
	width: 200px;
	height: 600px;
	background-color: orange;
	font-size:11pt;
}
.ex-layout .main .content{
	float: left;
	width: 1000px;
}
.ex-layout .footer{
	padding: 15px;
	background-color: #ddd;
}

.ex-layout .gnb span { padding:20px; cursor:pointer; }
</style>

<script type="text/javascript">
$(document).ready(function() {
	goMenu(4);	
});

function goMenu(pgmId) {
	// 발송대상자관리  
	if(pgmId == 1) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/seg/segMainP.jsp' target='mp_body' class='left_menu'>대상자관리</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/seg/segFileAddfP.jsp' target='mp_body' class='left_menu'>대상자등록</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 발송
	} else if(pgmId == 2) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22><a href='/cam/campListP.jsp' target='mp_body' class='left_menu'>캠페인관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='/tmp/tempListP.jsp' target='mp_body' class='left_menu'>템플릿관리</a></td></tr>";
		str += "<tr><td width=158 height=22><a href='/cam/mailMainP.jsp' target='mp_body' class='left_menu'>메일관리</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 통계/분석
	} else if(pgmId == 3) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/ana/mailListP.jsp' target='mp_body' class='left_menu'>메일별분석</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/ana/taskListP.jsp' target='mp_body' class='left_menu'>정기메일분석</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/ana/campListP.jsp' target='mp_body' class='left_menu'>캠페인별분석</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/ana/summMainP.jsp' target='mp_body' class='left_menu'>누적분석</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/ana/pushStatsMainP.jsp' target='mp_body' class='left_menu'>PUSH분석</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 월간일정
	} else if(pgmId == 4) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sch/scheMonthP.jsp' target='mp_body' class='left_menu'>월간일정</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sch/scheWeekP.jsp' target='mp_body' class='left_menu'>주간일정</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	// 시스템관리
	} else if(pgmId == 5) {
		var str = "<table width=158 border=0 cellpadding=0 cellspacing=0>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sys/deptMainP.jsp' target='mp_body' class='left_menu'>부서/사용자관리</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sys/dbconnMainP.jsp' target='mp_body' class='left_menu'>데이터베이스 연결 관리</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sys/lgnhstListP.jsp' target='mp_body' class='left_menu'>사용자 로그인 관리</a></td></tr>";
		str += "<tr><td width=158 height=22 background='/img/men/menuline.gif'><a href='/sys/usercodeMainP.jsp?p_cd_grp=C004' target='mp_body' class='left_menu'>캠페인목적관리</a></td></tr>";
		str += "</table>";
		$("#lnb").html(str);
		
	}
}
</script>

<div class="ex-layout">
	<div class="gnb">
			<c:if test="${fn:length(menuList) > 0}">
		    	<c:forEach items="${menuList}" var="menuVO">
					<span onclick="goMenu(<c:out value='${menuVO.progId}'/>);"><c:out value="${menuVO.progNm}"/></span>
				</c:forEach>
			</c:if>
	</div>
	<div class="main">
		<div id="lnb" class="lnb"></div>
		<div class="content">
		</div>
	</div>
	<div class="footer">
		<%@ include file="/WEB-INF/jsp/inc/footer.jsp" %>
	</div>
</div>

</body>

</html>
