<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.07
	*	설명 : 메인화면
	**********************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>
<style type="text/css">
.on { text-weight:bold; background-color:#cccccc; }
</style>

<script type="text/javascript">
var x = 0;
var y = 0;

function fileUpload(rFileName,vFileName) {
	var obj = document.segform;
	$("#segInfoForm input[name='totCnt']").val("0");
	$("#segInfoForm input[name='separatorChar']").val("");
	$("#fileContentView").empty();


	var tmp = (y > screen.height/2) ? (y - 165) : (y + 15);
	window.open("<c:url value='/com/uploadP.ums'/>?folder=addressfile/<c:out value='${NEO_USER_ID}'/>&inputType=text&ext=txt,csv&formName=segInfoForm&title=Address&charset=UTF-8&rFileName="+rFileName+"&vFileName="+vFileName, "window", "width=640, height=120, left="+(x-300) + ", top="+ tmp);
}

function goNoticeParamPop() {
	window.open("<c:url value='/ems/seg/fileSampleDownPop.ums'/>", "segParamInfo", 'width=450,height=168,status=yes,scrollbars=no,resizable=no');
}

function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#segInfoForm select[name='userId']").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#segInfoForm select[name='userId']").append(option);
		});
	});
}

function fncSep() {
    var frm = $("#segInfoForm")[0];

    if($("#segInfoForm input[name='segFlPath']").val() == "") {
    	$("#segInfoForm input[name='separatorChar']").val("");
        alert("<spring:message code='SEGJSALT002'/>");		// 파일이 입력되어 있지 않습니다.\\n파일을 입력하신 후 구분자를 입력해 주세요.
        fileUpload("segFlPath", "tempFlPath");
        return;
    }
    
    if($("#segInfoForm input[name='separatorChar']").val() == "") {
    	alert("구분자를 입력하세요.");
    	return;
    }

    var tmp = $("#segInfoForm input[name='segFlPath']").val().substring($("#segInfoForm input[name='segFlPath']").val().lastIndexOf("/")+1);

    $("#segInfoForm input[name='segFlPath']").val("addressfile/<c:out value='${NEO_USER_ID}'/>/" + tmp);
	
	var param = $("#segInfoForm").serialize();
	alert(param);
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/segFileMemberListP.ums'/>?" + param,
		dataType : "html",
		async: false,
		success : function(pageHtml){
			$("#fileContentView").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
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
			

		    <form id="segInfoForm" name="segInfoForm" method="post">
		    <!-- new title -->
		    <p class="title_default"><spring:message code="SEGTBLTL001"/></p><!-- 발송대상그룹 -->
		    <!-- //new title -->
		    
			<div class="cWrap">

			<div id="divMenu1">
				<table  border="0" cellspacing="0" cellpadding="0" class="nTab">
					<tr>
						<td align="center"><a href="JavaScript:goCreateTy('000')"><spring:message code="SEGBTN001"/></a></td><!-- 추출도구이용 -->
						<td align="center"><a href="JavaScript:goCreateTy('002')"><spring:message code="SEGBTN003"/></a></td><!-- 직접 SQL 이용 -->
						<td align="center" class="on"><a href="JavaScript:goCreateTy('003')"><spring:message code="SEGBTN004"/></a></td><!-- 파일연동 -->
						<td align="center"><a href="JavaScript:goCreateTy('004')"><spring:message code="SEGBTN005"/></a></td><!-- 연계서비스지정 -->
					</tr>
				</table>
		    </div>
		    
		    <div class="nTwrap">
		    	<table  class="table_line_outline">
			   		<colgroup>
			   			<col style="width:10%">
			   			<col style="width:40%">
			   			<col style="width:10%">
			   			<col style="width:35%">
			   		</colgroup>
				    <tr>
				        <td class="td_title"><spring:message code="SEGTBLTL031"/></td><!-- 파일선택 -->
		        		<td class="td_body">
			        		<input type="text" name="tempFlPath" class="readonly_style" readonly>
			        		<input type="button" class="btn_style" value="<spring:message code="COMBTN012"/>" onClick="fileUpload('segFlPath', 'tempFlPath')"><!-- 찾기 -->
			        		<input type="button" class="btn_style" value="<spring:message code="COMBTN014"/>" onClick="goNoticeParamPop()"><!-- 샘플다운로드 -->
		        		</td>
				        <td class="td_title"><spring:message code="SEGTBLLB016"/></td><!-- 구분자 -->
				        <td class="td_body">
					        <input type="text" name="separatorChar" >
					        <input type="button" class="btn_style" value="<spring:message code="COMBTN011"/>" onClick="fncSep()"><!-- 확인 -->
					        <input type="hidden" name="segFlPath">
					        <input type="hidden" name="mergeKey">
					        <input type="hidden" name="mergeCol">
					        <input type="hidden" name="createTy" value='003'>
				        </td>
				    </tr> 
					<tr>
				        <td class="td_title"><spring:message code="SEGTBLTL002"/></td><!-- 발송대상그룹명 -->
				        <td class="td_body" colspan="3">
				        <input type="text" name="segNm">
				        </td>
				    </tr>
				    <c:if test="${'Y' eq NEO_ADMIN_YN}">
					    <tr>
					        <td  class="td_title"><spring:message code="COMTBLTL004"/></td><!-- 사용자그룹 -->
					        <td  class="td_body">
					            <select name="deptNo" onchange="javascript:getUserList(this.value);">
					                <option value='0'>::::<spring:message code="COMTBLLB004"/>::::</option><!-- 그룹 선택 -->
					                <c:if test="${fn:length(deptList) > 0}">
					                	<c:forEach items="${deptList}" var="dept">
					                		<option value="<c:out value='${dept.deptNo}'/>"><c:out value='${dept.deptNm}'/></option>
					                	</c:forEach>
					                </c:if>
					            </select>
					        </td>
					        <td  class="td_title"><spring:message code="COMTBLTL005"/></td><!-- 사용자 -->
					        <td  class="td_body">
					            <select name="userId">
					                <option value=''>::::<spring:message code="COMTBLLB005"/>::::</option><!-- 사용자 선택 -->
					            </select>
					        </td>
					    </tr>
				    </c:if>

				</table>
				
			    <!-- File Upload -->
				<table border="0" cellspacing="0" cellpadding="0" style="width:100%;height:200px">
				    <tr class='tr_head' >
				        <td>
				            <div id="fileContentView"></div>
				        </td>
				    </tr>
			    </table>
			
			    <!-- 커리문 -->
			    <div class="btn">
			    	<div class="left">
				    	<input type="button" class="btn_style" value="<spring:message code="SEGBTN006"/>" onClick="fSegCnt()"><!-- 대상자수추출 -->
				    	<input type="text" name="totCnt" size="9" value="0" class="readonly_style" readonly> <spring:message code="SEGTBLLB015"/><!-- 명 --> 
			    	</div>
			    	<div class="right">
			    		<input type="button" class="btn_typeC" value="<spring:message code="COMBTN005"/>" onClick="goAdd()">
			            <input type="button" class="btn_typeG" value="<spring:message code="COMBTN010"/>" onClick="goList()">
			    	</div>
			    </div>
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
