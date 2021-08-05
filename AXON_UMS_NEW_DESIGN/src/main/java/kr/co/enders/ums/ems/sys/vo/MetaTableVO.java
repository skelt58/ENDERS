/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.13
 * 설명 : 메타 테이블 VO
 */
package kr.co.enders.ums.ems.sys.vo;

public class MetaTableVO {
	private int tblNo;			// 테이블번호
	private String tblNm;		// 테이블이름
	private String tblDesc;		// 테이블설명
	private int dbConnNo;		// DB Connection 번호
	private String tblAlias;	// Table Alias
	
	public int getTblNo() {
		return tblNo;
	}
	public void setTblNo(int tblNo) {
		this.tblNo = tblNo;
	}
	public String getTblNm() {
		return tblNm;
	}
	public void setTblNm(String tblNm) {
		this.tblNm = tblNm;
	}
	public String getTblDesc() {
		return tblDesc;
	}
	public void setTblDesc(String tblDesc) {
		this.tblDesc = tblDesc;
	}
	public int getDbConnNo() {
		return dbConnNo;
	}
	public void setDbConnNo(int dbConnNo) {
		this.dbConnNo = dbConnNo;
	}
	public String getTblAlias() {
		return tblAlias;
	}
	public void setTblAlias(String tblAlias) {
		this.tblAlias = tblAlias;
	}
}
