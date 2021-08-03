/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.03
 * 설명 : 통계분석 결과요약 VO
 */
package kr.co.enders.ums.ems.ana.vo;

public class MailSummVO {
	
	private int taskNo;		// 주업무번호
	private int subTaskNo;	// 보조업무번호
	private int sendCnt;	// 대상수
	private int succCnt;	// 성공수
	private int failCnt;	// 실패수
	private int openCnt;	// 오픈수
	private int validCnt;	// 유효오픈수
	private int clickCnt;	// 링크클릭수
	private int blockCnt;	// 수신거부수
	
	private String step1;	// 1단계
	private String step2;	// 2단계
	private int cntStep2;	// 2단계수
	private String nmStep2;	// 2단계명
	private String domain;	// 도메인
	
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
	public int getFailCnt() {
		return failCnt;
	}
	public void setFailCnt(int failCnt) {
		this.failCnt = failCnt;
	}
	public int getOpenCnt() {
		return openCnt;
	}
	public void setOpenCnt(int openCnt) {
		this.openCnt = openCnt;
	}
	public int getValidCnt() {
		return validCnt;
	}
	public void setValidCnt(int validCnt) {
		this.validCnt = validCnt;
	}
	public int getClickCnt() {
		return clickCnt;
	}
	public void setClickCnt(int clickCnt) {
		this.clickCnt = clickCnt;
	}
	public int getBlockCnt() {
		return blockCnt;
	}
	public void setBlockCnt(int blockCnt) {
		this.blockCnt = blockCnt;
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
	public int getCntStep2() {
		return cntStep2;
	}
	public void setCntStep2(int cntStep2) {
		this.cntStep2 = cntStep2;
	}
	public String getNmStep2() {
		return nmStep2;
	}
	public void setNmStep2(String nmStep2) {
		this.nmStep2 = nmStep2;
	}
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
}
