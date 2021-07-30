<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.27
	*	설명 : 메일 목록 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<form id="mailListForm" name="mailListForm" method="post">
<input type="hidden" name="locPos" value="list">
<input type="hidden" id="status" name="status"/>
<table class="table_line_outline" border="1" cellspacing="0">
	<colgroup>
		<col style="width: 3%;" />
		<col style="width: 14%;" />
		<col style="width: 24%;" />
		<col style="width: 15%;" />
		<col style="width: 7%;" />
		<col style="width: 10%;" />
		<col style="width: 13%;" />
		<col style="width: 7%;" />
		<col style="width: 7%;" />
	</colgroup>
	<tr class="tr_head">
		<td width="3%" align=center>
			<c:if test="${not empty mailList}">
				<input type="checkbox" name="isAll" onclick='goAll()' style="border: 0">
			</c:if>
		</td>
		<td align=center><spring:message code='CAMTBLTL007'/></td><!-- 캠페인명 -->
		<td align=center><spring:message code='CAMTBLTL011'/></td><!-- 메일명 -->
		<td align=center><spring:message code='CAMTBLTL014'/></td><!-- 발송대상그룹 -->
		<td align=center><spring:message code='CAMTBLTL015'/></td><!-- 메일유형 -->
		<td align=center><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
		<td align=center><spring:message code='CAMTBLTL016'/></td><!-- 예약일 -->
		<td align=center><spring:message code='COMTBLTL001'/></td><!-- 상태 -->
		<td align=center><spring:message code='CAMTBLTL012'/></td><!-- 발송상태 -->
	</tr>
	<c:set var="emptyCnt" value="${10 - fn:length(mailList)}"/>
	<c:if test="${fn:length(mailList) > 0}">
		<c:forEach items="${mailList}" var="mail" varStatus="mailStatus">
			<tr class="tr_body">
				<td style="text-align: center;">
					<c:choose>
						<c:when test="${'002' eq mail.status}">
							<input type="checkbox" name="taskNos" value="<c:out value='${mail.taskNo}'/>" onclick='return goDeleteClick()'>
							<input type="checkbox" name="subTaskNos" value="<c:out value='${mail.subTaskNo}'/>" style="display:none;" readonly>
							<input type="checkbox" name="workStatus" value="<c:out value='${mail.workStatus}'/>" style="display:none;" readonly>
						</c:when>
						<c:otherwise>
							<input type="checkbox" name="taskNos" value="<c:out value='${mail.taskNo}'/>" onclick='goTaskNo(<c:out value='${mailStatus.index}'/>)'>
							<input type="checkbox" name="subTaskNos" value="<c:out value='${mail.subTaskNo}'/>" style="display:none;" readonly>
							<input type="checkbox" name="workStatus" value="<c:out value='${mail.workStatus}'/>" style="display:none;" readonly>
						</c:otherwise>
					</c:choose>
				</td>
				<td class="td_body">
					<c:out value="${mail.campNm}"/>
				</td>
				<td class="td_body">
					<div style="width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
					<a href="JavaScript:goUpdatef('<c:out value='${mail.taskNo}'/>','<c:out value='${mail.subTaskNo}'/>')" title="<c:out value='${mail.taskNm}'/>">
					<c:if test="${'000' ne mail.sendRepeat}">[<c:out value='${mail.subTaskNo}'/><spring:message code='COMTBLLB006'/>]</c:if> <c:out value="${mail.taskNm}"/>
					</a><!-- COMTBLLB006:차 -->
					</div>
				</td>
				<td class="td_body">
					<a href="javascript:goSegInfo('<c:out value='${mail.segNo}'/>')"> <c:out value="${mail.segNm}"/></a>
				</td>
				<td><c:out value="${mail.sendRepeatNm}"/></td>
				<td><c:out value="${mail.userId}"/></td>
				<td>
					<fmt:parseDate var="sendDate" value="${mail.sendDt}" pattern="yyyyMMddHHmm"/>
					<fmt:formatDate var="sendDt" value="${sendDate}" pattern="yyyy-MM-dd HH:mm"/> 
					<c:out value="${sendDt}"/>
				</td>
				<td><c:out value="${mail.subStatusNm}"/></td>
				<td style="word-break: break-all;">
					<c:choose>
						<c:when test="${'000' eq mail.workStatus}"><!-- 발송대기 -->
							<c:if test="${'000' eq mail.status}"><!-- 정상 -->
								<a href="JavaScript:goAdmit(<c:out value='${mailStatus.index}'/>)"><spring:message code='CAMTBLLB011'/></a><!-- 발송대기 -->
							</c:if>
							<c:if test="${'000' ne mail.status}">
								<spring:message code='CAMTBLLB011'/>
							</c:if>
						</c:when>
						<c:when test="${'001' eq mail.workStatus}"><!-- 발송승인 -->
							<spring:message code='CAMTBLLB012'/>
						</c:when>
						<c:when test="${'002' eq mail.workStatus}"><!-- 발송중... -->
							<spring:message code='CAMTBLLB013'/>
						</c:when>
						<c:when test="${'003' eq mail.workStatus}"><!-- 발송완료 -->
							<spring:message code='CAMTBLLB014'/>
						</c:when>
						<c:otherwise><!-- 발송실패 -->
							<a href="JavaScript:goFail('<c:out value='${mail.workStatusDtl}'/>');" title="<c:out value='${mail.workStatusDtl}'/>"><spring:message code='CAMTBLLB015'/></a>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${emptyCnt > 0}">
		<c:forEach var="i" begin="1" end="${emptyCnt}">
			<tr class="tr_body">
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</c:forEach>
	</c:if>
</table>
<div class="center">${pageUtil.pageHtml}</div>
<div class="btn">
	<div class="btnR">
		<input type="button" class="btn_typeC" value="<spring:message code='COMBTN005'/>" onClick="goMailAdd()"><!-- 등록 -->
		<input type="button" class="btn_typeG" value="<spring:message code='COMBTN006'/>" onClick="goDisable()"><!-- 사용중지 -->
		<input type="button" class="btn_typeG" value="<spring:message code='COMBTN008'/>" onClick="goDelete()"><!-- 삭제 -->
		<input type="button" class="btn_typeG" value="<spring:message code='CAMBTN001'/>" onClick="goCopy()"><!-- 복사 -->
		<input type="button" class="btn_typeC" value="<spring:message code='CAMBTN002'/>" onClick="goTestSend()"><!-- 테스트발송 -->
		<!------------------	MODIFY BY SEO CHANG HOON	START	------------------>
		<input type="button" name="btn_camp_list" class="btn_style" value="<spring:message code='CAMBTN012'/>" onClick="parent.parent.goCampList()" style="display: none;"><!-- 서비스으로 이동 -->
		<!------------------	MODIFY BY SEO CHANG HOON	END		------------------>
	</div>
</div>

</form>
