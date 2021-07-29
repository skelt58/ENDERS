/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 메일 Task VO
 */
package kr.co.enders.ums.ems.cam.vo;

import java.util.List;

import kr.co.enders.ums.com.vo.CommonVO;

public class TaskVO extends CommonVO {
	private int taskNo;
	private String taskNm;
	private int subTaskNo;
	private String mailTitle;
	private String mailFromNm;
	private String mailFromEm;
	private String replyToEm;
	private String returnEm;
	private String exeUserId;
	private int deptNo;
	private String deptNm;
	private String userId;
	private int attCnt;
	private String sendDt;
	private String sendRepeat;
	private String sendRepeatNm;
	private String sendTermLoop;
	private String sendTermLoopTy;
	private String sendTermEndDt;
	private String workStatus;
	private String workStatusNm;
	private String workStatusDtl;
	private int respLog;
	private int socketTimeout;
	private int connPerCnt;
	private int retryCnt;
	private String sendMode;
	private int dbConnNo;
	private int segNo;
	private String segNoc;		// 번호가 캐릭터로 사용되는경우 segno + mergekey
	private String segNm;
	private String selectSql;
	private String fromSql;
	private String whereSql;
	private String oderbySql;
	private String mergeKey;
	private String mergeCol;
	private String segFlPath;
	private String headerEnc;
	private String bodyEnc;
	private String charset;
	private int campNo;
	private String campNm;
	private String campTy;
	private String status;
	private String statusNm;
	private String subStatus;
	private String subStatusNm;
	private int sendUnitCost;
	private String contFlPath;
	private String contTy;
	private String planUserId;
	private String channel;
	private String recoStatus;
	private String idMerge;
	private String nmMerge;
	private String respYn;
	private String linkYn;
	private int surveyno;
	private String targetGrpTy;
	private String regId;
	private String regDt;
	private String upId;
	private String upDt;
	
	private String sendYmd;
	private String sendHour;
	private String sendMin;
	private String isSendTerm;
	private String respEndDt;
	
	//첨부파일
	private String attachNm;
	private String attachPath;
	
	// 추가정보
	private int searchDeptNo;
	private String searchUserId;
	private String searchStartDt;
	private String searchEndDt;
	private String searchTaskNm;
	private int searchCampNo;
	private String searchStatus;
	private String searchWorkStatus;
	private List<String> searchWorkStatusList;
	private String adminYn;
	private String uilang;
	private String composerValue;
	private String campInfo;
	
