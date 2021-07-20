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
import kr.co.enders.ums.com.vo.CodeGroupVO;
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.DbConnPermVO;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;
import kr.co.enders.ums.ems.sys.vo.MetaJoinVO;
import kr.co.enders.ums.ems.sys.vo.MetaOperatorVO;
import kr.co.enders.ums.ems.sys.vo.MetaTableVO;
import kr.co.enders.ums.ems.sys.vo.MetaValueVO;
import kr.co.enders.ums.ems.sys.vo.UserCodeVO;
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
		int rows = StringUtil.setNullToInt(dbConnVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
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
		
		
		int totCnt = newDbConnList != null && newDbConnList.size() > 0 ? ((DbConnVO)newDbConnList.get(0)).getTotalCount() : 0;
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
		
		dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnVO.getLoginPwd()));
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
		if(dbConnVO.getSearchDbConnNo() == 0) {
			dbConnVO.setDbConnNo(dbConnVO.getDbConnNo());
		} else {
			dbConnVO.setDbConnNo(dbConnVO.getSearchDbConnNo());
		}
		
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
			dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd()));
			dbConnInfo.setRegDt(StringUtil.getFDate(dbConnInfo.getRegDt(), Code.DT_FMT2));
			dbConnInfo.setUpDt(StringUtil.getFDate(dbConnInfo.getUpDt(), Code.DT_FMT2));
			
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
		
		dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnVO.getLoginPwd()));
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
			dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd()));
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
	 * DB 사용 권한 목록을 조회한다.
	 * @param dbConnPermVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/dbconnpermuserListP")
	public String getDbConnPermUserList(@ModelAttribute DbConnPermVO dbConnPermVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("getDbConnPermUserList dbConnNo = " + dbConnPermVO.getDbConnNo());
		
		// 부서(그룹) 목록 조회
		CodeVO deptVO = new CodeVO();
		deptVO.setStatus("000");
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(deptVO);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// DB 사용권한 목록 조회
		List<DbConnPermVO> dbConnPermList = null;
		try {
			dbConnPermList = systemService.getDbConnPermList(dbConnPermVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnPermList error = " + e);
		}
		
		model.addAttribute("dbConnNo", dbConnPermVO.getDbConnNo());
		model.addAttribute("deptList", deptList);
		model.addAttribute("dbConnPermList", dbConnPermList);
		
		
		return "ems/sys/dbconnpermuserListP";
	}
	
	/**
	 * DB 사용 권한 정보를 저장한다.
	 * @param dbConnPermVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/dbconnpermAdd")
	public ModelAndView saveDbConnPerm(@ModelAttribute DbConnPermVO dbConnPermVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("saveDbConnPerm dbConnNo = " + dbConnPermVO.getDbConnNo());
		logger.debug("saveDbConnPerm userId = " + dbConnPermVO.getUserId());
		
		// DB 사용 권한 정보 저장(삭제 후 등록)
		boolean result = false;
		try {
			systemService.saveDbConnPermInfo(dbConnPermVO);
			result = true;
		} catch(Exception e) {
			logger.error("systemService.saveDbConnPermInfo error = " + e);
		}
		
		
		// jsonView 생성
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
	 * 메타 테이블 정보를 조회한다.
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="dbconnmetaMainP")
	public String getDbConnMetaMain(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getDbConnMetaMain dbConnNo = " + dbConnVO.getDbConnNo());
		
		
		DbConnVO dbConnInfo = null;
		try {
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 목록 조회
		List<String> realTableList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realTableList = dbUtil.getRealTableList(dbTy, dbDriver, dbUrl, loginId, loginPwd);
		
		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		try {
			metaTableList = systemService.getMetaTableList(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableList error = " + e);
		}
		
		model.addAttribute("dbConnNo", dbConnVO.getDbConnNo());
		model.addAttribute("realTableList", realTableList);
		model.addAttribute("metaTableList", metaTableList);
		
		
		return "ems/sys/dbconnmetaMainP";
	}
	
	/**
	 * 메타 테이블 정보를 조회한다.
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metatableInfo")
	public ModelAndView getMetaTableInfo(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("getMetaTableInfo dbConnNo = " + metaTableVO.getDbConnNo());
		logger.debug("getMetaTableInfo tblNo = " + metaTableVO.getTblNo());
		
		// 메타 테이블 정보 조회
		MetaTableVO metaTableInfo = null;
		try {
			metaTableInfo = systemService.getMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableInfo error = " + e);
		}
		
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(metaTableInfo != null) {
			map.put("result","Success");
			map.put("metaTableInfo", metaTableInfo);
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 테이블 정보를 등록한다.(등록후 테이블 번호를 조회함)
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metatableAdd")
	public ModelAndView insertMetaTableInfo(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("insertMetaTableInfo dbConnNo = " + metaTableVO.getDbConnNo());
		logger.debug("insertMetaTableInfo tblNm = " + metaTableVO.getTblNm());
		logger.debug("insertMetaTableInfo tblAlias = " + metaTableVO.getTblAlias());
		logger.debug("insertMetaTableInfo tblDesc = " + metaTableVO.getTblDesc());
		
		// 메타 테이블 정보 저장
		boolean result = false;
		int tblNo = 0;
		try {
			tblNo = systemService.insertMetaTableInfo(metaTableVO);
			result = true;
		} catch(Exception e) {
			logger.error("systemService.insertMetaTableInfo error = " + e);
		}
		
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result) {
			map.put("result","Success");
			map.put("tblNo", tblNo);
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 테이블 정보 수정
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metatableUpdate")
	public ModelAndView updateMetaTableInfo(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateMetaTableInfo dbConnNo = " + metaTableVO.getDbConnNo());
		logger.debug("updateMetaTableInfo tblNo = " + metaTableVO.getTblNo());
		logger.debug("updateMetaTableInfo tblNm = " + metaTableVO.getTblNm());
		logger.debug("updateMetaTableInfo tblAlias = " + metaTableVO.getTblAlias());
		logger.debug("updateMetaTableInfo tblDesc = " + metaTableVO.getTblDesc());
		
		// 메타 테이블 정보 저장
		int result = 0;
		try {
			result = systemService.updateMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("systemService.updateMetaTableInfo error = " + e);
		}
		
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
			map.put("tblNo", metaTableVO.getTblNo());
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 테이블 정보 삭제
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metatableDelete")
	public ModelAndView deleteMetaTableInfo(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteMetaTableInfo tblNo = " + metaTableVO.getTblNo());
		
		// 메타 테이블 삭제(관계식 삭제 -> 관계값 삭제 -> 메타컬럼 삭제 -> 메타테이블 삭제)
		int result = 0;
		try {
			result = systemService.deleteMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("systemService.deleteMetaTableInfo error = " + e);
		}
		
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
			map.put("tblNo", metaTableVO.getTblNo());
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 컬럼 목록 조회
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metacolumnListP")
	public String getMetaColumnListP(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaColumnListP dbConnNo = " + metaTableVO.getDbConnNo());
		logger.debug("getMetaColumnListP tblNo = " + metaTableVO.getTblNo());
		logger.debug("getMetaColumnListP tblNm = " + metaTableVO.getTblNm());
		
		DbConnVO dbConnInfo = null;
		try {
			DbConnVO dbConnVO = new DbConnVO();
			dbConnVO.setDbConnNo(metaTableVO.getDbConnNo());
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 컬럼 목록 조회
		List<MetaColumnVO> realColumnList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realColumnList = dbUtil.getRealColumnList(dbTy, dbDriver, dbUrl, loginId, loginPwd, metaTableVO.getTblNm());

		
		List<MetaColumnVO> metaColumnList = null;
		MetaColumnVO columnVO = new MetaColumnVO();
		columnVO.setTblNo(metaTableVO.getTblNo());
		try {
			metaColumnList = systemService.getMetaColumnList(columnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaColumnList error = " + e);
		}
		
		model.addAttribute("dbConnNo", metaTableVO.getDbConnNo());
		model.addAttribute("tblNo", metaTableVO.getTblNo());
		model.addAttribute("tblNm", metaTableVO.getTblNm());
		model.addAttribute("realColumnList", realColumnList);
		model.addAttribute("metaColumnList", metaColumnList);
		
		return "ems/sys/metacolumnListP";
	}
	
	/**
	 * 메타 컬럼 목록 조회
	 * @param metaTableVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metacolumnList")
	public ModelAndView getMetaColumnList(@ModelAttribute MetaTableVO metaTableVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaColumnList dbConnNo = " + metaTableVO.getDbConnNo());
		logger.debug("getMetaColumnList tblNo = " + metaTableVO.getTblNo());
		
		List<MetaColumnVO> metaColumnList = null;
		MetaColumnVO columnVO = new MetaColumnVO();
		columnVO.setTblNo(metaTableVO.getTblNo());
		try {
			metaColumnList = systemService.getMetaColumnList(columnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaColumnList error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("metaColumnList", metaColumnList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 컬럼 정보 등록 및 수정
	 * @param metaColumnVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metacolumnUpdate")
	public ModelAndView updateMetaColumnInfo(@ModelAttribute MetaColumnVO metaColumnVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateMetaColumnInfo tblNo = " + metaColumnVO.getTblNo());
		logger.debug("updateMetaColumnInfo colNo = " + metaColumnVO.getColNo());
		
		
		int result = 0;
		try {
			if(metaColumnVO.getColNo() == 0) {
				result = systemService.insertMetaColumnInfo(metaColumnVO);
			} else {
				result = systemService.updateMetaColumnInfo(metaColumnVO);
				
			}
		} catch(Exception e) {
			if(metaColumnVO.getColNo() == 0) {
				logger.error("systemService.insertMetaColumnInfo error = " + e);
			} else {
				logger.error("systemService.updateMetaColumnInfo error = " + e);
			}
		}
		
		
		// jsonView 생성
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
	 * 메타 컬럼 정보 삭제(관계식, 관계값, 컬럼정보)
	 * @param metaColumnVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metacolumnDelete")
	public ModelAndView deleteMetaColumnInfo(@ModelAttribute MetaColumnVO metaColumnVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteMetaColumnInfo colNo = " + metaColumnVO.getColNo());
		
		
		int result = 0;
		try {
			result = systemService.deleteMetaColumnInfo(metaColumnVO.getColNo());
		} catch(Exception e) {
			logger.error("systemService.deleteMetaColumnInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 관계식, 관계값 화면 출력
	 * @param metaOperVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metaoperMainP")
	public String getMetaOperationListP(@ModelAttribute MetaOperatorVO metaOperVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaOperationListP colNo = " + metaOperVO.getColNo());
		logger.debug("getMetaOperationListP colNm = " + metaOperVO.getColNm());

		// 관계식코드 목록을 조회한다.
		CodeVO operVO = new CodeVO();
		operVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		operVO.setCdGrp("C037");	// 관계식
		operVO.setUseYn("Y");
		List<CodeVO> operCodeList = null;
		try {
			operCodeList = codeService.getCodeList(operVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C037] = " + e);
		}
		
		List<MetaOperatorVO> metaOperatorList = null;
		metaOperVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			metaOperatorList = systemService.getMetaOperatorList(metaOperVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaOperatorList error = " + e);
		}
		
		List<MetaValueVO> metaValueList = null;
		MetaValueVO valueVO = new MetaValueVO();
		valueVO.setColNo(metaOperVO.getColNo());
		try {
			metaValueList = systemService.getMetaValueList(valueVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaValueList error = " + e);
		}
		
		model.addAttribute("colNo", metaOperVO.getColNo());
		model.addAttribute("colNm", metaOperVO.getColNm());
		model.addAttribute("operCodeList", operCodeList);
		model.addAttribute("metaOperatorList", metaOperatorList);
		model.addAttribute("metaValueList", metaValueList);
		
		return "ems/sys/metaoperMainP";
	}
	
	/**
	 * 메타 관계식 정보 수정
	 * @param metaOperatorVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metaoperUpdate")
	public ModelAndView updateMetaOperatorInfo(@ModelAttribute MetaOperatorVO metaOperatorVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateMetaOperatorInfo colNo = " + metaOperatorVO.getColNo());
		logger.debug("updateMetaOperatorInfo operCd = " + metaOperatorVO.getOperCd());
		
		
		int result = 0;
		try {
			result = systemService.updateMetaOperatorInfo(metaOperatorVO);
		} catch(Exception e) {
			logger.error("systemService.updateMetaOperatorInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 관계값 정보 등록
	 * @param metaValueVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metavalAdd")
	public ModelAndView insertMetaValueInfo(@ModelAttribute MetaValueVO metaValueVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("insertMetaValueInfo colNo = " + metaValueVO.getColNo());
		logger.debug("insertMetaValueInfo valueNm = " + metaValueVO.getValueNm());
		logger.debug("insertMetaValueInfo valueAlias = " + metaValueVO.getValueAlias());
		
		
		int result = 0;
		try {
			result = systemService.insertMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("systemService.insertMetaValueInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 관계값 정보 수정
	 * @param metaValueVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metavalUpdate")
	public ModelAndView updateMetaValueInfo(@ModelAttribute MetaValueVO metaValueVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateMetaValueInfo colNo = " + metaValueVO.getColNo());
		logger.debug("updateMetaValueInfo valueNm = " + metaValueVO.getValueNm());
		logger.debug("updateMetaValueInfo valueAlias = " + metaValueVO.getValueAlias());
		
		
		int result = 0;
		try {
			result = systemService.updateMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("systemService.updateMetaValueInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 관계값 정보 삭제
	 * @param metaValueVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metavalDelete")
	public ModelAndView deleteMetaValueInfo(@ModelAttribute MetaValueVO metaValueVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("metavalDelete valueNo = " + metaValueVO.getValueNo());
		
		int result = 0;
		try {
			result = systemService.deleteMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("systemService.deleteMetaValueInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 관계값 목록 조회(JSON)
	 * @param metaValueVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metavalList")
	public ModelAndView getMetaValueList(@ModelAttribute MetaValueVO metaValueVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("getMetaValueList colNo = " + metaValueVO.getColNo());
		
		List<MetaValueVO> metaValueList = null;
		try {
			metaValueList = systemService.getMetaValueList(metaValueVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaValueList error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("metaValueList", metaValueList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 관계식 목록 조회(JSON)
	 * @param metaValueVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metaoperList")
	public ModelAndView getMetaOperationList(@ModelAttribute MetaOperatorVO metaOperatorVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaOperationList colNo = " + metaOperatorVO.getColNo());
		metaOperatorVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		List<MetaOperatorVO> metaOperatorList = null;
		try {
			metaOperatorList = systemService.getMetaOperatorList(metaOperatorVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaOperatorList error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("metaOperatorList", metaOperatorList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	
	/**
	 * 메차 조인 화면 출력
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metajoinMainP")
	public String getMetaJoinList(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaJoinList dbConnNo = " + metaJoinVO.getDbConnNo());

		// 조인유형코드 목록을 조회한다.
		CodeVO joinTyVO = new CodeVO();
		joinTyVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		joinTyVO.setCdGrp("C040");	// 조인유형코드
		joinTyVO.setUseYn("Y");
		List<CodeVO> joinTyList = null;
		try {
			joinTyList = codeService.getCodeList(joinTyVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C040] = " + e);
		}

		// 관계유형코드 목록을 조회한다.
		CodeVO relTyVO = new CodeVO();
		relTyVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		relTyVO.setCdGrp("C041");	// 관계유형코드
		relTyVO.setUseYn("Y");
		List<CodeVO> relTyList = null;
		try {
			relTyList = codeService.getCodeList(relTyVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error[C041] = " + e);
		}
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(metaJoinVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(metaJoinVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		metaJoinVO.setPage(page);
		metaJoinVO.setRows(rows);

		// 메타 조인 목록 조회
		List<MetaJoinVO> metaJoinList = null;
		metaJoinVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			metaJoinList = systemService.getMetaJoinList(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaJoinList error = " + e);
		}
		
		int totCnt = metaJoinList != null && metaJoinList.size() > 0 ? ((MetaJoinVO)metaJoinList.get(0)).getTotalCount() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);

		
		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		DbConnVO connVO = new DbConnVO();
		connVO.setDbConnNo(metaJoinVO.getDbConnNo());
		try {
			metaTableList = systemService.getMetaTableList(connVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableList error = " + e);
		}
		
		model.addAttribute("dbConnNo", metaJoinVO.getDbConnNo());
		model.addAttribute("joinTyList", joinTyList);
		model.addAttribute("relTyList", relTyList);
		model.addAttribute("metaJoinList", metaJoinList);
		model.addAttribute("metaTableList", metaTableList);
		model.addAttribute("rows", metaJoinList);
		model.addAttribute("page", page);
		model.addAttribute("total", total);
		model.addAttribute("records", totCnt);
		
		return "ems/sys/metajoinMainP";
	}
	
	/**
	 * 메타 조인 컬럼 목록 조회
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/getColumnList")
	public ModelAndView getColumnList(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getColumnList dbConnNo = " + metaJoinVO.getDbConnNo());
		logger.debug("getColumnList tblNm = " + metaJoinVO.getTblNm());
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			DbConnVO searchVO = new DbConnVO();
			searchVO.setDbConnNo(metaJoinVO.getDbConnNo());
			searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(searchVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}

		// 실제 DB 테이블 컬럼 목록 조회
		List<MetaColumnVO> realColumnList = null;
		
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realColumnList = dbUtil.getRealColumnList(dbTy, dbDriver, dbUrl, loginId, loginPwd, metaJoinVO.getTblNm());

		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("realColumnList", realColumnList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 메타 조인 정보 등록
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metajoinAdd")
	public ModelAndView insertMetaJoinInfo(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("insertMetaJoinInfo dbConnNo = " + metaJoinVO.getDbConnNo());
		logger.debug("insertMetaJoinInfo mstTblNm = " + metaJoinVO.getMstTblNm());
		logger.debug("insertMetaJoinInfo forTblNm = " + metaJoinVO.getForTblNm());
		logger.debug("insertMetaJoinInfo joinTy = " + metaJoinVO.getJoinTy());
		logger.debug("insertMetaJoinInfo relTy = " + metaJoinVO.getRelTy());
		
		int result = 0;
		try {
			result = systemService.insertMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.insertMetaJoinInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 조인 정보 수정
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metajoinUpdate")
	public ModelAndView updateMetaJoinInfo(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateMetaJoinInfo dbConnNo = " + metaJoinVO.getDbConnNo());
		logger.debug("updateMetaJoinInfo joinNo = " + metaJoinVO.getJoinNo());
		logger.debug("updateMetaJoinInfo mstTblNm = " + metaJoinVO.getMstTblNm());
		logger.debug("updateMetaJoinInfo forTblNm = " + metaJoinVO.getForTblNm());
		logger.debug("updateMetaJoinInfo joinTy = " + metaJoinVO.getJoinTy());
		logger.debug("updateMetaJoinInfo relTy = " + metaJoinVO.getRelTy());
		
		int result = 0;
		try {
			result = systemService.updateMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.updateMetaJoinInfo error = " + e);
		}
		
		// jsonView 생성
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
	 * 메타 조인 정보 삭제
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/metajoinDelete")
	public ModelAndView deleteMetaJoinInfo(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteMetaJoinInfo joinNo = " + metaJoinVO.getJoinNo());
		
		int result = 0;
		try {
			result = systemService.deleteMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.deleteMetaJoinInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	
	
	
	/******************************************************** 사용자 로그인 관리 ********************************************************/
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
		int rows = StringUtil.setNullToInt(loginHistVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		loginHistVO.setPage(page);
		loginHistVO.setRows(rows);
		loginHistVO.setSearchLgnStdDt(loginHistVO.getSearchLgnStdDt().replaceAll("-", "") + "000000");
		loginHistVO.setSearchLgnEndDt(loginHistVO.getSearchLgnEndDt().replaceAll("-", "") + "235959");
		
		
		// 로그인 이력 목록 조회
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
		
		int totCnt = newLoginHistList != null && newLoginHistList.size() > 0 ? ((LoginHistVO)newLoginHistList.get(0)).getTotalCount() : 0;
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
	
	
	
	/******************************************************** 캠페인 목적 관리 ********************************************************/
	/**
	 * 캠페인 목적 관리 화면 출력
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/usercodeMainP")
	public String goUserCodeList(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		String uilang = (String)session.getAttribute("NEO_UILANG");
		String cdGrp = "C004";		// 캠페인목적
		
		UserCodeVO userCodeVO = new UserCodeVO();
		userCodeVO.setUilang(uilang);
		userCodeVO.setCdGrp(cdGrp);
		
		// 코드그룹 정보 조회
		CodeGroupVO codeGrpVO = new CodeGroupVO();
		codeGrpVO.setUilang(uilang);
		codeGrpVO.setCdGrp(cdGrp);
		CodeGroupVO codeGrpInfo = null;
		try {
			codeGrpInfo = codeService.getCodeGrpInfo(codeGrpVO);
		} catch(Exception e) {
			logger.error("codeService.getCodeGrpInfo error = " + e);
		}
		
		
		List<UserCodeVO> userCodeList = null;
		try {
			userCodeList = systemService.getUserCodeList(userCodeVO);
		} catch(Exception e) {
			logger.error("systemService.getUserCodeList error = " + e);
		}
		
		// 언어권 코드
		CodeVO code = new CodeVO();
		code.setUilang(uilang);
		code.setCdGrp("C025");
		code.setUseYn("Y");
		List<CodeVO> uilangList = null;
		try {
			uilangList = codeService.getCodeList(code);
		} catch(Exception e) {
			logger.error("codeService.getCodeList error = " + e);
		}
		
		model.addAttribute("uilang", uilang);
		model.addAttribute("cdGrp", cdGrp);
		model.addAttribute("codeGrpInfo", codeGrpInfo);
		model.addAttribute("userCodeList", userCodeList);
		model.addAttribute("uilangList", uilangList);
		
		return "ems/sys/usercodeMainP";
	}
	
	@RequestMapping(value="/usercodeAdd")
	public ModelAndView insertUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("insertUserCodeInfo cdGrp = " + userCodeVO.getCdGrp());
		logger.debug("insertUserCodeInfo uilang = " + userCodeVO.getUilang());
		logger.debug("insertUserCodeInfo cd = " + userCodeVO.getCd());
		logger.debug("insertUserCodeInfo cdNm = " + userCodeVO.getCdNm());
		logger.debug("insertUserCodeInfo cdDtl = " + userCodeVO.getCdDtl());
		logger.debug("insertUserCodeInfo useYn = " + userCodeVO.getUseYn());
		
		int result = 0;
		try {
			if(",".equals(userCodeVO.getCdNm().trim())) userCodeVO.setCdNm(" , ");
			if(",".equals(userCodeVO.getCdDtl().trim())) userCodeVO.setCdDtl(" , ");
			result = systemService.insertUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("systemService.insertUserCodeInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	@RequestMapping(value="/usercodeUpdate")
	public ModelAndView updateUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("updateUserCodeInfo cdGrp = " + userCodeVO.getCdGrp());
		logger.debug("updateUserCodeInfo uilang = " + userCodeVO.getUilang());
		logger.debug("updateUserCodeInfo cd = " + userCodeVO.getCd());
		logger.debug("updateUserCodeInfo cdNm = " + userCodeVO.getCdNm());
		logger.debug("updateUserCodeInfo cdDtl = " + userCodeVO.getCdDtl());
		logger.debug("updateUserCodeInfo useYn = " + userCodeVO.getUseYn());
		
		int result = 0;
		try {
			result = systemService.updateUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("systemService.updateUserCodeInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result","Success");
		} else {
			map.put("result","Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	@RequestMapping(value="/usercodeDelete")
	public ModelAndView deleteUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("deleteUserCodeInfo cdGrp = " + userCodeVO.getCdGrp());
		logger.debug("deleteUserCodeInfo uilang = " + userCodeVO.getUilang());
		logger.debug("deleteUserCodeInfo cd = " + userCodeVO.getCd());
		
		int result = 0;
		try {
			result = systemService.deleteUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("systemService.deleteUserCodeInfo error = " + e);
		}
		
		// jsonView 생성
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
