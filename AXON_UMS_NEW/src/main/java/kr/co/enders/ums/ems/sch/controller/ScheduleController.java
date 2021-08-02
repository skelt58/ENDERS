/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 일정 Controller
 */
package kr.co.enders.ums.ems.sch.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ems/sch")
public class ScheduleController {

	@RequestMapping(value="/scheMonthP")
	public String goScheMonthP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/sch/scheMonthP";
	}
	
	
	@RequestMapping(value="/scheWeekP")
	public String goScheWeekP(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		return "ems/sch/scheWeekP";
	}
	
}
