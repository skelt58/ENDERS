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
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
$(document).ready(function() {
	getMetaFrameContent();
});

// 탭 클릭
function goCreateTy(no) {
    var actionUrl;
    
    if(no == '000') actionUrl = "<c:url value='/ems/seg/segToolAddP.ums'/>";      	// 추출도구이용
    if(no == '001') actionUrl = "<c:url value='/ems/seg/segOneClickAddP.ums'/>";  	// One Click
    if(no == '002') actionUrl = "<c:url value='/ems/seg/segDirectSQLAddP.ums'/>";	// SQL 직접 입력
    if(no == '003') actionUrl = "<c:url value='/ems/seg/segFileAddP.ums'/>";   		// 파일그룹
    if(no == '004') actionUrl = "<c:url value='/ems/seg/segRemarketAddP.ums'/>";    // 연계 캠페인 지정
    
    
    $("#searchForm").attr("action", actionUrl).submit();
}

// 사용자그룹 선택시 사용자 목록 설정
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#userId").append(option);
		});
	});
}

//메타 테이블 컨텐츠 생성
function getMetaFrameContent() {
	var dbConnNo = $("#dbConnNo").val();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/metatableListP.ums'/>?dbConnNo=" + dbConnNo,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#divMetaTableInfo").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

function goReload() {
	//getMetaFrameContent();
	$("#searchForm input[name='dbConnNo']").val($("#dbConnNo").val());
	$("#searchForm").attr("action","<c:url value='/ems/seg/segDirectSQLAddP.ums'/>").submit();
}

function goColumnInfo(tblNm) {
	var dbConnNo = $("#dbConnNo").val();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/metacolumnListP.ums'/>?dbConnNo=" + dbConnNo + "&tblNm=" + tblNm,
		dataType : "html",
		//async: false,
		success : function(pageHtml){
			$("#divMetaColumnInfo").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

// 대상수 구하기
function goSegCnt() {
    var errflag = false;
    var errstr = "";

    if($("#dbConnNo").val() == "") {
        errflag = true;
        errstr += " [DB CONNECTION NO] ";

    }
    if($("#query").val() == "") {
        errflag = true;
        errstr += " [QUERY] ";
    }
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n"+errstr);		// 다음 정보를 확인하세요.
		return;
	}
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segCount.json'/>?" + param, function(data) {
		$("#totCnt").val(data.totCnt);
	});
}

//쿼리 테스트 EVENT 구현
//SQL 문 유효성 체크및 필수 머지키 (ID, NAME, EMAIL) 확인,
//MERGY_KEY 정보 설정
function goQueryTest(type) {
	var errflag = false;
	var errstr = "";

	if($("#query").val() == "") {
		errflag = true;
		errstr += "[QUERY] ";
	}
	
	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n"+errstr);	// 다음 정보를 확인하세요.
		return;
	}

	var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDirectSQLTest.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			$("#mergeKey").val(data.mergeKey);
			$("#mergeCol").val(data.mergeKey);
			if(type == "000") {
				alert("<spring:message code='COMJSALT014'/>.\n[MERGE_KEY : " + data.mergeKey + "]");	// 성공
			} else if(type == "001") {
				goDirectSQLAdd();
			} else if(type == "002") {
				goSegInfo();
			} else if(type == "003") {
				alert("goUpdate");
			}
		} else if(data.result == 'Fail') {
			alert("<spring:message code='COMJSALT015'/>\n" + data.message);	// 실패
		}
	});
}

