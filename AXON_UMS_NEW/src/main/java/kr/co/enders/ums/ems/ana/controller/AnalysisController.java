/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계/분석 Controller
 */
package kr.co.enders.ums.ems.ana.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ems/ana")
public class AnalysisController {
	
	@RequestMapping(value="/mailListP")
	public String goMailListP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/ana/mailListP";
	}
	
	
	@RequestMapping(value="/taskListP")
	public String goTaskListP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/ana/taskListP";
	}
	
	
	@RequestMapping(value="/campListP")
	public String goCampListP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/ana/campListP";
	}
	
	
	@RequestMapping(value="/summMainP")
	public String goSummMainP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/ana/summMainP";
	}
	
}
