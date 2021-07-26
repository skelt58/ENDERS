/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.26
 * 설명 : 캠페인관리 Controller
 */
package kr.co.enders.ums.ems.cam.controller;

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
	private PropertiesUtil properties;
	
	@Autowired
	private CampaignService campaignService;
	
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

}
