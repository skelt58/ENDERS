/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 부서 정보 VO
 */
package kr.co.enders.ums.ems.sys.vo;

import kr.co.enders.ums.com.vo.CommonVO;

public class DeptVO extends CommonVO {
	private int deptNo;			// 부서코드,부서번호
	private String deptNm;		// 부서명
	private String deptDesc;	// 부서설명
	private String status;		// 상태코드
	private String statusNm;	// 상태명
	private String regId;		// 등록자
	private String regDt;		// 등록일시
	private String upId;		// 수정자
	private String upDt;		// 수정일시
	
	// 검색
	private String searchDeptNm;	// 검색부서명
	private String searchStatus;	// 검색상태코드
	private String uilang;			// 언어권
	private int userDeptNo;			// 사용자부서번호
	
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
	public String getDeptDesc() {
		return deptDesc;
	}
	public void setDeptDesc(String deptDesc) {
		this.deptDesc = deptDesc;
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
	public String getSearchDeptNm() {
		return searchDeptNm;
	}
	public void setSearchDeptNm(String searchDeptNm) {
		this.searchDeptNm = searchDeptNm;
	}
	public String getSearchStatus() {
		return searchStatus;
	}
	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
	}
	public String getUilang() {
		return uilang;
	}
	public void setUilang(String uilang) {
		this.uilang = uilang;
	}
	public int getUserDeptNo() {
		return userDeptNo;
	}
	public void setUserDeptNo(int userDeptNo) {
		this.userDeptNo = userDeptNo;
	}
}
