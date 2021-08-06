/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 로그인 Controller
 */
package kr.co.enders.ums.lgn.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.enders.ums.sys.vo.SysMenuVO;
import kr.co.enders.ums.sys.vo.UserVO;
import kr.co.enders.ums.lgn.service.LoginService;
import kr.co.enders.ums.lgn.vo.LoginHistVO;
import kr.co.enders.ums.lgn.vo.LoginVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.EncryptUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/lgn")
public class LoginController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private LoginService loginService;
	
	/**
	 * 로그인 화면을 출력한다.
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/lgnP")
	public String goLogin(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		logger.debug("## goLogin Form Start");
		
		return "lgn/lgnP";
	}
	
	/**
	 * 사용자 로그인을 처리한다.
	 * @param loginVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/lgn")
	public String loginProcess(@ModelAttribute LoginVO loginVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("## login process Start");
		
		// 아이디, 비밀번호 확인
		logger.debug("loginProcess pUserId = " + loginVO.getpUserId());
		logger.debug("loginProcess pUserPwd = " + loginVO.getpUserPwd());
		
		// ADMIN 처리
		if("ADMIN".equals(loginVO.getpUserId().toUpperCase())) {
			loginVO.setpUserId(loginVO.getpUserId().toUpperCase());
			loginVO.setpUserPwd(loginVO.getpUserPwd().toUpperCase());
		}
		
		String encPasswd = EncryptUtil.getEncryptedSHA256(loginVO.getpUserPwd());
		loginVO.setpUserPwd(encPasswd);
		UserVO userVO = null;
		
		// 사용자 아이디, 비밀번호 체크
		try {
			userVO = loginService.isValidUser(loginVO);
		} catch(Exception e) {
			logger.error("loginService.isValidUser Error = " + e);			
		}
		
		if(userVO != null) {
			
			// 세션값 설정
			session.setAttribute("NEO_USER_ID", userVO.getUserId());		// 사용자ID
			session.setAttribute("NEO_USER_NM", userVO.getUserNm());		// 사용자명
			session.setAttribute("NEO_DEPT_NO", userVO.getDeptNo());		// 부서번호
			session.setAttribute("NEO_DEPT_NM", userVO.getDeptNm());		// 부서명
			session.setAttribute("NEO_TZ_CD", userVO.getTzCd());			// 타임존코드
			session.setAttribute("NEO_TZ_TERM", userVO.getTzTerm());		// 타임존시간차
			session.setAttribute("NEO_UILANG", userVO.getUilang());			// 언어권
			session.setAttribute("NEO_CHARSET", userVO.getCharset());		// 문자셋
			session.setAttribute("NEO_FONT", userVO.getFont());				// 폰트
			// 관리자 여부
			if(userVO.getDeptNo() == 1) {
				session.setAttribute("NEO_ADMIN_YN", "Y");
			} else {
				session.setAttribute("NEO_ADMIN_YN", "N");
			}
			
			// 사용자 프로그램 사용권한 조회(데이터 등록 환경에 따라 쿼리 변동 가능성 있음)
			// 1단계 메뉴
			List<SysMenuVO> menuLvl1List = null;
			try {
				menuLvl1List = loginService.getUserMenuLvl1List(userVO.getUserId());
			} catch(Exception e) {
				logger.error("loginService.getUserMenuLvl1List Error = " + e);
			}
			// 2단계 메뉴
			List<SysMenuVO> menuLvl2List = null;
			try {
				menuLvl2List = loginService.getUserMenuLvl2List(userVO.getUserId());
			} catch(Exception e) {
				logger.error("loginService.getUserMenuLvl2List Error = " + e);
			}
			// 세션에 사용가능 메뉴 목록 저장
			session.setAttribute("MENU_LVL1_LIST", menuLvl1List);
			session.setAttribute("MENU_LVL2_LIST", menuLvl2List);
			
			// 로그인 이력 등록
			LoginHistVO histVO = new LoginHistVO();
			histVO.setDeptNo(userVO.getDeptNo());
			histVO.setUserId(userVO.getUserId());
			histVO.setLgnDt(StringUtil.getDate(Code.TM_YMDHMS));
			histVO.setLgnIp(request.getRemoteAddr());
			try {
				loginService.insertLoginHist(histVO);
			} catch(Exception e) {
				logger.error("loginService.insertLoginHist Error = " + e);
			}
			
			model.addAttribute("result","Y");
			return "lgn/lgn";
			
		} else {
			model.addAttribute("result","N");
			return "lgn/lgnP";
		}
	}
	
	/**
	 * 로그아웃 처리
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/logout")
	public String goLogout(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		// 세션정보 초기화
		session.invalidate();
		
		return "lgn/logout";
	}
	
	/**
	 * 세션 타임아웃 처리
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/timeout")
	public String goSessionTimeout(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		String requestUri = request.getRequestURI();
		
		model.addAttribute("requestUri", requestUri);
		
		return "lgn/timeout";
	}
}
