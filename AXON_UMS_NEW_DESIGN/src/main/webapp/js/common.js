/**
* --------------------------------
* Common JS
* creator : chowoobin
* from : enders
* --------------------------------
*/
var fn = (function() {
	"use strict";

	return {
		//공통
		common : function(){
			//fileupload
			fn.fileupload();
		},

		//input[type="file"]
		fileupload : function(){
			var fileTarget = $("input[type='file']"),
				filevalue,
				filename; // 파일명

			fileTarget.on("change", function(obj){ // 값이 변경되면
				filevalue = $(this).val().split("\\");
				filename = filevalue[filevalue.length-1]; // 파일명
				var error = $(obj).closest(".filebox").siblings(".list-star");

				$(this).siblings(".upload-name").val(filename);

				// 파일 형식 체크
				if(filename.substring(filename.lastIndexOf(".")+1,filename.length).search("html") == -1){
					if(error.hasClass("hide")){
						error.removeClass("hide");
					}
				}else {
					error.addClass("hide");

				}
				
			});

			// 삭제기능
			$(document).on("click",".filebox .inputfile ~ .btn.fullblack",function(){
				$(this).addClass("hide");
				$(this).siblings(".btn.fullblue").removeClass("hide");
				$(this).closest(".filebox").siblings(".list-star").addClass("hide");
				$(this).siblings(".inputfile").find("input[type='text']").val("");
				$(this).siblings(".inputfile").find(".filesize").text("");
			});
		},
		
		fileCheck : function(obj){
			var filevalue = $(obj).val().split("\\"),
				filedir = filevalue[filevalue.length-1], // 파일명
				error = $(obj).closest(".filebox").siblings(".list-star"),
				filesize = $(obj).siblings(".filesize");

			// 파일 형식 체크
			if(filedir.substring(filedir.lastIndexOf(".")+1,filedir.length).search("html") == -1){
				if(error.hasClass("hide")){
					error.removeClass("hide");
				}
			}else {
				error.addClass("hide");
			}

			// 용량 체크
			if($(obj).val() != ""){
				var fileSize = obj.files[0].size;
				$(obj).closest(".inputfile").siblings(".btn.fullblack").removeClass("hide");
				$(obj).closest(".inputfile").siblings(".btn.fullblue").addClass("hide");
			}
			var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'],
				e = Math.floor(Math.log(fileSize) / Math.log(1024));
			filesize.text((fileSize / Math.pow(1024, e)).toFixed(2) + " " + s[e]);
			return (fileSize / Math.pow(1024, e)).toFixed(2) + " " + s[e];
		},

		//popupOpen
		popupOpen : function(obj){
			$(obj).addClass("open");
			$("body").addClass("ov-hidden");
			setTimeout(function(){	//일정시간 뒤(로딩) 팝업 높이제어
				fn.popupHeight();
			}, 100);
		},

		//popupClose
		popupClose : function(obj){
			$(obj).removeClass("open");
			$("body").removeClass("ov-hidden");
		},

		//popupHeight
		popupHeight : function(obj){
			//popup
			$(".poplayer").each(function(){
				var popupH = $(this).find(".inner").outerHeight(),
					contentH = $(this).find(".cont").outerHeight(),
					headerH = $(this).find("header").outerHeight();
			
				if( popupH < contentH ){	// 팝업틀의 높이보다 팝업내 content 높이가 더 크다면
					var contheight = popupH - headerH;
					$(this).find(".cont").outerHeight(contheight);
				}

				if (!(popupH % 2) == 0) { // 팝업틀의 높이가 홀수라면 흐린현상으로 짝수로 잡아준다.(transform 사용)
					popupH += 1;	// 홀수이면 +1해서 짝수로 높이 잡아주기.
					$(this).find(".inner").outerHeight(popupH);
				}
			});
		}
	}
})();

