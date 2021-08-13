/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.26
 * 설명 : 캠페인관리 Controller
 */
package kr.co.enders.ums.ems.cam.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import kr.co.enders.ums.ems.cam.service.CampaignService;
import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.SendTestLogVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.cam.vo.TestUserVO;
import kr.co.enders.ums.ems.seg.service.SegmentService;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.ems.tmp.service.TemplateService;
import kr.co.enders.ums.ems.tmp.vo.TemplateVO;
import kr.co.enders.ums.sys.acc.service.AccountService;
import kr.co.enders.ums.sys.acc.vo.UserVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.PageUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/cam")
public class CampaignController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private CampaignService campaignService;
	
	@Autowired
	private SegmentService segmentService;
	
	@Autowired
	private TemplateService templateService;
	
	@Autowired
	private AccountService systemService;
	
	@Autowired
	private PropertiesUtil properties;
	
	
	/**
	 * 캠페인관리 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campListP")
	public String goCampListP(@ModelAttribute CampaignVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goCampListP searchCampNm  = " + searchVO.getSearchCampNm());
		logger.debug("goCampListP searchCampTy  = " + searchVO.getSearchCampTy());
		logger.debug("goCampListP searchStatus  = " + searchVO.getSearchStatus());
		logger.debug("goCampListP searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goCampListP searchEndDt   = " + searchVO.getSearchEndDt());
		logger.debug("goCampListP searchDeptNo  = " + searchVO.getSearchDeptNo());
		logger.debug("goCampListP searchUserId  = " + searchVO.getSearchUserId());
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyy")+"0101");
		} else {
			searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("\\.", ""));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyyMMdd"));
		} else {
			searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("\\.", ""));
		}
		if(searchVO.getSearchDeptNo() == 0) {
			if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo(0);
			} else {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
		}
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		
		// 캠페인목적 목록
		CodeVO campTy = new CodeVO();
		campTy.setUilang((String)session.getAttribute("NEO_UILANG"));
		campTy.setCdGrp("C004");
		campTy.setUseYn("Y");
		List<CodeVO> campTyList = null;
		try {
			campTyList = codeService.getCodeList(campTy);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C004] error = " + e);
		}
		
		// 캠페인상태 목록
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C014");
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C014] error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		CodeVO user = new CodeVO();
		user.setDeptNo(searchVO.getSearchDeptNo());
		user.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(user);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("campTyList", campTyList);		// 캠페인목적 목록
		model.addAttribute("statusList", statusList);		// 캠페인상태 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		
		return "ems/cam/campListP";
	}
	
	/**
	 * 캠페인 목록 조회
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campList")
	public String goCampList(@ModelAttribute CampaignVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goCampList searchCampNm  = " + searchVO.getSearchCampNm());
		logger.debug("goCampList searchCampTy  = " + searchVO.getSearchCampTy());
		logger.debug("goCampList searchStatus  = " + searchVO.getSearchStatus());
		logger.debug("goCampList searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goCampList searchEndDt   = " + searchVO.getSearchEndDt());
		logger.debug("goCampList searchDeptNo  = " + searchVO.getSearchDeptNo());
		logger.debug("goCampList searchUserId  = " + searchVO.getSearchUserId());
		

		searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("\\.", ""));
		searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("\\.", ""));
		if(searchVO.getSearchDeptNo() == 0) {
			if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo(0);
			} else {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
		}
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;
		
		// 캠페인 목록 조회
		List<CampaignVO> campaignList  = null;
		try {
			campaignList = campaignService.getCampaignList(searchVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		
		if(campaignList != null && campaignList.size() > 0) {
			totalCount = campaignList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);

		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("campaignList", campaignList);	// 캠페인 목록
		model.addAttribute("pageUtil", pageUtil);			// 페이징
		
		return "ems/cam/campList";
	}

	
	/**
	 * 캠페인 정보 조회
	 * @param campaignVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campInfo")
	public ModelAndView getCampInfo(@ModelAttribute CampaignVO campaignVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getCampInfo campNo      = " + campaignVO.getCampNo());
		
		campaignVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			campaignVO = campaignService.getCampaignInfo(campaignVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("campaign", campaignVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 캠페인 정보 등록
	 * @param campaignVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campAdd")
	public ModelAndView insertCampInfo(@ModelAttribute CampaignVO campaignVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("insertCampInfo campNm      = " + campaignVO.getCampNm());
		logger.debug("insertCampInfo campDesc      = " + campaignVO.getCampDesc());
		logger.debug("insertCampInfo campTy      = " + campaignVO.getCampTy());
		logger.debug("insertCampInfo status      = " + campaignVO.getStatus());
		logger.debug("insertCampInfo deptNo      = " + campaignVO.getDeptNo());
		logger.debug("insertCampInfo userId      = " + campaignVO.getUserId());
		campaignVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		campaignVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		int result = 0;
		try {
			result = campaignService.insertCampaignInfo(campaignVO);
		} catch(Exception e) {
			logger.error("campaignService.insertCampaignInfo error = " + e);
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
	 * 캠페인 정보 등록 화면을 출력한다.
	 * @param campaignVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campAddP")
	public String goCampAddP(@ModelAttribute CampaignVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		// 캠페인목적 목록
		CodeVO campTy = new CodeVO();
		campTy.setUilang((String)session.getAttribute("NEO_UILANG"));
		campTy.setCdGrp("C004");
		campTy.setUseYn("Y");
		List<CodeVO> campTyList = null;
		try {
			campTyList = codeService.getCodeList(campTy);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C004] error = " + e);
		}
		
		// 캠페인상태 목록
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C014");
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C014] error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		int deptNo = "Y".equals((String)session.getAttribute("NEO_ADMIN_YN")) ? 0 : (int)session.getAttribute("NEO_DEPT_NO");
		CodeVO user = new CodeVO();
		user.setDeptNo(deptNo);
		user.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(user);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		model.addAttribute("campTyList", campTyList);		// 캠페인목적 목록
		model.addAttribute("statusList", statusList);		// 캠페인상태 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		
		return "ems/cam/campAddP";
	}
	
	/**
	 * 캠페인 정보 수정 화면을 출력한다.
	 * @param campaignVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campUpdateP")
	public String goCampUpdateP(@ModelAttribute CampaignVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goCampUpdateP campNo = " + searchVO.getCampNo());
		
		// 캠페인 정보 조회
		CampaignVO campInfo = null;
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			campInfo = campaignService.getCampaignInfo(searchVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignInfo error = " + e);
		}
		
		// 캠페인목적 목록
		CodeVO campTy = new CodeVO();
		campTy.setUilang((String)session.getAttribute("NEO_UILANG"));
		campTy.setCdGrp("C004");
		campTy.setUseYn("Y");
		List<CodeVO> campTyList = null;
		try {
			campTyList = codeService.getCodeList(campTy);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C004] error = " + e);
		}
		
		// 캠페인상태 목록
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C014");
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C014] error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		int deptNo = "Y".equals((String)session.getAttribute("NEO_ADMIN_YN")) ? 0 : (int)session.getAttribute("NEO_DEPT_NO");
		CodeVO user = new CodeVO();
		user.setDeptNo(deptNo);
		user.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(user);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("campInfo", campInfo);			// 캠페인 정보
		model.addAttribute("campTyList", campTyList);		// 캠페인목적 목록
		model.addAttribute("statusList", statusList);		// 캠페인상태 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		
		return "ems/cam/campUpdateP";
	}
	
	/**
	 * 캠페인 정보 수정
	 * @param campaignVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campUpdate")
	public ModelAndView updateCampInfo(@ModelAttribute CampaignVO campaignVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateCampInfo campNo      = " + campaignVO.getCampNo());
		logger.debug("updateCampInfo campNm      = " + campaignVO.getCampNm());
		logger.debug("updateCampInfo campDesc      = " + campaignVO.getCampDesc());
		logger.debug("updateCampInfo campTy      = " + campaignVO.getCampTy());
		logger.debug("updateCampInfo status      = " + campaignVO.getStatus());
		logger.debug("updateCampInfo deptNo      = " + campaignVO.getDeptNo());
		logger.debug("updateCampInfo userId      = " + campaignVO.getUserId());
		campaignVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		campaignVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		int result = 0;
		try {
			result = campaignService.updateCampaignInfo(campaignVO);
		} catch(Exception e) {
			logger.error("campaignService.updateCampaignInfo error = " + e);
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
	 * 메일 관리 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailMainP")
	public String goMailMain(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailMain searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailMain searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailMain searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailMain searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailMain searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailMain searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailMain searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailMain searchWorkStatus = " + searchVO.getSearchWorkStatus());
		logger.debug("goMailMain campNo           = " + searchVO.getCampNo());
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(-1, "M", "yyyyMMdd"));
		} else {
			searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("\\.", ""));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyyMMdd"));
		} else {
			searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("\\.", ""));
		}
		if(searchVO.getSearchStatus() == null || "".equals(searchVO.getSearchStatus())) searchVO.setSearchStatus("000");
		if(searchVO.getSearchDeptNo() == 0) {
			if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo(0);
			} else {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
		}
		searchVO.setPage(searchVO.getPage()==0?1:searchVO.getPage());
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		
		// 캠페인 목록 조회
		CampaignVO campVO = new CampaignVO();
		campVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		campVO.setSearchStatus("000");
		campVO.setPage(1);
		campVO.setRows(1000);
		campVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		List<CampaignVO> campaignList = null;
		try {
			campaignList = campaignService.getCampaignList(campVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		CodeVO user = new CodeVO();
		user.setDeptNo(searchVO.getSearchDeptNo());
		user.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(user);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		// 메일상태 목록 조회
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C023");
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C023] error = " + e);
		}

		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("campaignList", campaignList);	// 캠페인 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		model.addAttribute("statusList", statusList);		// 메일상태 목록
		
		return "ems/cam/mailMainP";
	}
	
	/**
	 * 메일 목록 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailListP")
	public String goMailList(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailList searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailList searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailList searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailList searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailList searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailList searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailList searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailList searchWorkStatus = " + searchVO.getSearchWorkStatus());
		logger.debug("goMailList campNo           = " + searchVO.getCampNo());
		
		// 검색 기본값 설정
		searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("\\.", ""));
		searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("\\.", ""));
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		List<String> workStatusList = new ArrayList<String>();
		String[] workStatus = searchVO.getSearchWorkStatus().split(",");
		for(int i=0;i<workStatus.length;i++) {
			workStatusList.add(workStatus[i]);
		}
		searchVO.setSearchWorkStatusList(workStatusList);
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;

		// 메일 목록 조회
		List<TaskVO> mailList = null;
		try {
			mailList = campaignService.getMailList(searchVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		if(mailList != null && mailList.size() > 0) {
			totalCount = mailList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);
		
		model.addAttribute("searchVO", searchVO);	// 검색 항목
		model.addAttribute("mailList", mailList);	// 메일 목록
		model.addAttribute("pageUtil", pageUtil);	// 페이징
		
		return "ems/cam/mailListP";
	}
	
	/**
	 * 메일을 발송승인 상태로 변경한다. 
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailAdmit")
	public ModelAndView updateMailAdmit(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateMailAdmit taskNo    = " + taskVO.getTaskNo());
		logger.debug("updateMailAdmit subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setRecoStatus("001");	// 승인여부:승인
		taskVO.setWorkStatus("001");	// 발송상태:발송승인
		taskVO.setExeUserId((String)session.getAttribute("NEO_USER_ID"));

		
		int result = 0;
		try {
			result = campaignService.updateMailAdmit(taskVO);
		} catch(Exception e) {
			logger.error("campaignService.updateMailAdmit error = " + e);
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
	 * 메일 등록 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailAddP")
	public String goMailAddP(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailAddP searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailAddP searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailAddP searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailAddP searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailAddP searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailAddP searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailAddP searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailAddP searchWorkStatus = " + searchVO.getSearchWorkStatus());
		
		// 수신자정보머지키코드 목록
		CodeVO merge = new CodeVO();
		merge.setUilang((String)session.getAttribute("NEO_UILANG"));
		merge.setCdGrp("C001");
		merge.setUseYn("Y");
		List<CodeVO> mergeList = null;
		try {
			mergeList = codeService.getCodeList(merge);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C001] error = " + e);
		}
		
		// 채널코드 목록
		CodeVO channel = new CodeVO();
		channel.setUilang((String)session.getAttribute("NEO_UILANG"));
		channel.setCdGrp("C002");
		channel.setUseYn("Y");
		List<CodeVO> channelList = null;
		try {
			channelList = codeService.getCodeList(channel);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C002] error = " + e);
		}
		
		// 발송주기타입코드 목록
		CodeVO period = new CodeVO();
		period.setUilang((String)session.getAttribute("NEO_UILANG"));
		period.setCdGrp("C019");
		period.setUseYn("Y");
		List<CodeVO> periodList = null;
		try {
			periodList = codeService.getCodeList(period);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C019] error = " + e);
		}
		
		// 인코딩타입코드 목록
		CodeVO encoding = new CodeVO();
		encoding.setUilang((String)session.getAttribute("NEO_UILANG"));
		encoding.setCdGrp("C021");
		encoding.setUseYn("Y");
		List<CodeVO> encodingList = null;
		try {
			encodingList = codeService.getCodeList(encoding);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C021] error = " + e);
		}
		
		// 사용자정보
		UserVO userInfo = new UserVO();
		userInfo.setUilang((String)session.getAttribute("NEO_UILANG"));
		userInfo.setUserId((String)session.getAttribute("NEO_USER_ID"));
		try {
			userInfo = systemService.getUserInfo(userInfo);
		} catch(Exception e) {
			logger.error("systemService.getUserInfo error = " + e);
		}
		
		// 캠페인 목록 조회
		CampaignVO camp = new CampaignVO();
		camp.setUilang((String)session.getAttribute("NEO_UILANG"));
		camp.setSearchStatus("000");
		camp.setPage(1);
		camp.setRows(1000);
		camp.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<CampaignVO> campList = null;
		try {
			campList = campaignService.getCampaignList(camp);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		// 발송대상(세그먼트) 목록
		SegmentVO seg = new SegmentVO();
		seg.setUilang((String)session.getAttribute("NEO_UILANG"));
		seg.setSearchStatus("000");
		seg.setPage(1);
		seg.setRows(1000);
		seg.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<SegmentVO> segList = null;
		try {
			segList = segmentService.getSegmentList(seg);
		} catch(Exception e) {
			logger.error("segmentService.getSegmentList error = " + e);
		}
		
		// 템플릿 목록
		TemplateVO temp = new TemplateVO();
		temp.setUilang((String)session.getAttribute("NEO_UILANG"));
		temp.setSearchStatus("000");
		temp.setPage(1);
		temp.setRows(1000);
		temp.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<TemplateVO> tempList = null;
		try {
			tempList = templateService.getTemplateList(temp);
		} catch(Exception e) {
			logger.error("templateService.getTemplateList error = " + e);
		}
		
		
		// 캠페인정보
		CampaignVO campaignInfo = new CampaignVO();
		if(searchVO.getCampNo() != 0) {
			campaignInfo.setUilang((String)session.getAttribute("NEO_UILANG"));
			campaignInfo.setCampNo(searchVO.getCampNo());
			try {
				campaignInfo = campaignService.getCampaignInfo(campaignInfo);
			} catch(Exception e) {
				logger.error("campaignService.getCampaignInfo error = " + e);
			}
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		
		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("mergeList", mergeList);			// 수신자정보머지키코드
		model.addAttribute("channelList", channelList);		// 채널코드
		model.addAttribute("periodList", periodList);		// 발송주기타입코드
		model.addAttribute("encodingList", encodingList);	// 인코딩타입코드
		model.addAttribute("userInfo", userInfo);			// 사용자정보
		model.addAttribute("campList", campList);			// 캠페인목록
		model.addAttribute("segList", segList);				// 발송대상(세그먼트) 목록
		model.addAttribute("tempList", tempList);			// 템플릿 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		if(searchVO.getCampNo() != 0) {
			model.addAttribute("campaignInfo", campaignInfo);			// 캠페인정보
		}
		
		
		// 설정파일내용
		model.addAttribute("MP_FULL_URL", properties.getProperty("MP_FULL_URL"));
		model.addAttribute("SOCKET_TIME_OUT", properties.getProperty("SOCKET_TIME_OUT"));
		model.addAttribute("CONN_PER_CNT", properties.getProperty("CONN_PER_CNT"));
		model.addAttribute("RETRY_CNT", properties.getProperty("RETRY_CNT"));
		model.addAttribute("MAIL_ENCODING", properties.getProperty("MAIL_ENCODING"));
		
		return "ems/cam/mailAddP";
	}
	
	/**
	 * 메일 정보를 등록한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailAdd")
	public String goMailAdd(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailAdd deptNo     = " + taskVO.getDeptNo());
		logger.debug("goMailAdd userId     = " + taskVO.getUserId());
		logger.debug("goMailAdd campInfo   = " + taskVO.getCampInfo());
		logger.debug("goMailAdd segNo      = " + taskVO.getSegNo());
		logger.debug("goMailAdd contTy     = " + taskVO.getContTy());
		logger.debug("goMailAdd linkYn     = " + taskVO.getLinkYn());
		logger.debug("goMailAdd attachNm   = " + taskVO.getAttachNm());
		logger.debug("goMailAdd attachPath = " + taskVO.getAttachPath());
		
		List<AttachVO> attachList = null;		// 첨부파일 목록
		List<LinkVO> linkList = null;			// 링크 목록
		
		// 파일 사이즈 체크
		if(taskVO.getAttachPath() != null && !"".equals(taskVO.getAttachPath())) {
			attachList = new ArrayList<AttachVO>();
			
			File attachFile = null;
			String basePath = properties.getProperty("FILE.UPLOAD_PATH") + "/attach";
			
			long fileSize = 0;
			String[] fileNm = taskVO.getAttachNm().split(",");
			String[] filePath = taskVO.getAttachPath().split(",");
			taskVO.setAttCnt(filePath.length);		// 첨부파일 수 설정
			for(int i=0;i<filePath.length;i++) {
				attachFile = new File(basePath + "/" + filePath[i]);
				fileSize += attachFile.length();
				
				AttachVO attach = new AttachVO();
				attach.setAttNm(fileNm[i]);
				attach.setAttFlPath("attach/" + filePath[i]);
				attach.setAttFlSize(attachFile.length());
				
				attachList.add(attach);
			}
			
			// 합계 파일 사이즈가 10MB 이상인 경우 중지 
			if(fileSize > 10485760) {	// 10MB이상
				model.addAttribute("result","Fail");
				model.addAttribute("FILE_SIZE","EXCESS");
				return "ems/cam/mailAdd";
			}
		}

		// 기본값 설정
		if(taskVO.getDeptNo() == 0) taskVO.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));						// 부서번호
		if(StringUtil.isNull(taskVO.getUserId())) taskVO.setUserId((String)session.getAttribute("NEO_USER_ID"));	// 사용자아이디
		if(StringUtil.isNull(taskVO.getPlanUserId())) taskVO.setPlanUserId("");
		if(StringUtil.isNull(taskVO.getCampTy())) taskVO.setCampTy("");												// 캠페인유형
		if(StringUtil.isNull(taskVO.getNmMerge())) taskVO.setNmMerge("");											// $:nm_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getIdMerge())) taskVO.setIdMerge("");											// $:id_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getChannel())) taskVO.setChannel("000");										// 채널코드
		if(StringUtil.isNull(taskVO.getContTy())) taskVO.setContTy("000");											// 편집모드(기본 HTML형식)
		if(!StringUtil.isNull(taskVO.getSegNoc())) taskVO.setSegNo(Integer.parseInt( taskVO.getSegNoc().substring(0, taskVO.getSegNoc().indexOf("|")) ));		// 세그먼트번호(발송대상그룹)
		if(StringUtil.isNull(taskVO.getRespYn())) taskVO.setRespYn("0");											// 수신확인
		if(StringUtil.isNull(taskVO.getTaskNm())) taskVO.setTaskNm("");												// 메일명
		if(StringUtil.isNull(taskVO.getMailTitle())) taskVO.setMailTitle("");										// 메일제목
		if(StringUtil.isNull(taskVO.getSendYmd())) taskVO.setSendYmd("0000-00-00");									// 예약시간(예약일)
		String sendHour = StringUtil.setTwoDigitsString(taskVO.getSendHour());										// 예약시간(시)
		String sendMin = StringUtil.setTwoDigitsString(taskVO.getSendMin());										// 예약시간(분)
		taskVO.setSendDt( taskVO.getSendYmd().replaceAll("\\.", "") + sendHour + sendMin );							// 예약일시
		taskVO.setRespEndDt("999999999999");
		if(StringUtil.isNull(taskVO.getIsSendTerm())) taskVO.setIsSendTerm("N");									// 정기발송체크여부
		if(StringUtil.isNull(taskVO.getSendTermEndDt())) taskVO.setSendTermEndDt("0000-00-00");						// 정기발송종료일
		if(StringUtil.isNull(taskVO.getSendTermLoop())) taskVO.setSendTermLoop("");									// 정기발송주기
		if(StringUtil.isNull(taskVO.getSendTermLoopTy())) taskVO.setSendTermLoopTy("");								// 정기발송주기유형
		if(StringUtil.isNull(taskVO.getSendTestYn())) taskVO.setSendTestYn("N");
		if(StringUtil.isNull(taskVO.getSendTestEm())) taskVO.setSendTestEm("");
		if(StringUtil.isNull(taskVO.getComposerValue())) taskVO.setComposerValue("");								// 메일내용
		if("Y".equals(taskVO.getIsSendTerm())) {
			taskVO.setSendTermEndDt( taskVO.getSendTermEndDt().replaceAll("\\.", "") + "2359" );						// 정기발송종료일
			taskVO.setSendRepeat("001");
		} else {
			taskVO.setSendTermEndDt("");
			taskVO.setSendTermLoop("");
			taskVO.setSendTermLoopTy("");
			taskVO.setSendRepeat("000");
		}
		if(StringUtil.isNull(taskVO.getLinkYn())) taskVO.setLinkYn("N");											// 링크클릭
		taskVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		taskVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		
		if(StringUtil.isNull(taskVO.getSendMode())) taskVO.setSendMode("");
		if(StringUtil.isNull(taskVO.getMailFromNm())) taskVO.setMailFromNm("");
		if(StringUtil.isNull(taskVO.getMailFromEm())) taskVO.setMailFromEm("");
		if(StringUtil.isNull(taskVO.getReplyToEm())) taskVO.setReplyToEm("");
		if(StringUtil.isNull(taskVO.getReturnEm())) taskVO.setReturnEm("");
		
		if(StringUtil.isNull(taskVO.getHeaderEnc())) taskVO.setHeaderEnc("");
		if(StringUtil.isNull(taskVO.getBodyEnc())) taskVO.setBodyEnc("");
		if(StringUtil.isNull(taskVO.getCharset())) taskVO.setCharset("");
		
		
		taskVO.setStatus("000");
		taskVO.setRecoStatus("000");
		taskVO.setWorkStatus("000");
		taskVO.setSendIp(properties.getProperty("SEND_IP"));
		
		// 링크클릭 체크한 경우
		if("Y".equals(taskVO.getLinkYn()) && "000".equals(taskVO.getContTy())) {
			// 링크 클릭 알리아싱 처리(mailAliasParser.jsp 내용 처리) =============================================================================
			List<LinkVO> dataList = null;

			// 수신자정보머지키코드 목록
			CodeVO merge = new CodeVO();
			merge.setUilang((String)session.getAttribute("NEO_UILANG"));
			merge.setCdGrp("C001");
			merge.setUseYn("Y");
			List<CodeVO> mergeList = null;
			try {
				mergeList = codeService.getCodeList(merge);
			} catch(Exception e) {
				logger.error("codeService.getCodeList[C001] error = " + e);
			}
			
			try {
				// 링크 클릭 알리아스 처리
				dataList = campaignService.mailAliasParser(taskVO, mergeList, properties);
			} catch(Exception e) {
				logger.error("campaignService.mailAliasParser error = "+ e);
			}
			
			if(dataList != null && dataList.size() > 0) {
				linkList = new ArrayList<LinkVO>();
				for(LinkVO data:dataList) {
					LinkVO link = new LinkVO();
					
					link.setLinkTy(data.getLinkTy());
					link.setLinkUrl(data.getLinkUrl());
					link.setLinkNm(data.getLinkNm());
					link.setLinkNo(data.getLinkNo());
					link.setRegId((String)session.getAttribute("NEO_USER_ID"));
					link.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
					linkList.add(link);
				}
			}
		}

		// 수신확인 클릭한 경우
		if("Y".equals(taskVO.getRespYn())) {
			// send_dt와 p_resp_log를 이용하여 수신 종료 응답시간을 구한다.
			if(taskVO.getRespLog() != 0) { // respLog : 수신확인추적기간
				Calendar cal = Calendar.getInstance();
				SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
				cal.set(Integer.parseInt(taskVO.getSendYmd().substring(0,4)), Integer.parseInt(taskVO.getSendYmd().substring(5,7))-1, Integer.parseInt(taskVO.getSendYmd().substring(8,10)));
				cal.add(Calendar.DATE, taskVO.getRespLog());
				taskVO.setRespEndDt(fmt.format(cal.getTime()) + taskVO.getSendHour() + taskVO.getSendMin()) ;
			} else {
				taskVO.setRespEndDt("999999999999");
			}
			
			String tmpCompose = taskVO.getComposerValue();
			int pos = tmpCompose.toLowerCase().indexOf("</body>");
			
			String strResponse = "<!--NEO__RESPONSE__START-->";
			strResponse += "<img src='"+properties.getProperty("RESPONSE_URL")+"?$:RESP_END_DT:$|000|"+taskVO.getIdMerge()+"|$:TASK_NO:$|$:SUB_TASK_NO:$|$:DEPT_NO:$|$:USER_ID:$|$:CAMP_TY:$|$:CAMP_NO:$' width=0 height=0 border=0>";
			strResponse += "<!--NEO__RESPONSE__END-->";
			if(pos == -1) taskVO.setComposerValue(taskVO.getComposerValue() + strResponse);
			else taskVO.setComposerValue( taskVO.getComposerValue().substring(0, pos) + strResponse + taskVO.getComposerValue().substring(pos));
		}
		

		// 메일 작성내용 파일로 생성(파일 생성 전 디렉토리 생성)
		taskVO.getComposerValue();
		String contFlPath = "content/" + (String)session.getAttribute("NEO_USER_ID") + "/" + StringUtil.getDate(Code.TM_YMDHMSM) + ".tmp";
		taskVO.setContFlPath(contFlPath);
		String basePath = properties.getProperty("FILE.UPLOAD_PATH");
		String filePath = basePath + "/" + contFlPath;
		String dirPath = basePath + "/content/" + (String)session.getAttribute("NEO_USER_ID");
		File fileDir = new File(dirPath);
		if(!fileDir.exists()) {
			fileDir.mkdir();
		}
		
		FileOutputStream fos = null;
		OutputStreamWriter writer = null;
		try {
			File contentFile = new File(filePath);
			fos = new FileOutputStream(contentFile);
			writer = new OutputStreamWriter(fos, "UTF-8");
			writer.write(taskVO.getComposerValue());
			writer.flush();
		} catch(Exception e) {
			logger.error("mailAdd File Write Error = " + e);
		} finally {
			if(writer != null) try { writer.close(); } catch(Exception e) {}
			if(fos != null) try { fos.close(); } catch(Exception e) {}
		}
		
		
		
		int result = 0;
		// 메일 정보 등록(NEO_TASK, NEO_SUBTASK, NEO_ATTACH, NEO_LINK)
		try {
			result = campaignService.insertMailInfo(taskVO, attachList, linkList);
		} catch(Exception e) {
			logger.error("campaignService.insertMailInfo error = " + e);
		}
		
		if(result > 0) {
			model.addAttribute("result","Success");
		} else {
			model.addAttribute("result","Fail");
		}
		
		
		return "ems/cam/mailAdd";
	}
	
	/**
	 * 메일 정보 수정 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="mailUpdateP")
	public String goMailUpdateP(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailUpdateP searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailUpdateP searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailUpdateP searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailUpdateP searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailUpdateP searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailUpdateP searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailUpdateP searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailUpdateP searchWorkStatus = " + searchVO.getSearchWorkStatus());
		logger.debug("goMailUpdateP taskNo           = " + searchVO.getTaskNo());
		logger.debug("goMailUpdateP subTaskNo        = " + searchVO.getSubTaskNo());
		
		// 수신자정보머지키코드 목록
		CodeVO merge = new CodeVO();
		merge.setUilang((String)session.getAttribute("NEO_UILANG"));
		merge.setCdGrp("C001");
		merge.setUseYn("Y");
		List<CodeVO> mergeList = null;
		try {
			mergeList = codeService.getCodeList(merge);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C001] error = " + e);
		}
		
		// 채널코드 목록
		CodeVO channel = new CodeVO();
		channel.setUilang((String)session.getAttribute("NEO_UILANG"));
		channel.setCdGrp("C002");
		channel.setUseYn("Y");
		List<CodeVO> channelList = null;
		try {
			channelList = codeService.getCodeList(channel);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C002] error = " + e);
		}
		
		// 발송주기타입코드 목록
		CodeVO period = new CodeVO();
		period.setUilang((String)session.getAttribute("NEO_UILANG"));
		period.setCdGrp("C019");
		period.setUseYn("Y");
		List<CodeVO> periodList = null;
		try {
			periodList = codeService.getCodeList(period);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C019] error = " + e);
		}
		
		// 메일 상세정보 조회
		TaskVO mailInfo = new TaskVO();
		mailInfo.setTaskNo(searchVO.getTaskNo());
		mailInfo.setSubTaskNo(searchVO.getSubTaskNo());
		try {
			mailInfo = campaignService.getMailInfo(mailInfo);
		} catch(Exception e) {
			logger.error("campaignService.getMailInfo error = " + e);
		}
		
		// 캠페인정보
		CampaignVO campaignInfo = new CampaignVO();
		campaignInfo.setUilang((String)session.getAttribute("NEO_UILANG"));
		campaignInfo.setCampNo(mailInfo.getCampNo());
		try {
			campaignInfo = campaignService.getCampaignInfo(campaignInfo);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignInfo error = " + e);
		}
		
		// 캠페인 목록 조회
		CampaignVO camp = new CampaignVO();
		camp.setUilang((String)session.getAttribute("NEO_UILANG"));
		camp.setSearchStatus("000");
		camp.setPage(1);
		camp.setRows(1000);
		camp.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<CampaignVO> campList = null;
		try {
			campList = campaignService.getCampaignList(camp);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		// 발송대상(세그먼트) 목록
		SegmentVO seg = new SegmentVO();
		seg.setUilang((String)session.getAttribute("NEO_UILANG"));
		seg.setSearchStatus("000");
		seg.setPage(1);
		seg.setRows(1000);
		seg.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<SegmentVO> segList = null;
		try {
			segList = segmentService.getSegmentList(seg);
		} catch(Exception e) {
			logger.error("segmentService.getSegmentList error = " + e);
		}
		
		// 템플릿 목록
		TemplateVO temp = new TemplateVO();
		temp.setUilang((String)session.getAttribute("NEO_UILANG"));
		temp.setSearchStatus("000");
		temp.setPage(1);
		temp.setRows(1000);
		temp.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		List<TemplateVO> tempList = null;
		try {
			tempList = templateService.getTemplateList(temp);
		} catch(Exception e) {
			logger.error("templateService.getTemplateList error = " + e);
		}
		
		// 첨부파일 목록
		List<AttachVO> attachList = null;
		try {
			attachList = campaignService.getAttachList(searchVO.getTaskNo());
		} catch(Exception e) {
			logger.error("campaignService.getAttachList error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO dept = new CodeVO();
		dept.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(dept);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		CodeVO user = new CodeVO();
		user.setDeptNo(mailInfo.getDeptNo());
		user.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(user);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		// 메일 내용
		String compVal = getContFileText(mailInfo.getContFlPath());
		
		
		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("mergeList", mergeList);			// 수신자정보머지키코드
		model.addAttribute("channelList", channelList);		// 채널코드
		model.addAttribute("periodList", periodList);		// 발송주기타입코드
		model.addAttribute("mailInfo", mailInfo);			// 메일상세정보
		model.addAttribute("campaignInfo", campaignInfo);	// 캠페인정보
		model.addAttribute("campList", campList);			// 캠페인목록
		model.addAttribute("segList", segList);				// 발송대상(세그먼트) 목록
		model.addAttribute("tempList", tempList);			// 템플릿 목록
		model.addAttribute("attachList", attachList);		// 첨부파일 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		model.addAttribute("compVal", compVal);				// 메일 내용
		
		return "ems/cam/mailUpdateP";
	}
	
	/**
	 * 메일 정보를 수정한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailUpdate")
	public String goMailUpdate(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailUpdate taskNo     = " + taskVO.getTaskNo());
		logger.debug("goMailUpdate subTaskNo  = " + taskVO.getSubTaskNo());
		logger.debug("goMailUpdate deptNo     = " + taskVO.getDeptNo());
		logger.debug("goMailUpdate userId     = " + taskVO.getUserId());
		logger.debug("goMailUpdate campInfo   = " + taskVO.getCampInfo());
		logger.debug("goMailUpdate segNo      = " + taskVO.getSegNo());
		logger.debug("goMailUpdate contTy     = " + taskVO.getContTy());
		logger.debug("goMailUpdate linkYn     = " + taskVO.getLinkYn());
		logger.debug("goMailUpdate attachNm   = " + taskVO.getAttachNm());
		logger.debug("goMailUpdate attachPath = " + taskVO.getAttachPath());
		
		List<AttachVO> attachList = null;		// 첨부파일 목록
		List<LinkVO> linkList = null;			// 링크 목록
		
		/*
		// 파일 사이즈 체크
		if(taskVO.getAttachPath() != null && !"".equals(taskVO.getAttachPath())) {
			attachList = new ArrayList<AttachVO>();
			
			File attachFile = null;
			String basePath = properties.getProperty("FILE.UPLOAD_PATH") + "/attach";
			
			long fileSize = 0;
			String[] fileNm = taskVO.getAttachNm().split(",");
			String[] filePath = taskVO.getAttachPath().split(",");
			taskVO.setAttCnt(filePath.length);		// 첨부파일 수 설정
			for(int i=0;i<filePath.length;i++) {
				attachFile = new File(basePath + "/" + filePath[i]);
				fileSize += attachFile.length();
				
				AttachVO attach = new AttachVO();
				attach.setTaskNo(taskVO.getTaskNo());
				attach.setAttNm(fileNm[i]);
				attach.setAttFlPath("attach/" + filePath[i]);
				attach.setAttFlSize(attachFile.length());
				
				attachList.add(attach);
			}
			
			// 합계 파일 사이즈가 10MB 이상인 경우 중지 
			if(fileSize > 10485760) {	// 10MB이상
				model.addAttribute("result","Fail");
				model.addAttribute("FILE_SIZE","EXCESS");
				return "ems/cam/mailUpdate";
			}
		}
		
		// 기본값 설정
		if(taskVO.getDeptNo() == 0) taskVO.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));						// 부서번호
		if(StringUtil.isNull(taskVO.getUserId())) taskVO.setUserId((String)session.getAttribute("NEO_USER_ID"));	// 사용자아이디
		if(StringUtil.isNull(taskVO.getPlanUserId())) taskVO.setPlanUserId("");
		if(StringUtil.isNull(taskVO.getCampTy())) taskVO.setCampTy("");												// 캠페인유형
		if(StringUtil.isNull(taskVO.getNmMerge())) taskVO.setNmMerge("");											// $:nm_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getIdMerge())) taskVO.setIdMerge("");											// $:id_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getChannel())) taskVO.setChannel("000");										// 채널코드
		if(StringUtil.isNull(taskVO.getContTy())) taskVO.setContTy("000");											// 편집모드(기본 HTML형식)
		if(!StringUtil.isNull(taskVO.getSegNoc())) taskVO.setSegNo(Integer.parseInt( taskVO.getSegNoc().substring(0, taskVO.getSegNoc().indexOf("|")) ));		// 세그먼트번호(발송대상그룹)
		if(StringUtil.isNull(taskVO.getRespYn())) taskVO.setRespYn("0");											// 수신확인
		if(StringUtil.isNull(taskVO.getTaskNm())) taskVO.setTaskNm("");												// 메일명
		if(StringUtil.isNull(taskVO.getMailTitle())) taskVO.setMailTitle("");										// 메일제목
		if(StringUtil.isNull(taskVO.getSendYmd())) taskVO.setSendYmd("0000-00-00");									// 예약시간(예약일)
		String sendHour = StringUtil.setTwoDigitsString(taskVO.getSendHour());										// 예약시간(시)
		String sendMin = StringUtil.setTwoDigitsString(taskVO.getSendMin());										// 예약시간(분)
		taskVO.setSendDt( taskVO.getSendYmd().replaceAll("\\.", "") + sendHour + sendMin );							// 예약일시
		taskVO.setRespEndDt("999999999999");
		if(StringUtil.isNull(taskVO.getIsSendTerm())) taskVO.setIsSendTerm("N");									// 정기발송체크여부
		if(StringUtil.isNull(taskVO.getSendTermEndDt())) taskVO.setSendTermEndDt("0000-00-00");						// 정기발송종료일
		if(StringUtil.isNull(taskVO.getSendTermLoop())) taskVO.setSendTermLoop("");									// 정기발송주기
		if(StringUtil.isNull(taskVO.getSendTermLoopTy())) taskVO.setSendTermLoopTy("");								// 정기발송주기유형
		if(StringUtil.isNull(taskVO.getSendTestYn())) taskVO.setSendTestYn("N");
		if(StringUtil.isNull(taskVO.getSendTestEm())) taskVO.setSendTestEm("");
		if(StringUtil.isNull(taskVO.getComposerValue())) taskVO.setComposerValue("");								// 메일내용
		if("Y".equals(taskVO.getIsSendTerm())) {
			taskVO.setSendTermEndDt( taskVO.getSendTermEndDt().replaceAll("\\.", "") + "2359" );						// 정기발송종료일
			taskVO.setSendRepeat("001");
		} else {
			taskVO.setSendTermEndDt("");
			taskVO.setSendTermLoop("");
			taskVO.setSendTermLoopTy("");
			taskVO.setSendRepeat("000");
		}
		if(StringUtil.isNull(taskVO.getLinkYn())) taskVO.setLinkYn("N");											// 링크클릭
		taskVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		taskVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		if(StringUtil.isNull(taskVO.getSendMode())) taskVO.setSendMode("");
		if(StringUtil.isNull(taskVO.getMailFromNm())) taskVO.setMailFromNm("");
		if(StringUtil.isNull(taskVO.getMailFromEm())) taskVO.setMailFromEm("");
		if(StringUtil.isNull(taskVO.getReplyToEm())) taskVO.setReplyToEm("");
		if(StringUtil.isNull(taskVO.getReturnEm())) taskVO.setReturnEm("");
		
		if(StringUtil.isNull(taskVO.getHeaderEnc())) taskVO.setHeaderEnc("");
		if(StringUtil.isNull(taskVO.getBodyEnc())) taskVO.setBodyEnc("");
		if(StringUtil.isNull(taskVO.getCharset())) taskVO.setCharset("");
		
		
		taskVO.setStatus("000");
		taskVO.setRecoStatus("000");
		taskVO.setWorkStatus("000");
		taskVO.setSendIp(properties.getProperty("SEND_IP"));
		
		// 링크클릭 체크한 경우
		if("Y".equals(taskVO.getLinkYn())) {
			// 링크 클릭 알리아싱 처리(mailAliasParser.jsp 내용 처리) =============================================================================
			List<LinkVO> dataList = null;

			// 수신자정보머지키코드 목록
			CodeVO merge = new CodeVO();
			merge.setUilang((String)session.getAttribute("NEO_UILANG"));
			merge.setCdGrp("C001");
			merge.setUseYn("Y");
			List<CodeVO> mergeList = null;
			try {
				mergeList = codeService.getCodeList(merge);
			} catch(Exception e) {
				logger.error("codeService.getCodeList[C001] error = " + e);
			}
			
			try {
				// 링크 클릭 알리아스 처리
				dataList = campaignService.mailAliasParser(taskVO, mergeList, properties);
			} catch(Exception e) {
				logger.error("campaignService.mailAliasParser error = "+ e);
			}
			
			if(dataList != null && dataList.size() > 0) {
				linkList = new ArrayList<LinkVO>();
				for(LinkVO data:dataList) {
					LinkVO link = new LinkVO();
					
					link.setLinkTy(data.getLinkTy());
					link.setLinkUrl(data.getLinkUrl());
					link.setLinkNm(data.getLinkNm());
					link.setLinkNo(data.getLinkNo());
					link.setRegId((String)session.getAttribute("NEO_USER_ID"));
					link.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
					linkList.add(link);
				}
			}
		}
		
		// 수신확인 클릭한 경우
		if("Y".equals(taskVO.getRespYn()) && "000".equals(taskVO.getContTy())) {
			// send_dt와 p_resp_log를 이용하여 수신 종료 응답시간을 구한다.
			if(taskVO.getRespLog() != 0) { // respLog : 수신확인추적기간
				Calendar cal = Calendar.getInstance();
				SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
				cal.set(Integer.parseInt(taskVO.getSendYmd().substring(0,4)), Integer.parseInt(taskVO.getSendYmd().substring(5,7))-1, Integer.parseInt(taskVO.getSendYmd().substring(8,10)));
				cal.add(Calendar.DATE, taskVO.getRespLog());
				taskVO.setRespEndDt(fmt.format(cal.getTime()) + taskVO.getSendHour() + taskVO.getSendMin()) ;
			} else {
				taskVO.setRespEndDt("999999999999");
			}
			
			if(taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__START-->") == -1) {
				String tmpCompose = taskVO.getComposerValue();
				int pos = tmpCompose.toLowerCase().indexOf("</body>");
				
				String strResponse = "<!--NEO__RESPONSE__START-->";
				strResponse += "<img src='"+properties.getProperty("RESPONSE_URL")+"?$:RESP_END_DT:$|000|"+taskVO.getIdMerge()+"|$:TASK_NO:$|$:SUB_TASK_NO:$|$:DEPT_NO:$|$:USER_ID:$|$:CAMP_TY:$|$:CAMP_NO:$' width=0 height=0 border=0>";
				strResponse += "<!--NEO__RESPONSE__END-->";
				if(pos == -1) taskVO.setComposerValue(taskVO.getComposerValue() + strResponse);
				else taskVO.setComposerValue( taskVO.getComposerValue().substring(0, pos) + strResponse + taskVO.getComposerValue().substring(pos));
			}
		} else {
			int startPos = taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__START-->");
			int endPos = taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__END-->");
			if(startPos != -1 && endPos != -1) {
				taskVO.setComposerValue( taskVO.getComposerValue().substring(0, startPos) + taskVO.getComposerValue().substring(endPos+"<!--NEO__RESPONSE__END-->".length()) );
			}
		}

		// 파일을 수정한다.
		FileOutputStream fos = null;
		OutputStreamWriter writer = null;
		try {
			File contFile = new File(properties.getProperty("FILE.UPLOAD_PATH") + "/" + taskVO.getContFlPath());
			fos = new FileOutputStream(contFile);
			writer = new OutputStreamWriter(fos, "UTF-8");
			writer.write(taskVO.getComposerValue());
			writer.flush();
		} catch(Exception e) {
			logger.error("mailUpdate File Write Error = " + e);
		}
		*/
		
		String res = "";
		try {
			res = mailUpdateProcess(taskVO, model, attachList, linkList, session);
		} catch(Exception e) {
			logger.error("mailUpdateProcess error = " + e);
		}
		
		// 합계 파일 사이즈가 10MB 이상인 경우 중지 
		if("FILE_SIZE".equals(res)) {
			model.addAttribute("result","Fail");
			model.addAttribute("FILE_SIZE","EXCESS");
			return "ems/cam/mailUpdate";
		}
		
		int result = 0;
		if("Success".equals(res)) {
			// 메일 정보 수정(NEO_TASK, NEO_SUBTASK, NEO_ATTACH, NEO_LINK)
			try {
				result = campaignService.updateMailInfo(taskVO, attachList, linkList);
			} catch(Exception e) {
				logger.error("campaignService.updateMailInfo error = " + e);
			}
		}
		
		if(result > 0) {
			model.addAttribute("result","Success");
		} else {
			model.addAttribute("result","Fail");
		}
		
		return "ems/cam/mailUpdate";
	}

	
	
	/**
	 * 웹에이전트 팝업 화면을 출력한다.
	 * @return
	 */
	@RequestMapping(value="/mailWebAgentP")
	public String goMailWebAgent() {
		return "ems/cam/mailWebAgentP";
	}
	
	/**
	 * 환경설정 팝업 화면을 출력한다.
	 * @return
	 */
	@RequestMapping(value="/mailOptionP")
	public String goMailOption(Model model, HttpSession session) {
		
		// 인코딩타입코드 목록
		CodeVO encoding = new CodeVO();
		encoding.setUilang((String)session.getAttribute("NEO_UILANG"));
		encoding.setCdGrp("C021");
		encoding.setUseYn("Y");
		List<CodeVO> encodingList = null;
		try {
			encodingList = codeService.getCodeList(encoding);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C021] error = " + e);
		}
		
		// 문자셋코드 목록
		CodeVO charset = new CodeVO();
		charset.setUilang((String)session.getAttribute("NEO_UILANG"));
		charset.setCdGrp("C022");
		charset.setUseYn("Y");
		List<CodeVO> charsetList = null;
		try {
			charsetList = codeService.getCodeList(charset);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C022] error = " + e);
		}
		
		// 발송모드코드 목록
		CodeVO sendMode = new CodeVO();
		sendMode.setUilang((String)session.getAttribute("NEO_UILANG"));
		sendMode.setCdGrp("C020");
		sendMode.setUseYn("Y");
		List<CodeVO> sendModeList = null;
		try {
			sendModeList = codeService.getCodeList(sendMode);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C020] error = " + e);
		}
		
		model.addAttribute("encodingList", encodingList);	// 인코딩
		model.addAttribute("charsetList", charsetList);		// 문자셋
		model.addAttribute("sendModeList", sendModeList);	// 발송모드
		
		return "ems/cam/mailOptionP";
	}
	
	/**
	 * 수신거부 팝업 화면을 출력한다.
	 * @return
	 */
	@RequestMapping(value="/mailRejectP")
	public String goMailReject(Model model, HttpSession session) {
		
		// 수신자정보머지키코드 목록
		CodeVO merge = new CodeVO();
		merge.setUilang((String)session.getAttribute("NEO_UILANG"));
		merge.setCdGrp("C001");
		merge.setUseYn("Y");
		List<CodeVO> mergeList = null;
		try {
			mergeList = codeService.getCodeList(merge);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C001] error = " + e);
		}
		
		model.addAttribute("mergeList", mergeList);
		model.addAttribute("RES_REJECT_URL", properties.getProperty("RES_REJECT_URL"));
		
		return "ems/cam/mailRejectP";
	}
	
	/**
	 * 메일(캠페인 주업무, 보조업무) 상태를 업데이트 한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailDelete")
	public ModelAndView updateMailStatus(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateMailStatus taskNos    = " + taskVO.getTaskNos());
		logger.debug("updateMailStatus subTaskNos = " + taskVO.getSubTaskNos());
		logger.debug("updateMailStatus status     = " + taskVO.getStatus());
		
		taskVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		taskVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));

		int result = 0;
		try {
			result = campaignService.updateMailStatus(taskVO);
		} catch(Exception e) {
			logger.error("campaignService.updateMailStatus error = " + e);
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
	 * 메일을 복사한다.(주업무, 보조업무, 첨부파일)
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailCopy")
	public ModelAndView copyMailInfo(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("copyMailInfo taskNos    = " + taskVO.getTaskNos());
		logger.debug("copyMailInfo subTaskNos = " + taskVO.getSubTaskNos());
		
		taskVO.setTaskNo( Integer.parseInt(taskVO.getTaskNos()) );
		taskVO.setSubTaskNo( Integer.parseInt(taskVO.getSubTaskNos()) );
		taskVO.setUserId((String)session.getAttribute("NEO_USER_ID"));
		taskVO.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		taskVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		
		int result = 0;
		try {
			result = campaignService.copyMailInfo(taskVO, properties);
		} catch(Exception e) {
			logger.error("campaignService.copyMailInfo error = " + e);
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
	 * 테스트발송 팝업창을 출력한다.
	 * @param testUserVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestListP")
	public String goTestUserList(@ModelAttribute TestUserVO testUserVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goTestUserList taskNos    = " + testUserVO.getTaskNos());
		logger.debug("goTestUserList subTaskNos = " + testUserVO.getSubTaskNos());
		
		String userId = (String)session.getAttribute("NEO_USER_ID");
		List<TestUserVO> testUserList = null;
		try {
			testUserList = campaignService.getTestUserList(userId);
		} catch(Exception e) {
			logger.error("campaignService.getTestUserList error = " + e);
		}
		
		model.addAttribute("testUserVO", testUserVO);
		model.addAttribute("testUserList", testUserList);	// 테스트유저 목록
		
		return "ems/cam/mailTestListP";
	}
	
	/**
	 * 테스트 사용자 정보 등록
	 * @param testUserVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestAdd")
	public ModelAndView insertTestUserInfo(@ModelAttribute TestUserVO testUserVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("insertTestUserInfo testUserNm = " + testUserVO.getTestUserNm());
		logger.debug("insertTestUserInfo testUserEm = " + testUserVO.getTestUserEm());
		
		testUserVO.setUserId((String)session.getAttribute("NEO_USER_ID"));
		int result = 0;
		try {
			result = campaignService.insertTestUserInfo(testUserVO);
		} catch(Exception e) {
			logger.error("campaignService.insertTestUserInfo error = " + e);
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
	 * 테스트 사용자 정보 수정
	 * @param testUserVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestUpdate")
	public ModelAndView updateTestUserInfo(@ModelAttribute TestUserVO testUserVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateTestUserInfo testUserNm = " + testUserVO.getTestUserNm());
		logger.debug("updateTestUserInfo testUserEm = " + testUserVO.getTestUserEm());
		logger.debug("updateTestUserInfo testUserNo = " + testUserVO.getTestUserNo());
		
		int result = 0;
		try {
			result = campaignService.updateTestUserInfo(testUserVO);
		} catch(Exception e) {
			logger.error("campaignService.updateTestUserInfo error = " + e);
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
	 * 테스트 사용자 정보 삭제
	 * @param testUserVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestDelete")
	public ModelAndView deleteTestUserInfo(@ModelAttribute TestUserVO testUserVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("deleteTestUserInfo testUserNo = " + testUserVO.getTestUserNo());
		
		int result = 0;
		try {
			result = campaignService.deleteTestUserInfo(testUserVO);
		} catch(Exception e) {
			logger.error("campaignService.deleteTestUserInfo error = " + e);
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
	 * 테스트발송 등록
	 * @param testUserVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestSend")
	public ModelAndView sendTestMail(@ModelAttribute TestUserVO testUserVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("sendTestMail taskNos    = " + testUserVO.getTaskNos());
		logger.debug("sendTestMail subTaskNos = " + testUserVO.getSubTaskNos());
		logger.debug("sendTestMail testEmail  = " + testUserVO.getTestEmail());
		
		testUserVO.setSendDt(StringUtil.getDate(Code.TM_YMDHM));
		
		int result = 0;
		try {
			result = campaignService.sendTestMail(testUserVO, session);
		} catch(Exception e) {
			logger.error("campaignService.sendTestMail error = " + e);
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
	 * 메일업데이트 화면에서 발송승인 처리
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailUpdateAdmit")
	public String goMailUpdateAdmit(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		List<AttachVO> attachList = null;		// 첨부파일 목록
		List<LinkVO> linkList = null;			// 링크 목록

		String res = "";
		try {
			res = mailUpdateProcess(taskVO, model, attachList, linkList, session);
		} catch(Exception e) {
			logger.error("mailUpdateProcess error = " + e);
		}
		
		// 합계 파일 사이즈가 10MB 이상인 경우 중지 
		if("FILE_SIZE".equals(res)) {
			model.addAttribute("result","Fail");
			model.addAttribute("FILE_SIZE","EXCESS");
			return "ems/cam/mailUpdateAdmit";
		}
		
		int result = 0;
		if("Success".equals(res)) {
			// 메일 정보 수정(NEO_TASK, NEO_SUBTASK, NEO_ATTACH, NEO_LINK)
			try {
				result += campaignService.updateMailInfo(taskVO, attachList, linkList);
			} catch(Exception e) {
				logger.error("campaignService.updateMailInfo error = " + e);
			}
			
			if(result == 0) {
				model.addAttribute("result","Fail");
				return "ems/cam/mailUpdateAdmit";
			} 
			
			// 발송승인 처리
			taskVO.setRecoStatus("001");	// 승인여부:승인
			taskVO.setWorkStatus("001");	// 발송상태:발송승인
			taskVO.setExeUserId((String)session.getAttribute("NEO_USER_ID"));
			try {
				result += campaignService.updateMailAdmit(taskVO);
			} catch(Exception e) {
				logger.error("campaignService.updateMailAdmit error = " + e);
			}
		}
		
		if(result > 0) {
			model.addAttribute("result","Success");
		} else {
			model.addAttribute("result","Fail");
		}
		
		return "ems/cam/mailUpdateAdmit";
	}
	
	
	/**
	 * 메일 업데이트 처리
	 * @param taskVO
	 * @param model
	 * @param attachList
	 * @param linkList
	 * @param session
	 * @return
	 * @throws Exception
	 */
	public String mailUpdateProcess(TaskVO taskVO, Model model, List<AttachVO> attachList, List<LinkVO> linkList, HttpSession session) throws Exception {
		// 파일 사이즈 체크
		if(taskVO.getAttachPath() != null && !"".equals(taskVO.getAttachPath())) {
			attachList = new ArrayList<AttachVO>();
			
			File attachFile = null;
			String basePath = properties.getProperty("FILE.UPLOAD_PATH") + "/attach";
			
			long fileSize = 0;
			String[] fileNm = taskVO.getAttachNm().split(",");
			String[] filePath = taskVO.getAttachPath().split(",");
			taskVO.setAttCnt(filePath.length);		// 첨부파일 수 설정
			for(int i=0;i<filePath.length;i++) {
				attachFile = new File(basePath + "/" + filePath[i]);
				fileSize += attachFile.length();
				
				AttachVO attach = new AttachVO();
				attach.setTaskNo(taskVO.getTaskNo());
				attach.setAttNm(fileNm[i]);
				attach.setAttFlPath("attach/" + filePath[i]);
				attach.setAttFlSize(attachFile.length());
				
				attachList.add(attach);
			}
			
			// 합계 파일 사이즈가 10MB 이상인 경우 중지 
			if(fileSize > 10485760) {	// 10MB이상
				model.addAttribute("result","Fail");
				model.addAttribute("FILE_SIZE","EXCESS");
				return "FILE_SIZE";
			}
		}
		
		// 기본값 설정
		if(taskVO.getDeptNo() == 0) taskVO.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));						// 부서번호
		if(StringUtil.isNull(taskVO.getUserId())) taskVO.setUserId((String)session.getAttribute("NEO_USER_ID"));	// 사용자아이디
		if(StringUtil.isNull(taskVO.getPlanUserId())) taskVO.setPlanUserId("");
		if(StringUtil.isNull(taskVO.getCampTy())) taskVO.setCampTy("");												// 캠페인유형
		if(StringUtil.isNull(taskVO.getNmMerge())) taskVO.setNmMerge("");											// $:nm_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getIdMerge())) taskVO.setIdMerge("");											// $:id_merge:$형태로 넘어옴
		if(StringUtil.isNull(taskVO.getChannel())) taskVO.setChannel("000");										// 채널코드
		if(StringUtil.isNull(taskVO.getContTy())) taskVO.setContTy("000");											// 편집모드(기본 HTML형식)
		if(!StringUtil.isNull(taskVO.getSegNoc())) taskVO.setSegNo(Integer.parseInt( taskVO.getSegNoc().substring(0, taskVO.getSegNoc().indexOf("|")) ));		// 세그먼트번호(발송대상그룹)
		if(StringUtil.isNull(taskVO.getRespYn())) taskVO.setRespYn("0");											// 수신확인
		if(StringUtil.isNull(taskVO.getTaskNm())) taskVO.setTaskNm("");												// 메일명
		if(StringUtil.isNull(taskVO.getMailTitle())) taskVO.setMailTitle("");										// 메일제목
		if(StringUtil.isNull(taskVO.getSendYmd())) taskVO.setSendYmd("0000-00-00");									// 예약시간(예약일)
		String sendHour = StringUtil.setTwoDigitsString(taskVO.getSendHour());										// 예약시간(시)
		String sendMin = StringUtil.setTwoDigitsString(taskVO.getSendMin());										// 예약시간(분)
		taskVO.setSendDt( taskVO.getSendYmd().replaceAll("\\.", "") + sendHour + sendMin );							// 예약일시
		taskVO.setRespEndDt("999999999999");
		if(StringUtil.isNull(taskVO.getIsSendTerm())) taskVO.setIsSendTerm("N");									// 정기발송체크여부
		if(StringUtil.isNull(taskVO.getSendTermEndDt())) taskVO.setSendTermEndDt("0000-00-00");						// 정기발송종료일
		if(StringUtil.isNull(taskVO.getSendTermLoop())) taskVO.setSendTermLoop("");									// 정기발송주기
		if(StringUtil.isNull(taskVO.getSendTermLoopTy())) taskVO.setSendTermLoopTy("");								// 정기발송주기유형
		if(StringUtil.isNull(taskVO.getSendTestYn())) taskVO.setSendTestYn("N");
		if(StringUtil.isNull(taskVO.getSendTestEm())) taskVO.setSendTestEm("");
		if(StringUtil.isNull(taskVO.getComposerValue())) taskVO.setComposerValue("");								// 메일내용
		if("Y".equals(taskVO.getIsSendTerm())) {
			taskVO.setSendTermEndDt( taskVO.getSendTermEndDt().replaceAll("\\.", "") + "2359" );						// 정기발송종료일
			taskVO.setSendRepeat("001");
		} else {
			taskVO.setSendTermEndDt("");
			taskVO.setSendTermLoop("");
			taskVO.setSendTermLoopTy("");
			taskVO.setSendRepeat("000");
		}
		if(StringUtil.isNull(taskVO.getLinkYn())) taskVO.setLinkYn("N");											// 링크클릭
		taskVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		taskVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		if(StringUtil.isNull(taskVO.getSendMode())) taskVO.setSendMode("");
		if(StringUtil.isNull(taskVO.getMailFromNm())) taskVO.setMailFromNm("");
		if(StringUtil.isNull(taskVO.getMailFromEm())) taskVO.setMailFromEm("");
		if(StringUtil.isNull(taskVO.getReplyToEm())) taskVO.setReplyToEm("");
		if(StringUtil.isNull(taskVO.getReturnEm())) taskVO.setReturnEm("");
		
		if(StringUtil.isNull(taskVO.getHeaderEnc())) taskVO.setHeaderEnc("");
		if(StringUtil.isNull(taskVO.getBodyEnc())) taskVO.setBodyEnc("");
		if(StringUtil.isNull(taskVO.getCharset())) taskVO.setCharset("");
		
		
		taskVO.setStatus("000");
		taskVO.setRecoStatus("000");
		taskVO.setWorkStatus("000");
		taskVO.setSendIp(properties.getProperty("SEND_IP"));
		
		// 링크클릭 체크한 경우
		if("Y".equals(taskVO.getLinkYn())) {
			// 링크 클릭 알리아싱 처리(mailAliasParser.jsp 내용 처리) =============================================================================
			List<LinkVO> dataList = null;

			// 수신자정보머지키코드 목록
			CodeVO merge = new CodeVO();
			merge.setUilang((String)session.getAttribute("NEO_UILANG"));
			merge.setCdGrp("C001");
			merge.setUseYn("Y");
			List<CodeVO> mergeList = null;
			try {
				mergeList = codeService.getCodeList(merge);
			} catch(Exception e) {
				logger.error("codeService.getCodeList[C001] error = " + e);
			}
			
			try {
				// 링크 클릭 알리아스 처리
				dataList = campaignService.mailAliasParser(taskVO, mergeList, properties);
			} catch(Exception e) {
				logger.error("campaignService.mailAliasParser error = "+ e);
			}
			
			if(dataList != null && dataList.size() > 0) {
				linkList = new ArrayList<LinkVO>();
				for(LinkVO data:dataList) {
					LinkVO link = new LinkVO();
					
					link.setLinkTy(data.getLinkTy());
					link.setLinkUrl(data.getLinkUrl());
					link.setLinkNm(data.getLinkNm());
					link.setLinkNo(data.getLinkNo());
					link.setRegId((String)session.getAttribute("NEO_USER_ID"));
					link.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
					linkList.add(link);
				}
			}
		}
		
		// 수신확인 클릭한 경우
		if("Y".equals(taskVO.getRespYn()) && "000".equals(taskVO.getContTy())) {
			// send_dt와 p_resp_log를 이용하여 수신 종료 응답시간을 구한다.
			if(taskVO.getRespLog() != 0) { // respLog : 수신확인추적기간
				Calendar cal = Calendar.getInstance();
				SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
				cal.set(Integer.parseInt(taskVO.getSendYmd().substring(0,4)), Integer.parseInt(taskVO.getSendYmd().substring(5,7))-1, Integer.parseInt(taskVO.getSendYmd().substring(8,10)));
				cal.add(Calendar.DATE, taskVO.getRespLog());
				taskVO.setRespEndDt(fmt.format(cal.getTime()) + taskVO.getSendHour() + taskVO.getSendMin()) ;
			} else {
				taskVO.setRespEndDt("999999999999");
			}
			
			if(taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__START-->") == -1) {
				String tmpCompose = taskVO.getComposerValue();
				int pos = tmpCompose.toLowerCase().indexOf("</body>");
				
				String strResponse = "<!--NEO__RESPONSE__START-->";
				strResponse += "<img src='"+properties.getProperty("RESPONSE_URL")+"?$:RESP_END_DT:$|000|"+taskVO.getIdMerge()+"|$:TASK_NO:$|$:SUB_TASK_NO:$|$:DEPT_NO:$|$:USER_ID:$|$:CAMP_TY:$|$:CAMP_NO:$' width=0 height=0 border=0>";
				strResponse += "<!--NEO__RESPONSE__END-->";
				if(pos == -1) taskVO.setComposerValue(taskVO.getComposerValue() + strResponse);
				else taskVO.setComposerValue( taskVO.getComposerValue().substring(0, pos) + strResponse + taskVO.getComposerValue().substring(pos));
			}
		} else {
			int startPos = taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__START-->");
			int endPos = taskVO.getComposerValue().indexOf("<!--NEO__RESPONSE__END-->");
			if(startPos != -1 && endPos != -1) {
				taskVO.setComposerValue( taskVO.getComposerValue().substring(0, startPos) + taskVO.getComposerValue().substring(endPos+"<!--NEO__RESPONSE__END-->".length()) );
			}
		}

		// 파일을 수정한다.
		FileOutputStream fos = null;
		OutputStreamWriter writer = null;
		try {
			File contFile = new File(properties.getProperty("FILE.UPLOAD_PATH") + "/" + taskVO.getContFlPath());
			fos = new FileOutputStream(contFile);
			writer = new OutputStreamWriter(fos, "UTF-8");
			writer.write(taskVO.getComposerValue());
			writer.flush();
		} catch(Exception e) {
			logger.error("mailUpdate File Write Error = " + e);
		}
		
		return "Success";
	}
	
	/**
	 * 테스트발송상세정보 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestTaskP")
	public String goMailTestTaskP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailTestTaskP sendTestTaskNo    = " + taskVO.getSendTestTaskNo());
		logger.debug("goMailTestTaskP sendTestSubTaskNo = " + taskVO.getSendTestSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 테스트발송 목록 조회
		List<TaskVO> testList = null;
		try {
			testList = campaignService.getMailTestTaskList(taskVO);
		} catch(Exception e) {
			logger.error("campaignService.getMailTestTaskList error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);
		model.addAttribute("testList", testList);
		
		return "ems/cam/mailTestTaskP";
	}
	
	/**
	 * 테스트발송결과로그 조회
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailTestSendLogP")
	public String goMailTestSendLogP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailTestSendLogP taskNo    = " + taskVO.getTaskNo());
		logger.debug("goMailTestSendLogP subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 테스트발송로그 목록 조회
		List<SendTestLogVO> logList = null;
		try {
			logList = campaignService.getMailTestSendLogList(taskVO);
		} catch(Exception e) {
			logger.error("campaignService.getMailTestSendLogList error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);
		model.addAttribute("testList", logList);
		
		return "ems/cam/mailTestSendLogP";
	}
	
	
	
	/**
	 * 파일의 내용을 읽는다.
	 * @param contFlPath
	 * @return
	 */
	public String getContFileText(String contFlPath) {
		logger.debug("getContFileText contFlPath  = " + contFlPath);
		
		File file = null;
		FileReader fileReader = null;
		BufferedReader bufferedReader = null;
		StringBuffer sb = new StringBuffer();
		try {
			String basePath = properties.getProperty("FILE.UPLOAD_PATH");
			String contPath = basePath + "/" + contFlPath;
			
			file = new File(contPath);
			fileReader = new FileReader(file);
			bufferedReader = new BufferedReader(fileReader);
			String line = "";
			while((line = bufferedReader.readLine()) != null) {
				sb.append(line);
			}
		} catch(Exception e) {
			logger.error("goContFileView error = " + e);
		} finally {
			if(bufferedReader != null) try { bufferedReader.close(); } catch(Exception e) {};
			if(fileReader != null) try { fileReader.close(); } catch(Exception e) {};
		}
		
		String fileContent = sb.toString().trim();
		fileContent = fileContent.replaceAll("\"", "'");
		fileContent = fileContent.replaceAll("\n", " ");
		fileContent = fileContent.replaceAll("\r", " ");
		
		return fileContent;
	}
}
