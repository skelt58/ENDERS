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
import kr.co.enders.ums.sys.cod.service.UserCodeService;
import kr.co.enders.ums.sys.cod.vo.UserCodeGroupVO;
import kr.co.enders.ums.sys.cod.vo.UserCodeVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
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
			userCodeList = userCodeService.getUserCodeList(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.getUserCodeList error = " + e);
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
			result = userCodeService.updateUserCodeInfo(userCodeVO);
		} catch(Exception e) {
			logger.error("userCodeService.updateUserCodeInfo error = " + e);
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
