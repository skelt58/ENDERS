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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.enders.ums.main.service.MainService;
import kr.co.enders.ums.sys.vo.SysMenuVO;
import kr.co.enders.util.PropertiesUtil;

@Controller
@RequestMapping(value="/")
public class MainController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private PropertiesUtil properties;
	
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
		String pMenuId = properties.getProperty("MENU.EMS_INIT_P_MENU_ID");
		String menuId = properties.getProperty("MENU.EMS_INIT_MENU_ID");
		session.setAttribute("NEO_P_MENU_ID", pMenuId);
		session.setAttribute("NEO_MENU_ID", menuId);
		
		// 기본 접속 화면 설정
		SysMenuVO menuInfo = null;
		try {
			menuInfo = mainService.getMenuBasicInfo(menuId);
		} catch(Exception e) {
			logger.error("mainService.getMenuBasicInfo error = " + e);
		}
		
		model.addAttribute("baseSourcePath", menuInfo.getSourcePath());
			
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
		String pMenuId = properties.getProperty("MENU.RNS_INIT_P_MENU_ID");
		String menuId = properties.getProperty("MENU.RNS_INIT_MENU_ID");
		session.setAttribute("NEO_P_MENU_ID", pMenuId);
		session.setAttribute("NEO_MENU_ID", menuId);
		
		// 기본 접속 화면 설정
		SysMenuVO menuInfo = null;
		try {
			menuInfo = mainService.getMenuBasicInfo(menuId);
		} catch(Exception e) {
			logger.error("mainService.getMenuBasicInfo error = " + e);
		}
		
		model.addAttribute("baseSourcePath", menuInfo.getSourcePath());
			
		return "rns/index";
	}
}
