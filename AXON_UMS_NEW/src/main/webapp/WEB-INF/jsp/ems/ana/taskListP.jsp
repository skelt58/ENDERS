<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.02
	*	설명 : 정기메일분석 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

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
			<table width="1000" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
				<tr>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL005'/></td><!-- 메일명 -->
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;"  name="searchTaskNm" class="input" style="width:195;" value="<c:out value='${searchVO.searchTaskNm}'/>">
					</td>
					<td width="10%" class="td_title"><spring:message code='ANATBLTL006'/></td><!-- 캠페인 -->
					<td width="22%" colspan=3 class="td_body">
						<select name="p_camp_no" style="width: 140px;" class="select" value="<%= p_camp_no%>">
							<option value=''>::: <%=tbllb_camp%> :::</option><!--캠페인 선택-->
							<%	while(campDs.next()) {													%>
							<%		if(campDs.getData("CAMP_NO").equals(p_camp_no)) {					%>
							<option value='<%=campDs.getData("CAMP_NO")%>' selected><%=campDs.getData("CAMP_NM")%></option>
							<%		} else {															%>
							<option value='<%=campDs.getData("CAMP_NO")%>'><%=campDs.getData("CAMP_NM")%></option>
							<%		}																	%>
							<%	}																		%>
						</select>
					</td>
				</tr>
				<tr>
					<td width="10%" class="td_title"><%=tbltl_reg_dt%><!--등록일--></td>
					<td width="22%" class="td_body">
						<input type="text" style="border:1px solid #c0c0c0;"  name="p_stdt" class="readonly_style" style="width:70;cursor:hand" value="<%=p_stdt%>" readonly onCLick="show_calendar('search_form', 'p_stdt', event.screenX, event.screenY)">
						&nbsp;&nbsp;~&nbsp;&nbsp;
						<input type="text" style="border:1px solid #c0c0c0;"  name="p_eddt" class="readonly_style" style="width:70;cursor:hand" value="<%=p_eddt%>" readonly onClick="show_calendar('search_form', 'p_eddt', event.screenX, event.screenY)">
					</td>
					<td width="10%" class="td_title"><%=tbltl_dept_no%><!--그룹--></td>
					<td width="22%" class="td_body">
						<%	//관리자의 경우 전체 요청그룹을 전시하고 그 외의 경우에는 해당 그룹만 전시함
						if( util.checkAdmin(request) ) {										%>
						<select name="p_dept_no" style="width: 140px;" class="select" onchange="javascript:getUserList('search_form','p_user_id',this.value,'false');" value="<%= p_dept_no%>">
			<option value=''>:: <%=tbllb_dept_no%> ::</option><!--그룹 선택-->
			<%		while(deptDs.next()) {
			if(deptDs.getData("DEPT_NO").equals(p_dept_no)) {				%>
			<option value='<%=deptDs.getData("DEPT_NO")%>' selected><%=deptDs.getData("DEPT_NM")%></option>
			<%			} else {														%>
			<option value='<%=deptDs.getData("DEPT_NO")%>'><%=deptDs.getData("DEPT_NM")%></option>
			<%			}
			}																	%>
			</select>
			<%	} else {																%>
			<select name="p_dept_no" style="width: 140px;" class="select" value="<%= p_dept_no%>">
			<%		while(deptDs.next()) {
			if(deptDs.getData("DEPT_NO").equals(p_dept_no)) {				%>
			<option value='<%=deptDs.getData("DEPT_NO")%>' selected><%=deptDs.getData("DEPT_NM")%></option>
			<%			}
			}																	%>
			</select>
			<%	}																		%>
			</td>
			<td width="10%" class="td_title"><%=tbltl_user_id%><!--사용자--></td>
			<td width="22%" class="td_body">
			<select name="p_user_id" style="width: 140px;" class="select" value="<%= p_user_id%>">
			<option value=''>:: <%=tbllb_user_id%> ::</option><!--사용자 선택-->
			<%	while(userDs.next()) {													%>
			<%		if(userDs.getData("USER_ID").equals(p_user_id)) {					%>
			<option value='<%=userDs.getData("USER_ID")%>' selected><%=userDs.getData("USER_NM")%></option>
			<%		} else {															%>
			<option value='<%=userDs.getData("USER_ID")%>'><%=userDs.getData("USER_NM")%></option>
			<%		}																	%>
			<%	}																		%>
			</select>
			<%
			if(!(util.getSesValue("NEO_UILANG", request)).equals("001")) {
			out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
			}
			%>

			</td>
			</tr>
			</form>
			<!--검색/초기화 버튼-->
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td height="3"></td>
			</tr>
			<tr>
			<td align="right">
			<input type="button" value="<%=btn_search%>" class="btn_typeC" onClick="goSearch()"><!--검색-->
			<input type="button" value="<%=btn_init%>" class="btn_style" onClick="goReset(this.form)"><!--초기화-->
			</td>
			</tr>
			<tr>
			<td height="10"></td>
			</tr>
			</table>
			</table>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	SEARCH	END		---------------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="right" height=5>
			</td>
			</tr>
			</table>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	LIST	START	---------------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>
			<table width="1000" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
			<form name="list_form">
			<!--<tr>
			<td class="td_line" colspan=9></td>
			</tr>-->
			<tr class="tr_head">
			<!--<td width="50"><a href="javascript:goAll()"><%=tbltl_select%></a></td>--><!--전체선택-->
			<td width="3%"><input type="checkbox" name="isAll" onclick='goAll()' style="border:0"></td>
			<td width="10%"><%=tbltl_camp_nm%><!--캠페인명--></td>
			<!--<td width="140">메일명</td>
			<td width="50">채널</td>-->
			<td width="23%"><%=tbltl_mail_nm%><!--메일명--></td>
			<td width="24%"><%=tbltl_seg_nm%><!--Segment 명--></td>
			<td width="10%"><%=tbltl_reg_id%><!--등록자--></td>
			<td width="10%"><%=tbltl_reg_dt%><!--등록일--></td>
			<td width="10%"><%=tbltl_status%><!--발송상태--></td>
			<td width="10%"><%=tbltl_mail%></td>
			</tr>
			<%	if(ds != null && ds.size() > 0) {
			String task_no = "";
			String subtask_no = "";
			String reg_dt = "";
			String tz_reg_dt = "";
			String interval = (String)util.getSesValue("NEO_TZ_TERM",request);

			while(ds.next()) {
			task_no = ds.getData("TASK_NO");
			subtask_no = ds.getData("SUB_TASK_NO");
			reg_dt = ds.getData("REG_DT");
			if(reg_dt != null && !reg_dt.equals("")) {
			tz_reg_dt = util.getIntervalTime(reg_dt, interval);
			tz_reg_dt = util.getFDate(tz_reg_dt.substring(0,8),Code.DT_FMT2);
			}																%>
			<tr class="tr_body">
			<td><input type="checkbox" name="p_task_no" value="<%=task_no%>" style="border:0"></td>
			<td><%=util.cutStr(ds.getData("CAMP_NM"), 0, 15, "...")%></td>
			<td><a href="javascript:goOz('tab1','/ana/taskSummP.jsp','<%=task_no%>')"><%=util.cutStr(ds.getData("TASK_NM"), 0, 15, "...")%></a></td>
			<!--<td><%=ds.getData("CHANNEL_NM")%></td>-->
			<td><%=util.cutStr(ds.getData("SEG_NM"), 0, 10, "...")%></td>
			<td><%=ds.getData("USER_NM")%></td>
			<td><%=tz_reg_dt%></td>
			<td><%=ds.getData("STATUS_NM")%></td>
			<td><input type="button" value="<%=tbltl_mail%>" class="btn_style" onClick="goMail('<%=task_no%>')"></td>
			</tr>
			<%		}
			for(int i=0; i<util.parseInt(p_pagerow)-ds.size(); i++) {		%>
			<tr class="tr_body">
			<!--<td></td>-->
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			</tr>
			<%		}
			} else {
			for(int i=0; i<util.parseInt(p_pagerow); i++) {								%>
			<tr class="tr_body">
			<!--<td></td>-->
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			</tr>
			<%		}
			}																		%>
			</form>
			</table>
			<%
			if(ds.getTotPage() > 1) {
			%>
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" height=25><%= linkstr%></td>
			</tr>
			</table>
			<%	}	%>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	LIST	END		---------------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td height=10>
			</td>
			</tr>
			<tr>
			<td height=30>
			<input type="button" value="<%=btn_join%>" class="btn_typeC" onClick="goJoin()"><!--병합분석-->
			</td>
			</tr>
			<tr>
			<td height=10>
			</td>
			</tr>
			</table>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	OZREPORT	START		-------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>
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
			<td width="6"><img src="/img/com/Content_tab_after_r.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><%=btn_summ%><!--결과요약--></td>
			<td width="6"><img src="/img/com/Content_tab_back_r.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			<div id="tab1" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr height="23">
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('tab1','/ana/taskSummP.jsp')" class="tab"><%=btn_summ%><!--결과요약--></a></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			<td width="1"></td>
			<td width="100">
			<div id="click_tab2" style="display : none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after_r.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><%=btn_err%><!--세부에러--></td>
			<td width="6"><img src="/img/com/Content_tab_back_r.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			<div id="tab2" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('tab2','/ana/taskErrorP.jsp')" class="tab"><%=btn_err%><!--세부에러--></a></b></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			<td width="1"></td>
			<td width="100">
			<div id="click_tab3" style="display : none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after_r.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><%=btn_domain%><!--도메인별--></td>
			<td width="6"><img src="/img/com/Content_tab_back_r.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			<div id="tab3" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('tab3','/ana/taskDomainP.jsp')" class="tab"><%=btn_domain%><!--도메인별--></a></b></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			<td width="1"></td>
			<td width="100">
			<div id="click_tab4" style="display : none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after_r.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><%=btn_send%><!--발송시간별--></td>
			<td width="6"><img src="/img/com/Content_tab_back_r.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			<div id="tab4" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('tab4','/ana/taskSendP.jsp')" class="tab"><%=btn_send%><!--발송시간별--></a><b></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			<td width="1"></td>
			<td width="100">
			<div id="click_tab5" style="display : none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after_r.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage_r.gif" class="tab"><%=btn_resp%><!--응답시간별--></td>
			<td width="6"><img src="/img/com/Content_tab_back_r.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			<div id="tab5" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('tab5','/ana/taskRespP.jsp')" class="tab"><%=btn_resp%><!--응답시간별--></a><b></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			<!--
			<td width="1"></td>
			<td width="89">
			<div id="click_tab6" style="display=">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="6"><img src="/img/com/Content_tab_after.gif" width="6" height="23"></td>
			<td width="110" align="center" background="/img/com/Content_tab_bgimage.gif"><a href="javascript:goOzTab('/ana/taskSex.jsp')">성·연령별</a></td>
			<td width="6"><img src="/img/com/Content_tab_back.gif" width="6" height="23"></td>
			</tr>
			</table>
			</div>
			</td>
			-->
			<td align="right">&nbsp;
			<%	if(util.getEnv("WIZ_USE_YN").equals("Y") && util.getEnv("WIZ_DISPLAY_YN").equals("Y") ) {	%>
			<a href="javascript:reportScript(ifrm_report.report_form,'print')"><img src="/img/ana/oz_print.jpg" border='0' alt="<%=jsalt_print%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><img src="/img/ana/oz_save.jpg" border='0' alt="<%=jsalt_save%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><img src="/img/ana/oz_prev.jpg" border='0' alt="<%=jsalt_prev%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><img src="/img/ana/oz_next.jpg" border='0' alt="<%=jsalt_next%>" align="absbottom"></a>
			<!--
			<a href="javascript:reportScript(ifrm_report.report_form,'zoomin')"><img src="/img/ana/oz_zoom_in.jpg" border='0' alt="<%=jsalt_in%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'zoomout')"><img src="/img/ana/oz_zoom_out.jpg" border='0' alt="<%=jsalt_out%>" align="absbottom"></a>
			-->
			<%	}	%>
			</td>
			</tr>
			</table>
			</div>
			<div id="notab" style="display:none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="right">&nbsp;
			<%	if(util.getEnv("WIZ_USE_YN").equals("Y") && util.getEnv("WIZ_DISPLAY_YN").equals("Y") ) {	%>
			<a href="javascript:reportScript(ifrm_report.report_form,'print')"><img src="/img/ana/oz_print.jpg" border='0' alt="<%=jsalt_print%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'save',form_report.save_nm.value)"><img src="/img/ana/oz_save.jpg" border='0' alt="<%=jsalt_save%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'vprev')"><img src="/img/ana/oz_prev.jpg" border='0' alt="<%=jsalt_prev%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'vnext')"><img src="/img/ana/oz_next.jpg" border='0' alt="<%=jsalt_next%>" align="absbottom"></a>
			<!--
			<a href="javascript:reportScript(ifrm_report.report_form,'zoomin')"><img src="/img/ana/oz_zoom_in.jpg" border='0' alt="<%=jsalt_in%>" align="absbottom"></a>
			<a href="javascript:reportScript(ifrm_report.report_form,'zoomout')"><img src="/img/ana/oz_zoom_out.jpg" border='0' alt="<%=jsalt_out%>" align="absbottom"></a>
			-->
			<%	}	%>
			</td>
			</tr>
			</table>
			</div>
			</td>
			</tr>
			<tr>
			<td height=5 background="/img/com/Content_tab_bar.gif"><img src="/img/com/Content_tab_bar.gif" width="3" height="5"></td>
			</tr>
			<tr>
			<td>
			<iframe name="ifrm_report" border='0' frameborder='1' scrolling='no' width='100%' height='1070'></iframe>
			</td>
			</tr>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	OZREPORT	END		------------------------------------------>
			<!------------------------------------------------------------------------------------------------------------>

			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	USER LIST IFRAME START	-------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>
			<iframe name="ifrm_user" border='0' frameborder='0' scrolling='no' width='0' height='0'></iframe>
			<!------------------------------------------------------------------------------------------------------------>
			<!------------------------------------------	USER LIST IFRAME END	-------------------------------------->
			<!------------------------------------------------------------------------------------------------------------>

			</table>

			<form name="form_report">
			<input type="hidden" name="save_nm" value="">
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