	public int getTaskNo() {
		return taskNo;
	}
	public void setTaskNo(int taskNo) {
		this.taskNo = taskNo;
	}
	public String getTaskNm() {
		return taskNm;
	}
	public void setTaskNm(String taskNm) {
		this.taskNm = taskNm;
	}
	public int getSubTaskNo() {
		return subTaskNo;
	}
	public void setSubTaskNo(int subTaskNo) {
		this.subTaskNo = subTaskNo;
	}
	public String getMailTitle() {
		return mailTitle;
	}
	public void setMailTitle(String mailTitle) {
		this.mailTitle = mailTitle;
	}
	public String getMailFromNm() {
		return mailFromNm;
	}
	public void setMailFromNm(String mailFromNm) {
		this.mailFromNm = mailFromNm;
	}
	public String getMailFromEm() {
		return mailFromEm;
	}
	public void setMailFromEm(String mailFromEm) {
		this.mailFromEm = mailFromEm;
	}
	public String getReplyToEm() {
		return replyToEm;
	}
	public void setReplyToEm(String replyToEm) {
		this.replyToEm = replyToEm;
	}
	public String getReturnEm() {
		return returnEm;
	}
	public void setReturnEm(String returnEm) {
		this.returnEm = returnEm;
	}
	public String getExeUserId() {
		return exeUserId;
	}
	public void setExeUserId(String exeUserId) {
		this.exeUserId = exeUserId;
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
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getAttCnt() {
		return attCnt;
	}
	public void setAttCnt(int attCnt) {
		this.attCnt = attCnt;
	}
	public String getSendDt() {
		return sendDt;
	}
	public void setSendDt(String sendDt) {
		this.sendDt = sendDt;
	}
	public String getSendRepeat() {
		return sendRepeat;
	}
	public void setSendRepeat(String sendRepeat) {
		this.sendRepeat = sendRepeat;
	}
	public String getSendRepeatNm() {
		return sendRepeatNm;
	}
	public void setSendRepeatNm(String sendRepeatNm) {
		this.sendRepeatNm = sendRepeatNm;
	}
	public String getSendTermLoop() {
		return sendTermLoop;
	}
	public void setSendTermLoop(String sendTermLoop) {
		this.sendTermLoop = sendTermLoop;
	}
	public String getSendTermLoopTy() {
		return sendTermLoopTy;
	}
	public void setSendTermLoopTy(String sendTermLoopTy) {
		this.sendTermLoopTy = sendTermLoopTy;
	}
	public String getSendTermEndDt() {
		return sendTermEndDt;
	}
	public void setSendTermEndDt(String sendTermEndDt) {
		this.sendTermEndDt = sendTermEndDt;
	}
	public String getWorkStatus() {
		return workStatus;
	}
	public void setWorkStatus(String workStatus) {
		this.workStatus = workStatus;
	}
	public String getWorkStatusNm() {
		return workStatusNm;
	}
	public void setWorkStatusNm(String workStatusNm) {
		this.workStatusNm = workStatusNm;
	}
	public String getWorkStatusDtl() {
		return workStatusDtl;
	}
	public void setWorkStatusDtl(String workStatusDtl) {
		this.workStatusDtl = workStatusDtl;
	}
	public int getRespLog() {
		return respLog;
	}
	public void setRespLog(int respLog) {
		this.respLog = respLog;
	}
	public int getSocketTimeout() {
		return socketTimeout;
	}
	public void setSocketTimeout(int socketTimeout) {
		this.socketTimeout = socketTimeout;
	}
	public int getConnPerCnt() {
		return connPerCnt;
	}
	public void setConnPerCnt(int connPerCnt) {
		this.connPerCnt = connPerCnt;
	}
	public int getRetryCnt() {
		return retryCnt;
	}
	public void setRetryCnt(int retryCnt) {
		this.retryCnt = retryCnt;
	}
	public String getSendMode() {
		return sendMode;
	}
	public void setSendMode(String sendMode) {
		this.sendMode = sendMode;
	}
	public int getDbConnNo() {
		return dbConnNo;
	}
	public void setDbConnNo(int dbConnNo) {
		this.dbConnNo = dbConnNo;
	}
	public int getSegNo() {
		return segNo;
	}
	public void setSegNo(int segNo) {
		this.segNo = segNo;
	}
	public String getSegNoc() {
		return segNoc;
	}
	public void setSegNoc(String segNoc) {
		this.segNoc = segNoc;
	}
	public String getSegNm() {
		return segNm;
	}
	public void setSegNm(String segNm) {
		this.segNm = segNm;
	}
	public String getSelectSql() {
		return selectSql;
	}
	public void setSelectSql(String selectSql) {
		this.selectSql = selectSql;
	}
	public String getFromSql() {
		return fromSql;
	}
	public void setFromSql(String fromSql) {
		this.fromSql = fromSql;
	}
	public String getWhereSql() {
		return whereSql;
	}
	public void setWhereSql(String whereSql) {
		this.whereSql = whereSql;
	}
	public String getOderbySql() {
		return oderbySql;
	}
	public void setOderbySql(String oderbySql) {
		this.oderbySql = oderbySql;
	}
	public String getMergeKey() {
		return mergeKey;
	}
	public void setMergeKey(String mergeKey) {
		this.mergeKey = mergeKey;
	}
	public String getMergeCol() {
		return mergeCol;
	}
	public void setMergeCol(String mergeCol) {
		this.mergeCol = mergeCol;
	}
	public String getSegFlPath() {
		return segFlPath;
	}
	public void setSegFlPath(String segFlPath) {
		this.segFlPath = segFlPath;
	}
	public String getHeaderEnc() {
		return headerEnc;
	}
	public void setHeaderEnc(String headerEnc) {
		this.headerEnc = headerEnc;
	}
	public String getBodyEnc() {
		return bodyEnc;
	}
	public void setBodyEnc(String bodyEnc) {
		this.bodyEnc = bodyEnc;
	}
	public String getCharset() {
		return charset;
	}
	public void setCharset(String charset) {
		this.charset = charset;
	}
	public int getCampNo() {
		return campNo;
	}
	public void setCampNo(int campNo) {
		this.campNo = campNo;
	}
	public String getCampNm() {
		return campNm;
	}
	public void setCampNm(String campNm) {
		this.campNm = campNm;
	}
	public String getCampTy() {
		return campTy;
	}
	public void setCampTy(String campTy) {
		this.campTy = campTy;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatusNm() {
		return statusNm;
	}
	public void setStatusNm(String statusNm) {
		this.statusNm = statusNm;
	}
	public String getSubStatus() {
		return subStatus;
	}
	public void setSubStatus(String subStatus) {
		this.subStatus = subStatus;
	}
	public String getSubStatusNm() {
		return subStatusNm;
	}
	public void setSubStatusNm(String subStatusNm) {
		this.subStatusNm = subStatusNm;
	}
	public int getSendUnitCost() {
		return sendUnitCost;
	}
	public void setSendUnitCost(int sendUnitCost) {
		this.sendUnitCost = sendUnitCost;
	}
	public String getContFlPath() {
		return contFlPath;
	}
	public void setContFlPath(String contFlPath) {
		this.contFlPath = contFlPath;
	}
	public String getContTy() {
		return contTy;
	}
	public void setContTy(String contTy) {
		this.contTy = contTy;
	}
	public String getPlanUserId() {
		return planUserId;
	}
	public void setPlanUserId(String planUserId) {
		this.planUserId = planUserId;
	}
	public String getChannel() {
		return channel;
	}
	public void setChannel(String channel) {
		this.channel = channel;
	}
	public String getRecoStatus() {
		return recoStatus;
	}
	public void setRecoStatus(String recoStatus) {
		this.recoStatus = recoStatus;
	}
	public String getIdMerge() {
		return idMerge;
	}
	public void setIdMerge(String idMerge) {
		this.idMerge = idMerge;
	}
	public String getNmMerge() {
		return nmMerge;
	}
	public void setNmMerge(String nmMerge) {
		this.nmMerge = nmMerge;
	}
	public String getRespYn() {
		return respYn;
	}
	public void setRespYn(String respYn) {
		this.respYn = respYn;
	}
	public String getLinkYn() {
		return linkYn;
	}
	public void setLinkYn(String linkYn) {
		this.linkYn = linkYn;
	}
	public int getSurveyno() {
		return surveyno;
	}
	public void setSurveyno(int surveyno) {
		this.surveyno = surveyno;
	}
	public String getTargetGrpTy() {
		return targetGrpTy;
	}
	public void setTargetGrpTy(String targetGrpTy) {
		this.targetGrpTy = targetGrpTy;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public String getRegDt() {
		return regDt;
	}
	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}
	public String getUpId() {
		return upId;
	}
	public void setUpId(String upId) {
		this.upId = upId;
	}
	public String getUpDt() {
		return upDt;
	}
	public void setUpDt(String upDt) {
		this.upDt = upDt;
	}
	public String getUilang() {
		return uilang;
	}
	public void setUilang(String uilang) {
		this.uilang = uilang;
	}
	public int getSearchDeptNo() {
		return searchDeptNo;
	}
	public void setSearchDeptNo(int searchDeptNo) {
		this.searchDeptNo = searchDeptNo;
	}
	public String getSearchUserId() {
		return searchUserId;
	}
	public void setSearchUserId(String searchUserId) {
		this.searchUserId = searchUserId;
	}
	public String getSearchStartDt() {
		return searchStartDt;
	}
	public void setSearchStartDt(String searchStartDt) {
		this.searchStartDt = searchStartDt;
	}
	public String getSearchEndDt() {
		return searchEndDt;
	}
	public void setSearchEndDt(String searchEndDt) {
		this.searchEndDt = searchEndDt;
	}
	public String getSearchTaskNm() {
		return searchTaskNm;
	}
	public void setSearchTaskNm(String searchTaskNm) {
		this.searchTaskNm = searchTaskNm;
	}
	public int getSearchCampNo() {
		return searchCampNo;
	}
	public void setSearchCampNo(int searchCampNo) {
		this.searchCampNo = searchCampNo;
	}
	public String getSearchStatus() {
		return searchStatus;
	}
	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
	}
	public String getSearchWorkStatus() {
		return searchWorkStatus;
	}
	public void setSearchWorkStatus(String searchWorkStatus) {
		this.searchWorkStatus = searchWorkStatus;
	}
	public List<String> getSearchWorkStatusList() {
		return searchWorkStatusList;
	}
	public void setSearchWorkStatusList(List<String> searchWorkStatusList) {
		this.searchWorkStatusList = searchWorkStatusList;
	}
	public String getAdminYn() {
		return adminYn;
	}
	public void setAdminYn(String adminYn) {
		this.adminYn = adminYn;
	}
	public String getComposerValue() {
		return composerValue;
	}
	public void setComposerValue(String composerValue) {
		this.composerValue = composerValue;
	}
	public String getCampInfo() {
		return campInfo;
	}
	public void setCampInfo(String campInfo) {
		this.campInfo = campInfo;
	}
	public String getAttachNm() {
		return attachNm;
	}
	public void setAttachNm(String attachNm) {
		this.attachNm = attachNm;
	}
	public String getAttachPath() {
		return attachPath;
	}
	public void setAttachPath(String attachPath) {
		this.attachPath = attachPath;
	}
	public String getSendYmd() {
		return sendYmd;
	}
	public void setSendYmd(String sendYmd) {
		this.sendYmd = sendYmd;
	}
	public String getSendHour() {
		return sendHour;
	}
	public void setSendHour(String sendHour) {
		this.sendHour = sendHour;
	}
	public String getSendMin() {
		return sendMin;
	}
	public void setSendMin(String sendMin) {
		this.sendMin = sendMin;
	}
	public String getRespEndDt() {
		return respEndDt;
	}
	public void setRespEndDt(String respEndDt) {
		this.respEndDt = respEndDt;
	}
	public String getIsSendTerm() {
		return isSendTerm;
	}
	public void setIsSendTerm(String isSendTerm) {
		this.isSendTerm = isSendTerm;
	}
}
