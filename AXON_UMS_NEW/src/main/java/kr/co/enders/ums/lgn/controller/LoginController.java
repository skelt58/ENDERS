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

import kr.co.enders.ums.ems.sys.vo.UserProgVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;
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
		
		return "/lgn/lgnP";
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
			model.addAttribute("result","Y");
			
			// 세션값 설정
			session.setAttribute("NEO_USER_ID", userVO.getUserId());
			session.setAttribute("NEO_USER_NM", userVO.getUserNm());
			session.setAttribute("NEO_DEPT_NO", userVO.getDeptNo());
			session.setAttribute("NEO_TZ_CD", userVO.getTzCd());
			session.setAttribute("NEO_TZ_TERM", userVO.getTzTerm());
			session.setAttribute("NEO_UILANG", userVO.getUilang());
			session.setAttribute("NEO_CHARSET", userVO.getCharset());
			session.setAttribute("NEO_FONT", userVO.getFont());
			
			// 사용자 프로그램 사용권한 조회
			List<UserProgVO> userProgList = null;
			try {
				userProgList = loginService.getUserProgList(userVO.getUserId());
			} catch(Exception e) {
				logger.error("loginService.getUserProgList Error = " + e);
			}
			session.setAttribute("USER_PROG_LIST", userProgList);
			//model.addAttribute("userProgList", userProgList);
			
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
			return "/lgn/lgn";
			
		} else {
			model.addAttribute("result","N");
			return "/lgn/lgnP";
		}
	}
	
	@RequestMapping(value="/logout")
	public String goLogout(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		// 세션정보 초기화
		session.invalidate();
		
		return "/lgn/lgnP";
	}
}
