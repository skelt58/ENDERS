/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : Segment 관리 Controller
 */
package kr.co.enders.ums.ems.seg.controller;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

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
import kr.co.enders.ums.ems.seg.service.SegmentService;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;
import kr.co.enders.ums.ems.sys.vo.MetaTableVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.PageUtil;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Controller
@RequestMapping("/ems/seg")
public class SegmentController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private PropertiesUtil properties;
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private SystemService systemService;
	
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
		if(searchVO.getSearchStatus() == null || "".equals(searchVO.getSearchStatus())) {
			searchVO.setSearchStatus("000");	// 정상
		}
		if(searchVO.getSearchDeptNo() == 0) {
			if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
				searchVO.setSearchDeptNo(0);
			} else {
				searchVO.setSearchDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
			}
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
		search.setSearchStartDt(search.getSearchStartDt().replaceAll("-","") + "000000");
		search.setSearchEndDt(search.getSearchEndDt().replaceAll("-", "") + "235959");
		List<SegmentVO> segmentList = null;
		try {
			segmentList = segmentService.getSegmentList(search);
		} catch(Exception e) {
			logger.error("segmentService.getSegmentList error = " + e);
		}
		

		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("createTyList", createTyList);	// 세그먼트 생성 유형
		model.addAttribute("statusList", statusList);		// 발송그룹상태
		model.addAttribute("deptList", deptList);			// 부서번호
		model.addAttribute("userList", userList);			// 사용자
		model.addAttribute("segmentList", segmentList);
		
		return "ems/seg/segMainP";
	}
	
	@RequestMapping(value="/segFileAddP")
	public String goSegFileAdd(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegFileAdd searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegFileAdd searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegFileAdd searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegFileAdd searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegFileAdd searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegFileAdd searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegFileAdd searchUserId = " + searchVO.getSearchUserId());
		
		// 부서목록(코드성) 조회
		CodeVO deptVO = new CodeVO();
		deptVO.setStatus("000"); // 정상
		List<CodeVO> deptList = null;
		try {
			deptList = codeService.getDeptList(deptVO);
		} catch(Exception e) {
			logger.error("codeService.getDeptList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);		// 검색 항목
		model.addAttribute("deptList", deptList);		// 부서번호
		
		return "ems/seg/segFileAddP";
	}
	
	@RequestMapping(value="/fileSampleDownPop")
	public String goFileSampleDown() {
		return "ems/seg/fileSampleDownPop";
	}
	
	@RequestMapping(value="/segFileMemberListP")
	public String goSegFileMemberList(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegFileMemberList segFlPath = " + segmentVO.getSegFlPath());
		logger.debug("goSegFileMemberList separatorChar = " + segmentVO.getSeparatorChar());
		logger.debug("goSegFileMemberList page = " + segmentVO.getPage());

		int pageRow = Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE"));
		if(segmentVO.getPage() == 0) segmentVO.setPage(1);
		
		String result = "";
		int totCount = 0;	// 회원총수
		int aliasCnt = 0;	// 알리아스수
		String mergeKey = "";
		
		List<HashMap<String,String>> memList = new ArrayList<HashMap<String,String>>();
		List<String> memAlias = new ArrayList<String>();
		
		BufferedReader line = null;
		String tempStr = "";
		try {
			String tmpFlPath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + segmentVO.getSegFlPath();
			line = new BufferedReader(new InputStreamReader(new FileInputStream(tmpFlPath), "UTF-8"));
			while((tempStr = line.readLine()) != null) {
				if("".equals(tempStr.trim())) continue;
				StringTokenizer st = new StringTokenizer(tempStr, segmentVO.getSeparatorChar());
				
				if(totCount == 0) {	// 첫줄의 알리아스를 읽어 셋팅한다.
					while(st.hasMoreTokens()) {
						memAlias.add(st.nextToken());
						aliasCnt++;
					}
				} else {
					if(tempStr == null || "".equals(tempStr)) break;
					if(totCount > (segmentVO.getPage()-1)*pageRow && totCount <= segmentVO.getPage() * pageRow) { // 페이지별로 size만큼만 저장.
						HashMap<String, String> unitInfo = new HashMap<String,String>();
	                    for(int cnt = 0; cnt < aliasCnt; cnt++) {
	                    	unitInfo.put((String)memAlias.get(cnt), st.nextToken());
	                    }
	                    memList.add(unitInfo);

					}
				}
				totCount++;
			}
			totCount = totCount - 1;	// 첫라인은 알리아스이기때문에 한줄을 빼준다.
			result = "Success";
		} catch(Exception e) {
			memAlias.clear();
			memList.clear();
			
			memAlias.add("LINE");
			memAlias.add("Error");
			
			HashMap<String,String> unitInfo = new HashMap<String,String>();
			unitInfo.put("Line", Integer.toString(totCount));
			unitInfo.put("Error", tempStr);
			memList.add(unitInfo);
			
            if(line != null) try { line.close(); } catch(Exception ex) {}
            result = "Fail";
		}
		
		if(memAlias != null && memAlias.size() > 0) {
			for(int i=0;i<memAlias.size();i++) {
				if(i == 0) {
					mergeKey += (String)memAlias.get(i);
				} else {
					mergeKey += "," + (String)memAlias.get(i);
				}
			}
		}
		
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, segmentVO.getPage(), totCount, pageRow);
		
		model.addAttribute("result", result);
		model.addAttribute("totCount", totCount);
		model.addAttribute("memList", memList);
		model.addAttribute("memAlias", memAlias);
		model.addAttribute("mergeKey", mergeKey);
		model.addAttribute("pageUtil", pageUtil);
		
		return "ems/seg/segFileMemberListP";
	}
	
	@RequestMapping(value="/segAdd")
	public ModelAndView insertSegmentInfo(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("insertSegmentInfo userId        = " + segmentVO.getUserId());
		logger.debug("insertSegmentInfo dbConnNo      = " + segmentVO.getDbConnNo());
		logger.debug("insertSegmentInfo segNm         = " + segmentVO.getSegNm());
		logger.debug("insertSegmentInfo createTy      = " + segmentVO.getCreateTy());
		logger.debug("insertSegmentInfo mergeKey      = " + segmentVO.getMergeKey());
		logger.debug("insertSegmentInfo mergeCol      = " + segmentVO.getMergeCol());
		logger.debug("insertSegmentInfo segFlPath     = " + segmentVO.getSegFlPath());
		logger.debug("insertSegmentInfo srcWhere      = " + segmentVO.getSrcWhere());
		logger.debug("insertSegmentInfo totCnt        = " + segmentVO.getTotCnt());
		logger.debug("insertSegmentInfo selectSql     = " + segmentVO.getSelectSql());
		logger.debug("insertSegmentInfo fromSql       = " + segmentVO.getFromSql());
		logger.debug("insertSegmentInfo whereSql      = " + segmentVO.getWhereSql());
		logger.debug("insertSegmentInfo orderbySql    = " + segmentVO.getOrderbySql());
		logger.debug("insertSegmentInfo query         = " + segmentVO.getQuery());
		logger.debug("insertSegmentInfo separatorChar = " + segmentVO.getSeparatorChar());
		
		int result = 0;
		
		if(segmentVO.getUserId() == null || "".equals(segmentVO.getUserId())) {
			segmentVO.setUserId((String)session.getAttribute("NEO_USER_ID"));
		}
		segmentVO.setRegId((String)session.getAttribute("NEO_USER_ID"));
		segmentVO.setRegDt(StringUtil.getDate(Code.TM_YMDHMS));
		segmentVO.setStatus("000");
		
		try {
			result = segmentService.insertSegmentInfo(segmentVO);
		} catch(Exception e) {
			logger.error("segmentService.insertSegmentInfo Error = " + e);
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
	
	@RequestMapping(value="/segToolAddP")
	public String goSegToolAdd(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegToolAdd createTy = " + searchVO.getCreateTy());
		String createTy =  searchVO.getCreateTy()==null||"".equals(searchVO.getCreateTy())?"000":searchVO.getCreateTy();
		
		// DB Connection 목록 조회
		DbConnVO dbConnVO = new DbConnVO();
		dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		dbConnVO.setAdminYn((String)session.getAttribute("NEO_ADMIN_YN"));
		dbConnVO.setUserId((String)session.getAttribute("NEO_USER_ID"));
		List<DbConnVO> dbConnList = null;
		try {
			dbConnList = segmentService.getDbConnList(dbConnVO);
		} catch(Exception e) {
			logger.error("segmentService.getDbConnList error = " + e);
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
		
		int dbConnNo = 0;
		if(searchVO.getDbConnNo() == 0) {
			if(dbConnList != null && dbConnList.size() > 0) {
				dbConnNo = ((DbConnVO)dbConnList.get(0)).getDbConnNo();
			}
		} else {
			dbConnNo = searchVO.getDbConnNo();
		}

		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		DbConnVO metaDbConn = new DbConnVO();
		metaDbConn.setDbConnNo(dbConnNo);
		try {
			metaTableList = systemService.getMetaTableList(metaDbConn);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("createTy", createTy);			// 생성 유형
		model.addAttribute("dbConnList", dbConnList);		// DB연결 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("metaTableList", metaTableList);	// 메타테이블 목록
		
		return "ems/seg/segToolAddP";
	}
	
	@RequestMapping(value="/segMetaFrameP")
	public String goSegMetaFrame(@ModelAttribute MetaColumnVO columnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegMetaFrame dbConnNo = " + columnVO.getDbConnNo());
		logger.debug("goSegMetaFrame tblNo = " + columnVO.getTblNo());
		
		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		DbConnVO connVO = new DbConnVO();
		connVO.setDbConnNo( columnVO.getDbConnNo());
		try {
			metaTableList = systemService.getMetaTableList(connVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableList error = " + e);
		}
		
		// 메타 컬럼 목록 조회
		List<MetaColumnVO> metaColumnList = null;
		try {
			metaColumnList = systemService.getMetaColumnList(columnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaColumnList error = " + e);
		}

		model.addAttribute("metaTableList", metaTableList);
		model.addAttribute("metaColumnList", metaColumnList);
		
		return "ems/seg/segMetaFrameP";
	}
	
	
	
}
