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
import kr.co.enders.ums.ems.cam.service.CampaignService;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.seg.service.SegmentService;
import kr.co.enders.ums.ems.seg.vo.SegmentMemberVO;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.ems.sys.service.SystemService;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;
import kr.co.enders.ums.ems.sys.vo.MetaJoinVO;
import kr.co.enders.ums.ems.sys.vo.MetaTableVO;
import kr.co.enders.util.Code;
import kr.co.enders.util.DBUtil;
import kr.co.enders.util.EncryptUtil;
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
	
	@Autowired
	private CampaignService campaignService;
	
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
		
		
		// 페이지 설정
		int page = StringUtil.setNullToInt(searchVO.getPage(), 1);
		int rows = StringUtil.setNullToInt(searchVO.getRows(), Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE")));
		searchVO.setPage(page);
		searchVO.setRows(rows);
		int totalCount = 0;
		
		// 발송대상(세그먼트) 목록 조회
		SegmentVO search = searchVO;
		search.setUilang((String)session.getAttribute("NEO_UILANG"));
		search.setSearchStartDt(search.getSearchStartDt().replaceAll("-",""));
		search.setSearchEndDt(search.getSearchEndDt().replaceAll("-", ""));
		List<SegmentVO> segmentList = null;
		try {
			segmentList = segmentService.getSegmentList(search);
		} catch(Exception e) {
			logger.error("segmentService.getSegmentList error = " + e);
		}
		
		if(segmentList != null && segmentList.size() > 0) {
			totalCount = segmentList.get(0).getTotalCount();
		}
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, searchVO.getPage(), totalCount, rows);

		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("createTyList", createTyList);	// 세그먼트 생성 유형
		model.addAttribute("statusList", statusList);		// 발송그룹상태
		model.addAttribute("deptList", deptList);			// 부서번호
		model.addAttribute("userList", userList);			// 사용자
		model.addAttribute("segmentList", segmentList);		// 발송대상(세그먼트) 목록
		model.addAttribute("pageUtil", pageUtil);			// 페이징
		model.addAttribute("uploadPath", properties.getProperty("FILE.UPLOAD_PATH"));	// 업로드경로
		
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
		
		if(!"003".equals(segmentVO.getCreateTy()) && !"002".equals(segmentVO.getCreateTy())) {
			String query = "";
	    	
	    	query = " SELECT " + segmentVO.getSelectSql();
	    	query += " FROM " + segmentVO.getFromSql();
	    	if(!"".equals(segmentVO.getWhereSql())) {
	    		query += " WHERE " + segmentVO.getWhereSql();
	    	}
	    	segmentVO.setQuery(query);
		}
		
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
		logger.debug("goSegToolAdd searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegToolAdd searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegToolAdd searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegToolAdd searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegToolAdd searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegToolAdd searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegToolAdd searchUserId = " + searchVO.getSearchUserId());
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
		
		
		// 페이지 설정
		MetaJoinVO metaJoinVO = new MetaJoinVO();
		metaJoinVO.setPage(1);
		metaJoinVO.setRows(100);
		metaJoinVO.setDbConnNo(dbConnNo);
		metaJoinVO.setUilang((String)session.getAttribute("NEO_UILANG"));

		// 메타 조인 목록 조회
		List<MetaJoinVO> metaJoinList = null;
		try {
			metaJoinList = systemService.getMetaJoinList(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaJoinList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("createTy", createTy);			// 생성 유형
		model.addAttribute("dbConnList", dbConnList);		// DB연결 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("metaTableList", metaTableList);	// 메타테이블 목록
		model.addAttribute("metaJoinList", metaJoinList);	// 메타조인 목록
		
		return "ems/seg/segToolAddP";
	}
	
	@RequestMapping(value="/segToolUpdateP")
	public String goSegToolUpdate(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegToolUpdate segNo = " + searchVO.getSegNo());
		logger.debug("goSegToolUpdate searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegToolUpdate searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegToolUpdate searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegToolUpdate searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegToolUpdate searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegToolUpdate searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegToolUpdate searchUserId = " + searchVO.getSearchUserId());
		logger.debug("goSegToolUpdate createTy = " + searchVO.getCreateTy());
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
		
		
		// 페이지 설정
		MetaJoinVO metaJoinVO = new MetaJoinVO();
		metaJoinVO.setPage(1);
		metaJoinVO.setRows(100);
		metaJoinVO.setDbConnNo(dbConnNo);
		metaJoinVO.setUilang((String)session.getAttribute("NEO_UILANG"));

		// 메타 조인 목록 조회
		List<MetaJoinVO> metaJoinList = null;
		try {
			metaJoinList = systemService.getMetaJoinList(metaJoinVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaJoinList error = " + e);
		}
		
		// 발송대상(세그먼트) 정보 조회
		SegmentVO segmentInfo = null;
		try {
			searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			segmentInfo = segmentService.getSegmentInfo(searchVO);
		} catch(Exception e) {
			logger.error("");
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("createTy", createTy);			// 생성 유형
		model.addAttribute("dbConnList", dbConnList);		// DB연결 목록
		model.addAttribute("deptList", deptList);			// 부서 목록
		model.addAttribute("metaTableList", metaTableList);	// 메타테이블 목록
		model.addAttribute("metaJoinList", metaJoinList);	// 메타조인 목록
		model.addAttribute("segmentInfo", segmentInfo);		// 발송대상(세그먼트) 정보
		
		return "ems/seg/segToolUpdateP";
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
	
	/**
	 * 대상자 수 추출(DB로 조회)
	 * @param segmentVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/segCount")
	public ModelAndView getSegCount(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getSegCount dbConnNo      = " + segmentVO.getDbConnNo());
		logger.debug("getSegCount selectSql     = " + segmentVO.getSelectSql());
		logger.debug("getSegCount fromSql       = " + segmentVO.getFromSql());
		logger.debug("getSegCount whereSql      = " + segmentVO.getWhereSql());
		logger.debug("getSegCount query         = " + segmentVO.getQuery());
		logger.debug("getSegCount createTy      = " + segmentVO.getCreateTy());
		
		int totCnt = 0;
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			DbConnVO searchVO = new DbConnVO();
			searchVO.setDbConnNo(segmentVO.getDbConnNo());
			searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(searchVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 대상자 수 조회
		if(dbConnInfo != null) {
			DBUtil dbUtil = new DBUtil();
			String dbDriver = dbConnInfo.getDbDriver();
			String dbUrl = dbConnInfo.getDbUrl();
			String loginId = dbConnInfo.getLoginId();
			String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
			totCnt = dbUtil.getSegmentCount(dbDriver, dbUrl, loginId, loginPwd, segmentVO);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("totCnt", totCnt);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	@RequestMapping(value="/segInfoP")
	public String goSegInfoPreview(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegInfoPreview segNo         = " + segmentVO.getSegNo());
		logger.debug("goSegInfoPreview dbConnNo      = " + segmentVO.getDbConnNo());
		logger.debug("goSegInfoPreview selectSql     = " + segmentVO.getSelectSql());
		logger.debug("goSegInfoPreview fromSql       = " + segmentVO.getFromSql());
		logger.debug("goSegInfoPreview whereSql      = " + segmentVO.getWhereSql());
		logger.debug("goSegInfoPreview orderbySql    = " + segmentVO.getOrderbySql());
		logger.debug("goSegInfoPreview query         = " + segmentVO.getQuery());
		logger.debug("goSegInfoPreview createTy      = " + segmentVO.getCreateTy());
		logger.debug("goSegInfoPreview mergeKey      = " + segmentVO.getMergeKey());
		logger.debug("goSegInfoPreview mergeCol      = " + segmentVO.getMergeCol());

		model.addAttribute("segmentVO", segmentVO);
		
		if(segmentVO.getSegNo() != 0) {
			try {
				segmentVO.setUilang((String)session.getAttribute("NEO_UILANG"));
				segmentVO = segmentService.getSegmentInfo(segmentVO);
			} catch(Exception e) {
				logger.error("segmentService.getSegmentInfo error = " + e);
			}
		}
		
		model.addAttribute("segmentVO", segmentVO);
		model.addAttribute("uploadPath", properties.getProperty("FILE.UPLOAD_PATH"));	// 업로드경로
		
		return "ems/seg/segInfoP";
	}
	
	@RequestMapping(value="/segDbMemberListP")
	public String getDbMemberList(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegInfoPreview segNo         = " + segmentVO.getSegNo());
		logger.debug("goSegInfoPreview dbConnNo      = " + segmentVO.getDbConnNo());
		logger.debug("goSegInfoPreview selectSql     = " + segmentVO.getSelectSql());
		logger.debug("goSegInfoPreview fromSql       = " + segmentVO.getFromSql());
		logger.debug("goSegInfoPreview whereSql      = " + segmentVO.getWhereSql());
		logger.debug("goSegInfoPreview orderbySql    = " + segmentVO.getOrderbySql());
		logger.debug("goSegInfoPreview query         = " + segmentVO.getQuery());
		logger.debug("goSegInfoPreview createTy      = " + segmentVO.getCreateTy());
		logger.debug("goSegInfoPreview mergeKey      = " + segmentVO.getMergeKey());
		logger.debug("goSegInfoPreview mergeCol      = " + segmentVO.getMergeCol());
		logger.debug("goSegInfoPreview segNo         = " + segmentVO.getPage());

		int pageRow = Integer.parseInt(properties.getProperty("LIST.ROW_PER_PAGE"));
		if(segmentVO.getPage() == 0) segmentVO.setPage(1);
		
		// DB Connection 정보를 조회한다.
		DbConnVO dbConnInfo = null;
		try {
			DbConnVO searchVO = new DbConnVO();
			searchVO.setDbConnNo(segmentVO.getDbConnNo());
			searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(searchVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		SegmentMemberVO memberVO = null;
		List<HashMap<String,String>> memberList = null;
		List<HashMap<String,String>> pageMemberList = new ArrayList<HashMap<String,String>>();
		// 대상자 수 조회
		if(dbConnInfo != null) {
			DBUtil dbUtil = new DBUtil();
			String dbDriver = dbConnInfo.getDbDriver();
			String dbUrl = dbConnInfo.getDbUrl();
			String loginId = dbConnInfo.getLoginId();
			String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
			memberVO = dbUtil.getMemberList(dbDriver, dbUrl, loginId, loginPwd, segmentVO);
		}
		
		int totalCount = 0;
		if(memberVO != null) {
			totalCount = memberVO.getTotalCount();
			memberList = memberVO.getMemberList();
			if(memberList != null && memberList.size() > 0) {
				for(int i=0;i<memberList.size();i++) {
					if(i >= (segmentVO.getPage()-1)*pageRow && i< segmentVO.getPage()*pageRow) { // 페이지별로 size만큼만 저장.
						HashMap<String,String> member = (HashMap<String,String>)memberList.get(i);
						pageMemberList.add(member);
					}
				}
			}
		}
		
		PageUtil pageUtil = new PageUtil();
		pageUtil.init(request, segmentVO.getPage(), totalCount, pageRow);
		
		model.addAttribute("segmentVO", segmentVO);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("memberList", pageMemberList);
		model.addAttribute("pageUtil", pageUtil);
		
		return "ems/seg/segDbMemberListP";
	}
	
	/**
	 * 발송대상(세그먼트) 상태 수정(중지, 삭제...)
	 * @param segmentVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/segDelete")
	public ModelAndView updateSegmentStatus(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("updateSegmentStatus segNo  = " + segmentVO.getSegNo());
		logger.debug("updateSegmentStatus segNos = " + segmentVO.getSegNos());
		logger.debug("updateSegmentStatus status = " + segmentVO.getStatus());
		
		int result = 0;
		
		segmentVO.setUpId((String)session.getAttribute("NEO_USER_ID"));
		segmentVO.setUpDt(StringUtil.getDate(Code.TM_YMDHMS));
		
		try {
			result = segmentService.updateSegmentStatus(segmentVO);
		} catch(Exception e) {
			logger.error("segmentService.updateSegmentStatus Error = " + e);
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
	 * 	 * 직접SQL이용 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/segDirectSQLAddP")
	public String goSegDirectSQLAddP(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegDirectSQLAddP searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegDirectSQLAddP searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegDirectSQLAddP searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegDirectSQLAddP searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegDirectSQLAddP searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegDirectSQLAddP searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegDirectSQLAddP searchUserId = " + searchVO.getSearchUserId());
		logger.debug("goSegDirectSQLAddP createTy = " + searchVO.getCreateTy());
		String createTy =  searchVO.getCreateTy()==null||"".equals(searchVO.getCreateTy())?"002":searchVO.getCreateTy();
		
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
		
		return "ems/seg/segDirectSQLAddP";
	}
	
	/**
	 * 	 * 직접SQL이용 테이블 목록 조회
	 * @param dbConnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metatableListP")
	public String getMetaTableListP(@ModelAttribute DbConnVO dbConnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaTableListP dbConnNo = " + dbConnVO.getDbConnNo());
		
		DbConnVO dbConnInfo = null;
		try {
			dbConnVO.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 목록 조회
		List<String> realTableList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realTableList = dbUtil.getRealTableList(dbTy, dbDriver, dbUrl, loginId, loginPwd);

		// 메타 테이블 목록 조회
		List<MetaTableVO> metaTableList = null;
		try {
			metaTableList = systemService.getMetaTableList(dbConnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaTableList error = " + e);
		}
		
		model.addAttribute("realTableList", realTableList);	// 실제테이블 목록
		model.addAttribute("metaTableList", metaTableList);	// 메타테이블 목록
		
		return "ems/seg/metatableListP";
	}
	
	/**
	 * 직접SQL이용 컬럼 목록 조회
	 * @param metaColumnVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/metacolumnListP")
	public String getMetaColumnListP(@ModelAttribute MetaColumnVO metaColumnVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getMetaColumnListP dbConnNo = " + metaColumnVO.getDbConnNo());
		logger.debug("getMetaColumnListP tblNo    = " + metaColumnVO.getTblNo());
		
		DbConnVO dbConnInfo = new DbConnVO();
		try {
			dbConnInfo.setDbConnNo(metaColumnVO.getDbConnNo());
			dbConnInfo.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnInfo);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 컬럼 목록 조회
		List<MetaColumnVO> realColumnList = null;
		DBUtil dbUtil = new DBUtil();
		String dbTy = dbConnInfo.getDbTy();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		realColumnList = dbUtil.getRealColumnList(dbTy, dbDriver, dbUrl, loginId, loginPwd, metaColumnVO.getTblNm());
		
		// 메타 컬럼 목록 조회
		List<MetaColumnVO> metaColumnList = null;
		try {
			metaColumnList = systemService.getMetaColumnList(metaColumnVO);
		} catch(Exception e) {
			logger.error("systemService.getMetaColumnList error = " + e);
		}
		
		model.addAttribute("realColumnList", realColumnList);	// 실제컬럼 목록
		model.addAttribute("metaColumnList", metaColumnList);	// 메타컬럼 목록
		
		return "ems/seg/metacolumnListP";
	}
	
	/**
	 * SQL TES 실행
	 * @param segmentVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/segDirectSQLTest")
	public ModelAndView goSegDirectSQLTest(@ModelAttribute SegmentVO segmentVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegDirectSQLTest dbConnNo = " + segmentVO.getDbConnNo());
		logger.debug("goSegDirectSQLTest query    = " + segmentVO.getQuery());
		logger.debug("goSegDirectSQLTest testType = " + segmentVO.getTestType());
		
		DbConnVO dbConnInfo = new DbConnVO();
		try {
			dbConnInfo.setDbConnNo(segmentVO.getDbConnNo());
			dbConnInfo.setUilang((String)session.getAttribute("NEO_UILANG"));
			dbConnInfo = systemService.getDbConnInfo(dbConnInfo);
		} catch(Exception e) {
			logger.error("systemService.getDbConnInfo error = " + e);
		}
		
		// 실제 DB 테이블 컬럼 목록 조회
		SegmentMemberVO memberVO = null;
		DBUtil dbUtil = new DBUtil();
		String dbDriver = dbConnInfo.getDbDriver();
		String dbUrl = dbConnInfo.getDbUrl();
		String loginId = dbConnInfo.getLoginId();
		String loginPwd = EncryptUtil.getJasyptDecryptedString(properties.getProperty("JASYPT.ALGORITHM"), properties.getProperty("JASYPT.KEYSTRING"), dbConnInfo.getLoginPwd());
		memberVO = dbUtil.getDirectSqlTest(dbDriver, dbUrl, loginId, loginPwd, segmentVO);

		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(memberVO.isResult()) {
			map.put("result", "Success");
			map.put("mergeKey", memberVO.getMergeKey());
		} else {
			map.put("result", "Fail");
			map.put("message", memberVO.getMessage());
		}
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	/**
	 * 연계서비스지정 화면을 출력한다.
	 * @param searchVO
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/segRemarketAddP")
	public String goSegRemarketAddP(@ModelAttribute SegmentVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegRemarketAddP searchSegNm = " + searchVO.getSearchSegNm());
		logger.debug("goSegRemarketAddP searchCreateTy = " + searchVO.getSearchCreateTy());
		logger.debug("goSegRemarketAddP searchStatus = " + searchVO.getSearchStatus());
		logger.debug("goSegRemarketAddP searchStartDt = " + searchVO.getSearchStartDt());
		logger.debug("goSegRemarketAddP searchEndDt = " + searchVO.getSearchEndDt());
		logger.debug("goSegRemarketAddP searchDeptNo = " + searchVO.getSearchDeptNo());
		logger.debug("goSegRemarketAddP searchUserId = " + searchVO.getSearchUserId());
		
		// 수신자정보머지키 조회
		CodeVO merge = new CodeVO();
		merge.setUilang((String)session.getAttribute("NEO_UILANG"));
		merge.setCdGrp("C001");	// 발송그룹상태
		merge.setUseYn("Y");
		List<CodeVO> mergeKeyList = null;
		try {
			mergeKeyList = codeService.getCodeList(merge);
		} catch(Exception e) {
			logger.error("codeService.getCodeList[C001] error = " + e);
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
		
		model.addAttribute("searchVO", searchVO);			// 검색 항목
		model.addAttribute("mergeKeyList", mergeKeyList);	// 수신자정보머지키 목록
		model.addAttribute("deptList", deptList);			// 부서목록
		
		return "ems/seg/segRemarketAddP";
	}
	
	@RequestMapping(value="/segRemarketMailMainP")
	public String goSegRemarketMailMainP(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		// 검색 기본값 설정
		if(searchVO.getSearchStartDt() == null || "".equals(searchVO.getSearchStartDt())) {
			searchVO.setSearchStartDt(StringUtil.getCalcDateFromCurr(-1, "M", "yyyy-MM-dd"));
		}
		if(searchVO.getSearchEndDt() == null || "".equals(searchVO.getSearchEndDt())) {
			searchVO.setSearchEndDt(StringUtil.getCalcDateFromCurr(0, "D", "yyyy-MM-dd"));
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
		
		// 사용자목록(코드성) 조회
		CodeVO userVO = new CodeVO();
		userVO.setStatus("000"); // 정상
		if("Y".equals((String)session.getAttribute("NEO_ADMIN_YN"))) {
			userVO.setDeptNo(0);
		} else {
			userVO.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		}
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(userVO);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		// 캠페인 목록 조회
		CampaignVO campaignVO = new CampaignVO();
		campaignVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		List<CampaignVO> campaignList = null;
		try {
			campaignList = campaignService.getCampaignList(campaignVO);
		} catch(Exception e) {
			logger.error("campaignService.getCampaignList error = " + e);
		}
		
		model.addAttribute("searchVO", searchVO);			// 검색항목
		model.addAttribute("deptList", deptList);			// 부서목록
		model.addAttribute("userList", userList);			// 사용자목록
		model.addAttribute("campaignList", campaignList);	// 캠페인목록
		
		return "ems/seg/segRemarketMailMainP";
	}
	
	@RequestMapping(value="/segRemarketMailListP")
	public String goSegRemarketMailListP(@ModelAttribute TaskVO searchVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goSegRemarketMailListP searchTaskNm     = " + searchVO.getSearchTaskNm());
		logger.debug("goSegRemarketMailListP searchCampNo     = " + searchVO.getSearchCampNo());
		logger.debug("goSegRemarketMailListP searchDeptNo     = " + searchVO.getSearchDeptNo());
		logger.debug("goSegRemarketMailListP searchUserId     = " + searchVO.getSearchUserId());
		logger.debug("goSegRemarketMailListP searchStatus     = " + searchVO.getSearchStatus());
		logger.debug("goSegRemarketMailListP searchStartDt    = " + searchVO.getSearchStartDt());
		logger.debug("goSegRemarketMailListP searchEndDt      = " + searchVO.getSearchEndDt());
		logger.debug("goSegRemarketMailListP searchWorkStatus = " + searchVO.getSearchWorkStatus());
		
		searchVO.setUilang((String)session.getAttribute("NEO_UILANG"));
		searchVO.setSearchStatus("000");
		searchVO.setSearchWorkStatus("000,001,002,003");
		searchVO.setSearchStartDt(searchVO.getSearchStartDt().replaceAll("-", ""));
		searchVO.setSearchEndDt(searchVO.getSearchEndDt().replaceAll("-", ""));
		List<String> workStatusList = new ArrayList<String>();
		String[] workStatus = searchVO.getSearchWorkStatus().split(",");
		for(int i=0;i<workStatus.length;i++) {
			workStatusList.add(workStatus[i]);
		}
		searchVO.setSearchWorkStatusList(workStatusList);
		
		List<TaskVO> mailList = null;
		try {
			mailList = campaignService.getMailList(searchVO);
		} catch(Exception e) {
			logger.error("campaignService.getMailList error = " + e);
		}
		
		model.addAttribute("mailList", mailList);
		
		return "ems/seg/segRemarketMailListP";
	}
	
	
}
