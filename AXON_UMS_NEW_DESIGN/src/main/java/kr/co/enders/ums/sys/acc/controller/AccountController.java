/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller==>사용자 코드 관리 Controller
 * 수정자 : 김준희
 * 작성일시 : 2021.08.09
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경 kr.co.enders.ums.sys.controller ==> kr.co.enders.ums.sys.acc.controller
 *                사용자코드 관리 기능 외의 항목제거
 */
package kr.co.enders.ums.sys.acc.controller;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.servlet.ModelAndView;

import kr.co.enders.ums.com.service.CodeService;
import kr.co.enders.ums.com.vo.CodeGroupVO;
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.sys.acc.service.AccountService;
import kr.co.enders.ums.sys.acc.vo.DeptVO;
import kr.co.enders.ums.sys.acc.vo.UserProgVO;
import kr.co.enders.ums.sys.acc.vo.UserVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/sys/acc")
public class AccountController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private AccountService systemService;

	@Autowired
	private PropertiesUtil properties;
 
	/**
	 * 부서/사용자관리 화면을 출력한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/deptMainP")
	public String goDeptMain(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("System Account Controller goDeptMain Start...");
		
		// 그룹상태코드 목록을 조회한다.
		CodeVO deptCodeVO = new CodeVO();
		deptCodeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		deptCodeVO.setCdGrp("C009");	// 그룹상태
		deptCodeVO.setUseYn("Y");
		List<CodeVO> deptStatusList = null;
		try {
			deptStatusList = codeService.getCodeList(deptCodeVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C009] = " + e);
		}
		
		// 사용자상태코드 목록을 조회한다.
		CodeVO userCodeVO = new CodeVO();
		userCodeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		userCodeVO.setCdGrp("C010");	// 사용자상태
		userCodeVO.setUseYn("Y");
		List<CodeVO> userStatusList = null;
		try {
			userStatusList = codeService.getCodeList(userCodeVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C010] = " + e);
		}
		
		// 문자셋유형코드 목록을 조회한다.
		CodeVO charsetVO = new CodeVO();
		charsetVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		charsetVO.setCdGrp("C022");	// 문자셋유형
		charsetVO.setUseYn("Y");
		List<CodeVO> charsetList = null;
		try {
			charsetList = codeService.getCodeList(charsetVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C022] = " + e);
		}
		
		// 언어권코드 목록을 조회한다.
		CodeVO uilangVO = new CodeVO();
		uilangVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		uilangVO.setCdGrp("C025");	// 언어퀀
		uilangVO.setUseYn("Y");
		List<CodeVO> uilangList = null;
		try {
			uilangList = codeService.getCodeList(uilangVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C025] = " + e);
		}
		
		// 타임존코드 목록을 조회한다.
		CodeVO timezoneVO = new CodeVO();
		timezoneVO.setUseYn("Y");
		List<CodeVO> timezoneList = null;
		try {
			timezoneList = codeService.getTimezoneList(timezoneVO);
		} catch(Exception e) {
			logger.error("codeService.getTimezoneList error = " + e);
		}
		
		// 부서 목록을 조회힌다.
		CodeVO deptVO = new CodeVO();
		deptVO.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(deptVO);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 권한그룹 목록을 조회한다. ------------------------- 사용 안하는 듯~~~~~~~~
		/*
		List<CodeVO> authGroupList = null;
		try {
			authGroupList = codeService.getAuthGroupList();
		} catch(Exception e) {
			logger.error("codeService.getAuthGroupList error = " + e);
		}
		*/
		
		// 프로그램 목록을 조회한다.
		CodeVO programVO = new CodeVO();
		programVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		List<CodeVO> programList = null;
		try {
			programList = codeService.getProgramList(programVO);
		} catch(Exception e) {
			logger.error("codeService.getProgramList error = " + e);
		}
		 
		// model에 코드 목록 추가
		model.addAttribute("deptStatusList", deptStatusList);		// 그룹상태코드
		model.addAttribute("userStatusList", userStatusList);		// 사용자상태코드
		model.addAttribute("charsetList", charsetList);				// 문자셋유형코드
		model.addAttribute("uilangList", uilangList);				// 언어권코드
		model.addAttribute("timezoneList", timezoneList);			// 타임존코드
		model.addAttribute("deptList", deptList);					// 부서(그룹)코드
		model.addAttribute("programList", programList);				// 프로그램
		
		return "ems/sys/deptMainP";
	}
	
	/**
	 * 부서 목록을 조회한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/deptList")
	public ModelAndView getDeptList(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getDeptList searchDeptNm = " + deptVO.getSearchDeptNm());
		logger.debug("getDeptList searchStatus = " + deptVO.getSearchStatus());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(deptVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(deptVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		deptVO.setPage(page);
		deptVO.setRows(rows);
		
		// 부서 목록 조회
		List<DeptVO> deptList = null;
		List<DeptVO> newDeptList = new ArrayList<DeptVO>();
		deptVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			deptList = systemService.getDeptList(deptVO);
		} catch(Exception e) {
			logger.error("systemService.getDeptList error = " + e);
		}
		// 등록일시 포멧 수정
		if(deptList != null) {
			for(DeptVO lDeptVO:deptList) {
				lDeptVO.setRegDt(StringUtil.getFDate(lDeptVO.getRegDt(), Code.DT_FMT2));
				newDeptList.add(lDeptVO);
			}
		}
		
		
		int totCnt = newDeptList != null && newDeptList.size() > 0 ? ((DeptVO)newDeptList.get(0)).getTotalCount() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("rows", newDeptList);
		map.put("page", page);
		map.put("total", total);
		map.put("records", totCnt);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 부서 정보를 조회한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/deptInfo")
	public ModelAndView getDeptInfo(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("getDeptInfo deptNo = " + deptVO.getDeptNo());
		DeptVO deptInfoVO = null;
		try {
			deptInfoVO = systemService.getDeptInfo(deptVO);
			deptInfoVO.setRegDt(StringUtil.getFDate(deptInfoVO.getRegDt(), Code.DT_FMT2));
			deptInfoVO.setUpDt(StringUtil.getFDate(deptInfoVO.getUpDt(), Code.DT_FMT2));
		} catch(Exception e) {
			logger.error("systemService.getDeptInfo error = " + e);
		}
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("deptInfo", deptInfoVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 신규 부서 정보를 등록한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/deptAdd")
	public ModelAndView insertDeptInfo(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("insertDeptInfo deptNm = " + deptVO.getDeptNm());
		logger.debug("insertDeptInfo status = " + deptVO.getStatus());
		logger.debug("insertDeptInfo deptDesc = " + deptVO.getDeptDesc());
		
		deptVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		deptVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		int result = 0;
		try {
			result = systemService.insertDeptInfo(deptVO);
		} catch(Exception e) {
			logger.error("systemService.insertDeptInfo error = " + e);
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 부서 정보를 수정한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/deptUpdate")
	public ModelAndView updateDeptInfo(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("updateDeptInfo deptNm = " + deptVO.getDeptNm());
		logger.debug("updateDeptInfo status = " + deptVO.getStatus());
		logger.debug("updateDeptInfo deptDesc = " + deptVO.getDeptDesc());
		
		deptVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		deptVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));

		int result = 0;
		try {
			result = systemService.updateDeptInfo(deptVO);
		} catch(Exception e) {
			logger.error("systemService.updateDeptInfo error = " + e);
		}
		
		// 000COMJSALT010=수정 성공
		// 000COMJSALT011=수정 실패
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	
	/**
	 * 사용자 목록을 조회한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/userList")
	public ModelAndView getUserList(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getUserList userDeptdeptNo = " + deptVO.getUserDeptNo());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(deptVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(deptVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		deptVO.setPage(page);
		deptVO.setRows(rows);
		deptVO.setDeptNo(deptVO.getUserDeptNo());
		
		// 사용자 목록 조회
		List<UserVO> userList = null;
		List<UserVO> newUsertList = new ArrayList<UserVO>();
		deptVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			userList = systemService.getUserList(deptVO);
		} catch(Exception e) {
			logger.error("systemService.getUserList error = " + e);
		}
		// 등록일시 포멧 수정
		if(userList != null) {
			for(UserVO userVO:userList) {
				userVO.setRegDt(StringUtil.getFDate(userVO.getRegDt(), Code.DT_FMT2));
				newUsertList.add(userVO);
			}
		}
		
		int totCnt = newUsertList != null && newUsertList.size() > 0 ? ((UserVO)newUsertList.get(0)).getTotalCount() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("rows", newUsertList);
		map.put("page", page);
		map.put("total", total);
		map.put("records", totCnt);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 부서 정보를 조회한다.
	 * @param deptVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userInfo")
	public ModelAndView getUserInfo(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("getUserInfo getUserId = " + userVO.getUserId());
		
		userVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		UserVO userInfoVO = null;
		List<UserProgVO> userProgList = null;
		try {
			userInfoVO = systemService.getUserInfo(userVO);
			userInfoVO.setRegDt(StringUtil.getFDate(userInfoVO.getRegDt(), Code.DT_FMT2));
			userInfoVO.setUpDt(StringUtil.getFDate(userInfoVO.getUpDt(), Code.DT_FMT2));
			
			userProgList = systemService.getUserProgList(userVO);
		} catch(Exception e) {
			logger.error("systemService.getUserInfo error = " + e);
		}
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("userInfo", userInfoVO);
		map.put("userProgList", userProgList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 사용자 아이디를 체크한다. 아이디 중복을 방지.
	 * @param userVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userIdCheck")
	public ModelAndView userIdCheck(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("userIdCheck userId = " + userVO.getUserId());
		

		boolean result = false;
		List<UserVO> userList = null;
		try {
			userList = systemService.userIdCheck(userVO.getUserId());
		} catch(Exception e) {
			logger.error("systemService.userIdCheck error = " + e);
		}
		
		if(userList != null && userList.size() > 0) {
			result = false;
		} else {
			result = true;
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 사용자 정보를 등록한다.
	 * @param userVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userAdd")
	public ModelAndView insertUserInfo(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("insertUserInfo userId = " + userVO.getUserId());
		logger.debug("insertUserInfo userNm = " + userVO.getUserNm());
		logger.debug("insertUserInfo userPwd = " + userVO.getUserPwd());
		logger.debug("insertUserInfo userEm = " + userVO.getUserEm());
		logger.debug("insertUserInfo userTel = " + userVO.getUserTel());
		logger.debug("insertUserInfo status = " + userVO.getUserStatus());
		logger.debug("insertUserInfo deptNo = " + userVO.getSelDeptNo());
		logger.debug("insertUserInfo progId = " + userVO.getProgId());
		
		userVO.setDeptNo(userVO.getSelDeptNo());
		userVO.setStatus(userVO.getUserStatus());
		userVO.setUserPwd(EncryptUtil.getEncryptedSHA256(userVO.getUserPwd()));
		userVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		userVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		// 사용자 정보를 등록한다.(사용자 정보 + 사용자 프로그램 정보)
		try {
			result = systemService.insertUserInfo(userVO);
		} catch(Exception e) {
			logger.error("systemService.insertUserInfo error = " + e);
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		return modelAndView;
	}
	
	/**
	 * 사용자 정보를 업데이트 한다.
	 * @param userVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userUpdate")
	public ModelAndView updateUserInfo(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateUserInfo userId = " + userVO.getUserId());
		logger.debug("updateUserInfo userNm = " + userVO.getUserNm());
		logger.debug("updateUserInfo userPwd = " + userVO.getUserPwd());
		logger.debug("updateUserInfo userEm = " + userVO.getUserEm());
		logger.debug("updateUserInfo userTel = " + userVO.getUserTel());
		logger.debug("updateUserInfo status = " + userVO.getUserStatus());
		logger.debug("updateUserInfo deptNo = " + userVO.getSelDeptNo());
		logger.debug("updateUserInfo progId = " + userVO.getProgId());
		
		userVO.setDeptNo(userVO.getSelDeptNo());
		userVO.setStatus(userVO.getUserStatus());
		if(userVO.getUserPwd() != null && !"".equals(userVO.getUserPwd())) {
			userVO.setUserPwd(EncryptUtil.getEncryptedSHA256(userVO.getUserPwd()));
		}
		userVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		userVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		int result = 0;
		
		// 사용자 정보를 수정한다.(사용자 정보 수정 + 사용자 프로그램 정보 삭제 + 사용자 프로그램 등록)
		try {
			result = systemService.updateUserInfo(userVO);
		} catch(Exception e) {
			logger.error("systemService.updateUserInfo error = " + e);
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);		
		return modelAndView;
	}
}
