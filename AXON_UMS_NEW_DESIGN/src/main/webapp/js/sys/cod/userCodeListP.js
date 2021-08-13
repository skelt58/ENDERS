$(document).ready(function() {		
	goSearch();
}); 

// 검색 버튼 클릭시
function goSearch() {
  
	var param = $("#searchForm").serialize();
	alert(param);
	$.ajax({
		type : "GET",
		url : "./userCodeList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divUserCodeList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}
 
 
// 검색 버튼 클릭시
function goSelect(obj) { 
 
	$.getJSON("/sys/cod/userCodeInfo.json?cdGrp=" + cdGrp + "&cd=" + cd, function(data) {
		if(data) {
			$("#cd").val(data.userCode.cd);
			$("#cdNm").val(data.userCode.cdNm);
			$("#cdDtl").val(data.userCode.cdDtl);			
			$("#cdGrp").val(data.userCode.cdGrp).prop("selected",true);
			$("#upCd").val(data.userCode.upCd).prop("selected",true);
			$("#uiLang").val(data.userCode.uiLang).prop("selected",true);
			$("#useYn").val(data.userCode.useYn).prop("selected",true);
			$("#sysYn").val(data.userCode.sysYn).prop("selected",true);
			
			$("#cdNm").attr("readonly", false);
			$("#cdDtl").attr("readonly", false);	
			document.getElementById("cdGrp").removeAttribute("disabled");
			document.getElementById("upCd").removeAttribute("disabled");				
			document.getElementById("uiLang").removeAttribute("disabled");
			document.getElementById("useYn").removeAttribute("disabled");
				
			if(data.userCode.sysYn == "Y"){				
				$("#cdNm").attr("readonly", true);
				$("#cdDtl").attr("readonly", true);				
				document.getElementById("cdGrp").disabled = true;
				document.getElementById("upCd").disabled = true;						
				document.getElementById("uiLang").disabled = true;	
				document.getElementById("useYn").disabled = true;
			}
			$("#cd").attr("readonly", true);						
		} else {
			alert("Error!!");
		}
	});
}
 
// 초기화 버튼 클릭시
function goReset() {
	
	$("#searchCdGrp").find('option:first').attr('selected', 'selected');
	$("#searchCdGrpNm").val("");

    var checkboxes = document.getElementsByName('userCodeDelYn');
    for (var checkbox of checkboxes) {
        checkbox.checked = false;
    }
	goSearch();
} 

// 등록 버튼 클릭시
function goAdd() {
	// 입력 폼 검사
	if(checkForm()) {
		return;
	}
	 
	var param = $("#userCodeInfoForm").serialize();	
	alert(param);
	$.ajax({
		type : "POST",
		url : "./userCodeAdd.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			alert("등록이 완료 되었습니다");		// 등록 성공
			$("#page").val("1");			
			$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeListP.ums").submit();
		},
		error : function(){
			alert("Error!!");
		}
	});
	
	
}

//수정 EVENT 구현
function goUpdate() {
	if($("#cd").val() != "") { 
		if(checkForm()) {
			return;
		}

		document.getElementById("cdGrp").removeAttribute("disabled");
		document.getElementById("upCd").removeAttribute("disabled");				
		document.getElementById("uiLang").removeAttribute("disabled");
		document.getElementById("useYn").removeAttribute("disabled");
			
		var param = $("#userCodeInfoForm").serialize();
		alert(param);
		 
		$.ajax({
			type : "POST",
			url : "./userCodeUpdate.ums?" + param,
			dataType : "html",
			success : function(pageHtml){
				alert("수정이 완료 되었습니다");		// 등록 성공
				$("#page").val("1");
				$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeListP.ums").submit();
			},
			error : function(){
				alert("Error!!");
			}
		});
	}
}

//삭제 EVENT 구현
function goDelete() {
	
	var checkboxs = $("input[name=userCodeDelYn]:checked");
	
	if(checkboxs.length < 1 ){
		alert("삭제할 공통코드를 선택해주세요");
		return;
	}
	 
	checkboxs.each(function(i) {
		var rowData = new Array();
		var tr = checkboxs.parent().parent().eq(i);
		var td = tr.children();
		rowData.push(tr.text());
		cd = td.eq(8).text(); 
		cdGrp = td.eq(9).text();
		
		$.getJSON("/sys/cod/userCodeDelete.json?cd=" + cd + "&cdGrp=" + cdGrp , function(data) {
			if(data) {
				if( i == checkboxs.length -1 ) {
			 		alert("삭제에 성공 하였습니다");		// 등록 성공					
					$("#page").val("1");
					$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeListP.ums").submit();
				}
			} else {
				alert("Error!!");
			}
		}); 
	});
}
 
// 입력 폼 검사
function checkForm() {
	var errstr = "";
	var errflag = false;
	if($("#cdNm").val() == "") {
		errstr += "[공콩코드명]";
		errflag = true;
	}
	if($("#cdGrp").val() == "") {
		errstr +=  "[코드그룹]";
		errflag = true;
	}	
	if($("#cdDtl").val() == "") {
		errstr +=  "[설명]";
		errflag = true;
	}

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);		// 다음 정보를 확인하세요.
	}
	
	if($.byteString($(userCodeInfoForm.cdNm).val()) > 60 ) {
		alert("코드명은 60byte를 넘을 수 없습니다.");
		$(userCodeInfoForm.cdNm).focus();
		$(userCodeInfoForm.cdNm).select();
		errflag = true;
	}
	if($.byteString($(userCodeInfoForm.cdDtl).val()) > 100 ) {
		alert("코드설명은 100byte를 넘을 수 없습니다.");
		$(userCodeInfoForm.cdDtl).focus();
		$(userCodeInfoForm.cdDtl).select();
		errflag = true;
	} 
	return errflag;
}

// 입력 폼 리셋
function goAddReset() {
	$("#cd").val("");
	$("#cdNm").val("");
	$("#cdGrp").val("");
	$("#cdDtl").val("");
	$("#upCd").val("0");
	$("#uiLang").val("0");
	$("#sysYn").val("0");
	$("#useYn").val("0");
}

// 검색 코드 분류 변경시 
function searchCdGrpSelect() {
	$("#searchCdGrpNm").val(""); 	
	goSearch();
}

// 코드상세정보의 분류 코드 변경시 연결된 상위코드 목록 조회
function searchUpCdGrpSelect(cdGrp) { 	
	alert(cdGrp);
	$.getJSON("/sys/cod/userCodeListByCodeGroup.json?cdGrp=" + cdGrp, function(data) {
		$("#upCd").children("option:not(:first)").remove();
		$.each(data.upCdGrpList, function(idx,item){
			var option = new Option(item.cdNm,item.cd);
			$("#upCd").append(option);
		});
	});
}  

function selectAll(selectAll)  {
	$("#listForm input[name='userCodeDelYn']").each(function(idx,item){
		if( $(item).is(":disabled") == false) {
			$(item).prop("checked",selectAll.checked);
		}
	});
} 

// 페이징
function goPageNum(page) {
	$("#page").val(page);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./userCodeList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divuserCodeList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
} 
