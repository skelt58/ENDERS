/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계/분석 Controller
 */
package kr.co.enders.ums.ems.ana.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mp.util.Code;

import kr.co.enders.ums.com.service.CodeService;
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.ana.service.AnalysisService;
import kr.co.enders.ums.ems.ana.vo.MailDomainVO;
import kr.co.enders.ums.ems.ana.vo.MailErrorVO;
import kr.co.enders.ums.ems.ana.vo.MailSummVO;
import kr.co.enders.ums.ems.ana.vo.RespLogVO;
import kr.co.enders.ums.ems.ana.vo.SendLogVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.util.MessageUtil;
import kr.co.enders.util.PageUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/ana")
public class AnalysisController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private AnalysisService analysisService;
	
	@Autowired
	private PropertiesUtil properties;
	
	@Autowired
	private MessageUtil messageUtil;
	
	/**
	 * 메일별 분석 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailListP")
	public String goMailListP(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
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
		if(searchVO.getSearchDeptNo() == 0) {
			if(!"Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
		}
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE_ANA")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;

		// 캠페인 목록 조회
		List<CampaignVO> campList = null;
		CampaignVO camp = new CampaignVO();
		camp.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		camp.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		camp.setStatus("000");
		try {
			campList = codeService.getCampaignList(camp);
		} catch(Exception e) {
			logger.error("codeService.getCampaignList error = " + e);
		}
		
		// 부서 목록 조회
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
		
		// 메일 목록 조회
		List<TaskVO> mailList = null;
		try {
			mailList = analysisService.getMailList(searchVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailList error = " + e);
		}
		
		if(mailList != null && mailList.size() > 0) {
			totalCount = mailList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);
		
		model.addAttribute("searchVO", searchVO);	// 검색 항목
		model.addAttribute("mailList", mailList);	// 메일 목록
		model.addAttribute("campList", campList);	// 캠페인 목록
		model.addAttribute("deptList", deptList);	// 부서 목록
		model.addAttribute("userList", userList);	// 사용자 목록
		model.addAttribute("pageUtil", pageUtil);	// 페이징
		
		return "ems/ana/mailListP";
	}
	
	/**
	 * 통계분석 결과요약 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailSummP")
	public String goMailSumm(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailSumm taskNo = " + taskVO.getTaskNo());
		logger.debug("goMailSumm subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 메일 정보 조회
		TaskVO mailInfo = null;
		try {
			mailInfo = analysisService.getMailInfo(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailInfo error = " + e);
		}
		
		// 발송결과 조회
		MailSummVO sendResult = null;
		try {
			sendResult = analysisService.getMailSummResult(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailSummResult error = " + e);
		}
		
		// 세부에러 조회
		List<MailErrorVO> detailList = null;
		try {
			detailList = analysisService.getMailSummDetail(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailSummDetail error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);			// 조건정보
		model.addAttribute("mailInfo", mailInfo);		// 메일 정보
		model.addAttribute("sendResult", sendResult);	// 발송결과
		model.addAttribute("detailList", detailList);	// 세부에러
		
		return "ems/ana/mailSummP";
	}
	
	/**
	 * 발송 실패 목록 조회
	 * @param sendLogVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/failListP")
	public String goFailListP(@ModelAttribute SendLogVO sendLogVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goFailListP taskNo    = " + sendLogVO.getTaskNo());
		logger.debug("goFailListP subTaskNo = " + sendLogVO.getSubTaskNo());
		logger.debug("goFailListP step1     = " + sendLogVO.getStep1());
		logger.debug("goFailListP step2     = " + sendLogVO.getStep2());
		logger.debug("goFailListP step3     = " + sendLogVO.getStep3());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(sendLogVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(sendLogVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		sendLogVO.setPage(page);
		sendLogVO.setRows(rows);
		int totalCount = 0;
		
		// 발송 실패 목록 조회
		List<SendLogVO> failList = null;
		try {
			failList = analysisService.getFailList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getFailList error = " + e);
		}
		
		// 페이징 설정
		if(failList != null && failList.size() > 0) {
			totalCount = failList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, sendLogVO.getPage(), totalCount, rows);
		
		model.addAttribute("sendLogVO", sendLogVO);
		model.addAttribute("failList", failList);
		model.addAttribute("pageUtil", pageUtil);
		
		return "ems/ana/failListP";
	}
	
	/**
	 * 발송 실패 목록 엑셀 다운로드
	 * @param sendLogVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/failExcelList")
	public void goFailExcelList(@ModelAttribute SendLogVO sendLogVO, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("goFailExcelList taskNo    = " + sendLogVO.getTaskNo());
		logger.debug("goFailExcelList subTaskNo = " + sendLogVO.getSubTaskNo());
		logger.debug("goFailExcelList step1     = " + sendLogVO.getStep1());
		logger.debug("goFailExcelList step2     = " + sendLogVO.getStep2());
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(sendLogVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(sendLogVO.getRows(), 9999999);
		sendLogVO.setPage(page);
		sendLogVO.setRows(rows);
		
		// 발송 실패 목록 조회
		List<SendLogVO> failList = null;
		try {
			failList = analysisService.getFailList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getFailList error = " + e);
		}

		try {
			// 엑셀 생성
			XSSFWorkbook wb = new XSSFWorkbook();
			XSSFSheet sheet = wb.createSheet("Log List");
			Row row = null;
			Cell cell = null;
			int rowNum = 0;
			
			// 헤더 색상 지정
			XSSFCellStyle headerStyle = wb.createCellStyle();
			headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			
			// 엑셀 헤더 생성 ( EMAIL | ID | NAME | SENDING DATE | MESSAGE )
			row = sheet.createRow(rowNum++);
			cell = row.createCell(0); cell.setCellStyle(headerStyle); cell.setCellValue("EMAIL");
			cell = row.createCell(1); cell.setCellStyle(headerStyle); cell.setCellValue("ID");
			cell = row.createCell(2); cell.setCellStyle(headerStyle); cell.setCellValue("NAME");
			cell = row.createCell(3); cell.setCellStyle(headerStyle); cell.setCellValue("SENDING DATE");
			cell = row.createCell(4); cell.setCellStyle(headerStyle); cell.setCellValue("MESSAGE");
			
			// 엑셀 내용 추가
			for(SendLogVO log:failList) {
				row = sheet.createRow(rowNum++);
				cell = row.createCell(0); cell.setCellValue( log.getCustEm() );		// EMAIL
				cell = row.createCell(1); cell.setCellValue( log.getCustId() );		// ID
				cell = row.createCell(2); cell.setCellValue( log.getCustNm() );		// NAME
				cell = row.createCell(3); cell.setCellValue( StringUtil.getFDate(log.getSendDt()) );	// SENDING DATE
				cell = row.createCell(4); cell.setCellValue( log.getSendMsg() );	// MESSAGE
			}
			
			// 컨텐츠 타입과 파일명 지정
			response.setContentType("ms-vnd/excel");
			response.setHeader("Content-Disposition", "attachment;filename=Error.xlsx");
			
			// 엑셀 파일 다운로드
			wb.write(response.getOutputStream());
			wb.close();
		} catch(Exception e) {
			logger.error("Excel File Download Error = " + e);
		}
	}

	/**
	 * 통계분석 세부에러 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailErrorP")
	public String goMailErrorP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailErrorP taskNo = " + taskVO.getTaskNo());
		logger.debug("goMailErrorP subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 메일 정보 조회
		TaskVO mailInfo = null;
		try {
			mailInfo = analysisService.getMailInfo(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailInfo error = " + e);
		}
		
		// 세부에러 목록 조회
		List<MailErrorVO> errorList = null;
		try {
			errorList = analysisService.getMailErrorList(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailErrorList error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);			// 조건정보
		model.addAttribute("mailInfo", mailInfo);		// 메일 정보
		model.addAttribute("errorList", errorList);		// 세부에러

		return "/ems/ana/mailErrorP";
	}
	
	/**
	 * 통계분석 도메인별 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailDomainP")
	public String goMailDomainP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailDomainP taskNo = " + taskVO.getTaskNo());
		logger.debug("goMailDomainP subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 메일 정보 조회
		TaskVO mailInfo = null;
		try {
			mailInfo = analysisService.getMailInfo(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailInfo error = " + e);
		}
		
		// 도메인별 목록 조회
		List<MailDomainVO> domainList = null;
		try {
			domainList = analysisService.getMailDomainList(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailDomainList error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);			// 조건정보
		model.addAttribute("mailInfo", mailInfo);		// 메일 정보
		model.addAttribute("domainList", domainList);	// 도메인별
		
		return "ems/ana/mailDomainP";
	}
	
	/**
	 * 통계분석 발송시간별 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailSendP")
	public String goMailSendP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailSendP taskNo = " + taskVO.getTaskNo());
		logger.debug("goMailSendP subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 메일 정보 조회
		TaskVO mailInfo = null;
		try {
			mailInfo = analysisService.getMailInfo(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailInfo error = " + e);
		}
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(taskVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(taskVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		taskVO.setPage(page);
		taskVO.setRows(rows);
		int totalCount = 0;

		// 발송시간별 목록 조회
		List<SendLogVO> sendList = null;
		try {
			sendList = analysisService.getMailSendHourList(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailSendHourList error = " + e);
		}
		
		// 페이징 설정
		if(sendList != null && sendList.size() > 0) {
			totalCount = sendList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, taskVO.getPage(), totalCount, rows);
		
		// 발송시간별 합계 조회
		SendLogVO sendSum = null;
		try {
			sendSum = analysisService.getMailSendHourSum(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailSendHourList error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);			// 조건정보
		model.addAttribute("mailInfo", mailInfo);		// 메일 정보
		model.addAttribute("sendList", sendList);		// 발송시간별 목록
		model.addAttribute("sendSum", sendSum);			// 발송시간별 합계
		model.addAttribute("pageUtil", pageUtil);		// 페이징
		
		return "ems/ana/mailSendP";
	}
	
	/**
	 * 통계분석 응답시간별 화면을 출력한다.
	 * @param taskVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailRespP")
	public String goMailRespP(@ModelAttribute TaskVO taskVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goMailRespP taskNo = " + taskVO.getTaskNo());
		logger.debug("goMailRespP subTaskNo = " + taskVO.getSubTaskNo());
		taskVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		// 메일 정보 조회
		TaskVO mailInfo = null;
		try {
			mailInfo = analysisService.getMailInfo(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailInfo error = " + e);
		}
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(taskVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(taskVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		taskVO.setPage(page);
		taskVO.setRows(rows);
		int totalCount = 0;

		// 응답시간별 목록 조회
		List<RespLogVO> respList = null;
		try {
			respList = analysisService.getMailRespHourList(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailRespHourList error = " + e);
		}
		
		// 페이징 설정
		if(respList != null && respList.size() > 0) {
			totalCount = respList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, taskVO.getPage(), totalCount, rows);
		
		// 응답시간별 합계 조회
		RespLogVO respSum = null;
		try {
			respSum = analysisService.getMailRespHourSum(taskVO);
		} catch(Exception e) {
			logger.error("analysisService.getMailRespHourSum error = " + e);
		}
		
		model.addAttribute("taskVO", taskVO);			// 조건정보
		model.addAttribute("mailInfo", mailInfo);		// 메일 정보
		model.addAttribute("respList", respList);		// 응답시간별 목록
		model.addAttribute("respSum", respSum);			// 응답시간별 합계
		model.addAttribute("pageUtil", pageUtil);		// 페이징
		
		return "ems/ana/mailRespP";
	}
	
	/**
	 * 통계분석 고객별 화면을 출력한다.
	 * @param sendLogVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="logListP")
	public String goLogListP(@ModelAttribute SendLogVO sendLogVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("logListP taskNo       = " + sendLogVO.getTaskNo());
		logger.debug("logListP subTaskNo    = " + sendLogVO.getSubTaskNo());
		logger.debug("logListP searchCustId = " + sendLogVO.getSearchCustId());
		logger.debug("logListP searchCustEm = " + sendLogVO.getSearchCustEm());
		logger.debug("logListP searchCustNm = " + sendLogVO.getSearchCustNm());
		logger.debug("logListP searchKind   = " + sendLogVO.getSearchKind());
		
		// 검색유형 초기값 설정(검색유형 선택 => 전체)
		if(StringUtil.isNull(sendLogVO.getSearchKind())) sendLogVO.setSearchKind("000");
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(sendLogVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(sendLogVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		sendLogVO.setPage(page);
		sendLogVO.setRows(rows);

		// 고객별 로그 목록 조회
		List<SendLogVO> custList = null;
		try {
			custList = analysisService.getCustLogList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getCustLogList error = " + e);
		}
		
		// 페이징 설정
		int totalCount = 0;
		if(custList != null && custList.size() > 0) {
			totalCount = custList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, sendLogVO.getPage(), totalCount, rows);
		
		model.addAttribute("sendLogVO", sendLogVO);		// 조건정보
		model.addAttribute("custList", custList);		// 고객별 목록
		model.addAttribute("pageUtil", pageUtil);		// 페이징
		
		return "ems/ana/logListP";
	}
	
	/**
	 * 통계분석 고객별 화면에서 엑셀로 다운로드 한다.
	 * @param sendLogVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 */
	@RequestMapping(value="/logExcelList")
	public void goLogExcelList(@ModelAttribute SendLogVO sendLogVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goLogExcelList taskNo       = " + sendLogVO.getTaskNo());
		logger.debug("goLogExcelList subTaskNo    = " + sendLogVO.getSubTaskNo());
		logger.debug("goLogExcelList searchCustId = " + sendLogVO.getSearchCustId());
		logger.debug("goLogExcelList searchCustEm = " + sendLogVO.getSearchCustEm());
		logger.debug("goLogExcelList searchCustNm = " + sendLogVO.getSearchCustNm());
		logger.debug("goLogExcelList searchKind   = " + sendLogVO.getSearchKind());
		
		// 검색유형 초기값 설정(검색유형 선택 => 전체)
		if(StringUtil.isNull(sendLogVO.getSearchKind())) sendLogVO.setSearchKind("000");

		// 페이지 설정
		int page = StringUtil.setNullToInt(sendLogVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(sendLogVO.getRows(), 9999999);
		sendLogVO.setPage(page);
		sendLogVO.setRows(rows);
		
		// 고객별 로그 목록 조회
		List<SendLogVO> custList = null;
		try {
			custList = analysisService.getCustLogList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getCustLogList error = " + e);
		}

		try {
			String fileName = "log_" + sendLogVO.getTaskNo() + "_" + sendLogVO.getSubTaskNo() + "_" + StringUtil.getDate(Code.TM_YMD) + ".xlsx";
			logger.debug("#### FileName = " + fileName);
			
			// 엑셀 생성
			XSSFWorkbook wb = new XSSFWorkbook();
			XSSFSheet sheet = wb.createSheet("Log List");
			Row row = null;
			Cell cell = null;
			int rowNum = 0;
			
			// 헤더 색상 지정
			XSSFCellStyle headerStyle = wb.createCellStyle();
			headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			// 엑셀 헤더 생성 ( ID | EMAIL | NAME | 발송여부 | 발송시간 | 수신확인 | 수신거부자 | 수신시간 | Message )
			row = sheet.createRow(rowNum++);
			cell = row.createCell(0); cell.setCellStyle(headerStyle); cell.setCellValue("ID");
			cell = row.createCell(1); cell.setCellStyle(headerStyle); cell.setCellValue("EMAIL");
			cell = row.createCell(2); cell.setCellStyle(headerStyle); cell.setCellValue("NAME");
			cell = row.createCell(3); cell.setCellStyle(headerStyle); cell.setCellValue(messageUtil.getMessage("ANATBLLB006"));		// 발송여부
			cell = row.createCell(4); cell.setCellStyle(headerStyle); cell.setCellValue(messageUtil.getMessage("ANATBLLB007"));		// 발송시간
			cell = row.createCell(5); cell.setCellStyle(headerStyle); cell.setCellValue("수신확인");
			cell = row.createCell(6); cell.setCellStyle(headerStyle); cell.setCellValue("수신거부");
			cell = row.createCell(7); cell.setCellStyle(headerStyle); cell.setCellValue("수신시간");
			cell = row.createCell(8); cell.setCellStyle(headerStyle); cell.setCellValue("Message");
			
			// 엑셀 내용 추가
			for(SendLogVO log:custList) {
				row = sheet.createRow(rowNum++);
				cell = row.createCell(0); cell.setCellValue( log.getCustId() );		// ID
				cell = row.createCell(1); cell.setCellValue( log.getCustEm() ); 	// EMAIL
				cell = row.createCell(2); cell.setCellValue( log.getCustNm() );		// NAME
				cell = row.createCell(3); cell.setCellValue( "000".equals(log.getSendRcode())?messageUtil.getMessage("ANATBLTL017"):messageUtil.getMessage("ANATBLTL018") );	// 발송성공,발송실패
				cell = row.createCell(4); cell.setCellValue( StringUtil.getFDate(log.getSendDt()) );
				cell = row.createCell(5); cell.setCellValue( StringUtil.isNull(log.getOpenDt())?"미확인":"수신확인" );
				cell = row.createCell(6); cell.setCellValue( "Y".equals(log.getDeniedType())?"수신거부":"수신허용" );
				cell = row.createCell(7); cell.setCellValue( StringUtil.getFDate(log.getOpenDt()) );
				cell = row.createCell(8); cell.setCellValue( log.getSendMsg() );
			}
			
			// 컨텐츠 타입과 파일명 지정
			response.setContentType("ms-vnd/excel");
			response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
			
			// 엑셀 파일 다운로드
			wb.write(response.getOutputStream());
			wb.close();
		} catch(Exception e) {
			logger.error("Excel File Download Error = " + e);
		}
	}
	
	/**
	 * 병합분석 화면을 출력한다.
	 * @param sendLogVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/mailJoinP")
	public String goMailJoinP(@ModelAttribute SendLogVO sendLogVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goLogExcelList taskNos       = " + sendLogVO.getTaskNos());
		logger.debug("goLogExcelList subTaskNos    = " + sendLogVO.getSubTaskNos());
		sendLogVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		
		String[] taskNo = sendLogVO.getTaskNos().split(",");
		String[] subTaskNo = sendLogVO.getSubTaskNos().split(",");
		List<HashMap<String, Integer>> joinList = new ArrayList<HashMap<String, Integer>>();
		for(int i=0;i<taskNo.length;i++) {
			HashMap<String, Integer> key = new HashMap<String, Integer>();
			key.put("taskNo", Integer.parseInt(taskNo[i]));
			key.put("subTaskNo", Integer.parseInt(subTaskNo[i]));
			joinList.add(key);
		}
		sendLogVO.setJoinList(joinList);
		
		// 병합분석 메일정보 목록 조회
		List<TaskVO> mailList = null;
		try {
			mailList = analysisService.getJoinMailList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getJoinMailList error = " + e);
		}
		
		// 병합분석 발송결과 조회
		RespLogVO respLog = null;
		try {
			respLog = analysisService.getJoinSendResult(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getJoinSendResult error = " + e);
		}
		
		// 병합분석 세부에러 목록 조회
		List<MailErrorVO> errorList = null;
		try {
			errorList = analysisService.getJoinErrorList(sendLogVO);
		} catch(Exception e) {
			logger.error("analysisService.getJoinErrorList error = " + e);
		}
		
		model.addAttribute("sendLogVO", sendLogVO);		// 조건정보
		model.addAttribute("mailList", mailList);		// 병합분석 메일정보 목록
		model.addAttribute("respLog", respLog);			// 병합분석 발송결과
		model.addAttribute("errorList", errorList);		// 병합분석 세부에러 목록
		
		return "ems/ana/mailJoinP";
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
