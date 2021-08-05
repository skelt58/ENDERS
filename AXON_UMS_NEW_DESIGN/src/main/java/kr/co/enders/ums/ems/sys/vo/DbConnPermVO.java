/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.12
 * 설명 : DB사용권한 VO
 */
package kr.co.enders.ums.ems.sys.vo;

public class DbConnPermVO {
	private int dbConnNo;		// DB연결 일련번호
	private String dbConnNm;	// DB연결명
	private String userId;		// 사용자ID
	private String userNm;		// 사용자명
	private int deptNo;			// 부서번호
	private String deptNm;		// 부서명
	private String permYn;		// 권한여부
	
	
	public int getDbConnNo() {
		return dbConnNo;
	}
	public void setDbConnNo(int dbConnNo) {
		this.dbConnNo = dbConnNo;
	}
	public String getDbConnNm() {
		return dbConnNm;
	}
	public void setDbConnNm(String dbConnNm) {
		this.dbConnNm = dbConnNm;
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
	public String getPermYn() {
		return permYn;
	}
	public void setPermYn(String permYn) {
		this.permYn = permYn;
	}
}
