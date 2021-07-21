<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.21
	*	설명 : 직접 SQL 이용 등록 화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
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
			</form>
			
			<form id="segInfoForm" name="segInfoForm">
			<input type="hidden" name="mergeKey">
			<input type="hidden" name="mergeCol">
			<input type="hidden" name="testType">
			<input type="hidden" name="createTy" value="${createTy}">
				
			<!-- new title -->
		    <p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
		    <!-- //new title -->
			
			<div class="cWrap">
			<div id="divMenu1">
			    <table border="0" cellspacing="0" cellpadding="0" class="nTab">
				    <tr height="20">
				         <td align="center"><a href="JavaScript:goCreateTy('000')"><spring:message code='SEGBTN001'/></a></td><!-- 추출도구이용 -->
				         <td align="center" class="on"><a href="JavaScript:goCreateTy('002')"><spring:message code='SEGBTN003'/></a></td><!-- 직접 SQL 이용 -->
				      <td align="center"><a href="JavaScript:goCreateTy('003')"><spring:message code='SEGBTN004'/></a></td><!-- 파일연동 -->
				      <td align="center"><a href="JavaScript:goCreateTy('004')"><spring:message code='SEGBTN005'/></a></td><!-- 연계서비스지정 -->
				     </tr>
				</table>
			    </div>
			    <div class="nTwrap">
				<table class="table_line_outline">
				<colgroup>
					<col style="width:15%">
					<col style="width:35%">
					<col style="width:15%">
					<col style="width:35%">
				</colgroup>
				<!-- DB Connection -->
			    <tr>
			        <td class="td_title">Connection&nbsp;</td>
			        <td class="td_body">
		                <select id="dbConnNo" name='dbConnNo' onchange='goReload()'>
		                	<c:if test="${fn:length(dbConnList) > 0}">
		                		<c:forEach items="${dbConnList}" var="dbConn">
		                			<c:choose>
		                			<c:when test="${dbConn.dbConnNo == searchVO.dbConnNo}">
			                			<option value="<c:out value='${dbConn.dbConnNo}'/>" selected><c:out value='${dbConn.dbConnNm}'/></option>
		                			</c:when>
		                			<c:otherwise>
			                			<option value="<c:out value='${dbConn.dbConnNo}'/>"><c:out value='${dbConn.dbConnNm}'/></option>
		                			</c:otherwise>
		                			</c:choose>
		                		</c:forEach>
		                	</c:if>
		                </select>

		            </td>
		            <td class="td_title"><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
		            <td class="td_body">
		                <input type="text" name="segNm" style="width:280;">
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
		                    		<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
		                    	</c:forEach>
		                    </c:if>
		                </select>
		            </td>
		            <td class="td_title"><spring:message code='COMTBLTL005'/></td><!-- 사용자 -->
		            <td class="td_body">
		                <select id="userId" name="userId">
		                    <option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
		                </select>
		            </td>
		        </tr>
		        </c:if>
		        
			        <!-- DB Connection -->
			        <tr class="inTable">
			            <td colspan="4">
			            
			            
			            
			                <!-- 연결된 테이블/컬럼 정보 설정  -->
			                <iFrame name="iFrmMeta" width="985" height=250 src="/seg/segDirectMetaMainP.jsp?p_db_conn_no=" frameborder=0 marginheight=0 marginwidth=0 scrolling=auto></iframe>
			                <!-- 연결된 테이블/컬럼 설정 -->
			                
			                
			                
			            </td>
			        </tr>
			        </table>
			   
			    <!--차장님  table width="800" border="0" cellspacing="0" cellpadding="0">
			        <tr>
			            <td>
			                <div id="divConditional"></div>
			            </td>
			        </tr>
			    </table-->
			        <!-- 조건 선택 -->
			
			        <!-- 커리문 -->
			        <table class="table_line_outline">
				        <tr>
				            <td class="td_title" width="150">QUERY</td>
				            <td class="td_body">
				                <div id='divSelect'><textarea name="query" style="width:810px;height:200px;"></textarea></div>
				            </td>
				        </tr>
			        </table>
			        <!-- 커리문 -->
			        <div class="btn">
			        	<div class="left">
			        	<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
			        	<input type="text" name="totCnt" size="9" class='readonly_style' readonly><spring:message code='SEGTBLLB015'/><!-- 명 -->
			        	</div>
			        	<div class="right">
			        	<input type="button" class="btn_typeC" value="QUERY TEST" onClick="goQueryTest('000')">
			            <input type="button" class="btn_typeC" value="<spring:message code='COMBTN005'/>" onClick="goQueryTest('001')"><!-- 등록 -->
			            <input type="button" class="btn_typeG" value="<spring:message code='SEGBTN007'/>" onClick="goQueryTest('002')"><!-- 대상자보기 -->
			            <input type="button" class="btn_typeG" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
			        	</div>  
			        </div>
			        <table class="frameWrap">
			           <tr>
			             <td>
			                 <iFrame name=iFrmCnt frameborder=0 framespacing=0 marginheight=0 noresize scrolling=no style='height:0; margin:0; width:0'></iFrame>
			             </td>
			           </tr>
			        </table>
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
