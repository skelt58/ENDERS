<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.03
	*	설명 : 통계분석 메일별분석 결과요약 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<script type="text/javascript" src="<c:url value='/js/echarts.min.js'/>"></script>
<script type="text/javascript">
//에러 확인 팝업창
function openError(step1, step2) {
	var url = "<c:url value='/ems/ana/failListP.ums'/>?taskNo=<c:out value='${taskVO.taskNo}'/>&subTaskNo=<c:out value='${taskVO.subTaskNo}'/>";
	url = url + "&step1=" + step1 + "&step2=" + step2;
	var feature = "menubar=no, scrollbars=no, toolbar=no, width=800, height=500, top=0, left=0";
	window.open(url, "", feature);
}
</script>

<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr class="tr_head">
		<td class="title_report" height=30><spring:message code='ANATBLTL101'/></td><!-- 결과요약 -->
	</tr>
</table>
<br>
<c:if test="${not empty mailInfo}">
<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
	<tr>
		<td class="td_line" colspan=2></td>
	</tr>
	<tr class="tr_head">
		<td colspan=2 align=left><b><spring:message code='ANATBLTL102'/></b></td><!-- 메일정의 -->
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB101'/></td><!-- 캠페인유형 -->
		<td class="td_body"><c:out value='${mailInfo.campTy}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB102'/></td><!-- 캠 페 인 명 -->
		<td class="td_body"><c:out value='${mailInfo.campNm}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB103'/></td><!-- 발 송 대 상 -->
		<td class="td_body"><c:out value='${mailInfo.segNm}'/></td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB104'/></td><!-- 발 송 일 자 -->
		<td class="td_body">
			<fmt:parseDate var="mailSendDt" value="${mailInfo.sendDt}" pattern="yyyyMMddHHmm"/>
			<fmt:formatDate var="sendDt" value="${mailSendDt}" pattern="yyyy-MM-dd HH:mm"/>
			<fmt:parseDate var="mailEndDt" value="${mailInfo.endDt}" pattern="yyyyMMddHHmm"/>
			<fmt:formatDate var="endDt" value="${mailEndDt}" pattern="yyyy-MM-dd HH:mm"/>
			<c:out value='${sendDt}'/> ~ <c:out value='${endDt}'/>
		</td>
	</tr>
	<tr>
		<td class="td_title"><spring:message code='ANATBLLB105'/></td><!-- 메&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;명 -->
		<td class="td_body"><c:out value='${mailInfo.taskNm}'/></td>
	</tr>
</table>
</c:if>

<br>

