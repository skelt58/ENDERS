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
.tArea { width:700px;height:50px; }
</style>

<script type="text/javascript">
$(document).ready(function() {
	//메타 테이블 컨텐츠 생성
	getMetaFrameContent();
});

//사용자그룹 선택시 사용자 목록 설정
function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.userNm,item.userId);
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

//메타 컬럼 컨텐츠 생성
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

//대상수 구하기
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
			} else if(type == "002") {
				goSegInfo();
			} else if(type == "003") {
				goDirectSQLUpdate();
			}
		} else if(data.result == 'Fail') {
			alert("<spring:message code='COMJSALT015'/>\n" + data.message);	// 실패
		}
	});
}

//수정버튼 클릭시(삭제된 발송대상)
function isStatus() {
    alert("<spring:message code='SEGTBLLB020'/>.");		// 삭제된 발송대상그룹입니다!!\\n삭제된 발송대상그룹은 수정을 할 수 없습니다!!
}

//수정버튼 클릭시(발송대상(세그먼트) 정보 수정)
function goDirectSQLUpdate() {
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
        alert("<spring:message code='COMJSALT001'/>\n" + errstr);	// 입력값 에러\\n다음 정보를 확인하세요.
        return;
    }

    if($("#totCnt").val() == "0") {
    	var a = confirm("<spring:message code='SEGJSALT010'/>");		// 대상자수 추출을 하지 않았습니다.\\n계속 실행을 하겠습니까?
        if ( a ) {
        	var param = $("#segInfoForm").serialize();
        	$.getJSON("<c:url value='/ems/seg/segUpdate.json'/>?" + param, function(data) {
        		if(data.result == "Success") {
        			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
        			
        			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
        		} else if(data.result == "Fail") {
        			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
        		}
        	});
        } else return;
    } else {
    	var param = $("#segInfoForm").serialize();
    	$.getJSON("<c:url value='/ems/seg/segUpdate.json'/>?" + param, function(data) {
    		if(data.result == "Success") {
    			alert("<spring:message code='COMJSALT010'/>");	// 수정 성공
    			
    			$("#searchForm").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
    		} else if(data.result == "Fail") {
    			alert("<spring:message code='COMJSALT011'/>");	// 수정 실패
    		}
    	});
    }
}

//복구 버튼 클릭시
function goEnable() {
	$("#status").val("000");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='CAMJSALT027'/>");		// 복구성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='CAMJSALT029'/>");		// 복구실패
		}
	});
}

//사용중지 버튼 클릭 시
function goDisable() {
	$("#status").val("001");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='CAMJSALT028'/>");		// 사용중지성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='CAMJSALT030'/>");		// 사용중지실패
		}
	});
}

//삭제 버튼 클릭 시
function goDelete() {
	$("#status").val("002");
    var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segDelete.json'/>?" + param, function(data) {
		if(data.result == 'Success') {
			alert("<spring:message code='COMJSALT012'/>");		// 삭제 성공
			$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
		} else if(data.result == 'Fail') {
			alert("<spring:message code='COMJSALT013'/>");		// 삭제 실패
		}
	});
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

