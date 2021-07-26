/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.26
 * 설명 : 템플릿관리 Controller
 */
package kr.co.enders.ums.ems.tmp.controller;

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
import kr.co.enders.ums.ems.tmp.service.TemplateService;
import kr.co.enders.ums.ems.tmp.vo.TemplateVO;
import kr.co.enders.util.PageUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/tmp")
public class TemplateController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private PropertiesUtil properties;
	
	@Autowired
	private TemplateService templateService;
	
	/**
	 * 템플릿 목록 조회화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/tempListP")
	public String goTemplateList(@ModelAttribute TemplateVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goTemplateList searchTempNm  = " + searchVO.getSearchTempNm());
		logger.debug("goTemplateList searchStatus  = " + searchVO.getSearchStatus());
		logger.debug("goTemplateList searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goTemplateList searchEndDt   = " + searchVO.getSearchEndDt());
		logger.debug("goTemplateList searchDeptNo  = " + searchVO.getSearchDeptNo());
		logger.debug("goTemplateList searchUserId  = " + searchVO.getSearchUserId());
		
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
		
		// 템플릿 목록 조회
		List<TemplateVO> templateList = null;
		try {
			templateList = templateService.getTemplateList(searchVO);
		} catch(Exception e) {
			logger.error("templateService.getTemplateList error = " + e);
		}

		// 템플릿상태 목록
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C016");
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C016] error = " + e);
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
		
		if(templateList != null && templateList.size() > 0) {
			totalCount = templateList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);

		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("templateList", templateList);	// 템플릿 목록
		model.addAttribute("statusList", statusList);		// 템플릿상태 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("userList", userList);			// 사용자 목록
		model.addAttribute("pageUtil", pageUtil);			// 페이징
		
		return "ems/tmp/tempListP";
	}
	
	/**
	 * 템플릿 정보 조회
	 * @param templateVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/tempInfo")
	public ModelAndView getTempInfo(@ModelAttribute TemplateVO templateVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getTempInfo tempNo      = " + templateVO.getTempNo());
		
		templateVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			templateVO = templateService.getTemplateInfo(templateVO);
		} catch(Exception e) {
			logger.error("templateService.getTemplateInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("template", templateVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	@RequestMapping(value="/tempAdd")
	public ModelAndView insertTempInfo(@ModelAttribute TemplateVO templateVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getTempInfo tempNm      = " + templateVO.getTempNm());
		logger.debug("getTempInfo tempDesc      = " + templateVO.getTempDesc());
		
		templateVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		try {
			templateVO = templateService.getTemplateInfo(templateVO);
		} catch(Exception e) {
			logger.error("templateService.getTemplateInfo error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("template", templateVO);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
}