<c:set var="totFailCnt" value="${0}"/>
<c:if test="${not empty sendResult}">
	<c:set var="totFailCnt" value="${sendResult.failCnt}"/>
	<table>
		<colgroup>
			<col width="37%"/>
			<col width="3%"/>
			<col width="60%"/>
		</colgroup>
		<tr>
			<td valign="top">
				<table width="100%" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
					<tr>
						<td class="td_line" colspan=3></td>
					</tr>
					<tr class="tr_head">
						<td colspan=3 align="left"><b><spring:message code='ANATBLTL103'/></b></td><!-- 발송결과 -->
					</tr>
					<tr>
						<td class="td_title" width=85><spring:message code='ANATBLLB106'/></td><!-- 대상수 -->
						<td class="td_title" width=85><spring:message code='ANATBLLB011'/></td><!-- 성공수 -->
						<td class="td_title" width=85><spring:message code='ANATBLLB010'/></td><!-- 실패수 -->
					</tr>
					<tr>
						<td class="td_body" rowspan=2 align="right">
							<fmt:formatNumber var="sendCntNum" type="number" value="${sendResult.sendCnt}" />
							<c:out value='${sendCntNum}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="succCntNum" type="number" value="${sendResult.succCnt}" />
							<c:out value='${succCntNum}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="failCntNum" type="number" value="${sendResult.failCnt}" />
							<c:out value='${failCntNum}'/>
						</td>
					</tr>
					<tr>
						<td class="td_body" align="right">
							<fmt:formatNumber var="succPer" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.succCnt / sendResult.sendCnt}" />
							<c:out value='${succPer}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="failPer" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.failCnt / sendResult.sendCnt}" />
							<c:out value='${failPer}'/>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<div id="sendResultChart" style="width:460px;height:300px;">
							<script type="text/javascript">
							var chartDom = document.getElementById('sendResultChart');
							var myChart = echarts.init(chartDom);
							var option;
							
							option = {
							    tooltip: {
							        trigger: 'item'
							    },
							    legend: {
							    	orient: 'horizontal',
							    	left: 'center',
							    	bottom: 10
							    },
							    series: [
							        {
							            name: '발송결과',
							            type: 'pie',
							            radius: '60%',
							            data: [
							                {value: <c:out value='${sendResult.succCnt}'/>, name: '성공수'},
							                {value: <c:out value='${sendResult.failCnt}'/>, name: '실패수'}
							            ],
							            emphasis: {
							                itemStyle: {
							                    shadowBlur: 10,
							                    shadowOffsetX: 0,
							                    shadowColor: 'rgba(0, 0, 0, 0.5)'
							                }
							            }
							        }
							    ]
							};
							
							option && myChart.setOption(option);
							</script>
							</div>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
			<td valign="top">
				<table width="100%" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
					<tr>
						<td class="td_line" colspan=6></td>
					</tr>
					<tr class="tr_head">
						<td colspan=6 align="left"><b><spring:message code='ANATBLTL104'/></b></td><!-- 반응결과 -->
					</tr>
					<tr>
						<td class="td_title" width=70>&nbsp;</td>
						<td class="td_title" width=80><b><spring:message code='ANATBLLB011'/></b></td><!-- 성공수 -->
						<td class="td_title" width=70><b><spring:message code='ANATBLLB012'/></b></td><!-- 오픈수 -->
						<td class="td_title" width=70><b><spring:message code='ANATBLLB013'/></b></td><!-- 유효오픈수 -->
						<td class="td_title" width=70><b><spring:message code='ANATBLLB014'/></b></td><!-- 링크클릭수 -->
						<td class="td_title" width=70><b><spring:message code='ANATBLLB015'/></b></td><!-- 수신거부 -->
					</tr>
					<tr>
						<td class="td_body"><spring:message code='ANATBLLB109'/></td><!-- 반응수 -->
						<td class="td_body" rowspan=2 align="right">
							<c:out value='${succCntNum}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="openCntNum" type="number" value="${sendResult.openCnt}" />
							<c:out value='${openCntNum}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="validCntNum" type="number" value="${sendResult.validCnt}" />
							<c:out value='${validCntNum}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="validCntNum" type="number" value="${sendResult.validCnt}" />
							<c:if test="${sendResult.clickCnt > 0}">
								<a href="#" onclick="openLink()"><c:out value='${validCntNum}'/></a>
							</c:if>
							<c:if test="${sendResult.clickCnt == 0}">
								<c:out value='${validCntNum}'/>
							</c:if>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="blockCntNum" type="number" value="${sendResult.blockCnt}" />
							<c:out value='${blockCntNum}'/>
						</td>
					</tr>
					<tr>
						<td class="td_body"><spring:message code='ANATBLLB110'/></td><!-- 성공대비 -->
						<td class="td_body" align="right">
							<fmt:formatNumber var="succPerCont" type="percent" value="${sendResult.succCnt == 0 ? 0 : sendResult.openCnt / sendResult.succCnt}" />
							<c:out value='${succPerCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="validPerCont" type="percent" value="${sendResult.succCnt == 0 ? 0 : sendResult.validCnt / sendResult.succCnt}" />
							<c:out value='${validPerCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="clickCntCont" type="percent" value="${sendResult.succCnt == 0 ? 0 : sendResult.clickCnt / sendResult.succCnt}" />
							<c:out value='${clickCntCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="blockCntCont" type="percent" value="${sendResult.succCnt == 0 ? 0 : sendResult.blockCnt / sendResult.succCnt}" />
							<c:out value='${blockCntCont}'/>
						</td>
					</tr>
					<tr>
						<td class="td_body"><spring:message code='ANATBLLB111'/></td><!-- 전체대비 -->
						<td class="td_body" align="right">
							<fmt:formatNumber var="succCntCont" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.succCnt / sendResult.sendCnt}" />
							<c:out value='${succCntCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="openCntCont" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.openCnt / sendResult.sendCnt}" />
							<c:out value='${openCntCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="validCntCont" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.validCnt / sendResult.sendCnt}" />
							<c:out value='${validCntCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="clickCntCont" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.clickCnt / sendResult.sendCnt}" />
							<c:out value='${clickCntCont}'/>
						</td>
						<td class="td_body" align="right">
							<fmt:formatNumber var="blockCntCont" type="percent" value="${sendResult.sendCnt == 0 ? 0 : sendResult.blockCnt / sendResult.sendCnt}" />
							<c:out value='${blockCntCont}'/>
						</td>
					</tr>
					<tr>
						<td colspan="6">
							<div id="respResultChart" style="width:740px;height:279px;">
							<script type="text/javascript">
							var chartDom = document.getElementById('respResultChart');
							var myChart = echarts.init(chartDom);
							var option;
							
							option = {
								    xAxis: {
								        type: 'category',
								        data: ['성공수', '오픈수', '유효오픈수', '링크클릭수', '수신거부']
								    },
								    yAxis: {
								        type: 'value'
								    },
								    series: [{
							            name: '반응결과',
								        type: 'bar',
								        data: [
								        	{ value: <c:out value='${sendResult.succCnt}'/>, itemStyle: {color:'#5470c6'} },
								        	{ value: <c:out value='${sendResult.openCnt}'/>, itemStyle: {color:'#91cc75'} },
								        	{ value: <c:out value='${sendResult.validCnt}'/>, itemStyle: {color:'#fac858'} },
								        	{ value: <c:out value='${sendResult.clickCnt}'/>, itemStyle: {color:'#ee6666'} },
								        	{ value: <c:out value='${sendResult.blockCnt}'/>, itemStyle: {color:'#73c0de'} }
								        ]
								    }]
								};
							option && myChart.setOption(option);
							</script>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</c:if>

