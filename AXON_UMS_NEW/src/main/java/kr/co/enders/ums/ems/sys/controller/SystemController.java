/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller
 */
package kr.co.enders.ums.ems.sys.controller;

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
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.UserProgVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
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
	public ModelAndView getDeptList(@ModelAttribute DeptVO deptVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getDeptList searchDeptNm = " + deptVO.getSearchDeptNm());
		logger.debug("getDeptList searchStatus = " + deptVO.getSearchStatus());
		
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
		
		
		int totCnt = newDeptList != null && newDeptList.size() > 0 ? ((DeptVO)newDeptList.get(0)).getTotCnt() : 0;
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
		int rows = StringUtil.setNullToInt(deptVO.getRows(), Integer.parseInt(properties.getProperty("UMS.ROW_PER_PAGE")));
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
	
	/**
	 * DB Connection 메인 화면을 출력한다.
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/dbconnMainP")
	public String goDbConnMain(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("SystemController goDbConnMain Start...");
		
		// DBMS 유형 목록을 조회한다.
		CodeVO dbmsTypeVO = new CodeVO();
		dbmsTypeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbmsTypeVO.setCdGrp("C033");	// DBMS 유형
		dbmsTypeVO.setUseYn("Y");
		List<CodeVO> dbmsTypeList = null;
		try {
			dbmsTypeList = codeService.getCodeList(dbmsTypeVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C033] = " + e);
		}
		
		// DB Connection 상태코드 목록을 조회한다.
		CodeVO dbConnStatusVO = new CodeVO();
		dbConnStatusVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbConnStatusVO.setCdGrp("C011");	// DB Connection 상태
		dbConnStatusVO.setUseYn("Y");
		List<CodeVO> dbConnStatusList = null;
		try {
			dbConnStatusList = codeService.getCodeList(dbConnStatusVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C011] = " + e);
		}
		
		// DB CharSet 코드 목록을 조회한다.
		CodeVO dbCharSetVO = new CodeVO();
		dbCharSetVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbCharSetVO.setCdGrp("C032");	// DB CharSet
		dbCharSetVO.setUseYn("Y");
		List<CodeVO> dbCharSetList = null;
		try {
			dbCharSetList = codeService.getCodeList(dbCharSetVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C032] = " + e);
		}
		
		// model에 코드 목록 추가
		model.addAttribute("dbmsTypeList", dbmsTypeList);			// DBMS유형코드
		model.addAttribute("dbConnStatusList", dbConnStatusList);	// DBConnection상태코드
		model.addAttribute("dbCharSetList",dbCharSetList);			// DB CharSet
		
		// 검색항목 설정
		// 페이지 설정
		int page = StringUtil.setNullToInt(dbConnVO.getPage(), 1);
		dbConnVO.setPage(page);
		dbConnVO.setSearchStatus(dbConnVO.getSearchStatus()==null||"".equals(dbConnVO.getSearchStatus())?"000":dbConnVO.getSearchStatus());
		model.addAttribute("searchInfo", dbConnVO);
		
		return "ems/sys/dbconnMainP";
	}
	
	/**
	 * DB Connection 목록 조회
	 * @param dbconnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/dbconnList")
	public ModelAndView getDbconnList(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getDbconnList searchDbConnNm = " + dbConnVO.getSearchDbConnNm());
		logger.debug("getDbconnList searchDbTy = " + dbConnVO.getSearchDbTy());
		logger.debug("getDbconnList searchStatus = " + dbConnVO.getSearchStatus());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(dbConnVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(dbConnVO.getRows(), Integer.parseInt(properties.getProperty("UMS.ROW_PER_PAGE")));
		dbConnVO.setPage(page);
		dbConnVO.setRows(rows);
		
		// 부서 목록 조회
		List<DbConnVO> dbConnList = null;
		List<DbConnVO> newDbConnList = new ArrayList<DbConnVO>();
		dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			dbConnList = systemService.getDbConnList(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnList error = " + e);
		}
		// 등록일시 포멧 수정
		if(dbConnList != null) {
			for(DbConnVO lDbconnVO:dbConnList) {
				lDbconnVO.setRegDt(StringUtil.getFDate(lDbconnVO.getRegDt(), Code.DT_FMT2));
				newDbConnList.add(lDbconnVO);
			}
		}
		
		
		int totCnt = newDbConnList != null && newDbConnList.size() > 0 ? ((DbConnVO)newDbConnList.get(0)).getTotCnt() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("rows", newDbConnList);
		map.put("page", page);
		map.put("total", total);
		map.put("records", totCnt);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * DB Connection 정보를 등록한다.
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/dbconnAdd")
	public ModelAndView insertDbConnInfo(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("insertDbConnInfo dbConnNm = " + dbConnVO.getDbConnNm());
		logger.debug("insertDbConnInfo dbTy = " + dbConnVO.getDbTy());
		logger.debug("insertDbConnInfo status = " + dbConnVO.getStatus());
		logger.debug("insertDbConnInfo dbDriver = " + dbConnVO.getDbDriver());
		logger.debug("insertDbConnInfo dbUrl = " + dbConnVO.getDbUrl());
		logger.debug("insertDbConnInfo dbCharSet = " + dbConnVO.getDbCharSet());
		logger.debug("insertDbConnInfo loginId = " + dbConnVO.getLoginId());
		logger.debug("insertDbConnInfo loginPwd = " + dbConnVO.getLoginPwd());
		logger.debug("insertDbConnInfo dbConnDesc = " + dbConnVO.getDbConnDesc());
		
		dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.algorithm"), properties.getProperty("JASYPT.password"), dbConnVO.getLoginPwd()));
		dbConnVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		dbConnVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		// DB Connection 정보를 등록한다.
		try {
			result = systemService.insertDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.insertDbConnInfo error = " + e);
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
	 * DB Connection 연결을 테스트 한다.
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/dbconnTest")
	public ModelAndView testDbConn(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		int result = 0;
		
		logger.debug("testDbConn dbDriver = " + dbConnVO.getDbDriver());
		logger.debug("testDbConn dbUrl = " + dbConnVO.getDbUrl());
		logger.debug("testDbConn loginId = " + dbConnVO.getLoginId());
		logger.debug("testDbConn loginPwd = " + dbConnVO.getLoginPwd());

		// DB 접속 테스트
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String errMsg = "";
		try {
			conn = dbUtil.getConnection(dbConnVO.getDbDriver(), dbConnVO.getDbUrl(), dbConnVO.getLoginId(), dbConnVO.getLoginPwd());
			result++;
		} catch(Exception e) {
			logger.error("dbUtil.getConnection error = " + e);
			errMsg = e.toString();
		} finally {
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
			map.put("errMsg", errMsg);
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		return modelAndView;
	}
	
	/**
	 * DB Connection 정보를 조회한다.
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/dbconnInfoP")
	public String goDbConnInfo(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("SystemController goDbConnInfo Start...");
		
		logger.debug("goDbConnInfo searchDbConnNo = " + dbConnVO.getSearchDbConnNo());
		logger.debug("goDbConnInfo searchDbConnNm = " + dbConnVO.getSearchDbConnNm());
		logger.debug("goDbConnInfo searchDbTy = " + dbConnVO.getSearchDbTy());
		logger.debug("goDbConnInfo searchStatus = " + dbConnVO.getSearchStatus());
		dbConnVO.setDbConnNo(dbConnVO.getSearchDbConnNo());
		
		// DBMS 유형 목록을 조회한다.
		CodeVO dbmsTypeVO = new CodeVO();
		dbmsTypeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbmsTypeVO.setCdGrp("C033");	// DBMS 유형
		dbmsTypeVO.setUseYn("Y");
		List<CodeVO> dbmsTypeList = null;
		try {
			dbmsTypeList = codeService.getCodeList(dbmsTypeVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C033] = " + e);
		}
		
		// DB Connection 상태코드 목록을 조회한다.
		CodeVO dbConnStatusVO = new CodeVO();
		dbConnStatusVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbConnStatusVO.setCdGrp("C011");	// DB Connection 상태
		dbConnStatusVO.setUseYn("Y");
		List<CodeVO> dbConnStatusList = null;
		try {
			dbConnStatusList = codeService.getCodeList(dbConnStatusVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C011] = " + e);
		}
		
		// DB CharSet 코드 목록을 조회한다.
		CodeVO dbCharSetVO = new CodeVO();
		dbCharSetVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbCharSetVO.setCdGrp("C032");	// DB CharSet
		dbCharSetVO.setUseYn("Y");
		List<CodeVO> dbCharSetList = null;
		try {
			dbCharSetList = codeService.getCodeList(dbCharSetVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C032] = " + e);
		}
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnVO);
			dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.algorithm"), properties.getProperty("JASYPT.password"), dbConnInfo.getLoginPwd()));
			dbConnInfo.setRegDt(StringUtil.getFDate(dbConnInfo.getRegDt(), Code.DT_FMT2));
			dbConnInfo.setUpDt(StringUtil.getFDate(dbConnInfo.getUpDt(), Code.DT_FMT2));
			
			logger.debug("systemService.getDbConnInfo Decrypted Password = " + dbConnInfo.getLoginPwd());
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// model에 코드 목록 추가
		model.addAttribute("dbmsTypeList", dbmsTypeList);			// DBMS유형코드
		model.addAttribute("dbConnStatusList", dbConnStatusList);	// DB Connection상태코드
		model.addAttribute("dbCharSetList",dbCharSetList);			// DB CharSet
		model.addAttribute("searchInfo", dbConnVO);					// 리스트 페이지 검색정보
		model.addAttribute("dbConnInfo", dbConnInfo);				// DB Connetion 정보
		
		return "ems/sys/dbconnInfoP";
	}
	
	/**
	 * DB Connection 정보를 수정한다.
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/dbconnUpdate")
	public ModelAndView updateDbConnInfo(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		logger.debug("updateDbConnInfo dbConnNo = " + dbConnVO.getDbConnNo());
		logger.debug("updateDbConnInfo dbConnNm = " + dbConnVO.getDbConnNm());
		logger.debug("updateDbConnInfo dbTy = " + dbConnVO.getDbTy());
		logger.debug("updateDbConnInfo status = " + dbConnVO.getStatus());
		logger.debug("updateDbConnInfo dbDriver = " + dbConnVO.getDbDriver());
		logger.debug("updateDbConnInfo dbUrl = " + dbConnVO.getDbUrl());
		logger.debug("updateDbConnInfo dbCharSet = " + dbConnVO.getDbCharSet());
		logger.debug("updateDbConnInfo loginId = " + dbConnVO.getLoginId());
		logger.debug("updateDbConnInfo loginPwd = " + dbConnVO.getLoginPwd());
		logger.debug("updateDbConnInfo dbConnDesc = " + dbConnVO.getDbConnDesc());
		
		dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.algorithm"), properties.getProperty("JASYPT.password"), dbConnVO.getLoginPwd()));
		dbConnVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		dbConnVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		// DB Connection 정보를 수정한다.
		try {
			result = systemService.updateDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.updateDbConnInfo error = " + e);
		}
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnVO);
			dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.algorithm"), properties.getProperty("JASYPT.password"), dbConnInfo.getLoginPwd()));
			dbConnInfo.setRegDt(StringUtil.getFDate(dbConnInfo.getRegDt(), Code.DT_FMT2));
			dbConnInfo.setUpDt(StringUtil.getFDate(dbConnInfo.getUpDt(), Code.DT_FMT2));
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}

		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
			map.put("dbConnInfo", dbConnInfo);
		} else {
			map.put("result","Fail");
		}
		
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		return modelAndView;
	}
	
	/**
	 * 사용자 로그인 이력관리 화면을 출력한다.
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/lgnhstListP")
	public String goLoginHistList(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String searchLgnStdDt = StringUtil.getCalcDateFromCurr(-1, "M", "yyyy-MM-dd");
		String searchLgnEndDt = StringUtil.getCalcDateFromCurr(0, "D", "yyyy-MM-dd");
		
		model.addAttribute("searchLgnStdDt", searchLgnStdDt);
		model.addAttribute("searchLgnEndDt", searchLgnEndDt);
		
		return "ems/sys/lgnhstListP";
	}
	
	/**
	 * 사용자 로그인 이력 목록을 조회한다.
	 * @param loginHistVO
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/lgnhstList")
	public ModelAndView getLoginHistList(@ModelAttribute LoginHistVO loginHistVO, Model model) {
		logger.debug("getLoginHistList searchDeptNm = " + loginHistVO.getSearchDeptNm());
		logger.debug("getLoginHistList searchUserId = " + loginHistVO.getSearchUserId());
		logger.debug("getLoginHistList searchLgnStdDt = " + loginHistVO.getSearchLgnStdDt());
		logger.debug("getLoginHistList searchLgnEndDt = " + loginHistVO.getSearchLgnEndDt());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(loginHistVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(loginHistVO.getRows(), Integer.parseInt(properties.getProperty("UMS.ROW_PER_PAGE")));
		loginHistVO.setPage(page);
		loginHistVO.setRows(rows);
		loginHistVO.setSearchLgnStdDt(loginHistVO.getSearchLgnStdDt().replaceAll("-", "") + "000000");
		loginHistVO.setSearchLgnEndDt(loginHistVO.getSearchLgnEndDt().replaceAll("-", "") + "235959");
		
		
		// 부서 목록 조회
		List<LoginHistVO> loginHistList = null;
		List<LoginHistVO> newLoginHistList = new ArrayList<LoginHistVO>();
		try {
			loginHistList = systemService.getLoginHistList(loginHistVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnList error = " + e);
		}
		// 등록일시 포멧 수정
		if(loginHistList != null) {
			for(LoginHistVO nLoginHistVO:loginHistList) {
				nLoginHistVO.setLgnDt(StringUtil.getFDate(nLoginHistVO.getLgnDt(), Code.DT_FMT2));
				newLoginHistList.add(nLoginHistVO);
			}
		}
		
		
		int totCnt = newLoginHistList != null && newLoginHistList.size() > 0 ? ((LoginHistVO)newLoginHistList.get(0)).getTotCnt() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("rows", newLoginHistList);
		map.put("page", page);
		map.put("total", total);
		map.put("records", totCnt);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;

	}
}