function goDirectSQLAdd() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
        if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";		// 사용자
        }
    }
    if($("#dbConnNo").val() == "") {
        errflag = true;
        errstr += " [ DB Connection ] ";
    }
    if($("#segNm").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL002'/> ] ";			// 발송대상그룹명
    }
    if($("#query").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL004'/> ] ";			// 질의문
    }

    if(errflag) {
        alert("<spring:message code='SEGTBLTL004'/>\n" + errstr);	// 입력값 에러\\n다음 정보를 확인하세요.
        return;
    }

    if($("#totCnt").val() == "0") {
        var a = confirm("<spring:message code='SEGTBLTL004'/>");	// 대상자수 추출을 하지 않았습니다.\\n계속 실행을 하겠습니까?
        if ( a ) {
        	var param = $("#segInfoForm").serialize();
        	$.getJSON("<c:url value='/ems/seg/segAdd.json'/>?" + param, function(data) {
        		if(data.result == "Success") {
        			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
        			
        			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
        		} else if(data.result == "Fail") {
        			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
        		}
        	});
        } else return;
    } else {
    	var param = $("#segInfoForm").serialize();
    	$.getJSON("<c:url value='/ems/seg/segAdd.json'/>?" + param, function(data) {
    		if(data.result == "Success") {
    			alert("<spring:message code='COMJSALT008'/>");	// 등록 성공
    			
    			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
    		} else if(data.result == "Fail") {
    			alert("<spring:message code='COMJSALT009'/>");	// 등록 실패
    		}
    	});
    }

}

//대상자보기(미리보기)
function goSegInfo() {
    var errflag = false;
    var errstr = "";

     if($("#dbConnNo").val() == "") {
        errflag = true;
        errstr += " [DB CONNECTION NO] ";
    }
    if($("#query").val() == "") {
        errflag = true;
        errstr += " [QUERY] ";
    }

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);	// 다음 정보를 확인하세요.
		return;
	}

    window.open("","segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
    $("#segInfoForm").attr("target","segInfo").attr("action","<c:url value='/ems/seg/segInfoP.ums'/>").submit();
}

function goSegList() {
	$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
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
			
			<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" name="page" value="<c:out value='${searchVO.page}'/>">
			<input type="hidden" name="searchSegNm" value="<c:out value='${searchVO.searchSegNm}'/>">
			<input type="hidden" name="searchDeptNo" value="<c:out value='${searchVO.searchDeptNo}'/>">
			<input type="hidden" name="searchUserId" value="<c:out value='${searchVO.searchUserId}'/>">
			<input type="hidden" name="searchCreateTy" value="<c:out value='${searchVO.searchCreateTy}'/>">
			<input type="hidden" name="searchStatus" value="<c:out value='${searchVO.searchStatus}'/>">
			<input type="hidden" name="searchStartDt" value="<c:out value='${searchVO.searchStartDt}'/>">
			<input type="hidden" name="searchEndDt" value="<c:out value='${searchVO.searchEndDt}'/>">
			<input type="hidden" name="dbConnNo" value="<c:out value='${searchVO.dbConnNo}'/>">
			</form>
			
			<form id="segInfoForm" name="segInfoForm">
			<input type="hidden" id="mergeKey" name="mergeKey">
			<input type="hidden" id="mergeCol" name="mergeCol">
			<input type="hidden" id="testType" name="testType">
			<input type="hidden" id="createTy" name="createTy" value="${createTy}">
				
			<!-- new title -->
		    <p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
		    <!-- //new title -->
			
			<div class="cWrap">
			<div id="divMenu1">
			    <table border="0" cellspacing="5" cellpadding="0" class="nTab">
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
		                <input type="text" id="segNm" name="segNm" style="width:280;">
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
			            
			                <!-- 연결된 테이블/컬럼 설정 -->
			                <div id="divMetaTableInfo" style="width:985px;height:250px;overflow:auto;"></div>
			                <!-- 연결된 테이블/컬럼 설정 -->			                
			                
			            </td>
			        </tr>
			        </table>
			
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
			        	<input type="text" id="totCnt" name="totCnt" value="0" size="9" class='readonly_style' readonly><spring:message code='SEGTBLLB015'/><!-- 명 -->
			        	</div>
			        	<div class="right">
			        	<input type="button" class="btn_typeC" value="QUERY TEST" onClick="goQueryTest('000')">
			            <input type="button" class="btn_typeC" value="<spring:message code='COMBTN005'/>" onClick="goQueryTest('001')"><!-- 등록 -->
			            <input type="button" class="btn_typeG" value="<spring:message code='SEGBTN007'/>" onClick="goQueryTest('002')"><!-- 대상자보기 -->
			            <input type="button" class="btn_typeG" value="<spring:message code='COMBTN010'/>" onClick="goSegList()"><!-- 리스트 -->
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
