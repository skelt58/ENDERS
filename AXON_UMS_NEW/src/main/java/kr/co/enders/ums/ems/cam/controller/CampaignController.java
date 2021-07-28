/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.26
 * 설명 : 캠페인관리 Controller
 */
package kr.co.enders.ums.ems.cam.controller;

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
import kr.co.enders.ums.ems.cam.service.CampaignService;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.seg.service.SegmentService;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.UserVO;
import kr.co.enders.ums.ems.tmp.service.TemplateService;
import kr.co.enders.ums.ems.tmp.vo.TemplateVO;
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
	private SystemService systemService;
	
	@Autowired
	private PropertiesUtil properties;
	
	
	/**
	 * 캠페인 목록 조회
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/campListP")
	public String goCampList(@ModelAttribute CampaignVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goCampList searchCampNm  = " + searchVO.getSearchCampNm());
		logger.debug("goCampList searchCampTy  = " + searchVO.getSearchCampTy());
		logger.debug("goCampList searchStatus  = " + searchVO.getSearchStatus());
		logger.debug("goCampList searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goCampList searchEndDt   = " + searchVO.getSearchEndDt());
		logger.debug("goCampList searchDeptNo  = " + searchVO.getSearchDeptNo());
		logger.debug("goCampList searchUserId  = " + searchVO.getSearchUserId());
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(-1, "M", "yyyyMMdd"));
		} else {
			searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("-", ""));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyyMMdd"));
		} else {
			searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("-", ""));
		}
		if(searchVO.getSearchStatus() == null || "".equals(searchVO.getSearchStatus())) searchVO.setSearchStatus("000");
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
		
		if(campaignList != null && campaignList.size() > 0) {
			totalCount = campaignList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);

		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("campaignList", campaignList);	// 캠페인 목록
		model.addAttribute("campTyList", campTyList);		// 캠페인목적 목록
		model.addAttribute("statusList", statusList);		// 캠페인상태 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		model.addAttribute("pageUtil", pageUtil);			// 페이징
		
		return "ems/cam/campListP";
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
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(-1, "M", "yyyyMMdd"));
		} else {
			searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("-", ""));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyyMMdd"));
		} else {
			searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("-", ""));
		}
		if(searchVO.getSearchStatus() == null || "".equals(searchVO.getSearchStatus())) searchVO.setSearchStatus("000");
		if(searchVO.getSearchDeptNo() == 0) {
			if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo(0);
			} else {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
		}
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
		logger.debug("goMailMain searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailMain searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailMain searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailMain searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailMain searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailMain searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailMain searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailMain searchWorkStatus = " + searchVO.getSearchWorkStatus());
		
		// 검색 기본값 설정
		searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("-", ""));
		searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("-", ""));
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
	public String goMailAdd(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailAdd searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goMailAdd searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goMailAdd searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goMailAdd searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goMailAdd searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goMailAdd searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goMailAdd searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goMailAdd searchWorkStatus = " + searchVO.getSearchWorkStatus());
		
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
		model.addAttribute("TAGFREE_CLASSID", properties.getProperty("TAGFREE_CLASSID"));
		model.addAttribute("TAGFREE_CODEBASE", properties.getProperty("TAGFREE_CODEBASE"));
		model.addAttribute("MP_FULL_URL", properties.getProperty("MP_FULL_URL"));

		model.addAttribute("SOCKET_TIME_OUT", properties.getProperty("SOCKET_TIME_OUT"));
		model.addAttribute("CONN_PER_CNT", properties.getProperty("CONN_PER_CNT"));
		model.addAttribute("RETRY_CNT", properties.getProperty("RETRY_CNT"));
		model.addAttribute("MAIL_ENCODING", properties.getProperty("MAIL_ENCODING"));
		
		return "ems/cam/mailAddP";
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
}
