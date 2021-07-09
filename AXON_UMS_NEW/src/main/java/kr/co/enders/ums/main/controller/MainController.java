/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 메인화면 처리
 */
package kr.co.enders.ums.main.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.enders.ums.main.service.MainService;
import kr.co.enders.ums.main.vo.MenuVO;

@Controller
@RequestMapping(value="/")
public class MainController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private MainService mainService;

	/**
	 * 메인화면
	 * @param model
	 * @param req
	 * @param res
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/index")
	public String goIndex(Model model, HttpServletRequest req, HttpServletResponse res, HttpSession session) {
		
		// 로그인 여부 세션확인
		String userId = (String)session.getAttribute("NEO_USER_ID");
		
		if(userId == null || "".equals(userId)) { // 로그인 화면으로 이동
			return "lgn/lgnP";
		} else {	// 메인 화면
			
			return "index";
		}
	}
}
