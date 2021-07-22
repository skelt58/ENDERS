/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : Campaign VO
 */
package kr.co.enders.ums.ems.cam.vo;

import kr.co.enders.ums.com.vo.CommonVO;

public class CampaignVO extends CommonVO {
	private int campNo;			// 캠페인 등록번호
	private String campNm;		// 캠페인명
	private String campTy;		// 캠페인유형
	private String campTyNm;	// 캠페인유형명
	private String campDesc;	// 캠페인설명
	private String status;		// 상태
	private String statusNm;	// 상태명
	private int deptNo;			// 부서번호
	private String deptNm;		// 부서명
	private String userId;		// 사용자아이디
	private String userNm;		// 사용자명
	private String regId;		// 등록자
	private String regNm;		// 등록자명
	private String regDt;		// 등록일자
	private String upId;		// 수정자
	private String upDt;		// 수정일자
	
	//추가정보
	private String uilang;		// 언어권
	
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
	public String getCampTyNm() {
		return campTyNm;
	}
	public void setCampTyNm(String campTyNm) {
		this.campTyNm = campTyNm;
	}
	public String getCampDesc() {
		return campDesc;
	}
	public void setCampDesc(String campDesc) {
		this.campDesc = campDesc;
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
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public String getRegNm() {
		return regNm;
	}
	public void setRegNm(String regNm) {
		this.regNm = regNm;
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
}
