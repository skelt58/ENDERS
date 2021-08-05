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
}