$(document).ready(function(){
	// lnb 메뉴
	$(document).on("click", "#lnb .depth1", function(){
		if($(this).closest("li").hasClass("active")){
			$(this).siblings(".inner-menu").slideUp();
			$(this).closest("li").removeClass("active");
		}else{
			$(".inner-menu").slideUp();
			$(this).siblings(".inner-menu").slideDown();
			$(this).closest("li").addClass("active").siblings().removeClass("active");
		}
	});
	$(document).on("click", "#lnb .inner-menu a", function(){
		$("#lnb .inner-menu li").removeClass("active");
		$(this).closest("li").addClass("active");
	});

	//cont-head util user
	$(document).on("click", ".cont-head .util .info button", function(){
		if($(this).closest(".user").hasClass("open")){
			$(this).closest(".user").removeClass("open");
			$(this).text("열기");
		}else{
			$(this).closest(".user").addClass("open").siblings().removeClass("open");
			$(this).text("닫기");
		}
	});
	$(document).on("click", function(event){
		if ($(event.target).closest(".cont-head .util .info button").length === 0){
			$(".cont-head .util .user").removeClass("open");
			$(".cont-head .util .info button").text("열기");
		}
		event.stopPropagation();
	});

	//toggle
	$(document).on("click", ".toggle .btn-toggle", function(){
		if($(this).closest("li").hasClass("open")){
			$(this).closest("li").removeClass("open");
		}else{
			$(this).closest("li").addClass("open").siblings().removeClass("open");
		}
	});
	$(document).on("click", ".toggle .depth2 button", function(){
		$(".toggle .depth2 li").removeClass("active");
		$(this).closest("li").addClass("active");
	});

	//datepicker
	$('.datepicker input').datepicker({
		dateFormat: 'yy.mm.dd', //날짜 포맷이다.
		//prevText: '이전 달',	// 마우스 오버시 이전달 텍스트
		//nextText: '다음 달',	// 마우스 오버시 다음달 텍스트
		closeText: '닫기', // 닫기 버튼 텍스트 변경
		currentText: '오늘', // 오늘 텍스트 변경
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더중 월 표시를 위한 부분
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더 중 월 표시를 위한 부분
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],	//한글 캘린더 요일 표시 부분
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],	//한글 요일 표시 부분
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],	// 한글 요일 표시 부분
		showMonthAfterYear: true,	// true : 년 월	false : 월 년 순으로 보여줌
		yearSuffix: '년',	//
		showButtonPanel: true,	// 오늘로 가는 버튼과 달력 닫기 버튼 보기 옵션
	}).datepicker('setDate',new Date());

	//시작일.
	$('.datepickerrange.fromDate input').datepicker({
		dateFormat: 'yy.mm.dd', //날짜 포맷이다.
		closeText: '닫기', // 닫기 버튼 텍스트 변경
		currentText: '오늘', // 오늘 텍스트 변경
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더중 월 표시를 위한 부분
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더 중 월 표시를 위한 부분
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],	//한글 캘린더 요일 표시 부분
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],	//한글 요일 표시 부분
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],	// 한글 요일 표시 부분
		showMonthAfterYear: true,	// true : 년 월	false : 월 년 순으로 보여줌
		yearSuffix: '년',	//
		showButtonPanel: true,	// 오늘로 가는 버튼과 달력 닫기 버튼 보기 옵션

		onClose: function( selectedDate ) {    
			// 시작일(fromDate) datepicker가 닫힐때
			// 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
			$(".datepickerrange.toDate input").datepicker( "option", "minDate", selectedDate );
		}  
	});

	//종료일
	$('.datepickerrange.toDate input').datepicker({
		dateFormat: 'yy.mm.dd', //날짜 포맷이다.
		closeText: '닫기', // 닫기 버튼 텍스트 변경
		currentText: '오늘', // 오늘 텍스트 변경
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더중 월 표시를 위한 부분
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더 중 월 표시를 위한 부분
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],	//한글 캘린더 요일 표시 부분
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],	//한글 요일 표시 부분
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],	// 한글 요일 표시 부분
		showMonthAfterYear: true,	// true : 년 월	false : 월 년 순으로 보여줌
		yearSuffix: '년',	//
		showButtonPanel: true,	// 오늘로 가는 버튼과 달력 닫기 버튼 보기 옵션

		onClose: function( selectedDate ) {
			// 종료일(toDate) datepicker가 닫힐때
			// 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정 
			$(".datepickerrange.fromDate input").datepicker( "option", "maxDate", selectedDate );
		}                
	});

	/*
	//select
	$(document).on("click", ".select", function(event){
		$(".select").not($(this)).removeClass("open");
		$(this).toggleClass("open");
	});
	//Close when clicking outside
	$(document).on("click", function(event){
		if ($(event.target).closest(".select").length === 0){
			$(".select").removeClass("open");
		}
		event.stopPropagation();
	});
	*/


});


$(window).on("load", function(){
	//init
	fn.common();
});