<br/>

<c:if test="${not empty detailList}">
	<c:set var="syntaxErrCnt" value="${0}"/>
	<c:set var="webAgentErrCnt" value="${0}"/>
	<c:set var="dbAgentErrCnt" value="${0}"/>
	<c:set var="mailBodyErrCnt" value="${0}"/>
	<c:set var="domainErrCnt" value="${0}"/>
	<c:set var="networkErrCnt" value="${0}"/>
	<c:set var="connectErrCnt" value="${0}"/>
	<c:set var="heloErrCnt" value="${0}"/>
	<c:set var="mailFromErrCnt" value="${0}"/>
	<c:set var="rcptToErrCnt" value="${0}"/>
	<c:set var="resetErrCnt" value="${0}"/>
	<c:set var="dataErrCnt" value="${0}"/>
	<c:set var="dotErrCnt" value="${0}"/>
	<c:set var="quitErrCnt" value="${0}"/>
	<c:set var="sumStep1Err" value="${0}"/>
	<c:set var="sumStep2Err" value="${0}"/>
	<c:set var="step1" value=""/>
	<c:set var="step2" value=""/>
	<c:set var="failCnt" value="${0}"/>
	
	<c:forEach items="${detailList}" var="detail">
		<c:set var="step1" value="${detail.step1}"/>
		<c:set var="step2" value="${detail.step2}"/>
		<c:set var="failCnt" value="${detail.cntStep2}"/>
		<c:if test="${'001' eq step1}">
			<c:set var="sumStep1Err" value="${sumStep1Err + failCnt}"/>
			<c:choose>
				<c:when test="${'001' eq step2}">
					<c:set var="syntaxErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'002' eq step2}">
					<c:set var="webAgentErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'003' eq step2}">
					<c:set var="dbAgentErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'004' eq step2}">
					<c:set var="mailBodyErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'005' eq step2}">
					<c:set var="domainErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'006' eq step2}">
					<c:set var="networkErrCnt" value="${failCnt}"/>
				</c:when>
			</c:choose>
		</c:if>
		<c:if test="${'002' eq step1}">
			<c:set var="sumStep2Err" value="${sumStep2Err + failCnt}"/>
			<c:choose>
				<c:when test="${'001' eq step2}">
					<c:set var="connectErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'002' eq step2}">
					<c:set var="heloErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'003' eq step2}">
					<c:set var="mailFromErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'004' eq step2}">
					<c:set var="rcptToErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'005' eq step2}">
					<c:set var="resetErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'006' eq step2}">
					<c:set var="dataErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'007' eq step2}">
					<c:set var="dotErrCnt" value="${failCnt}"/>
				</c:when>
				<c:when test="${'008' eq step2}">
					<c:set var="quitErrCnt" value="${failCnt}"/>
				</c:when>
			</c:choose>
		</c:if>
	</c:forEach>


	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_line"></td>
		</tr>
		<tr class="tr_head">
			<td align="left"><b><spring:message code='ANATBLTL105'/></b></td><!-- 세부에러 -->
		</tr>
		<tr class="tr_head">
			<td class="td_title"><b><spring:message code='ANATBLLB107'/></b></td><!-- 메일발송 전 단계 -->
		</tr>
	<table>
	
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_body" align=center width=100>Syntax</td>
			<td class="td_body" align=center width=100>Web Agent</td>
			<td class="td_body" align=center width=100>DB Agent</td>
			<td class="td_body" align=center width=100>Mail Body</td>
			<td class="td_body" align=center width=100>Domain</td>
			<td class="td_body" align=center width=100>Network</td>
			<td class="td_body" align=center width=100><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		</tr>
		<tr>
			<td class="td_body" align="right" <c:if test="${syntaxErrCnt > 0}"> onClick="openError('001','001')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="syntaxErrCntNum" type="number" value="${syntaxErrCnt}" />
				<c:out value='${syntaxErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${webAgentErrCnt > 0}"> onClick="openError('001','002')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="webAgentErrCntNum" type="number" value="${webAgentErrCnt}" />
				<c:out value='${webAgentErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${dbAgentErrCnt > 0}"> onClick="openError('001','003')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="dbAgentErrCntNum" type="number" value="${dbAgentErrCnt}" />
				<c:out value='${dbAgentErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${mailBodyErrCnt > 0}"> onClick="openError('001','004')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="mailBodyErrCntNum" type="number" value="${mailBodyErrCnt}" />
				<c:out value='${mailBodyErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${domainErrCnt > 0}"> onClick="openError('001','005')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="domainErrCntNum" type="number" value="${domainErrCnt}" />
				<c:out value='${domainErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${networkErrCnt > 0}"> onClick="openError('001','006')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="networkErrCntNum" type="number" value="${networkErrCnt}" />
				<c:out value='${networkErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${sumStep1Err > 0}"> onClick="openError('001','')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="sumStep1ErrNum" type="number" value="${sumStep1Err}" />
				<c:out value='${sumStep1ErrNum}'/>
			</td>
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="syntaxErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : (syntaxErrCnt / totFailCnt)}" />
				<c:out value='${syntaxErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="webAgentErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : (webAgentErrCnt / totFailCnt)}" />
				<c:out value='${webAgentErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dbAgentErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : (dbAgentErrCnt / totFailCnt)}" />
				<c:out value='${dbAgentErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailBodyErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 :( mailBodyErrCnt / totFailCnt)}" />
				<c:out value='${mailBodyErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="domainErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : (domainErrCnt / totFailCnt)}" />
				<c:out value='${domainErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="networkErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : (networkErrCnt / totFailCnt)}" />
				<c:out value='${networkErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep1ErrPer" type="percent" value="${totFailCnt == 0 ? 0 : (sumStep1Err / totFailCnt)}" />
				<c:out value='${sumStep1ErrPer}'/>
			</td>
		</tr>
	</table>
	
	<br/>
	
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr class="tr_head">
			<td><b><spring:message code='ANATBLLB106'/></b></td><!-- 대상수 -->
		</tr>
	<table>
	
	<table width="700" border="1" cellspacing="0" cellpadding="0" class="table_line_outline">
		<tr>
			<td class="td_body" align=center width=75>CONNECT</td>
			<td class="td_body" align=center width=75>HELO</td>
			<td class="td_body" align=center width=75>MAIL FROM</td>
			<td class="td_body" align=center width=75>RCPT TO</td>
			<td class="td_body" align=center width=75>RESET</td>
			<td class="td_body" align=center width=75>DATA</td>
			<td class="td_body" align=center width=75>DOT</td>
			<td class="td_body" align=center width=75>QUIT</td>
			<td class="td_body" align=center width=100><spring:message code='ANATBLLB112'/></td><!-- 합계 -->
		</tr>
		<tr>
			<td class="td_body" align="right" <c:if test="${connectErrCnt > 0}"> onClick="openError('002','001')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="connectErrCntNum" type="number" value="${connectErrCnt}" />
				<c:out value='${connectErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${heloErrCnt > 0}"> onClick="openError('002','002')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="heloErrCntNum" type="number" value="${heloErrCnt}" />
				<c:out value='${heloErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${mailFromErrCnt > 0}"> onClick="openError('002','003')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="mailFromErrCntNum" type="number" value="${mailFromErrCnt}" />
				<c:out value='${mailFromErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${rcptToErrCnt > 0}"> onClick="openError('002','004')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="rcptToErrCntNum" type="number" value="${rcptToErrCnt}" />
				<c:out value='${rcptToErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${resetErrCnt > 0}"> onClick="openError('002','005')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="resetErrCntNum" type="number" value="${resetErrCnt}" />
				<c:out value='${resetErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${dataErrCnt > 0}"> onClick="openError('002','006')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="dataErrCntNum" type="number" value="${dataErrCnt}" />
				<c:out value='${dataErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${dotErrCnt > 0}"> onClick="openError('002','007')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="dotErrCntNum" type="number" value="${dotErrCnt}" />
				<c:out value='${dotErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${quitErrCnt > 0}"> onClick="openError('002','008')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="quitErrCntNum" type="number" value="${quitErrCnt}" />
				<c:out value='${quitErrCntNum}'/>
			</td>
			<td class="td_body" align="right" <c:if test="${sumStep2Err > 0}"> onClick="openError('002','009')" style="cursor:pointer"</c:if>>
				<fmt:formatNumber var="sumStep2ErrNum" type="number" value="${sumStep2Err}" />
				<c:out value='${sumStep2ErrNum}'/>
			</td>
		</tr>
		<tr>
			<td class="td_body" align="right">
				<fmt:formatNumber var="connectErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : connectErrCnt / totFailCnt}" />
				<c:out value='${connectErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="heloErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : heloErrCnt / totFailCnt}" />
				<c:out value='${heloErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="mailFromErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : mailFromErrCnt / totFailCnt}" />
				<c:out value='${mailFromErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="rcptToErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : rcptToErrCnt / totFailCnt}" />
				<c:out value='${rcptToErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="resetErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : resetErrCnt / totFailCnt}" />
				<c:out value='${resetErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dataErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : dataErrCnt / totFailCnt}" />
				<c:out value='${dataErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="dotErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : dotErrCnt / totFailCnt}" />
				<c:out value='${dotErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="quitErrCntPer" type="percent" value="${totFailCnt == 0 ? 0 : quitErrCnt / totFailCnt}" />
				<c:out value='${quitErrCntPer}'/>
			</td>
			<td class="td_body" align="right">
				<fmt:formatNumber var="sumStep2ErrPer" type="percent" value="${totFailCnt == 0 ? 0 : sumStep2Err / totFailCnt}" />
				<c:out value='${sumStep2ErrPer}'/>
			</td>
		</tr>
	</table>
