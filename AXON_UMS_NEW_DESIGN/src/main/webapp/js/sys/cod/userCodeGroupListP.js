$(document).ready(function() {		
	goSearch();
}); 

// 검색 버튼 클릭시
function goSearch() {
  
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./userCodeGroupList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divUserCodeGroupList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}
 
// 검색 버튼 클릭시
function goSelect(cdGrp) { 
	 
	$.getJSON("/sys/cod/userCodeGroupInfo.json?cdGrp=" + cdGrp, function(data) {
		if(data) {
			$("#cdGrp").val(data.userCodeGroup.cdGrp);
			$("#cdGrpNm").val(data.userCodeGroup.cdGrpNm);
			$("#cdGrpDtl").val(data.userCodeGroup.cdGrpDtl);
			$("#upCdGrp").val(data.userCodeGroup.upCdGrp).prop("selected",true);
			$("#uiLang").val(data.userCodeGroup.uilang).prop("selected",true);
			$("#useYn").val(data.userCodeGroup.useYn).prop("selected",true);
			$("#sysYn").val(data.userCodeGroup.sysYn).prop("selected",true);
			
			$("#cdGrpNm").attr("readonly", false);
			$("#cdGrpDtl").attr("readonly", false);	
			document.getElementById("upCdGrp").removeAttribute("disabled");				
			document.getElementById("uiLang").removeAttribute("disabled");
			document.getElementById("useYn").removeAttribute("disabled");
				
			if(data.userCodeGroup.sysYn == "Y"){				
				$("#cdGrpNm").attr("readonly", true);
				$("#cdGrpDtl").attr("readonly", true);				
				document.getElementById("upCdGrp").disabled = true;						
				document.getElementById("uiLang").disabled = true;	
				document.getElementById("useYn").disabled = true;
			}
			$("#cdGrp").attr("readonly", true);			
			document.getElementById("sysYn").disabled = true;
		} else {
			alert("Error!!");
		}
	});
}
 
// 초기화 버튼 클릭시
function goReset() {
	
	$("#searchCdGrp").find('option:first').attr('selected', 'selected');
	$("#searchCdGrpNm").val("");

    var checkboxes = document.getElementsByName('userCodeGrouupDelYn');
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
	 
	var param = $("#userCodeGroupInfoForm").serialize();	

	$.ajax({
		type : "POST",
		url : "./userCodeGroupAdd.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			alert("등록이 완료 되었습니다");		// 등록 성공
			$("#page").val("1");
			$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeGroupListP.ums").submit();
		},
		error : function(){
			alert("Error!!");
		}
	});
}

//수정 EVENT 구현
function goUpdate() {
	if($("#cdGrp").val() != "") { 
		// 입력 폼 검사
		if(checkForm()) {
			return;
		}

		document.getElementById("upCdGrp").removeAttribute("disabled");				
		document.getElementById("uiLang").removeAttribute("disabled");
		document.getElementById("useYn").removeAttribute("disabled");
			
		var param = $("#userCodeGroupInfoForm").serialize();
		alert(param);
		 
		$.ajax({
			type : "POST",
			url : "./userCodeGroupUpdate.ums?" + param,
			dataType : "html",
			success : function(pageHtml){
				alert("수정이 완료 되었습니다");		// 등록 성공
				$("#page").val("1");
				$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeGroupListP.ums").submit();
			},
			error : function(){
				alert("Error!!");
			}
		});
	}
}

//삭제 EVENT 구현
function goDelete() {
	
	var checkboxs = $("input[name=userCodeGrouupDelYn]:checked");
	
	if(checkboxs.length < 1 ){
		alert("삭제할 분류코드를 선택해주세요");
		return;
	}
	
	var total = checkboxs.length;
	 
	var success = 0;
	var fail = 0; 
	
	checkboxs.each(function(i) {
		var rowData = new Array();
		var tr = checkboxs.parent().parent().eq(i);
		var td = tr.children();
		rowData.push(tr.text());
		cdGrp = td.eq(7).text(); 
		
		$.getJSON("/sys/cod/userCodeGroupDelete.json?cdGrp=" + cdGrp, function(data) {
			if(data) {
		 		alert("삭제에 성공 하였습니다");		// 등록 성공
				$("#page").val("1");
				$("#searchForm").attr("target","").attr("action","/sys/cod/userCodeGroupListP.ums").submit();
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
	if($("#cdGrp").val() == "" || $("#cdGrp").val().length != 4 ) {
		errstr += "[코드그룹]";
		errflag = true;
	}
	if($("#cdGrpNm").val() == "") {
		errstr += "[코드그룹명]";
		errflag = true;
	}
	if($("#cdGrpDtl").val() == "") {
		errstr +=  "[코드그룹설명]";
		errflag = true;
	}

	if(errflag) {
		alert("<spring:message code='COMJSALT016'/>\n" + errstr);		// 다음 정보를 확인하세요.
	}
	return errflag;
}

// 입력 폼 리셋
function goAddReset() {
	$("#cdGrp").val("");
	$("#cdGrpNm").val("");
	$("#cdGrpDtl").val("");
	$("#upCdGrp").val("0");
	$("#uiLang").val("0");
	$("#sysYn").val("0");
	$("#useYn").val("0");
}

// 검색 코드 분류 변경시 
function changeCdGrpSelect() {
	$("#searchCdGrpNm").val("");	
/*	var cdGrpSelect = document.getElementById("searchCdGrp"); 
	var selectValue = cdGrpSelect.options[cdGrpSelect.selectedIndex].value;	
*/	
	goSearch();
}  

function selectAll(selectAll)  {
	
	var checkboxes = document.getElementsByName('userCodeGrouupDelYn');
	for (var checkbox of checkboxes) {
		if( !$('#checkbox').is('disabled') ){
	    	checkbox.checked = selectAll.checked;
		}
	} 
} 

// 페이징
function goPageNum(page) {
	$("#page").val(page);
	var param = $("#searchForm").serialize();
	$.ajax({
		type : "GET",
		url : "./userCodeGroupList.ums?" + param,
		dataType : "html",
		success : function(pageHtml){
			$("#divUserCodeGroupList").html(pageHtml);
		},
		error : function(){
			alert("Error!!");
		}
	});
}