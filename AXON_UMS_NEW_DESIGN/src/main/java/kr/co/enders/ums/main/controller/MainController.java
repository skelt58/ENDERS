/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 메인화면 처리
 */
package kr.co.enders.ums.main.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/")
public class MainController {
	private Logger logger = Logger.getLogger(this.getClass());
	
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
		logger.debug("## goIndex Start.");
		
		// 로그인 여부 세션확인
		String userId = (String)session.getAttribute("NEO_USER_ID");
		
		if(userId == null || "".equals(userId)) { // 로그인 화면으로 이동
			return "lgn/lgnP";
		} else {	// 메인 화면
			
			return "index";
		}
	}
	
	/**
	 * 메인화면
	 * @param model
	 * @param req
	 * @param res
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/service")
	public String goService(Model model, HttpServletRequest req, HttpServletResponse res, HttpSession session) {
		logger.debug("## goService Start.");
		
		// 서비스 체크 필요
			
		return "service";
	}
	
	/**
	 * EMS 메인화면
	 * @param model
	 * @param req
	 * @param res
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/ems/index")
	public String goEmsMain(Model model, HttpServletRequest req, HttpServletResponse res, HttpSession session) {
		logger.debug("## goEmsMain Start.");
		
		// EMS 메인화면
			
		return "ems/index";
	}
	
	/**
	 * RNS 메인화면
	 * @param model
	 * @param req
	 * @param res
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/rns/index")
	public String goRnsMain(Model model, HttpServletRequest req, HttpServletResponse res, HttpSession session) {
		logger.debug("## goRnsMain Start.");
		
		// RNS 메인화면
			
		return "rns/index";
	}
}