</c:if>

<div id="errorDetailChart" style="width:1600px;height:300px;"></div>
<script type="text/javascript">
var chartDom = document.getElementById('errorDetailChart');
var myChart = echarts.init(chartDom);
var option;

option = {
	    tooltip: {
	        trigger: 'item'
	    },
	    xAxis: [{
	        type: 'category',
	        axisLabel : {
	        	rotate : 0
	        },
	        data: ['Syntax', 'Web Agent', 'DB Agent', 'Mail Body', 'Domain', 'Network', 'CONNECT', 'HELO', 'MAIL FROM', 'RCPT TO', 'RESET', 'DATA', 'DOT', 'QUIT']
	    }],
	    yAxis: {
	        type: 'value'
	    },
	    series: [{
            name: '세부에러',
	        type: 'bar',
	        data: [
	        	{ value: <c:out value='${syntaxErrCnt}'/>, itemStyle: {color:'#5470c6'} },
	        	{ value: <c:out value='${webAgentErrCnt}'/>, itemStyle: {color:'#91cc75'} },
	        	{ value: <c:out value='${dbAgentErrCnt}'/>, itemStyle: {color:'#fac858'} },
	        	{ value: <c:out value='${mailBodyErrCnt}'/>, itemStyle: {color:'#ee6666'} },
	        	{ value: <c:out value='${domainErrCnt}'/>, itemStyle: {color:'#73c0de'} },
	        	{ value: <c:out value='${networkErrCnt}'/>, itemStyle: {color:'#3ba272'} },
	        	{ value: <c:out value='${connectErrCnt}'/>, itemStyle: {color:'#fc8452'} },
	        	{ value: <c:out value='${heloErrCnt}'/>, itemStyle: {color:'#9a60b4'} },
	        	{ value: <c:out value='${mailFromErrCnt}'/>, itemStyle: {color:'#ea7ccc'} },
	        	{ value: <c:out value='${rcptToErrCnt}'/>, itemStyle: {color:'#5470c6'} },
	        	{ value: <c:out value='${resetErrCnt}'/>, itemStyle: {color:'#91cc75'} },
	        	{ value: <c:out value='${dataErrCnt}'/>, itemStyle: {color:'#fac858'} },
	        	{ value: <c:out value='${dotErrCnt}'/>, itemStyle: {color:'#ee6666'} },
	        	{ value: <c:out value='${quitErrCnt}'/>, itemStyle: {color:'#73c0de'} }
	        ]
	    }],
	};

option && myChart.setOption(option);
</script>


</body>
</html>
