/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller==>데이터베이스 연결 관리 Controller
 * 수정자 : 김준희
 * 작성일시 : 2021.08.09
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경 kr.co.enders.ums.sys.controller ==> kr.co.enders.ums.sys.dbc.controller
 *                데이터베이스 연결 관리 기능 외의 항목제거
 */
package kr.co.enders.ums.sys.dbc.controller;

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
import kr.co.enders.ums.sys.dbc.service.DBConnService;
import kr.co.enders.ums.sys.dbc.vo.DbConnPermVO;
import kr.co.enders.ums.sys.dbc.vo.DbConnVO;
import kr.co.enders.ums.sys.dbc.vo.MetaColumnVO;
import kr.co.enders.ums.sys.dbc.vo.MetaJoinVO;
import kr.co.enders.ums.sys.dbc.vo.MetaOperatorVO;
import kr.co.enders.ums.sys.dbc.vo.MetaTableVO;
import kr.co.enders.ums.sys.dbc.vo.MetaValueVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/sys/dbc")
public class DBConnController {
	private Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private CodeService codeService;
	
	@Autowired
	private DBConnService dbConnService;

	@Autowired
	private PropertiesUtil properties;
 
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
			dbConnList = dbConnService.getDbConnList(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnList error = " + e);
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
		
		//dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnVO.getLoginPwd()));
		dbConnVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		dbConnVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		// DB Connection 정보를 등록한다.
		try {
			result = dbConnService.insertDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.insertDbConnInfo error = " + e);
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
			dbConnInfo = dbConnService.getDbConnInfo(dbConnVO);
			//dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd()));
			dbConnInfo.setRegDt(StringUtil.getFDate(dbConnInfo.getRegDt(), Code.DT_FMT2));
			dbConnInfo.setUpDt(StringUtil.getFDate(dbConnInfo.getUpDt(), Code.DT_FMT2));
			
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnInfo error = " + e);
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
		
		//dbConnVO.setLoginPwd(EncryptUtil.getJasyptEncryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnVO.getLoginPwd()));
		dbConnVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		dbConnVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		int result = 0;
		
		// DB Connection 정보를 수정한다.
		try {
			result = dbConnService.updateDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.updateDbConnInfo error = " + e);
		}
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = dbConnService.getDbConnInfo(dbConnVO);
			//dbConnInfo.setLoginPwd(EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd()));
			dbConnInfo.setRegDt(StringUtil.getFDate(dbConnInfo.getRegDt(), Code.DT_FMT2));
			dbConnInfo.setUpDt(StringUtil.getFDate(dbConnInfo.getUpDt(), Code.DT_FMT2));
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnInfo error = " + e);
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
			dbConnPermList = dbConnService.getDbConnPermList(dbConnPermVO);
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnPermList error = " + e);
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
			dbConnService.saveDbConnPermInfo(dbConnPermVO);
			result = true;
		} catch(Exception e) {
			logger.error("dbConnService.saveDbConnPermInfo error = " + e);
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
			dbConnInfo = dbConnService.getDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 목록 조회
		List<String> realTableList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = dbConnInfo.getLoginPwd();  // =====================================> TEST
		//String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realTableList = dbUtil.getRealTableList(dbTy, dbDriver, dbUrl, loginId, loginPwd);
		
		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		try {
			metaTableList = dbConnService.getMetaTableList(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaTableList error = " + e);
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
			metaTableInfo = dbConnService.getMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaTableInfo error = " + e);
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
			tblNo = dbConnService.insertMetaTableInfo(metaTableVO);
			result = true;
		} catch(Exception e) {
			logger.error("dbConnService.insertMetaTableInfo error = " + e);
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
			result = dbConnService.updateMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("dbConnService.updateMetaTableInfo error = " + e);
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
			result = dbConnService.deleteMetaTableInfo(metaTableVO);
		} catch(Exception e) {
			logger.error("dbConnService.deleteMetaTableInfo error = " + e);
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
			dbConnInfo = dbConnService.getDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 컬럼 목록 조회
		List<MetaColumnVO> realColumnList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = dbConnInfo.getLoginPwd();	// ==================================================>> TEST
		//String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realColumnList = dbUtil.getRealColumnList(dbTy, dbDriver, dbUrl, loginId, loginPwd, metaTableVO.getTblNm());

		
		List<MetaColumnVO> metaColumnList = null;
		MetaColumnVO columnVO = new MetaColumnVO();
		columnVO.setTblNo(metaTableVO.getTblNo());
		try {
			metaColumnList = dbConnService.getMetaColumnList(columnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaColumnList error = " + e);
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
			metaColumnList = dbConnService.getMetaColumnList(columnVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaColumnList error = " + e);
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
				result = dbConnService.insertMetaColumnInfo(metaColumnVO);
			} else {
				result = dbConnService.updateMetaColumnInfo(metaColumnVO);
				
			}
		} catch(Exception e) {
			if(metaColumnVO.getColNo() == 0) {
				logger.error("dbConnService.insertMetaColumnInfo error = " + e);
			} else {
				logger.error("dbConnService.updateMetaColumnInfo error = " + e);
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
			result = dbConnService.deleteMetaColumnInfo(metaColumnVO.getColNo());
		} catch(Exception e) {
			logger.error("dbConnService.deleteMetaColumnInfo error = " + e);
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
			metaOperatorList = dbConnService.getMetaOperatorList(metaOperVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaOperatorList error = " + e);
		}
		
		List<MetaValueVO> metaValueList = null;
		MetaValueVO valueVO = new MetaValueVO();
		valueVO.setColNo(metaOperVO.getColNo());
		try {
			metaValueList = dbConnService.getMetaValueList(valueVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaValueList error = " + e);
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
			result = dbConnService.updateMetaOperatorInfo(metaOperatorVO);
		} catch(Exception e) {
			logger.error("dbConnService.updateMetaOperatorInfo error = " + e);
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
			result = dbConnService.insertMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("dbConnService.insertMetaValueInfo error = " + e);
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
			result = dbConnService.updateMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("dbConnService.updateMetaValueInfo error = " + e);
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
			result = dbConnService.deleteMetaValueInfo(metaValueVO);
		} catch(Exception e) {
			logger.error("dbConnService.deleteMetaValueInfo error = " + e);
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
			metaValueList = dbConnService.getMetaValueList(metaValueVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaValueList error = " + e);
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
			metaOperatorList = dbConnService.getMetaOperatorList(metaOperatorVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaOperatorList error = " + e);
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
	public String getMetaJoinListP(@ModelAttribute MetaJoinVO metaJoinVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaJoinListP dbConnNo = " + metaJoinVO.getDbConnNo());

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
			metaJoinList = dbConnService.getMetaJoinList(metaJoinVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaJoinList error = " + e);
		}
		
		int totCnt = metaJoinList != null && metaJoinList.size() > 0 ? ((MetaJoinVO)metaJoinList.get(0)).getTotalCount() : 0;
		int total = (int)Math.ceil((double)totCnt/rows);

		
		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		DbConnVO connVO = new DbConnVO();
		connVO.setDbConnNo(metaJoinVO.getDbConnNo());
		try {
			metaTableList = dbConnService.getMetaTableList(connVO);
		} catch(Exception e) {
			logger.error("dbConnService.getMetaTableList error = " + e);
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
			dbConnInfo = dbConnService.getDbConnInfo(searchVO);
		} catch(Exception e) {
			logger.error("dbConnService.getDbConnInfo error = " + e);
		}

		// 실제 DB 테이블 컬럼 목록 조회
		List<MetaColumnVO> realColumnList = null;
		
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = dbConnInfo.getLoginPwd();
		//String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
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
			result = dbConnService.insertMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("dbConnService.insertMetaJoinInfo error = " + e);
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
			result = dbConnService.updateMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("dbConnService.updateMetaJoinInfo error = " + e);
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
			result = dbConnService.deleteMetaJoinInfo(metaJoinVO);
		} catch(Exception e) {
			logger.error("dbConnService.deleteMetaJoinInfo error = " + e);
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
