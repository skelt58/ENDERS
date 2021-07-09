/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller
 */
package kr.co.enders.ums.ems.sys.controller;

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
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.MessageUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/sys")
public class SystemController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private SystemService systemService;

	@Autowired
	private MessageUtil messageUtil;
	
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
		logger.debug("SystemController goDeptMain Start...");
		
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
	public ModelAndView getDeptListJson(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getDeptListJson searchDeptNm = " + deptVO.getSearchDeptNm());
		logger.debug("getDeptListJson searchStatus = " + deptVO.getSearchStatus());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(deptVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(deptVO.getRows(), Integer.parseInt(properties.getProperty("UMS.ROW_PER_PAGE")));
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
		
		
		int totCnt = newDeptList != null && deptList.size() > 0 ? ((DeptVO)newDeptList.get(0)).getTotCnt() : 0;
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
	public ModelAndView getDeptInfoJson(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("getDeptInfoJson deptNo = " + deptVO.getDeptNo());
		DeptVO deptInfo = null;
		try {
			deptInfo = systemService.getDeptInfo(deptVO);
			deptInfo.setRegDt(StringUtil.getFDate(deptInfo.getRegDt(), Code.DT_FMT2));
			deptInfo.setUpDt(StringUtil.getFDate(deptInfo.getUpDt(), Code.DT_FMT2));
		} catch(Exception e) {
			logger.error("systemService.getDeptInfo error = " + e);
		}
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("deptInfo", deptInfo);
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
	public ModelAndView insertDeptInfoJson(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("insertDeptInfoJson deptNm = " + deptVO.getDeptNm());
		logger.debug("insertDeptInfoJson status = " + deptVO.getStatus());
		logger.debug("insertDeptInfoJson deptDesc = " + deptVO.getDeptDesc());
		
		deptVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		deptVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		int result = 0;
		try {
			result = systemService.insertDeptInfo(deptVO);
		} catch(Exception e) {
			logger.error("systemService.insertDeptInfo error = " + e);
		}
		
		// 000COMJSALT008=등록 성공
		// 000COMJSALT009=등록 실패
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
			map.put("message", messageUtil.getMessage("000COMJSALT008"));
		} else {
			map.put("result","Fail");
			map.put("message", messageUtil.getMessage("000COMJSALT009"));
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
	public ModelAndView updateDeptInfoJson(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("updateDeptInfoJson deptNm = " + deptVO.getDeptNm());
		logger.debug("updateDeptInfoJson status = " + deptVO.getStatus());
		logger.debug("updateDeptInfoJson deptDesc = " + deptVO.getDeptDesc());
		
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
			map.put("message", messageUtil.getMessage("000COMJSALT010"));
		} else {
			map.put("result","Fail");
			map.put("message", messageUtil.getMessage("000COMJSALT011"));
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
	public ModelAndView getUserListJson(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getUserListJson deptNo = " + deptVO.getDeptNo());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(deptVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(deptVO.getRows(), Integer.parseInt(properties.getProperty("UMS.ROW_PER_PAGE")));
		deptVO.setPage(page);
		deptVO.setRows(rows);
		
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
		
		int totCnt = newUsertList != null && newUsertList.size() > 0 ? ((UserVO)newUsertList.get(0)).getTotCnt() : 0;
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
	 * 사용자 아이디를 체크한다. 아이디 중복을 방지.
	 * @param userVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userIdCheck")
	public ModelAndView userIdCheckJson(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("userIdCheckJson userId = " + userVO.getUserId());
		

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
	
	@RequestMapping(value="/userAdd")
	public ModelAndView insertUserInfoJson(@ModelAttribute UserVO userVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("insertUserInfoJson userId = " + userVO.getUserId());
		logger.debug("insertUserInfoJson userNm = " + userVO.getUserNm());
		logger.debug("insertUserInfoJson userPwd = " + userVO.getUserPwd());
		logger.debug("insertUserInfoJson userEm = " + userVO.getUserEm());
		logger.debug("insertUserInfoJson userTel = " + userVO.getUserTel());
		logger.debug("insertUserInfoJson status = " + userVO.getUserStatus());
		logger.debug("insertUserInfoJson deptNo = " + userVO.getSelDeptNo());
		logger.debug("insertUserInfoJson progId = " + userVO.getProgId());
		
		userVO.setDeptNo(userVO.getSelDeptNo());
		userVO.setStatus(userVO.getUserStatus());
		userVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		userVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		/*
		try {
			result = systemService.insertUserInfo(userVO);
		} catch(Exception e) {
			logger.error("systemService.insertUserInfo error = " + e);
		}
		*/
		// 000COMJSALT010=수정 성공
		// 000COMJSALT011=수정 실패
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
			map.put("message", messageUtil.getMessage("000COMJSALT010"));
		} else {
			map.put("result","Fail");
			map.put("message", messageUtil.getMessage("000COMJSALT011"));
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	
}
