/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 관리 Controller==>시스템 로그 관리 Controller
 * 수정자 : 김준희
 * 작성일시 : 2021.08.09
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경 kr.co.enders.ums.sys.controller ==> kr.co.enders.ums.sys.log.controller
 *                사용자코드 관리 기능 외의 항목제거
 */
package kr.co.enders.ums.sys.log.controller;

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

import kr.co.enders.ums.sys.log.service.SystemLogService;
import kr.co.enders.ums.sys.log.vo.LoginHistVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/sys/log")
public class SystemLogController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private SystemLogService systemLogService;
	
	@Autowired
	private PropertiesUtil properties; 
	
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
		loginHistVO.setSearchLgnStdDt(loginHistVO.getSearchLgnStdDt().replaceAll("-", ""));
		loginHistVO.setSearchLgnEndDt(loginHistVO.getSearchLgnEndDt().replaceAll("-", ""));
		
		
		// 로그인 이력 목록 조회
		List<LoginHistVO> loginHistList = null;
		List<LoginHistVO> newLoginHistList = new ArrayList<LoginHistVO>();
		try {
			loginHistList = systemLogService.getLoginHistList(loginHistVO);
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
}
