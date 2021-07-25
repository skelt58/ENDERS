/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.19
 * 설명 : 파일다운로드 VO
 */
package kr.co.enders.ums.com.vo;

public class DownloadVO {
	private String divVal;
	private int seqNo;				// 순번
	private String downType;		// 다운로드 유형
	private String tempFlPath;		// 임시파일경로명
	private String segFlPath;		// 실제파일경로명
	public String getDivVal() {
		return divVal;
	}
	public void setDivVal(String divVal) {
		this.divVal = divVal;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public String getDownType() {
		return downType;
	}
	public void setDownType(String downType) {
		this.downType = downType;
	}
	public String getTempFlPath() {
		return tempFlPath;
	}
	public void setTempFlPath(String tempFlPath) {
		this.tempFlPath = tempFlPath;
	}
	public String getSegFlPath() {
		return segFlPath;
	}
	public void setSegFlPath(String segFlPath) {
		this.segFlPath = segFlPath;
	}
}