//리스트로 이동
function goList() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
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
			<input type="hidden" id="segNo"    name="segNo"    value="<c:out value='${segmentInfo.segNo}'/>">
			<input type="hidden" id="dbConnNo" name="dbConnNo" value="<c:out value='${segmentInfo.dbConnNo}'/>">
			<input type="hidden" id="status"   name="status"   value="<c:out value='${segmentInfo.status}'/>">
			<input type="hidden" id="mergeKey" name="mergeKey" value="<c:out value='${segmentInfo.mergeKey}'/>">
			<input type="hidden" id="mergeCol" name="mergeCol" value="<c:out value='${segmentInfo.mergeCol}'/>">
			<input type="hidden" id="createTy" name="createTy" value="<c:out value='${segmentInfo.createTy}'/>">
			<input type="hidden" id="testType" name="testType">
			
			<p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
			
			<div class="cWrap">
			<div id="divMenu1">
				<table class="nTab">
					<tr>
						<td align="center" id="td_tab1" ><spring:message code='SEGBTN001'/></td><!-- 추출도구이용 -->
						<td align="center" id="td_tab2" class='on'><spring:message code='SEGBTN003'/></td><!-- 직접 SQL 이용 -->
						<td align="center" id="td_tab3"><spring:message code='SEGBTN004'/></td><!-- 파일연동 -->
						<td align="center" id="td_tab4"><spring:message code='SEGBTN005'/></td><!-- 연계서비스지정 -->
					</tr>
				</table>
			</div>
			<div class="nTwrap">
				<table border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
					<colgroup>
						<col style="width:15%;" />
						<col style="width:35%;" />
						<col style="width:15%;" />
						<col style="width:35%;" />
					</colgroup>
					<!-- DB Connection -->
					<tr>
						<td class="td_title" width="100">Connection&nbsp;</td>
						<td class="td_body" width="300">
							<c:set var="dbConnNm" value=""/>
							<c:if test="${fn:length(dbConnList) > 0}">
								<c:forEach items="${dbConnList}" var="dbConn">
									<c:if test="${segmentInfo.dbConnNo == dbConn.dbConnNo}">
										<c:set var="dbConnNm" value="${dbConn.dbConnNm}"/>
									</c:if>
								</c:forEach>
							</c:if>
							<c:out value="${dbConnNm}"/>
			
						</td>
						<td class="td_title" width="100"><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
						<td class="td_body" width="300">
							<input type="text" id="segNm" name="segNm" value="<c:out value='${segmentInfo.segNm}'/>">
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
											<option value="<c:out value='${dept.deptNo}'/>"<c:if test="${segmentInfo.deptNo == dept.deptNo}"> selected</c:if>><c:out value='${dept.deptNm}'/></option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자 -->
							<td class="td_body">
								<select id="userId" name="userId">
									<option value=''>::::<spring:message code='COMTBLLB005'/>::::</option><!-- 사용자 선택 -->
										<c:if test="${fn:length(userList) > 0}"></c:if>
											<c:forEach items="${userList}" var="user">
												<option value="<c:out value='${user.userId}'/>"<c:if test="${segmentInfo.userId eq user.userId}"> selected</c:if>><c:out value='${user.userNm}'/></option>
											</c:forEach>
								</select>
							</td>
						</tr>
					</c:if>
					<!-- DB Connection -->
					<tr align="center">
						<td colspan="4" class="inTable">
						
			                <!-- 연결된 테이블/컬럼 설정 -->
			                <div id="divMetaTableInfo" style="width:985px;height:250px;overflow:auto;"></div>
			                <!-- 연결된 테이블/컬럼 설정 -->			                
							
						</td>
					</tr>
				</table>
			
				<table width="800" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div id="divConditional"></div>
						</td>
					</tr>
				</table>
				<!-- 조건 선택 -->
			
				<!-- 커리문 -->
				<table width="800" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
								<tr>
									<td class="td_title" width="150">Select</td>
									<td class="td_body">
										<div id='divSelect'><textarea id="query" name="query" style="width:870px;height:200px;"><c:out value="${segmentInfo.query}"/></textarea></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				
				<!-- 커리문 -->
				<div class="btn">
					<div class="left">
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
						<input type="text" id="totCnt" name="totCnt" value="<c:out value='${segmentInfo.totCnt}'/>" size="9" readonly>
					</div>
					<div class="right">
						<input type="button" class="btn_typeC" value="QUERY TEST" onClick="goQueryTest('000')">
						<c:if test="${'002' eq segmentInfo.status}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goQueryTest('003')"><!-- 수정 -->
						</c:if>
						<c:if test="${'001' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='CAMBTN013'/>" onClick="goEnable()"><!-- 복구 -->
						</c:if>
						<c:if test="${'000' eq segmentInfo.status}">
							<input type="button" class="btn_style" value="<spring:message code='COMBTN006'/>" onClick="goDisable()"><!-- 사용중지 -->
						</c:if>
						
						<c:if test="${'002' ne segmentInfo.status}">
						<input type="button" class="btn_style" value="<spring:message code='COMBTN008'/>" onClick="goDelete()"><!-- 삭제 -->
						</c:if>
			
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN007'/>" onClick="goQueryTest('002')"><!-- 대상자보기 -->
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
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
