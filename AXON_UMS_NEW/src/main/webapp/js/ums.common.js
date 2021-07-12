/**********************************************************
*	작성자 : 김상진
*	작성일시 : 2021.07.06
*	설명 : 공통 자바스크립트
**********************************************************/


/********************************************************
 * 쿠키값 설정 (쿠키명, 쿠키값, 기간)
 ********************************************************/
function setCookie( name, value, expiredays ) {
    var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays );
    document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

/********************************************************
 * 쿠키값 조회
 ********************************************************/
function getCookie(name) {
    var nameOfCookie = name + "=";
    var x = 0;
    while ( x <= document.cookie.length ) {
        var y = (x+nameOfCookie.length);
        if ( document.cookie.substring( x, y ) == nameOfCookie ) {
            if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                endOfCookie = document.cookie.length;
            return unescape( document.cookie.substring( y, endOfCookie ) );
        }
        x = document.cookie.indexOf( " ", x ) + 1;
        if ( x == 0 )
            break;
    }
    return "";
}


/********************************************************
 * jQuery 관련
 ********************************************************/
(function($) {
	$(document).ready(function(){
		/********************************************************
		 * datepicker 기본설정
		 ********************************************************/
		$.datepicker.regional['ko'] = {
			closeText: '닫기',
			prevText: '이전달',
			nextText: '다음달',
			currentText: '오늘',
			monthNames: ['1월','2월','3월','4월','5월','6월',
			             '7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월',
			                  '7월','8월','9월','10월','11월','12월'],
			dayNames: ['일','월','화','수','목','금','토'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			weekHeader: '주',
			dateFormat: 'yy-mm-dd',
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: '',
			changeMonth: true,
			changeYear: true
		};
		$.datepicker.setDefaults($.datepicker.regional['ko']);
	});

	var hangulByteLenth = 3; //한글 한글자에 대한 byte 를 지정


	/********************************************************
	 * TextArea 텍스트 입력 byte 체크
	 ********************************************************/
	$.fn.checkbyte = function(d) {
		var e = {
			indicator : $("#indicator"),
			limit : 80,
			twice : false
		};
		if (d) {
			$.extend(e, d);
		};
		return this.each(function() {
			var c = $(this);
			c.bind("keyup", function(a) {
				$.check(c, e.indicator, parseInt(e.limit), e.twice);
			});
		});
	};

	/********************************************************
	 * 최대 입력 문자열 길이 초과시 문자열 자름
	 ********************************************************/
	$.limitString = function(a, b) {
		var d = new String(a);
		var e = 0;
		for ( var i = 0; i < a.length; i++) {
			var c = escape(a.charAt(i));
			if (c.length == 1)
				e++;
			else if (c.indexOf("%u") != -1)
				e += hangulByteLenth;
			else if (c.indexOf("%") != -1)
				e += c.length / 3;
			if (e > b) {
				d = d.substring(0, i);
				break;
			}
		}
		return d;
	};

	/********************************************************
	 * 문자열 byte 체크
	 ********************************************************/
	$.byteString = function(a) {
		var b = 0;
		for ( var i = 0; i < a.length; i++) {
			var c = escape(a.charAt(i));
			if (c.length == 1)
				b++;
			else if (c.indexOf("%u") != -1)
				b += hangulByteLenth;
			else if (c.indexOf("%") != -1)
				b += c.length / 3;
		}
		return b;
	};

	/********************************************************
	 * 텍스트 입력 byte 제한
	 ********************************************************/
	$.check = function(a, b, c, d) {
		var e = $.byteString(a.val());
		if (e > c) {
			alert("내용은 " + c + "byte를 넘을 수 없습니다. 초과된 부분은 자동으로 삭제됩니다.");
			a.val($.limitString(a.val(), c));
		}
		b.html($.byteString(a.val()));
	};

	
	/********************************************************
	 * input box 문자열 길이 체크
	 ********************************************************/
	$.checkLength = function(strId, strName, minLen, maxLen) {
		var text = $.trim($('#' + strId).val()); //문자열 trim 추가(하윤식 2012.10.24)
		var textLen = $.byteString(text);

		if(minLen > 0 && textLen == 0) {
			msg = "[" + strName + "] : 입력해주십시오";
			$.showMsgBox(msg, null, strId);
			return false;
		}else if(textLen < minLen || textLen > maxLen) {
			if(minLen == maxLen) {
				msg = "[" + strName + "] : " + minLen + "Byte를 입력해주십시오\r\n\r\n (주의: 한글 1자는 " + hangulByteLenth + "Byte로 계산함.)";
				$.showMsgBox(msg, null, strId);
				return false;
			} else {
				msg = "[" + strName + "] : " + minLen + " - " + maxLen + " Byte를  입력해주십시오. <br/>(주의: 한글 1자는 " + hangulByteLenth + "Byte로 계산함.)";
				$.showMsgBox(msg, null, strId);
				return false;
			}
		} else {
			return true;
		}
	};

	/********************************************************
	 * jqGrid check box 선택여부 확인
	 ********************************************************/
	$.gridSelectChk = function(listId) {
		var id = $("#" + listId).getGridParam('selarrrow');
		var ids = $("#" + listId).jqGrid('getDataIDs');
		var isCheck = false;

		for (var i = 0; i < ids.length; i++) {
		    $.each(id, function (index, value) {
		        if (value == ids[i]) {
		        	isCheck = true;
		        }
		    });
		}
		return isCheck;
	};


	//배열의 중복 문자 제거..
	//배열명.unique(); <-- 사용법
	//var a = {1,2,3,4,5,1,2};
	//a.unique();
	//결과 [1,2,3,4,5]
	Array.prototype.unique = function() {
		var a = {};
		for(var i=0; i<this.length; i++)   {
			if(typeof a[this[i]] == "undefined")
				a[this[i]] = 1;
		}

		this.length = 0;
		for(var i in a)
			this[this.length] = i;

		return this;
	};

	// 주어진 패턴 공식에서 문자만 뽑아내서 갯수를 세고,
	// 각 A,B,C는 patChar[i]형태로 배열에 저장한다.
	//function extChar2(patt) {
	String.prototype.extChar = function() {
		var charReg;
		charReg = /\d/; // 삭제할 부분 숫자
		//charReg = /[a-z|A-Z]/; // 알파벳만 인정
		//charReg = /[a-z]/; // 알파벳 소문자만 인정
		charReg = /[A-Z]/; // 알파벳 대문자만 인정

		var pattern = this; // 패턴 공식 값 DB에서 읽어올 것
		var Char = "";
		var patChar = pattern.split("");

		for(var i=0; i<patChar.length; i++) {
			if(charReg.test(patChar[i])) {
				Char += patChar[i] + "/";
			}
		}

		return Char; //최종으로 뽑아낸 문자만 리턴해준다.
	};

	/********************************************************
	 * 설정된 value 값 초기화
	 ********************************************************/
	$.setInit = function(initObj) {
		for (var i = 0; i < arguments.length; i++) {
			$("#" + arguments[i]).val("");
		}
	};

	$.fn.numericOnly = function(param) {
			var allowList = "";
			if(param && param.allow && param.allow.length > 0 ){
				for( var i = 0 ;i < param.allow.length;i++ ){
					if(param.allow[i] == '.'){
						allowList+= "\\.";
					}
				}
			}

			return this.each(function() {
				var c = $(this);
				var regExp = new RegExp('[^0-9'+allowList+']','g');
				c.keyup(function(a) {
					if (this.value != this.value.replace(regExp, '')) {
					       this.value = this.value.replace(regExp, '');
					    }
				});
				c.change(function(a) {
					if (this.value != this.value.replace(regExp, '')) {
					       this.value = this.value.replace(regExp, '');
					    }
				});
			});
	};

})(jQuery);
