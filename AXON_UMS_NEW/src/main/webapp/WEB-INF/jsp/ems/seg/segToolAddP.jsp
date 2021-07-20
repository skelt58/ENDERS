<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.20
	*	설명 : 추출도구 입력폼 화면
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

function goCreateTy(no) {
    if(no == '000') {   // 추출도구이용
        //goSqlEdit('000');
        return;
    }
    
    var actionUrl;
    if(no == '000') actionUrl = "<c:url value='/ems/seg/segToolAddP.ums'/>";    	// 추출도구이용
    if(no == '001') actionUrl = "<c:url value='/ems/seg/segOneClickAddP.ums'/>";    // One Click
    if(no == '002') actionUrl = "<c:url value='/ems/seg/segDirectSQLAddP.ums'/>";	// SQL 직접 입력
    if(no == '003') actionUrl = "<c:url value='/ems/seg/segFileAddP.ums'/>";   		// 파일그룹
    if(no == '004') actionUrl = "<c:url value='/ems/seg/segRemarketAddP.ums'/>";    // 연계 캠페인 지정
    
    $("#searchForm").attr("action", actionUrl).submit();
}

function goSqlEdit(ch) {
    var obj = document.segform;
    var select_ = obj.p_select_.value;
    var from_ = obj.p_from_.value;
    var where_ = obj.p_where_.value;
    var orderby_ = obj.p_orderby_.value;
    var createTy = obj.p_create_ty.value;

    if(ch == createTy) return;
    obj.p_create_ty.value = ch;

    if(ch == "002") {    // 직접입력일 경우
        divSelect.innerHTML = ("<textarea name='p_select_' style='width:610;height:32;' class='readonly_style' readonly>" + select_ + "</textarea>");
        divFrom.innerHTML = ("<textarea name='p_from_' style='width:610;height:28;'>" + from_ + "</textarea>");
        divWhere.innerHTML = ("<textarea name='p_where_' style='width:610;height:80;'>" + where_ + "</textarea>");
        divOrderby.innerHTML = ("<textarea name='p_orderby_' style='width:610;height:28;'>" + orderby_ + "</textarea>");

        divMenu1.style.display = "none";
        divMenu2.style.display = "";
    } else {              // DB Tool일 경우
        divSelect.innerHTML = ("<textarea name='p_select_' style='width:610;height:32;' class='readonly_style' readonly>" + select_ + "</textarea>");
        divFrom.innerHTML = ("<textarea name='p_from_' style='width:610;height:28;' class='readonly_style' readonly>" + from_ + "</textarea>");
        divWhere.innerHTML = ("<textarea name='p_where_' style='width:610;height:80;' class='readonly_style' readonly>" + where_ + "</textarea>");
        divOrderby.innerHTML = ("<textarea name='p_orderby_' style='width:610;height:28;' class='readonly_style' readonly>" + orderby_ + "</textarea>");

        divMenu1.style.display = "";
        divMenu2.style.display = "none";
    }
}

function goReload() {
	//getMetaFrameContent();
	$("#searchForm input[name='dbConnNo']").val($("#dbConnNo").val());
	$("#searchForm").attr("action","<c:url value='/ems/seg/segToolAddP.ums'/>").submit();
}

function getUserList(deptNo) {
	$.getJSON("<c:url value='/com/getUserList.json'/>?deptNo=" + deptNo, function(data) {
		$("#userId").children("option:not(:first)").remove();
		$.each(data.userList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#userId").append(option);
		});
	});
}

