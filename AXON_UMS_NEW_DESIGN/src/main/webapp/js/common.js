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
			//select
			fn.select(".select");
			fn.selectInit();
		},

		//select
		select : function(obj){
			var obj = $(obj);
			obj.each(function(i, select){
				if ( !$(this).find("div").hasClass("dropdown") ){
					if ( $(this).find("select").is(":disabled") ){
						$(this).addClass("disabled");
					}
					$(this).append('<div class="dropdown" tabindex="0"><span class="current"></span><div class="list"><ul></ul></div></div>');
					var dropdown = $(this).find(".dropdown");
					var options = $(this).find("select").find("option");
					var selected = $(this).find("select").find("option:selected");
					//var disabled = $(this).find("select").find("option:disabled");
					dropdown.find(".current").html(selected.text());
					options.each(function(j, o){
						var btn = $(o).data("btn") || "";//재입고 알림버튼
						var stock = $(o).data("stock") || "";//남은 수량
						var price = $(o).data("price") || "";//가격

						if ( $(o).attr("class") == "select-ti" ){
							dropdown.find("ul").append('<li class="option select-ti" data-value="' + $(o).val() + '"><span>' + $(o).text() + '</span></li>');
						} else if ( btn ){
							dropdown.find("ul").append('<li class="option soldout' + ($(o).is(':selected') ? ' selected' :'')  + ($(o).is(':disabled') ? ' disabled' :'') + '" data-value="' + $(o).val() + '"><span>' + $(o).text() + '</span>' + btn + '</li>');
						} else {
							if ( stock && price ){
								dropdown.find("ul").append('<li class="option pro' + ($(o).is(':selected') ? ' selected' :'')  + ($(o).is(':disabled') ? ' disabled' :'') + '" data-value="' + $(o).val() + '"><span>' + $(o).text() + '</span>' + price + '' + stock + '</li>');
							} else if ( price ){
								dropdown.find("ul").append('<li class="option pro' + ($(o).is(':selected') ? ' selected' :'')  + ($(o).is(':disabled') ? ' disabled' :'') + '" data-value="' + $(o).val() + '"><span>' + $(o).text() + '</span>' + price +'</li>');
							} else {
								dropdown.find("ul").append('<li class="option' + ($(o).is(':selected') ? ' selected' :'')  + ($(o).is(':disabled') ? ' disabled' :'') + '" data-value="' + $(o).val() + '"><span>' + $(o).text() + '</span></li>');
							}
						}
					});
				}
			});
		},

		//select init
		selectInit : function(){
			$("select").change(function(){
				$(this).addClass("active");
			});

			//Open/close
			$(document).on("click", ".dropdown", function(event){
				$(".dropdown").not($(this)).removeClass("open");
				$(this).toggleClass("open");
				if ($(this).hasClass("open")){
					$(this).find(".option").attr("tabindex", 0);
					$(this).find(".selected").focus();
				}else{
					$(this).find(".option").removeAttr("tabindex");
					$(this).focus();
				}
			});
			//Close when clicking outside
			$(document).on("click", function(event){
				if ($(event.target).closest(".dropdown").length === 0){
					$(".dropdown").removeClass("open");
					$(".dropdown .option").removeAttr("tabindex");
				}
				event.stopPropagation();
			});
			//Option click
			$(document).on("click", ".dropdown .option", function(event){
				if ( !$(this).hasClass("disabled") ){
					$(this).closest(".list").find(".selected").removeClass("selected");
					$(this).addClass("selected");
					var text = $(this).data("display-text") || $(this).html();
					$(this).closest(".dropdown").addClass("active");
					$(this).closest(".dropdown").find(".current").html(text);
					$(this).closest(".dropdown").prev("select").val($(this).data("value")).trigger("change");
				}
			});
			//Keyboard events
			$(document).on("keydown", ".dropdown", function(event){
				var focused_option = $($(this).find(".list .option:focus")[0] || $(this).find(".list .option.selected")[0]);
				//Space or Enter
				if (event.keyCode == 32 || event.keyCode == 13){
					if ($(this).hasClass("open")){
						focused_option.trigger("click");
					}else{
						$(this).trigger("click");
					}
					return false;
				//Down
				}else if (event.keyCode == 40){
					if (!$(this).hasClass("open")){
						$(this).trigger("click");
					} else{
						focused_option.next().focus();
					}
					return false;
				//Up
				}else if (event.keyCode == 38){
					if (!$(this).hasClass("open")){
						$(this).trigger("click");
					}else{
						var focused_option = $($(this).find(".list .option:focus")[0] || $(this).find(".list .option.selected")[0]);
						focused_option.prev().focus();
					}
					return false;
				//Esc
				}else if (event.keyCode == 27){
					if ($(this).hasClass("open")){
						$(this).trigger("click");
					}
					return false;
				}
			});
		},

		//popupOpen
		popupOpen : function(obj){
			$(obj).show();
			$("body").addClass("ov-hidden");
			fn.popupHeight();
		},

		//popupClose
		popupClose : function(obj){
			$(obj).hide();
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
					popupH -= 1;	// 홀수이면 -1해서 짝수로 높이 잡아주기.
					$(this).find(".inner").outerHeight(popupH);
					$(this).find(".inner").css("max-height","none");
				}
			});
		}
	}
})();

$(document).ready(function(){
	// lnb 메뉴
	$("#lnb .depth1").on("click", function(){
		if($(this).closest("li").hasClass("active")){
			$(this).siblings(".inner-menu").slideUp();
			$(this).closest("li").removeClass("active");
		}else{
			$(".inner-menu").slideUp();
			$(this).siblings(".inner-menu").slideDown();
			$(this).closest("li").addClass("active").siblings().removeClass("active");
		}
	});
	$("#lnb .inner-menu a").on("click", function(){
		$("#lnb .inner-menu li").removeClass("active");
		$(this).closest("li").addClass("active");
	});

	//cont-head util user
	$(".cont-head .util .info button").on("click", function(){
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

	//input[type="file"]
	var fileTarget = $("input[type='file']"); 
	fileTarget.on("change", function(){ // 값이 변경되면
		$filename = $(this).val();
		$(this).siblings(".upload-name").val($filename);
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
	//selectbox
	$(document).on("click", ".selectbox", function(event){
		$(".selectbox").not($(this)).removeClass("open");
		$(this).toggleClass("open");
	});
	//Close when clicking outside
	$(document).on("click", function(event){
		if ($(event.target).closest(".selectbox").length === 0){
			$(".selectbox").removeClass("open");
		}
		event.stopPropagation();
	});
	*/


});


$(window).on("load", function(){
	//init
	fn.common();
});

