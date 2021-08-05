/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.03
 * 설명 : 발송로그 VO
 */
package kr.co.enders.ums.ems.ana.vo;

import java.util.HashMap;
import java.util.List;

import kr.co.enders.ums.com.vo.CommonVO;

public class SendLogVO extends CommonVO {
	private int taskNo;		// 주업무번호
	private int subTaskNo;	// 보조업무번호
	private String step1;	// 1단계
	private String step2;	// 2단계
	private String step3;	// 3단계
	private String domain;	// 도메인
	
	private int campNo;
	private String campty;
	private String custDomain;
	private String custEm;
	private String custId;
	private String custNm;
	private String day;
	private String deniedType;
	private int deptNo;
	private String deptNm;
	private String domainCd;
	private String hour;
	private String month;
	private String year;
	private String rcodeStep1;
	private String rcodeStep2;
	private String rcodeStep3;
	private int retryCnt;
	private int sendAmt;
	private String sendDt;
	private String sendMsg;
	private String sendRcode;
	private String openDt;
	private String targetGrpTy;
	private String userId;
	private String userNm;
	
	private String sendTime;
	private int sendCnt;
	private int succCnt;
	
	// 검색
	private String searchCustId;
	private String searchCustNm;
	private String searchCustEm;
	private String searchKind;
	private String taskNos;
	private String subTaskNos;
	private List<HashMap<String, Integer>> mergeList;
	
	public int getTaskNo() {
		return taskNo;
	}
	public void setTaskNo(int taskNo) {
		this.taskNo = taskNo;
	}
	public int getSubTaskNo() {
		return subTaskNo;
	}
	public void setSubTaskNo(int subTaskNo) {
		this.subTaskNo = subTaskNo;
	}
	public String getStep1() {
		return step1;
	}
	public void setStep1(String step1) {
		this.step1 = step1;
	}
	public String getStep2() {
		return step2;
	}
	public void setStep2(String step2) {
		this.step2 = step2;
	}
	public String getStep3() {
		return step3;
	}
	public void setStep3(String step3) {
		this.step3 = step3;
	}
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
	public int getCampNo() {
		return campNo;
	}
	public void setCampNo(int campNo) {
		this.campNo = campNo;
	}
	public String getCampty() {
		return campty;
	}
	public void setCampty(String campty) {
		this.campty = campty;
	}
	public String getCustDomain() {
		return custDomain;
	}
	public void setCustDomain(String custDomain) {
		this.custDomain = custDomain;
	}
	public String getCustEm() {
		return custEm;
	}
	public void setCustEm(String custEm) {
		this.custEm = custEm;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getCustNm() {
		return custNm;
	}
	public void setCustNm(String custNm) {
		this.custNm = custNm;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getDeniedType() {
		return deniedType;
	}
	public void setDeniedType(String deniedType) {
		this.deniedType = deniedType;
	}
	public int getDeptNo() {
		return deptNo;
	}
	public void setDeptNo(int deptNo) {
		this.deptNo = deptNo;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getDomainCd() {
		return domainCd;
	}
	public void setDomainCd(String domainCd) {
		this.domainCd = domainCd;
	}
	public String getHour() {
		return hour;
	}
	public void setHour(String hour) {
		this.hour = hour;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getRcodeStep1() {
		return rcodeStep1;
	}
	public void setRcodeStep1(String rcodeStep1) {
		this.rcodeStep1 = rcodeStep1;
	}
	public String getRcodeStep2() {
		return rcodeStep2;
	}
	public void setRcodeStep2(String rcodeStep2) {
		this.rcodeStep2 = rcodeStep2;
	}
	public String getRcodeStep3() {
		return rcodeStep3;
	}
	public void setRcodeStep3(String rcodeStep3) {
		this.rcodeStep3 = rcodeStep3;
	}
	public int getRetryCnt() {
		return retryCnt;
	}
	public void setRetryCnt(int retryCnt) {
		this.retryCnt = retryCnt;
	}
	public int getSendAmt() {
		return sendAmt;
	}
	public void setSendAmt(int sendAmt) {
		this.sendAmt = sendAmt;
	}
	public String getSendDt() {
		return sendDt;
	}
	public void setSendDt(String sendDt) {
		this.sendDt = sendDt;
	}
	public String getSendMsg() {
		return sendMsg;
	}
	public void setSendMsg(String sendMsg) {
		this.sendMsg = sendMsg;
	}
	public String getSendRcode() {
		return sendRcode;
	}
	public void setSendRcode(String sendRcode) {
		this.sendRcode = sendRcode;
	}
	public String getTargetGrpTy() {
		return targetGrpTy;
	}
	public void setTargetGrpTy(String targetGrpTy) {
		this.targetGrpTy = targetGrpTy;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getSendTime() {
		return sendTime;
	}
	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}
	public int getSendCnt() {
		return sendCnt;
	}
	public void setSendCnt(int sendCnt) {
		this.sendCnt = sendCnt;
	}
	public int getSuccCnt() {
		return succCnt;
	}
	public void setSuccCnt(int succCnt) {
		this.succCnt = succCnt;
	}
	public String getOpenDt() {
		return openDt;
	}
	public void setOpenDt(String openDt) {
		this.openDt = openDt;
	}
	public String getSearchCustId() {
		return searchCustId;
	}
	public void setSearchCustId(String searchCustId) {
		this.searchCustId = searchCustId;
	}
	public String getSearchCustNm() {
		return searchCustNm;
	}
	public void setSearchCustNm(String searchCustNm) {
		this.searchCustNm = searchCustNm;
	}
	public String getSearchCustEm() {
		return searchCustEm;
	}
	public void setSearchCustEm(String searchCustEm) {
		this.searchCustEm = searchCustEm;
	}
	public String getSearchKind() {
		return searchKind;
	}
	public void setSearchKind(String searchKind) {
		this.searchKind = searchKind;
	}
	public String getTaskNos() {
		return taskNos;
	}
	public void setTaskNos(String taskNos) {
		this.taskNos = taskNos;
	}
	public String getSubTaskNos() {
		return subTaskNos;
	}
	public void setSubTaskNos(String subTaskNos) {
		this.subTaskNos = subTaskNos;
	}
	public List<HashMap<String, Integer>> getMergeList() {
		return mergeList;
	}
	public void setMergeList(List<HashMap<String, Integer>> mergeList) {
		this.mergeList = mergeList;
	}
}