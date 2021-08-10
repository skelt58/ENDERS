<%--
	/**********************************************************
	*	작성자 : 김상진
	*	작성일시 : 2021.07.22
	*	설명 : 발송대상(세그먼트) 추출도구이용 수정 화면
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
	goLoad();
	getMetaFrameContent();
});

// 조건부분 초기화
function goLoad() {
    var srcWhere = "<c:out value='${srcWhere}'/>";

    var isLine = new Array(16);
    var allLine = new Array();     // isLine에 표현될 값
    var lastIsLine = "";                // 콤보박스에 표현될 값

    var pos = -1;
    var tmp = "";
    var i_ps = 0;

    pos = srcWhere.indexOf("##");

    while(pos != -1) {
        tmp = srcWhere.substring(0, pos);
        srcWhere = srcWhere.substring(pos+2);

        allLine[i_ps++] = tmp;
        pos = srcWhere.indexOf("##");
    }
    lastIsLine = srcWhere;  // 콤보박스에 표현될 값

    var condHTML = "";

    condHTML = "<table width='100%' border='1' cellspacing='0' cellpadding='0' class='table_line_outline'>";

    for(i =0; i < allLine.length; i++) {
        temp = allLine[i];

        ii = temp.indexOf("|");
        isLine[0] = temp.substring(0, ii);

        for(kk = 1; kk <= 14; kk++) {
            temp = temp.substring(ii+1);
            ii = temp.indexOf("|");
            isLine[kk] = temp.substring(0, ii);
        }

        isLine[15] = temp.substring(ii+1);

        // tblInfo = 0. p_tbl_no|1. p_tbl_nm|2. p_tbl_alias
        // colInfo = 3. p_col_no|4. p_col_nm|5. p_col_data_ty|6. p_col_alias
        // valueInfo = 7. p_value_no|8. p_value_nm|9. p_value_alias
        // operInfo = 10. p_oper_no|11. p_oper_nm|12. p_oper_alias
        // sort = 13. sort_nm|14. sort_alias(NULL일 경우 none|noen가 들어감)
        // whereRel = 15. 관계식(AND 또는 OR)

        if(isLine[14] == 'none') temp_sort = "&nbsp;";
        else temp_sort = isLine[14];
        condHTML += "        <tr  class='tr_body'> "
            +"            <td width='25' align='center'><input type='checkbox' name='isLine' value='"+allLine[i]+"' onclick='goIsLineClick();' checked></td>"
            +"            <td width='170'>"+ isLine[2] +"</td>"
            +"            <td width='170'>"+ isLine[6] +"</td>"
            +"            <td width='145'>"+ isLine[9] +"</td>"
            +"            <td width='160'>"+ isLine[12] +"</td>"
            +"            <td width='60'>"+ temp_sort +"</td>"
            +"            <td width='70'>"+ isLine[15] +"</td>"
            +"        </tr>";
    }

    condHTML += "        </table>";


    divConditional.innerHTML = (condHTML);

    // 콤보박스로 조건절을 선택하는 부분
    temp = lastIsLine;

    if(temp != "") {
        ii = temp.indexOf("|");
        isLine[0] = temp.substring(0, ii);

        for(kk = 1; kk <= 13; kk++) {
            temp = temp.substring(ii+1);
            ii = temp.indexOf("|");
            isLine[kk] = temp.substring(0, ii);
        }
        isLine[14] = temp.substring(ii+1);

        // 콤보박스를 표현해 주는 부분
        $("#tblInfo").val( isLine[0]+"|"+isLine[1]+"|"+isLine[2] );
        $("#tblNo").val( isLine[0] );
        $("#tblNm").val( isLine[1] );
        $("#tblAlias").val( isLine[3] );

        $("#colInfo").val( isLine[3]+"|"+isLine[4]+"|"+isLine[5]+"|"+isLine[6] );
        $("#colNo").val( isLine[3] );
        $("#colNm").val( isLine[4] );
        $("#colDataTy").val( isLine[5] );
        $("#colAlias").val( isLine[6] );

        if($("#valueInfo").attr("type") == 'text')
            $("#valueInfo").val( isLine[8] );
        else
            $("#valueInfo").val( isLine[7]+"|"+isLine[8]+"|"+isLine[9] );

        $("#valueNo").val( isLine[7] );
        $("#valueNm").val( isLine[8] );
        $("#valueAlias").val( isLine[9] );

        $("#operInfo").val( isLine[10]+"|"+isLine[11]+"|"+isLine[12] );
        $("#operNo").val( isLine[10] );
        $("#operNm").val( isLine[11] );
        $("#operAlias").val( isLine[12] );

        if(isLine[13] != 'none') $("#sort").val( isLine[13]+"|"+isLine[14] );
    }
}

//메타 테이블 컨텐츠 생성
function getMetaFrameContent() {
	var dbConnNo = $("#dbConnNo").val();
	var mergeCol = $("#mergeCol").val();
	$.ajax({
		type : "GET",
		url : "<c:url value='/ems/seg/segMetaFrameP.ums'/>?dbConnNo=" + dbConnNo + "&mergeCol=" + mergeCol,
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

//메타 테이블 체크박스 클릭
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
    
    getFromSql();
    getWhereSql();
    $("#mergeKey").val(mergeKey);
    $("#mergeCol").val(mergeCol);
    $("#selectSql").val(selectSql);
}

//조회조건 테이블 선택시
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

//조회조건 컬럼 선택시
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

//조회조건 추출값 선택시
function goValueSelect() {

    var tempStr = $("#valueInfo").val();
    if(tempStr == "") {
        $("#valueNo").val("");			//obj1.p_value_no.value = "";
        $("#valueNm").val("");			//obj1.p_value_nm.value = "";
        $("#valueAlias").val("");		//obj1.p_value_alias.value = "";
    } else if(tempStr.indexOf("|") == -1) {
        $("#valueNo").val("0");				//obj1.p_value_no.value = "none";
        $("#valueNm").val( tempStr );		//obj1.p_value_nm.value = tmp;
        $("#valueAlias").val( tempStr );	//obj1.p_value_alias.value = tmp;
    } else {
        $("#valueNo").val( tempStr.substring(0, tempStr.indexOf("|")) );							// obj1.p_value_no.value = tmp.substring(0, tmp.indexOf("|"));
        $("#valueNm").val( tempStr.substring(tempStr.indexOf("|")+1, tempStr.lastIndexOf("|")) );	//obj1.p_value_nm.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        $("#valueAlias").val( tempStr.substring(tempStr.lastIndexOf("|")+1) );						//obj1.p_value_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }
}

// 조회조건 조건식 선택시
function goOperSelect() {
    var tempStr = $("#operInfo").val();
    if(tempStr == "") {
        $("#operNo").val("");		//obj1.p_oper_no.value = "";
        $("#operNm").val("");		//obj1.p_oper_nm.value = "";
        $("#operAlias").val("");	//obj1.p_oper_alias.value = "";
    } else {
        $("#operNo").val( tempStr.substring(0, tempStr.indexOf("|")) );								//obj1.p_oper_no.value = tmp.substring(0, tmp.indexOf("|"));
        $("#operNm").val( tempStr.substring(tempStr.indexOf("|")+1, tempStr.lastIndexOf("|")) );	//obj1.p_oper_nm.value = tmp.substring(tmp.indexOf("|")+1, tmp.lastIndexOf("|"));
        $("#operAlias").val( tempStr.substring(tempStr.lastIndexOf("|")+1) );						// obj1.p_oper_alias.value = tmp.substring(tmp.lastIndexOf("|")+1);
    }

    if($("#valueNm").val() == "") {
        alert("<spring:message code='SEGJSALT011'/>");		// 추출값을 선택해 주세요.
        $("#operInfo option:eq(0)").prop("selected",true);
        return;
    }
}

//조회조건 정렬 선택하였을 경우
function goSortSelect() {

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
        $("#sort option:eq(0)").prop("selected",true);
        return;
    }

    if($("#operInfo").val() == "") {
        alert("<spring:message code='SEGJSALT014'/>");		// 조건식을 선택해 주세요.
        $("#sort option:eq(0)").prop("selected",true);
        return;
    }
}

//조회조건 등록 클릭시
function fRelSelect() {
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
        $("#sort option").eq(0).prop("selected",true);
        return;
    }
    
    if($("#operInfo").val() == "") {
        alert("<spring:message code='SEGJSALT014'/>");		// 조건식을 선택해 주세요.
        $("#sort option").eq(0).prop("selected",true);
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

     condHTML = "<table width='800'>"
        +"<tr> "
        +"    <td> "
        +"       <table border='1' cellspacing='0' class='table_line_outline' width='100%'>";

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

    if($("#sort").val() == "") tmpSort = "none|none";
    else tmpSort = $("#sort").val();

    condHTML += "        <tr class='tr_body'> ";
    condHTML += "            <td><input type='checkbox' name='isLine' value='"+ $("#tblInfo").val() +"|"+ $("#colInfo").val() +"|"+ $("#valueNo").val() +"|"+ $("#valueNm").val() +"|"+ $("#valueAlias").val() +"|"+ $("#operInfo").val() +"|"+ tmpSort +"|"+ $("#whereRel").val() +"' onclick='goIsLineClick();' checked></td>";
    condHTML += "            <td>"+ frm.tblAlias.value +"</td>";
    condHTML += "            <td>"+ frm.colAlias.value +"</td>";
    condHTML += "            <td>"+ frm.valueAlias.value +"</td>";
    condHTML += "            <td>"+ frm.operAlias.value +"</td>";
    condHTML += "            <td>"+ sort +"</td>";
    condHTML += "            <td>"+ frm.whereRel.value +"</td>";
    condHTML += "        </tr>";
    condHTML += "        </table>";
    condHTML += "    </td>"
    condHTML += "</tr>"
    condHTML += "</table>";

    divConditional.innerHTML = (condHTML);


    // 테이블, 컬럼, value, operator, 정렬, 관계식등을 초기화함.
    $("#tblInfo option").eq(0).prop("selected",true);
    $("#colInfo").children("option:not(:first)").remove();
	$("#valueInfoDisplay").empty();
	var valueHtml = "<input type='text' id='valueInfo' name='valueInfo' onkeyup='goValueSelect()' style='width:120px;'>";
	$("#valueInfoDisplay").html(valueHtml);
	$("#operInfo").children("option:not(:first)").remove();
    $("#sort option").eq(0).prop("selected",true);
    $("#whereRel option").eq(0).prop("selected",true);

    $("#tblNo").val("");			//frm.p_tbl_no.value = "";
    $("#tblNm").val("");			//frm.p_tbl_nm.value = "";
    $("#tblAlias").val("");			//frm.p_tbl_alias.value = "";
    $("#colNo").val("");			//frm.p_col_no.value = "";
    $("#colNm").val("");			//frm.p_col_nm.value = "";
    $("#colDataTy").val("");		//frm.p_col_data_ty.value = "";
    $("#colAlias").val("");			//frm.p_col_alias.value = "";
    $("#valueNo").val("");			//frm.p_value_no.value = "";
    $("#valueNm").val("");			//frm.p_value_nm.value = "";
    $("#valueAlias").val("");		//frm.p_value_alias.value = "";
    $("#operNo").val("");			//frm.p_oper_no.value = "";
    $("#operNm").val("");			//frm.p_oper_nm.value = "";
    $("#operAlias").val("");		//frm.p_oper_alias.value = "";

    getFromSql();
    getWhereSql();
    getOrderbySql();
}

//조건식을 선택하였을 경우
function goIsLineClick() {
    getOrderbySql();
    getWhereSql();
    getFromSql();
}




//From절을 얻어온다..........
//isLins에 들어가는 순서
//tblInfo = tblNo|tblNm|tblAlias
//colInfo = colNo|colNm|colDataTy|colAlias
//valueInfo = valueNo|valueNm|valueAlias
//operInfo = operNo|operNm|operAlias
//sort = sortNm|sortAlias(NULL일 경우 none|none가 들어감)
//whereRel = 관계식(AND 또는 OR)
function getFromSql() {
	var arrayFromSql = new Array();    // from절에 들어갈 모든 테이블명을 넣어 놓는다... 나중에 하니씩 비교를 하여 중복되는 것을 삭제함.
	var j = 0;
	// 이건 Select 절에 필요한 부분에서 From 절 뽑아옴.
	$("input[name='metaTblNm']").each(function(idx,item){
 		if($(item).is(":checked") == true) {
 			arrayFromSql[j] = $(item).val();
 			j++;
 		}
 	});

	// 이건 Where절에 필요한 부분에서 From 절 뽑아옴.
	$("input[name='isLine']").each(function(idx,item){
 		if($(item).is(":checked") == true) {
 			var tempIsLine = $(item).val().substring($(item).val().indexOf("|")+1);
 			arrayFromSql[j] = tempIsLine.substring(0, tempIsLine.indexOf("|"));
 			j++;
 		}
	});

	// 마지막으로 Where절을 하고 있을때(operator와 정렬까지 선택하였을 경우)
 	if($("#tblNm").val() != "") {
    	arrayFromSql[j] = $("#tblNm").val();
    	j++;
	}

	var tblCheck = false;                   // arrayFromSql 과 arrayTemp를 비교하여 false일 경우에만 fromSql 에 추가함.
	var arrayTemp = new Array();            // arrayFromSql 과 비교하기 위해 임시로 저장함.
	var fromSql = "";                       // 실질적으로 from절에 들어갈 값

	if(j > 0) {
		arrayTemp[0] = arrayFromSql[0];     // arrayTemp를 초기화함.
		fromSql = arrayTemp[0];

		j = 1;
		// 중복 테이블 명을 제거하는 부분
		for(i = 1; i < arrayFromSql.length; i++) {
			tblCheck = false;
			for(iii=0; iii < arrayTemp.length; iii++) {
				if(arrayTemp[iii] == arrayFromSql[i]) tblCheck = true;
       		}

			if(!tblCheck) {
				arrayTemp[j] = arrayFromSql[i];
				fromSql += ", " + arrayTemp[j];
				j++;
			}
		}
	}
	$("#fromSql").val(fromSql);
}

//Where절을 얻어온다..........
function getWhereSql() {
    var isLine = new Array(16);
    var temp = "";
    var ii;

    var whereSql = "";

    var tblNm = "";
    var colNm = "";
    var colDataTy = "";   // 데이타 타입
    var colRel = "";        //조건식
    var valueNm = "";

    var srcWhere = "";      // 조건절의 모든 부분을 여기에 저장함.

    var pos = -1;

    $("input[name='isLine']").each(function(idx,item){
    	if($(item).is(":checked") == true) {
    		temp = $(item).val();
    		srcWhere += temp + "##";
    		
    		ii = temp.indexOf("|");
    		isLine[0] = temp.substring(0, ii);
    		
    		for(kk = 1;kk<=14;kk++) {
    			temp = temp.substring(ii+1);
    			ii = temp.indexOf("|");
    			isLine[kk] = temp.substring(0, ii);
    		}
    		isLine[15] = temp.substring(ii+1);
    		
            // 조건식을 만든다.
            if(isLine[11].toUpperCase() == "PLIKE" || isLine[11].toUpperCase() == "SLIKE") whereSql += isLine[1] + "." + isLine[4] + " LIKE ";
            else whereSql += isLine[1] + "." + isLine[4] + " " + isLine[11] + " ";

            // tblInfo   = 0. tblNo|1. tblNm|2. tblAlias
            // colInfo   = 3. colNo|4. colNm|5. colDataTy|6. colAlias
            // valueInfo = 7. valueNo|8. valueNm|9. valueAlias
            // operInfo  = 10. operNo|11. operNm|12. operAlias
            // sort      = 13. sortNm|14. sortAlias(NULL일 경우 none|none가 들어감)
            // whereRel  = 15. 관계식(AND 또는 OR)
            // =, <>, >, < ,  >=, <=, != 등은 그대로
            // in 일 경우 괄호를 삽입
            // like일 경우 %를 양쪽으로 삽입
            if(!checkDBStrType(colDataTy)) {    // ums.common.js에 존제
                if(isLine[11].toUpperCase() == "IN" || isLine[11].toUpperCase() == "NOT IN") {
                    whereSql += "(" +isLine[8] + ") ";
                } else if(isLine[11].toUpperCase() == "LIKE" || isLine[11].toUpperCase() == "NOT LIKE") {
                	whereSql += "%" + isLine[8] + "% ";
                } else if(isLine[11].toUpperCase() == "PLIKE") {
                	whereSql += "" + isLine[8] + "% ";
                } else if(isLine[11].toUpperCase() == "SLIKE") {
                	whereSql += "%" + isLine[8] + " ";
                } else {
                	whereSql += isLine[8] + " ";
                }
            } else {
                if(isLine[11].toUpperCase() == "IN" || isLine[11].toUpperCase() == "NOT IN") {
                    temp = isLine[8];
                    valueNm = "";

                    pos = temp.indexOf(",");
                    while(pos != -1) {
                        valueNm += "'" + temp.substring(0, pos) + "', ";
                        temp = trim(temp.substring(pos+1));
                        pos = temp.indexOf(",");
                    }
                    value += "'" + trim(temp) + "' ";

                    whereSql += "(" +valueNm + ") ";
                } else if(isLine[11].toUpperCase() == "LIKE" || isLine[11].toUpperCase() == "NOT LIKE") {
                	whereSql += "'%" + isLine[8] + "%' ";
                } else if(isLine[11].toUpperCase() == "PLIKE") {
                	whereSql += "'" + isLine[8] + "%' ";
                } else if(isLine[11].toUpperCase() == "SLIKE") {
                	whereSql += "'%" + isLine[8] + "' ";
                } else {
                	whereSql += "'" + isLine[8] + "' ";
                }
            }

            whereSql += isLine[15] + " ";
    	}
    	
    	
    });

    // 마지막에 붙는 관계식(AND/OR)를 삭제함.. (조건식 및 정렬을 선택하였을 경우에는 삭제하지 않음)
    if($("#tblNm").val() == "") {
    	whereSql = whereSql.substring(0, whereSql.lastIndexOf(" "));
    	whereSql = whereSql.substring(0, whereSql.lastIndexOf(" "));
    }

    // 마지막으로 Where절을 하고 있을때(operator와 정렬까지 선택하였을 경우)
    if($("#tblNm").val() != "") {
        tblNm = $("#tblNm").val();
        colNm = $("#colNm").val();
        colDataTy = $("#colDataTy").val();
        colRel = $("#operNm").val();
        valueNm = $("#valueNm").val();

        // isLine에 들어가지 않은 조건의 선택문을 srcWhere 저장해 놓음.
        // 추후, 수정에서 사용됨.
        // 수정할때, isLine부분과 조건을 선택하는 부분을 그대로 재현하기 위하여 정보를 DB에 저장하기 위함.

        var tmpSort = "";

        if($("#sort").val() == "") tmpSort = "none|none";
        else tmpSort = $("#sort").val();

        srcWhere += $("#tblInfo").val() +"|"+ $("#colInfo").val() +"|"+ $("#valueNo").val() +"|"+ $("#valueNm").val() +"|"+ $("#valueAlias").val() +"|"+ $("#operInfo").val() +"|"+ tmpSort;

        if(colRel.toUpperCase() == "PLIKE" || colRel.toUpperCase() == "SLIKE") whereSql += tblNm + "." + colNm + " LIKE ";
        else whereSql += tblNm + "." + colNm + " " + colRel + " ";

        // =, <>, >, < ,  >=, <=, != 등은 그대로
        // in 일 경우 괄호를 삽입
        // like일 경우 %를 양쪽으로 삽입
        if(!checkDBStrType(colDataTy)) {
            if(colRel.toUpperCase() == "IN" || colRel.toUpperCase() == "NOT IN") {
            	whereSql += "(" +valueNm + ") ";
            } else if(colRel.toUpperCase() == "LIKE" || colRel.toUpperCase() == "NOT LIKE") {
            	whereSql += "%" + valueNm + "% ";
            } else if(colRel.toUpperCase() == "PLIKE") {
            	whereSql += "" + valueNm + "% ";
            } else if(colRel.toUpperCase() == "SLIKE") {
            	whereSql += "%" + valueNm + " ";
            } else {
            	whereSql += valueNm + " ";
            }
        } else {
            if(colRel.toUpperCase() == "IN" || colRel.toUpperCase() == "NOT IN") {
                var pos = -1;
                temp = valueNm;
                valueNm = "";

                pos = temp.indexOf(",");
                while(pos != -1) {
                    valueNm += "'" + temp.substring(0, pos) + "', ";
                    temp = trim(temp.substring(pos+1));
                    pos = temp.indexOf(",");
                }
                value += "'" + trim(temp) + "' ";

                where_ += "(" +valueNm + ") ";
            } else if(colRel.toUpperCase() == "LIKE" || colRel.toUpperCase() == "NOT LIKE") {
            	whereSql += "'%" + valueNm + "%' ";
            } else if(colRel.toUpperCase() == "PLIKE") {
            	whereSql += "'" + valueNm + "%' ";
            } else if(colRel.toUpperCase() == "SLIKE") {
            	whereSql += "'%" + valueNm + "' ";
            } else {
            	whereSql += "'" + valueNm + "' ";
            }
        }
    }

    var joinTbl = getJoinTbl();

    if(joinTbl.length != 0 && whereSql.length != 0) whereSql = whereSql + " AND " + joinTbl;
    else if(joinTbl.length != 0 && whereSql.length == 0) whereSql = joinTbl;

    $("#srcWhere").val( srcWhere );
    $("#whereSql").val( whereSql );
}

//order by 절
function getOrderbySql() {
    var isLine = new Array(16);
    var temp = "";
    var ii;

    var sortNm = "none";

    var orderbySql = "";

    var srcWhere = "";      // 조건절의 모든 부분을 여기에 저장함.

    var j = 0;
    $("input[name='isLine']").each(function(idx,item){
    	if($(item).is(":checked") == true) {
            temp = $(item).val();

            srcWhere += temp + "##";

            ii = temp.indexOf("|");
            isLine[0] = temp.substring(0, ii);

            for(kk = 1; kk <= 14; kk++) {
                temp = temp.substring(ii+1);
                ii = temp.indexOf("|");
                isLine[kk] = temp.substring(0, ii);
            }

            if(isLine[13] != "none") {
                if(j != 0) orderbySql += ", ";
                orderbySql += isLine[1] + "." + isLine[4] + " " + isLine[13];

                if(sortNm != "none" && sortNm != isLine[13]) {
                    if(sortNm == "none") sortNm = "";
                    $("#orderbySql").val( orderbySql );
                    $("#sort option").eq(0).prop("selected",true);
                    return false;
                }
                sortNm = isLine[13];
                j++;
            }

    	}
    	
    });

    if($("#sort").val() != "") {
        if(sortNm != "none" && sortNm != $("#sort").val().substring(0, $("#sort").val().indexOf("|")) ) {
            if(sortNm == "none") sortNm = "";
            $("#orderbySql").val( orderbySql );
            $("#sort option").eq(0).prop("selected",true);
            return false;
        }

        if(j > 0) orderbySql += ", ";
        else sortNm = $("#sort").val().substring(0, $("#sort").val().indexOf("|"));

        orderbySql += $("#tblNm").val() + "." + $("#colNm").val();

        var tmpSort = "";

        if($("#sort").val() == "") tmpSort = "none|none";
        else tmpSort = $("#sort").val();

        srcWhere += $("#tblInfo").val() +"|"+ $("#colInfo").val() +"|"+ $("#valueNo").val() +"|"+ $("#valueNm").val() +"|"+ $("#valueAlias").val() +"|"+ $("#operInfo").val() +"|"+ tmpSort;
    }


    if(sortNm == "none") sortNm = "";
    $("#srcWhere").val( srcWhere );
    if(orderbySql != "") $("#orderbySql").val( orderbySql );
    else $("#orderbySql").val("");
}

//조인
function getJoinTbl() {
    var temp = "";
    var pos = -1;

    var returnValue = "";
    var joinRelValue = new Array();
    var joinTblList = new Array();
    var joinRel = new Array();
    var n = 0;

    var fromTblList = new Array();      // From절에서 가져오 테이블 리스트
    
<c:if test="${fn:length(metaJoinList) > 0}">
	<c:set var="cnt" value="${0}"/>
	<c:forEach items="${metaJoinList}" var="metaJoin">
		joinTblList[<c:out value='${cnt}'/>] = "<c:out value='${metaJoin.mstTblNm}'/>,<c:out value='${metaJoin.forTblNm}'/>";
		joinRel[<c:out value='${cnt}'/>] = "<c:out value='${metaJoin.mstTblNm}'/>.<c:out value='${metaJoin.mstColNm}'/> = <c:out value='${metaJoin.forTblNm}'/>.<c:out value='${metaJoin.forColNm}'/>";
		<c:set var="cnt" value="${cnt+1}"/>
		joinTblList[<c:out value='${cnt}'/>] = "<c:out value='${metaJoin.forTblNm}'/>,<c:out value='${metaJoin.mstTblNm}'/>";
		joinRel[<c:out value='${cnt}'/>] = "<c:out value='${metaJoin.mstTblNm}'/>.<c:out value='${metaJoin.mstColNm}'/> = <c:out value='${metaJoin.forTblNm}'/>.<c:out value='${metaJoin.forColNm}'/>";
		<c:set var="cnt" value="${cnt+2}"/>
	</c:forEach>
</c:if>

    // [시작] From 절의 테이블을 fromTblList 배열에 넣어 놓는다.
    temp = $("#fromSql").val().toUpperCase();
    pos = temp.indexOf(",");
    while(pos != -1) {
        fromTblList[n] =  trim(temp.substring(0, pos));
        temp = temp.substring(pos+1);
        pos = temp.indexOf(",");
        n++;
    }
    fromTblList[n] = trim(temp);
    // [끝] From 절의 테이블을 fromTblList 배열에 넣어 놓는다.

    n = 0;
    // formTblList을 두개씩 나두어 조합을 하여 모든 경우의 수를 만들어 joinTblList와 비교를 한다.
    // formTblList는 A,B와 B,A의 경우를 같은 걸로 보고 A,B만 비교한다.
    for(ni = 0; ni < joinTblList.length; ni++) {
        for(fromTblList_i = 0; fromTblList_i < fromTblList.length; fromTblList_i++) {
            for(fromTblList_j = fromTblList_i + 1; fromTblList_j < fromTblList.length; fromTblList_j++) {
                if(joinTblList[ni] == (fromTblList[fromTblList_i] + "," + fromTblList[fromTblList_j])) {
                    joinRelValue[n] = joinRel[ni];
                    n++;
                }
            }
        }
    }

    for(rn = 0; rn < joinRelValue.length; rn++) {
        if(rn == joinRelValue.length - 1) returnValue += joinRelValue[rn];
        else returnValue += joinRelValue[rn] + " AND ";
    }
    return returnValue;
}

//대상수 구하기
function goSegCnt() {
	var obj = document.segform;

	if($("#dbConnNo").val().length == 0) {
		alert("<spring:message code='SEGJSALT008'/>");		// Connection 을 선택해 주세요.
		return;
	}

	if($("#selectSql").val().length == 0 || $("#fromSql").val().length == 0) {
		alert("<spring:message code='SEGJSALT009'/>");		// 쿼리문을 잘못 입력하셨습니다.
		return;
	}

	var param = $("#segInfoForm").serialize();
	$.getJSON("<c:url value='/ems/seg/segCount.json'/>?" + param, function(data) {
		$("#totCnt").val(data.totCnt);
	});
}


function noClick() {
        return false;
}

// 수정버튼 클릭시(삭제된 발송대상)
function isStatus() {
    alert("<spring:message code='SEGTBLLB020'/>.");		// 삭제된 발송대상그룹입니다!!\\n삭제된 발송대상그룹은 수정을 할 수 없습니다!!
}

// 수정버튼 클릭 시
function goSegToolUpdate() {
    var errflag = false;
    var errstr = "";

    if(typeof $("#deptNo").val() != "undefined") {
    	if($("#deptNo").val() != "0" && $("#userId").val() == "") {
            errflag = true;
            errstr += " [ <spring:message code='COMTBLTL005'/> ] ";			// 사용자
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
    if($("#selectSql").val() == "" || $("#fromSql").val() == "") {
        errflag = true;
        errstr += " [ <spring:message code='SEGTBLTL004'/> ] ";			// 질의문
    }
    if(errflag) {
        alert("<spring:message code='COMJSALT001'/>\n" + errstr);		// 입력값 에러\\n다음 정보를 확인하세요.
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

// 복구 버튼 클릭시
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
	if($("#dbConnNo").val() == "") {
    	alert("<spring:message code='SEGJSALT008'/>");		// Connection 을 선택해 주세요.
		return;
	}
	if($("#selectSql").val() == "" || $("#fromSql").val() == "") {
		alert("<spring:message code='SEGJSALT009'/>");		// 쿼리문을 잘못 입력하셨습니다.
		return;
	}
	
	window.open("","segInfo", "width=1100, height=683,status=yes,scrollbars=no,resizable=no");
	$("#segInfoForm").attr("target","segInfo").attr("action","<c:url value='/ems/seg/segInfoP.ums'/>").submit();
}

// 리스트 버튼 클릭시
function goList() {
	$("#searchForm").attr("target","").attr("action","<c:url value='/ems/seg/segMainP.ums'/>").submit();
}
</script>

<body>
	<div id="wrap">

		<!-- lnb// -->
		<div id="lnb">
			<!-- LEFT MENU -->
			<%@ include file="/WEB-INF/jsp/inc/menu_ems.jsp" %>
			<!-- LEFT MENU -->
		</div>
		<!-- //lnb -->

		<!-- content// -->
		<div id="content">

			<!-- cont-head// -->
			<section class="cont-head">
				<div class="title">
					<h2><c:out value='${NEO_MENU_NM}'/></h2>
				</div>
				
				<!-- 공통 표시부// -->
				<%@ include file="/WEB-INF/jsp/inc/top.jsp" %>
				<!-- //공통 표시부 -->
				
			</section>
			<!-- //cont-head -->

			<!-- cont-body// -->
			<section class="cont-body">




			<p class="title_default"><spring:message code='SEGTBLTL001'/></p><!-- 발송대상그룹 -->
			<!-- LOCATION 이동 EVENT FORM -->
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
			<input type="hidden" name="tblNo"/>
			<input type="hidden" name="colNo"/>
			<input type="hidden" name="status"/>
			</form>
			
			<form id="segInfoForm" name="segInfoForm">
			<input type="hidden" id="dbConnNo"  name="dbConnNo" value="<c:out value='${segmentInfo.dbConnNo}'/>">
			<input type="hidden" id="segNo"     name="segNo" value="<c:out value='${segmentInfo.segNo}'/>">
			<input type="hidden" id="status"    name="status" value="<c:out value='${segmentInfo.status}'/>">
			<input type="hidden" id="mergeKey"  name="mergeKey" value="<c:out value='${segmentInfo.mergeKey}'/>">
			<input type="hidden" id="mergeCol"  name="mergeCol" value="<c:out value='${segmentInfo.mergeCol}'/>">
			<input type="hidden" id="sercWhere" name="srcWhere" value="<c:out value='${segmentInfo.srcWhere}'/>">
			<input type="hidden" id="createTy"  name="createTy" value="<c:out value='${segmentInfo.createTy}'/>">
			
			<!-- 커리 조건 선택에 필요한 값들 -->
			<input type="hidden" id="tblNo"     name="tblNo" style="width:0;" readonly>
			<input type="hidden" id="tblNm"     name="tblNm" style="width:0;" readonly>
			<input type="hidden" id="tblAlias"  name="tblAlias" style="width:0;" readonly>
			
			<input type="hidden" id="colNo"     name="colNo" style="width:0;" readonly>
			<input type="hidden" id="colNm"     name="colNm" style="width:0;" readonly>
			<input type="hidden" id="colDataTy" name="colDataTy" style="width:0;" readonly>
			<input type="hidden" id="colAlias"  name="colAlias" style="width:0;" readonly>
			
			<input type="hidden" id="operNo"    name="operNo" style="width:0;" readonly>
			<input type="hidden" id="operNm"    name="operNm" style="width:0;" readonly>
			<input type="hidden" id="operAlias" name="operAlias" style="width:0;" readonly>
			
			<input type="hidden" id="valueNo"    name="valueNo" style="width:0;" readonly>
			<input type="hidden" id="valueNm"    name="valueNm" style="width:0;" readonly>
			<input type="hidden" id="valueAlias" name="valueAlias" style="width:0;" readonly>
			
			<!-- 커리 조건 선택에 필요한 값들 -->
			<div class="cWrap">
			
			<div id="divMenu1">
				<table class="nTab">
					<tr>
						<td align="center" id="td_tab1" class='on'><spring:message code='SEGBTN001'/></td><!-- 추출도구이용 -->
						<td align="center" id="td_tab2"><spring:message code='SEGBTN003'/></td><!-- 직접 SQL 이용 -->
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
						<td class="td_title">Connection&nbsp;</td>
						<td class="td_body" >
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
						<td class="td_title"><spring:message code='SEGTBLTL002'/>&nbsp;</td><!-- 발송대상그룹명 -->
						<td class="td_body" >
							<input type="text" name="segNm" value="<c:out value='${segmentInfo.segNm}'/>">
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
			
				<!-- 조건 선택 -->
				<table width="800" border="0" cellspacing="0" cellpadding="0">
					<tr><td height='10'></td></tr>
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
								<colgroup>
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:10%" />
								</colgroup>
								<tr class="tr_head">
									<td align="center"><spring:message code='SEGTBLTL007'/></td><!-- 테이블 -->
									<td align="center"><spring:message code='SEGTBLTL008'/></td><!-- 컬럼 -->
									<td align="center"><spring:message code='SEGTBLTL009'/></td><!-- 추출값 -->
									<td align="center"><spring:message code='SEGTBLTL010'/></td><!-- 조건식 -->
									<td align="center"><spring:message code='SEGTBLTL011'/></td><!-- 정렬 -->
									<td align="center"><spring:message code='SEGTBLTL012'/></td><!-- 관계식 -->
									<td align="center"><spring:message code='COMBTN005'/></td><!-- 등록 -->
								</tr>
			
								<tr class="tr_body">
									<td class="td_5">
										<input type='hidden' name='isLine' />
										<select id="tblInfo" name='tblInfo' onchange='goTblSelect()' style="width:120px;">
											<option value="">-----------------</option>
											<c:if test="${fn:length(metaTableList) > 0}">
												<c:forEach items="${metaTableList}" var="metaTable">
													<option value="<c:out value='${metaTable.tblNo}|${metaTable.tblNm}|${metaTable.tblAlias}'/>"><c:out value='${metaTable.tblAlias}'/></option>
												</c:forEach>
											</c:if>
										</select>
									</td>
									<td align="center" class="td_5">
					             		<select id="colInfo" name='colInfo' onchange='goColSelect()' style="width:120px;">
					             			<option value="">-----------------</option>
					             		</select>
									</td>
									<td id="valueInfoDisplay" align="center" class="td_5">
					             		<input type="text" id="valueInfo" name="valueInfo" onkeyup="goValueSelect()" style="width:120px;">
									</td>
									<td align="center" class="td_5">
										<select id="operInfo" name='operInfo' onchange='goOperSelect()' style="width:120px;">
					        				<option value="">-----------------</option>
									    </select>
									</td>
									<td align="center">
										<select id="sort" name="sort" class="select" onchange='goSortSelect();' style="width:120px;">
											<option value="" selected>----</option>
											<option value="ASC|올림"><spring:message code='SEGTBLLB017'/></option><!-- 올림 -->
											<option value="DESC|내림"><spring:message code='SEGTBLLB018'/></option><!-- 내림 -->
										</select>
									</td>
									<td align="center">
										<select id="whereRel" name="whereRel" class="select" style="width:120px;">
											<option value="" selected>----</option>
											<option value="AND">AND</option>
											<option value="OR">OR</option>
										</select>
									</td>
									<td align="center">
										<input type="button" class="btn_style" value="<spring:message code='COMBTN005'/>" onClick="fRelSelect()"><!-- 등록 -->
									</td>
								</tr>
							</table>
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
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table border="0" cellspacing="1" cellpadding="0" class="table_line_outline">
								<tr>
									<td class="td_title" width="150">Select</td>
									<td class="td_body">
										<div id='divSelect'><textarea id="selectSql" name="selectSql" class='tArea' style="width:870px;height:50px;" readonly><c:out value="${segmentInfo.selectSql}"/></textarea></div>
									</td>
								</tr>
								<tr>
									<td class="td_title">Form</td>
									<td class="td_body">
										<div id='divFrom'><textarea id="fromSql" name="fromSql" style="width:870px;height:50px;" readonly><c:out value="${segmentInfo.fromSql}"/></textarea></div>
									</td>
								</tr>
								<tr>
									<td class="td_title">Where</td>
									<td class="td_body">
										<div id='divWhere'><textarea id="whereSql" name="whereSql" style="width:870px;height:50px;" readonly><c:out value="${segmentInfo.whereSql}"/></textarea></div>
									</td>
								</tr>
								<tr>
									<td class="td_title">Order by</td>
									<td class="td_body">
										<div id='divOrderby'><textarea id="orderbySql" name="orderbySql" style="width:870px;height:50px;" readonly><c:out value="${segmentInfo.orderbySql}"/></textarea></div>
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
						<c:if test="${'002' eq segmentInfo.status}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="isStatus()"><!-- 수정 -->
						</c:if>
						<c:if test="${'002' ne segmentInfo.status}">
							<input type="button" class="btn_typeC" value="<spring:message code='COMBTN007'/>" onClick="goSegToolUpdate()"><!-- 수정 -->
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
			
						<input type="button" class="btn_style" value="<spring:message code='SEGBTN007'/>" onClick="goSegInfo()"><!-- 대상자보기 -->
						<input type="button" class="btn_style" value="<spring:message code='COMBTN010'/>" onClick="goList()"><!-- 리스트 -->
					</div>
				</div>
			
			</div>
			</div>
			</form>




			</section>
			<!-- //cont-body -->
			
		</div>
		<!-- // content -->
	</div>

	<!-- 팝업// -->
	<%@ include file="/WEB-INF/jsp/inc/popup.jsp" %>
	<!-- //팝업 -->
</body>
</html>
