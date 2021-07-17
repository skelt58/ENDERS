/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : Segment 관리 Controller
 */
package kr.co.enders.ums.ems.seg.controller;

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

import kr.co.enders.ums.com.service.CodeService;
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.seg.service.SegmentService;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/seg")
public class SegmentController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private SegmentService segmentService;
	
	@RequestMapping(value="/segMainP")
	public String goSegMain(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegMain searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegMain searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegMain searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegMain searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegMain searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegMain searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegMain searchUserId = " + searchVO.getSearchUserId());
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(-1, "M", "yyyy-MM-dd"));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyy-MM-dd"));
		}
		
		if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
			searchVO.setSearchDeptNo(0);
		} else {
			searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		}
		
		
		// 세그먼트 생성 유형 코드 조회
		CodeVO createTy = new CodeVO();
		createTy.setUilang((String)session.getAttribute("NEO_UILANG"));
		createTy.setCdGrp("C013");	// 세그먼트 생성 유형
		createTy.setUseYn("Y");
		List<CodeVO> createTyList = null;
		try {
			createTyList = codeService.getCodeList(createTy);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C013] error = " + e);
		}
		
		// 발송그룹상태 코드 조회
		CodeVO status = new CodeVO();
		status.setUilang((String)session.getAttribute("NEO_UILANG"));
		status.setCdGrp("C023");	// 발송그룹상태
		status.setUseYn("Y");
		List<CodeVO> statusList = null;
		try {
			statusList = codeService.getCodeList(status);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C023] error = " + e);
		}
		
		// 부서목록(코드성) 조회
		CodeVO deptVO = new CodeVO();
		deptVO.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(deptVO);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		// 사용자 목록 조회
		CodeVO userVO = new CodeVO();
		userVO.setDeptNo(searchVO.getSearchDeptNo());
		userVO.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(userVO);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		// 발송대상(세그먼트) 목록 조회
		SegmentVO search = searchVO;
		search.setUilang((String)session.getAttribute("NEO_UILANG"));
		search.setSearchStartDt(search.getSearchStartDt().replaceAll("-","")+"000000");
		search.setSearchEndDt(search.getSearchEndDt().replaceAll("-", "") + "240000");
		List<SegmentVO> segmentList = null;
		try {
			segmentList = segmentService.getSegmentList(search);
		} catch(Exception e) {
			logger.error("segmentService.getSegmentList error = " + e);
		}
		

		model.addAttribute("searchVO", searchVO);
		model.addAttribute("createTyList", createTyList);	// 세그먼트 생성 유형
		model.addAttribute("statusList", statusList);		// 발송그룹상태
		model.addAttribute("deptList", deptList);			// 부서번호
		model.addAttribute("userList", userList);			// 사용자
		model.addAttribute("segmentList", segmentList);
		
		return "ems/seg/segMainP";
	}
}
