/**
* --------------------------------
* Ems JS
* creator : chowoobin
* from : enders
* --------------------------------
*/

$(window).on('load', function(){
    
    //datebannerswiper
    var $datebannerswiperObj = $(".datebannerswiper");
    if ( $datebannerswiperObj.find(".swiper-slide").length > 1 ){
        var datebannerswiper = new Swiper(".datebannerswiper", {
            slidesPerView: "1",
            navigation: {
                nextEl: ".swiper-button-next-date",
                prevEl: ".swiper-button-prev-date",
            },
            observer: true,
            observeParents: true,
        });
    }

	//발송결재라인 등록 팝업 내 사용자
	$(document).on("click", ".user button", function(){
		if($(this).closest("li").hasClass("active")){
			$(this).closest("li").removeClass("active");
		}else{
			$(this).closest("li").addClass("active").siblings().removeClass("active");
		}
	});
    
});