// 메타 테이블 컨텐츠 생성
function getMetaFrameContent() {
	var dbConnNo = $("#dbConnNo").val();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/segMetaFrameP.ums'/>?dbConnNo=" + dbConnNo,
		dataType : "html",
		async: false,
		success : function(pageHtml){
			$("#divMetaTableInfo").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}

// 메타 테이블 체크박스 클릭
function goColumnClick() {
    var selectSql = "";
    var fromSql = "";
    var mergeKey = "";
    var mergeCol = "";

    // 테이블 체크 박스 초기화
    $("input[name='metaTblNm']").each(function(idx, item) {
    	$(item).prop("checked", false);
    });
    
    

    // Select절 구하는 부분
    var cnt = 0;
    $("input[name='metaColInfo']").each(function(x, column) {
    	if($(column).is(":checked") == true) {
    		if(cnt != 0) {
    			selectSql += ", ";
    			mergeKey  += ",";
    			mergeCol  += ",";
    		}
    		selectSql += $(column).val();
    		mergeKey  += $(column).val().substring($(column).val().indexOf(" AS ") + 4);
    		mergeCol  += $(column).val().substring(0, $(column).val().indexOf(" AS "));
    		cnt++;
    		
    		$("input[name='metaTblNm']").each(function(y,table) {
    			if( $(table).val() == $(column).val().substring(0, $(column).val().indexOf(".")) ) {
    				$(table).prop("checked", true);
    			}
    		});
    	}
    });
    
    
    /*
    parent.getFrom_();
    parent.getWhere_();
    parent.document.segform.p_merge_key.value = mergeKey;
    parent.document.segform.p_merge_col.value = mergeCol;
    parent.document.segform.p_select_.value = select_;
    */
}

function getFromSql() {
    var frm = window.document.segform;
    var frmMeta = iFrmMeta.window.document.metaform;

    var arrayFrom_ = new Array();    // from절에 들어갈 모든 테이블명을 넣어 놓는다... 나중에 하니씩 비교를 하여 중복되는 것을 삭제함.

    var j = 0;
    // 이건 Select 절에 필요한 부분에서 From 절 뽑아옴.
    for (i=0; i < frmMeta.length; i++) {
        if(frmMeta.elements[i].name == "tbl_nm") {
            if(frmMeta.elements[i].checked) {
                arrayFrom_[j] = frmMeta.elements[i].value;
                j++;
            }
        }
    }

    // 이건 Where절에 필요한 부분에서 From 절 뽑아옴.
    for (i=frm.length-1; i >= 0; i--) {
        if(frm.elements[i].name == "isLine") {
           if(frm.elements[i].checked) {
                tmpIsLine = frm.elements[i].value.substring(frm.elements[i].value.indexOf("|")+1);;
                arrayFrom_[j] = tmpIsLine.substring(0, tmpIsLine.indexOf("|"));
                j++;
            }
        }
    }

    // 마지막으로 Where절을 하고 있을때(operator와 정렬까지 선택하였을 경우)
    if(frm.p_tbl_nm.value != "") {
        arrayFrom_[j] = frm.p_tbl_nm.value;
        j++;
    }

    var tblCheck = false;                   // arrayFrom_ 과 arrayTemp를 비교하여 false일 경우에만 from_ 에 추가함.
    var arrayTemp = new Array();            // arrayFrom_ 과 비교하기 위해 임시로 저장함.
    var from_ = "";                         // 실질적으로 from절에 들어갈 값

    if(j > 0) {
        arrayTemp[0] = arrayFrom_[0];     // arrayTemp를 초기화함.
        from_ = arrayTemp[0];

        j = 1;
        // 중복 테이블 명을 제거하는 부분
        for(i = 1; i < arrayFrom_.length; i++) {
            tblCheck = false;
            for(iii=0; iii < arrayTemp.length; iii++) {
                if(arrayTemp[iii] == arrayFrom_[i]) tblCheck = true;
            }

            if(!tblCheck) {
                arrayTemp[j] = arrayFrom_[i];
                from_ += ", " + arrayTemp[j];
                j++;
            }
        }
    }
    frm.p_from_.value = from_;
}

function goTblSelect() {
	
	var tempStr = $("#tblInfo").val();
    if(tempStr == "") {
        $("#tblNo").val("");	//obj1.p_tbl_no.value = "";
        $("#tblNm").val("");	//obj1.p_tbl_nm.value = "";
        $("#tblAlias").val("");	//obj1.p_tbl_alias.value = "";
    } else {
    	$("#tblNo").val( tempStr.substring(0, tempStr.indexOf("|")) );	//obj1.p_tbl_no.value = tmp.substring(0, tmp.indexOf("|"));
        $("#tblNm").val( tempStr.substring(tempStr.indexOf("|")+1, tempStr.lastIndexOf("|")) );				//obj1.p_tbl_nm.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        $("#tblAlias").val( tempStr.substring(tempStr.lastIndexOf("|")+1) ); //obj1.p_tbl_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }

	
    var tmp = $("#tblInfo").val();
    var tblNo = tmp.substring(0,tmp.indexOf("|"));
	$.getJSON("<c:url value='/ems/sys/metacolumnList.json'/>?tblNo=" + tblNo, function(data) {
		$("#colInfo").children("option:not(:first)").remove();
		$.each(data.metaColumnList, function(idx,item){
			var option = new Option(item.colAlias,item.colNo + "|" + item.colNm + "|" + item.colDataTyJdbc + "|" + item.colAlias);
			$("#colInfo").append(option);
		});
	});
}

function goColSelect() {
    var tempStr = $("#colInfo").val();
    if(tempStr == "") {
        $("#colNo").val("");		//obj1.p_col_no.value = "";
        $("#colNm").val("");		//obj1.p_col_nm.value = "";
        $("#colDataTy").val("");	//obj1.p_col_data_ty.value = "";
        $("#colAlias").val("");		//obj1.p_col_alias.value = "";
    } else {
        $("#colNo").val( tempStr.substring(0, tempStr.indexOf("|")) );								//obj1.p_col_no.value = tmp.substring(0, tmp.indexOf("|"));
        tempStr = tempStr.substring(tempStr.indexOf("|")+1);
        $("#colNm").val( tempStr.substring(0, tempStr.indexOf("|")) );								//obj1.p_col_nm.value = tmp.substring(0, tmp.indexOf("|"));
        $("#colDataTy").val( tempStr.substring(tempStr.indexOf("|")+1, tempStr.lastIndexOf("|")) );	//obj1.p_col_data_ty.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        $("#colAlias").val( tempStr.substring(tempStr.lastIndexOf("|")+1) );						//obj1.p_col_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }	
	
    var tmp = $("#colInfo").val();
    var colNo = tmp.substring(0,tmp.indexOf("|"));
    
    // 추출값(관계값) 설정
	$.getJSON("<c:url value='/ems/sys/metavalList.json'/>?colNo=" + colNo, function(data) {
		if(data.metaValueList.length > 0) {
			$("#valueInfoDisplay").empty();
			
			var valueHtml = "";
			valueHtml += "<select id='valueInfo' name='valueInfo' onchange='goValueSelect();' style='width:120px;'>";
			valueHtml += "<option value='''>-----------------</option>";
			valueHtml += "</select>";
			
			$("#valueInfoDisplay").html(valueHtml);
			
			$("#valueInfo").children("option:not(:first)").remove();
			$.each(data.metaValueList, function(idx,item){
				var option = new Option(item.valueAlias,item.valueNo + "|" + item.valueNm + "|" + item.valueAlias);
				$("#valueInfo").append(option);
			});
		} else {
			$("#valueInfoDisplay").empty();
			var valueHtml = "<input type='text' id='valueInfo' name='valueInfo' onkeyup='goValueSelect()' style='width:120px;'>";
			$("#valueInfoDisplay").html(valueHtml);
		}
	});
	
	// 조건식(관계식) 설정
	$.getJSON("<c:url value='/ems/sys/metaoperList.json'/>?colNo=" + colNo, function(data) {
		$("#operInfo").children("option:not(:first)").remove();
		$.each(data.metaOperatorList, function(idx,item){
			var option = new Option(item.operAlias,item.operNo + "|" + item.operNm + "|" + item.operAlias);
			$("#operInfo").append(option);
		});
	});
}

function goValueSelect() {
    var obj1 = document.segform;
    var vobj = iFrmValue.window.document.valform;
    var tmp = vobj.value_info.value;

    var tempStr = $("#valueInfo").val();
    if(tmp == "") {
        obj1.p_value_no.value = "";
        obj1.p_value_nm.value = "";
        obj1.p_value_alias.value = "";
    } else if(tmp.indexOf("|") == -1) {
        obj1.p_value_no.value = "none";
        obj1.p_value_nm.value = tmp;
        obj1.p_value_alias.value = tmp;
    } else {
        obj1.p_value_no.value = tmp.substring(0, tmp.indexOf("|"));
        obj1.p_value_nm.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        obj1.p_value_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }

}

function goOperSelect() {
    var obj1 = document.segform;
    var oobj = iFrmOper.window.document.operform;
    // var tmp = oobj.oper_info.options[oobj.oper_info.selectedIndex].value;
    var tmp = oobj.oper_info.value;

    if(tmp == "") {
        obj1.p_oper_no.value = "";
        obj1.p_oper_nm.value = "";
        obj1.p_oper_alias.value = "";
    } else {
        obj1.p_oper_no.value = tmp.substring(0, tmp.indexOf("|"));
        obj1.p_oper_nm.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        obj1.p_oper_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }

    if(obj1.p_value_nm.value == "") {
        alert("<%= util.getUILang(request,"SEGJSALT011") %>");
        oobj.oper_info.selectedIndex = 0;
        return;
    }

}

function fRelSelect() {
    //var frm = window.document.segform;
    //var frmCol = iFrmCol.window.document.colform;
    //var frmValue = iFrmValue.window.document.valform;
    //var frmOper = iFrmOper.window.document.operform;

    var temp = "";
    var sort = "";
    var colAlias = "";
    var ii;

    if($("#tblInfo").val() == "") {
        alert("<spring:message code='SEGJSALT012'/>");		// 테이블을 선택해 주세요.
        $("#sort option:eq(0)").prop("selected",true);
        return;
    }

    if($("#colInfo").val() == "") {
        alert("<spring:message code='SEGJSALT013'/>");		// 컬럼을 선택해 주세요.
        $("#sort option:eq(0)").prop("selected",true);
        return;
    }

    if($("#valueInfo").val() == "") {
        alert("<spring:message code='SEGJSALT011'/>");		// 추출값을 선택해 주세요.
        frm.sort.selectedIndex = 0;
        return;
    }
    
    if($("#operInfo").val() == "") {
        alert("<spring:message code='SEGJSALT014'/>");		// 조건식을 선택해 주세요.
        frm.sort.selectedIndex = 0;
        return;
    }

    colAlias = $("#colAlias").val();

    temp = $("#sort").val().substring($("#sort").val().indexOf("|")+1);
    if(temp != "") sort = temp;

    if($("#valueInfo").val().indexOf("|") == -1) {
    	$("#valueInfo").val( $("#valueInfo").val()+"|"+$("#valueInfo").val()+"|"+$("#valueInfo").val() );
    }

    var condHTML = "";

    var isLine = new Array(16);

     condHTML = "<table>"
        +"<tr> "
        +"    <td> "
        +"       <table class='table_line_outline'>";

    var frm = document.segInfoForm;
    for(i=frm.length-1; i >= 0; i--) {
       if(frm.elements[i].name == "isLine") {
           if(frm.elements[i].checked) {
                temp = frm.elements[i].value;
                ii = temp.indexOf("|");
                isLine[0] = temp.substring(0, ii);

                for(kk = 1; kk <= 14; kk++) {
                    temp = temp.substring(ii+1);
                    ii = temp.indexOf("|");
                    isLine[kk] = temp.substring(0, ii);
                }
                if(isLine[14] == "none") isLine[14] = "&nbsp;";
                isLine[15] = temp.substring(ii+1);

                // isLine[2] : 테이블 알리아스
                // isLine[6] : 컬럼 알리아스
                // isLine[9] : Value 알리아스
                // isLine[12] : Operator 알리아스
                // isLine[14] : Sort 알리아스(none일경우 ""로 변경)
                // isLine[15] : 관계(And/Or)

                condHTML += "        <tr class='tr_body'> "
                    +"            <td><input type='checkbox' name='isLine' value='"+frm.elements[i].value+"' onclick='goIsLineClick();' checked></td>"
                    +"            <td>"+ isLine[2] +"</td>"
                    +"            <td>"+ isLine[6] +"</td>"
                    +"            <td>"+ isLine[9] +"</td>"
                    +"            <td>"+ isLine[12] +"</td>"
                    +"            <td>"+ isLine[14] +"</td>"
                    +"            <td>"+ isLine[15] +"</td>"
                    +"        </tr>";
            }
        }
    }

    var tmpSort = "";

    if(frm.sort.value == "") tmpSort = "none|none";
    else tmpSort = frm.sort.value;

    condHTML += "        <tr class='tr_body'> "
        +"            <td><input type='checkbox' name='isLine' value='"+ frm.tblInfo.value +"|"+ frm.colInfo.value +"|"+ frm.valueNo.value +"|"+ frm.valueNm.value +"|"+ frm.valueAlias.value +"|"+ frm.operInfo.value +"|"+ tmpSort +"|"+ frm.whereRel.value +"' onclick='goIsLineClick();' checked></td>"
        +"            <td>"+ frm.tblAlias.value +"</td>"
        +"            <td>"+ frm.colAlias.value +"</td>"
        +"            <td>"+ frm.valueAlias.value +"</td>"
        +"            <td>"+ frm.operAlias.value +"</td>"
        +"            <td>"+ sort +"</td>"
        +"            <td>"+ frm.whereRel.value +"</td>"
        +"        </tr>"
        +"        </table>"
        +"    </td>"
        +"</tr>"
        +"</table>";

    divConditional.innerHTML = (condHTML);


	/*
    // 테이블, 컬럼, value, operator, 정렬, 관계식등을 초기화함.
    frm.tbl_info.selectedIndex = 0;
    iFrmCol.document.location.href= "/seg/segMetaColFrameP.jsp";
    iFrmValue.document.location.href= "/seg/segMetaValFrameP.jsp";
    iFrmOper.document.location.href= "/seg/segMetaOperFrameP.jsp";
    frm.sort.selectedIndex = 0;
    frm.whereRel.selectedIndex = 0;

    frm.p_tbl_no.value = "";
    frm.p_tbl_nm.value = "";
    frm.p_tbl_alias.value = "";
    frm.p_col_no.value = "";
    frm.p_col_nm.value = "";
    frm.p_col_data_ty.value = "";
    frm.p_col_alias.value = "";
    frm.p_value_no.value = "";
    frm.p_value_nm.value = "";
    frm.p_value_alias.value = "";
    frm.p_oper_no.value = "";
    frm.p_oper_nm.value = "";
    frm.p_oper_alias.value = "";

    getFrom_();
    getWhere_();
    getOrderby_();
    */
	alert("A");
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
			<!-- new title -->
    		<p class="title_default"><spring:message code="SEGTBLTL001"/></p><!-- 발송대상그룹 -->
    		<!-- //new title -->
			<div class="cWrap">
				<div id="divMenu1">
		     		<table class="nTab" cellspacing="5">
			     	<tr>
		         	<td align="center" class="on"><a href="JavaScript:goCreateTy('000')"><spring:message code='SEGBTN001'/></a></td><!-- 추출도구이용 -->
		         	<td align="center"><a href="JavaScript:goCreateTy('002')"><spring:message code='SEGBTN003'/></a></td><!-- 직접 SQL 이용 -->
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
            <td class="td_title">Connection</td>
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
            <td class="td_title"><spring:message code='SEGTBLTL002'/></td><!-- 발송대상그룹명 -->
            <td class="td_body">
                <input type="text" id="segNm" name="segNm">
            </td>
        </tr>
        <!-- 관리자의 경우 전체 요청부서를 전시하고 그 외의 경우에는 해당 부서만 전시함 -->
        <c:if test="${'Y' eq NEO_ADMIN_YN}">
        <tr>
            <td class="td_title"><spring:message code='COMTBLTL004'/></td><!-- 사용자그룹 -->
            <td class="td_body">
                <select id="deptNo" name="deptNo" onchange="getUserList(this.value);">
                    <option value=''>::::<spring:message code='COMTBLLB004'/>::::</option><!-- 그룹 선택 -->
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
        <tr>
            <td colspan="4" class="inTable">
            
                <!-- 연결된 테이블/컬럼 설정 -->
                <div id="divMetaTableInfo"></div>
                <!-- 연결된 테이블/컬럼 설정 -->
                
            </td>
        </tr>
        </table>
        
        <table class="table_line_outline resize">    	
        	<colgroup>
        		<col style="width:15%">
        		<col style="width:15%">
        		<col style="width:15%">
        		<col style="width:15%">
        		<col style="width:15%">
        		<col style="width:15%">
        		<col style="width:10%">
        	</colgroup>
        	<tr class="tr_head">
                    <td><spring:message code='SEGTBLTL007'/></td><!-- 테이블 -->
                    <td><spring:message code='SEGTBLTL008'/></td><!-- 컬럼 -->
                    <td><spring:message code='SEGTBLTL009'/></td><!-- 추출값 -->
                    <td><spring:message code='SEGTBLTL010'/></td><!-- 조건식 -->
                    <td><spring:message code='SEGTBLTL011'/></td><!-- 정렬 -->
                    <td><spring:message code='SEGTBLTL012'/></td><!-- 관계식 -->
                    <td><spring:message code='COMBTN005'/></td><!-- 등록 -->
             </tr>
             <tr>
             	<td>
					<select id="tblInfo" name="tblInfo" onchange="goTblSelect()" style="width:120px;">
                            <option value="">------- 선택-------</option>
                            <c:if test="${fn:length(metaTableList) > 0}">
                            	<c:forEach items="${metaTableList}" var="metaTable">
                            		<option value="<c:out value='${metaTable.tblNo}'/>|<c:out value='${metaTable.tblNm}'/>|<c:out value='${metaTable.tblAlias}'/>"><c:out value='${metaTable.tblAlias}'/></option>
                            	</c:forEach>
                            </c:if>
                    </select>
                </td>
             	<td>
             		<select id="colInfo" name='colInfo' onchange='goColSelect()' style="width:120px;">
             			<option value="">-----------------</option>
             		</select>
                </td>
             	<td id="valueInfoDisplay">
             		<input type="text" id="valueInfo" name="valueInfo" onkeyup="goValueSelect()" style="width:120px;">
                </td>
                <td>
					<select id="operInfo" name='operInfo' onchange='goOperSelect()' style="width:120px;">
        				<option value="">-----------------</option>
				    </select>
                </td>
             	<td>
             		<select id="sort" name="sort" class="w130" onchange='goSortSelect();' style="width:120px;">
                            <option value="" selected>------- 선택-------</option>
                            <option value="ASC|올림"><spring:message code='SEGTBLLB017'/></option><!-- 올림 -->
                            <option value="DESC|내림"><spring:message code='SEGTBLLB018'/></option><!-- 내림 -->
                    </select>
             	</td>
             	<td>
             		<select id="whereRel" name="whereRel" class="w130" style="width:120px;">
                            <option value="" selected>------- 선택-------</option>
                            <option value="AND">AND</option>
                            <option value="OR">OR</option>
                        </select>
             	</td>
             	<td><input type="button" class="btn_style" value="<spring:message code='COMBTN005'/>" onClick="fRelSelect()"></td><!-- 등록 -->
             </tr>         
        </table>
	    
	    <!--  등록 리스트  -->
	    <div id="divConditional"></div>

        <!-- 커리문 -->
        <c:set var="readonly" value=""/>
        <c:if test="${'000' eq createTy}">
        	<c:set var="readonly" value=" readonly"/>
        </c:if>
	    <table class="table_line_outline">
	    	<tr>
	        	<td class="td_title" width="150">Select</td>
	          	<td class="td_body">
	              	<div id='divSelect'><textarea class="tArea" id="selectSql" name="selectSql"<c:out value='${readonly}'/>></textarea></div>
	          </td>
	      </tr>
	      <tr>
	          <td class="td_title">Form</td>
	          <td class="td_body">
	              <div id='divFrom'><textarea class="tArea" id="fromSql" name="fromSql" <c:out value='${readonly}'/>> </textarea></div>
	          </td>
	      </tr>
	      <tr>
	          <td class="td_title">Where</td>
	          <td class="td_body">
	              <div id='divWhere'><textarea class="tArea" id="whereSql" name="whereSql" <c:out value='${readonly}'/>> </textarea></div>
	          </td>
	      </tr>
	      <tr>
	          <td class="td_title">Order by</td>
	          <td class="td_body">
	              <div id='divOrderby'><textarea class="tArea" id="orderbySql" name="orderbySql" <c:out value='${readonly}'/>> </textarea></div>
	          </td>
	      </tr>
	  </table>
        <!-- 커리문 -->
        <div class="btn">
        <div class="left">
	        <input type="button" class="btn_style" value="<spring:message code='SEGBTN006'/>" onClick="goSegCnt()"><!-- 대상자수추출 -->
	        <input type="text" name="totCnt" size="10" class='readonly_style' readonly>
	        <spring:message code='SEGTBLLB015'/><!-- 명 -->
        
       	      <input type="hidden" id="mergeKey" name="mergeKey" style="width:0;" readonly>
              <input type="hidden" id="mergeCol" name="mergeCol" style="width:0;" readonly>
              <input type="hidden" id="srcWhere" name="srcWhere" style="width:0;" readonly>
              <input type="hidden" id="createTy" name="createTy" value="<c:out value='${createTy}'/>" style="width:0;" readonly>


              <!-- 커리 조건 선택에 필요한 값들 -->
              <input type="hidden" id="tblNo" name="tblNo" style="width:0;" readonly>
              <input type="hidden" id="tblNm" name="tblNm" style="width:0;" readonly>
              <input type="hidden" id="tblAlias" name="tblAlias" style="width:0;" readonly>

              <input type="hidden" id="colNo" name="colNo" style="width:0;" readonly>
              <input type="hidden" id="colNm" name="colNm" style="width:0;" readonly>
              <input type="hidden" id="colDataTy" name="colDataTy" style="width:0;" readonly>
              <input type="hidden" id="colAlias" name="colAlias" style="width:0;" readonly>

              <input type="hidden" id="operNo" name="operNo" style="width:0;" readonly>
              <input type="hidden" id="operNm" name="operNm" style="width:0;" readonly>
              <input type="hidden" id="operAlias" name="operAlias" style="width:0;" readonly>

              <input type="hidden" id="valueNo" name="valueNo" style="width:0;" readonly>
              <input type="hidden" id="valueNm" name="valueNm" style="width:0;" readonly>
              <input type="hidden" id="valueAlias" name="valueAlias" style="width:0;" readonly>
              <!-- 커리 조건 선택에 필요한 값들 -->
        
        </div>
       	<div class="btnR">
	      	<input type="button" class="btn_typeC" value="<spring:message code='COMBTN005'/>" onClick="goAdd()">
	        <input type="button" class="btn_typeG" value="<spring:message code='SEGBTN007'/>" onClick="goSegInfo()">
	        <input type="button" class="btn_typeG" value="<spring:message code='COMBTN010'/>" onClick="goList()">
    	 </div>
      </div> 
      <table>
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
