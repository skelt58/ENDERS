<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.08.05
	*	설명 : 좌측메뉴(EMS)
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/taglib.jsp" %>

<script type="text/javascript">
function runMenu(pMenuId, menuId, menuUrl) {
	$("#pMenuId").val(pMenuId);
	$("#menuId").val(menuId);
	$("#runMenuForm").attr("target","").attr("action",menuUrl).submit();
}
</script>

<form id="runMenuForm" name="runMenuForm">
<input type="hidden" id="pMenuId" name="pMenuId"/>
<input type="hidden" id="menuId" name="menuId"/>
</form>

<!-- 신규발송// -->
<span class="logo-ums"><img src="../../img/common/logo_ums.png" alt="UMS"></span>
<h1>AXon EMS</h1>

<div class="btn-mail">
	<button type="button" class="btn fullblue" onclick="fn.popupOpen('#popup_mailsend');">신규발송</button>
</div>
<!-- //신규발송 -->

<!-- 메뉴// -->
<nav>
	<ul>
		<c:if test="${fn:length(NEO_MENU_LVL1_LIST) > 0}">
			<c:forEach var="lvl1" items="${NEO_MENU_LVL1_LIST}">
				<c:if test="${lvl1.serviceGb == 10}">
				<li<c:if test="${lvl1.menuId eq NEO_P_MENU_ID}"> class="active"</c:if>>
					<a href="#" class="depth1"><span class="item0<c:out value='${lvl1.sortSno}'/>"><c:out value='${lvl1.menuNm}'/></span></a>
					<div class="inner-menu">
						<c:if test="${fn:length(NEO_MENU_LVL2_LIST) > 0}">
							<ul>
								<c:forEach var="lvl2" items="${NEO_MENU_LVL2_LIST}">
									<c:if test="${lvl1.menuId eq lvl2.parentmenuId}">
										<li<c:if test="${lvl2.menuId eq NEO_MENU_ID}"> class="active"</c:if>><a href="javascript:runMenu('<c:out value='${lvl1.menuId}'/>','<c:out value='${lvl2.menuId}'/>','<c:url value='${lvl2.sourcePath}'/>');"><c:out value='${lvl2.menuNm}'/></a></li>
									</c:if>
								</c:forEach>
							</ul>
						</c:if>
					</div>
				</li>
				</c:if>
			</c:forEach>
		</c:if>
	</ul>
</nav>
<!-- //메뉴 -->