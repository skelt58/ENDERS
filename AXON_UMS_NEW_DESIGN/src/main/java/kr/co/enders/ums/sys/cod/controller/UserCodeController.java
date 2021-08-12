/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller==>사용자 코드 관리 Controller
 * 수정자 : 김준희
 * 작성일시 : 2021.08.09
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경 kr.co.enders.ums.sys.controller ==> kr.co.enders.ums.sys.cod.controller
 *                사용자코드 관리 기능 외의 항목제거 
 */
package kr.co.enders.ums.sys.cod.controller;

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
import kr.co.enders.ums.sys.cod.service.UserCodeService;
import kr.co.enders.ums.sys.cod.vo.UserCodeGroupVO;
import kr.co.enders.ums.sys.cod.vo.UserCodeVO; 
import kr.co.enders.util.MessageUtil;
import kr.co.enders.util.PageUtil;  
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/sys/cod")
public class UserCodeController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private UserCodeService userCodeService;
	
	@Autowired
	private PropertiesUtil properties; 

	/**
	 * 코드 그룹 목록 화면을 출력한다
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeGroupListP")
	public String goUserCodeGroupListP(@ModelAttribute UserCodeGroupVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUserCodeGroupList searchUserCodeGroupNm = " + searchVO.getSearchCdGrpNm());
		logger.debug("goUserCodeGroupList searchUserCodeGroup = " + searchVO.getSearchCdGrp());
	
		searchVO.setSearchUiLang((String)session.getAttribute("NEO_UILANG"));		
		logger.debug("goUserCodeGroupList searchUserCodeGroup = " + searchVO.getSearchUiLang());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);		
		searchVO.setPage(page);		
		
		// 코드그룹목록(코드성) 조회
		CodeVO cdGrp = new CodeVO();
		cdGrp.setUilang(searchVO.getSearchUiLang());
		List<CodeVO> cdGrpList = null;
		try {
			cdGrpList = codeService.getCodeGrpList(cdGrp);
		} catch(Exception e) {
			logger.error("codeService.getCodeGrpList error = " + e);
		}
		
		// 캠페인목적 목록
		CodeVO uiLang = new CodeVO();
		uiLang.setUilang(searchVO.getSearchUiLang());
		uiLang.setCdGrp("C025");
		uiLang.setUseYn("Y");
		List<CodeVO> uiLangList = null;
		try {
			uiLangList = codeService.getCodeList(uiLang);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C004] error = " + e);
		}
		
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("cdGrpList", cdGrpList);			// 코드그룹 검색 조건 항목
		model.addAttribute("uiLangList", uiLangList);			// 코드그룹 검색 조건 항목
		
		return "sys/cod/userCodeGroupListP";
	}
	
	/**
	 * 코드 그룹 목록을 출력한다
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeGroupList")
	public String goUserCodeGroupList(@ModelAttribute UserCodeGroupVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUserCodeGroupList searchUserCodeGroupNm = " + searchVO.getSearchCdGrpNm());
		logger.debug("goUserCodeGroupList searchUserCodeGroup = " + searchVO.getSearchCdGrp());
	
		searchVO.setSearchUiLang((String)session.getAttribute("NEO_UILANG"));		
		logger.debug("goUserCodeGroupList searchUserCodeGroup = " + searchVO.getSearchUiLang());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE_COD")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;
		
		// 코드그룹 목록 조회
		List<UserCodeGroupVO> userCodeGroupList  = null;
		try {
			userCodeGroupList = userCodeService.getUserCodeGroupList(searchVO);
		} catch(Exception e) {
			logger.error("UserCodeService.getCodeGroupInfo error = " + e);
		}
		
		if(userCodeGroupList != null && userCodeGroupList.size() > 0) {
			totalCount = userCodeGroupList.get(0).getTotalCount();
		}
		
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);		
				
		model.addAttribute("userCodeGroupList", userCodeGroupList);// 코드그룹 목록
		model.addAttribute("pageUtil", pageUtil);	// 페이징
		
		return "sys/cod/userCodeGroupList";
	}
	
	/**
	 * 코드 그룹 정보 조회
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeGroupInfo")
	public ModelAndView getUserCodeGroupInfo(@ModelAttribute UserCodeGroupVO userCodeGroupVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getUserCodeGroupInfo codeGroup      = " + userCodeGroupVO.getSearchCdGrp());
		
		userCodeGroupVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			userCodeGroupVO = userCodeService.getUserCodeGroupInfo(userCodeGroupVO);
		} catch(Exception e) {
			logger.error("userCodeService.getUserCodeGroupInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("userCodeGroup", userCodeGroupVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 코드그룹 정보 추가
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */	
	@RequestMapping(value="/userCodeGroupAdd")
	public ModelAndView insertUserCodeGroupInfo(@ModelAttribute UserCodeGroupVO userCodeGroupVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("insertUserCodeGroupInfo cdGrp = " + userCodeGroupVO.getCdGrp());		
		logger.debug("insertUserCodeGroupInfo cdGrpNm = " + userCodeGroupVO.getCdGrpNm());
		logger.debug("insertUserCodeGroupInfo cdGrpDtl = " + userCodeGroupVO.getCdGrpDtl());		
		logger.debug("insertUserCodeGroupInfo upCd = " + userCodeGroupVO.getUpCdGrp());
		logger.debug("insertUserCodeGroupInfo sysYn = " + userCodeGroupVO.getSysYn());
		logger.debug("insertUserCodeGroupInfo useYn = " + userCodeGroupVO.getUseYn());
						
		//userCodeGroupVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		//테스트 용임 테스트 화면이라 세션없어서 이따위가..왜 삽질을 한것일까 우어어어..도대체 아아아아아악!
		userCodeGroupVO.setUilang("000");
		
		logger.debug("insertUserCodeGroupInfo Uilang = " + userCodeGroupVO.getUilang());
		
		int result = 0;
		try {
			result = userCodeService.insertUserCodeGroupInfo(userCodeGroupVO);
		} catch(Exception e) {
			logger.error("userCodeService.insertUserCodeGroupInfo error = " + e);
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
	 * 코드그룹 정보 수정
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeGroupUpdate")
	public ModelAndView updateCodeGroupInfo(@ModelAttribute UserCodeGroupVO userCodeGroupVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateCodeGroupInfo cdGrp      = " + userCodeGroupVO.getCdGrp());
		logger.debug("updateCodeGroupInfo cdGrpNm      = " + userCodeGroupVO.getCdGrpNm());
		logger.debug("updateCodeGroupInfo cdGrpDtl     = " + userCodeGroupVO.getCdGrpDtl());
		logger.debug("updateCodeGroupInfo upCd 			= " + userCodeGroupVO.getUpCdGrp());
		logger.debug("updateCodeGroupInfo sysYn        = " + userCodeGroupVO.getSysYn());
		logger.debug("updateCodeGroupInfo useYn        = " + userCodeGroupVO.getUseYn());
		 	 
						
		//userCodeGroupVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		//테스트 용임 테스트 화면이라 세션없어서 이따위가..왜 삽질을 한것일까 우어어어..도대체 아아아아아악! 와 씨 구와중에 add에 걸고 있었네 미친거아냐!!! 죽자!!
		userCodeGroupVO.setUilang("000");
		
		logger.debug("updateCodeGroupInfo Uilang = " + userCodeGroupVO.getUilang());
		
		
		int result = 0;
		try {
			result = userCodeService.updateUserCodeGroupInfo(userCodeGroupVO);
		} catch(Exception e) {
			logger.error("userCodeService.updateUserCodeGroupInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result", "Success");
		} else {
			map.put("result", "Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 코드 그룹 정보 삭제
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */		
	@RequestMapping(value="/userCodeGroupDelete")
	public ModelAndView deleteUserCodeGroupInfo(@ModelAttribute UserCodeGroupVO userCodeGroupVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("deleteUserCodeGroupInfo cdGrp      = " + userCodeGroupVO.getCdGrp());
		//userCodeGroupVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		//테스트 용임 테스트 화면이라 세션없어서 이따위가..왜 삽질을 한것일까 우어어어..도대체 아아아아아악! 와 씨 구와중에 add에 걸고 있었네 미친거아냐!!! 죽자!!
		userCodeGroupVO.setUilang("000");
		
		logger.debug("updateCodeGroupInfo Uilang = " + userCodeGroupVO.getUilang());		
		
		int result = 0;
		try {
			result = userCodeService.deleteUserCodeGroupInfo(userCodeGroupVO);
		} catch(Exception e) {
			logger.error("userCodeService.deleteUserCodeInfo error = " + e);
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
	 * 코드 관리 화면을 출력한다
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeListP")
	public String goUserCodeListP(@ModelAttribute UserCodeVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUserCodeList searchUserCodeGroupNm = " + searchVO.getSearchCdGrpNm());
		logger.debug("goUserCodeList searchUserCodeGroup = " + searchVO.getSearchCdGrp());
	
		searchVO.setSearchUiLang((String)session.getAttribute("NEO_UILANG"));

		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);		
		searchVO.setPage(page);
 
		// 코드그룹목록(코드성) 조회
		CodeVO cdGrp = new CodeVO();
		cdGrp.setUilang(searchVO.getSearchUiLang());
		List<CodeVO> cdGrpList = null;
		try {
			cdGrpList = codeService.getCodeGrpList(cdGrp);
		} catch(Exception e) {
			logger.error("codeService.getCodeGrpList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목		
		model.addAttribute("cdGrpList", cdGrpList);			// 코드그룹 검색 조건 항목 
		
		return "ems/sys/cod/userCodeGroupListP";
	}
	
	/**
	 * 코드 그룹 목록을 조회한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeList")
	public String goUserCodeList(@ModelAttribute UserCodeVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUserCodeList searchUserCodeGroupNm = " + searchVO.getSearchCdGrpNm());
		logger.debug("goUserCodeList searchUserCodeGroup = " + searchVO.getSearchCdGrp());
	
		searchVO.setSearchUiLang((String)session.getAttribute("NEO_UILANG"));

		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;
		
		// 코드 목록 조회
		List<UserCodeVO> userCodeList  = null;
		try {
			userCodeList = userCodeService.getUserCodeList(searchVO);
		} catch(Exception e) {
			logger.error("UserCodeService.getCodeInfo error = " + e);
		}
	 		
		if(userCodeList != null && userCodeList.size() > 0) {
			totalCount = userCodeList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);
		
		
		model.addAttribute("userCodeList", userCodeList);	// 코드그룹 내역 목록
		model.addAttribute("pageUtil", pageUtil);	// 페이징
		
		return "ems/sys/cod/userCodeList";
	}
	
	/**
	 * 코드 정보 조회
	 * @param userCodeVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeInfo")
	public ModelAndView getUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getUserCodeGroupInfo codeGroup      = " + userCodeVO.getSearchCdGrp());
		
		userCodeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			userCodeVO = userCodeService.getUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.getUserCodeInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("userCodeGroup", userCodeVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}	
	/**
	 * 코드 정보 추가
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */	
	@RequestMapping(value="/userCodeAdd")
	public ModelAndView insertUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("insertUserCodeInfo cd = " + userCodeVO.getCd());		
		logger.debug("insertUserCodeInfo cdGrp = " + userCodeVO.getCdGrp());
		logger.debug("insertUserCodeInfo cdNm = " + userCodeVO.getCdNm());
		logger.debug("insertUserCodeInfo upCd = " + userCodeVO.getUpCd());
		logger.debug("insertUserCodeInfo cdDtl = " + userCodeVO.getCdDtl());		
		logger.debug("insertUserCodeInfo useYn = " + userCodeVO.getUseYn());
		
		userCodeVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		int result = 0;
		try {
			result = userCodeService.insertUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.insertUserCodeInfo error = " + e);
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
	 * 코드 정보 수정
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeUpdate")
	public ModelAndView updateCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateCodeInfo cdNm      = " + userCodeVO.getCdNm());
		logger.debug("updateCodeInfo cdDtl     = " + userCodeVO.getCdDtl());
		logger.debug("updateCodeInfo useYn     = " + userCodeVO.getUseYn());
		
		int result = 0;
		try {
			result = userCodeService.updateUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.updateUserCodeInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(result > 0) {
			map.put("result", "Success");
		} else {
			map.put("result", "Fail");
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 코드 정보 삭제
	 * @param userCodeGroupVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/userCodeDelete")
	public ModelAndView deleteUserCodeInfo(@ModelAttribute UserCodeVO userCodeVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("deleteUserCodeGroupInfo cdGrp      = " + userCodeVO.getCdGrp());		
		logger.debug("deleteUserCodeGroupInfo cd      = " + userCodeVO.getCd());
		
		int result = 0;
		try {
			result = userCodeService.deleteUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.deleteUserCodeInfo error = " + e);
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
