/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.14
 * 설명 : 메타 컬럼 VO
 */
package kr.co.enders.ums.ems.sys.vo;

public class MetaColumnVO {
	private int colNo;				// 컬럼번호
	private String colNm;			// 컬럼명
	private String colDataTy;		// 컬럼데이터유형
	private String colDesc;			// 컬럼설명
	private String colDataTyJdbc;	// JDBC 컬럼데이터유형
	private int tblNo;				// 테이블번호
	private String tblNm;			// 테이블명
	private String colAlias;		// 컬럼 별칭
	private String isOper;			// OPER여부
	private String isValue;			// VALUE여부
	
	// 부가정보
	private int dbConnNo;			// DB 연결 번호
	private String mergeCol;		// 머지컬럼
	
	public int getColNo() {
		return colNo;
	}
	public void setColNo(int colNo) {
		this.colNo = colNo;
	}
	public String getColNm() {
		return colNm;
	}
	public void setColNm(String colNm) {
		this.colNm = colNm;
	}
	public String getColDataTy() {
		return colDataTy;
	}
	public void setColDataTy(String colDataTy) {
		this.colDataTy = colDataTy;
	}
	public String getColDesc() {
		return colDesc;
	}
	public void setColDesc(String colDesc) {
		this.colDesc = colDesc;
	}
	public String getColDataTyJdbc() {
		return colDataTyJdbc;
	}
	public void setColDataTyJdbc(String colDataTyJdbc) {
		this.colDataTyJdbc = colDataTyJdbc;
	}
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
	public String getColAlias() {
		return colAlias;
	}
	public void setColAlias(String colAlias) {
		this.colAlias = colAlias;
	}
	public String getIsOper() {
		return isOper;
	}
	public void setIsOper(String isOper) {
		this.isOper = isOper;
	}
	public String getIsValue() {
		return isValue;
	}
	public void setIsValue(String isValue) {
		this.isValue = isValue;
	}
	public int getDbConnNo() {
		return dbConnNo;
	}
	public void setDbConnNo(int dbConnNo) {
		this.dbConnNo = dbConnNo;
	}
	public String getMergeCol() {
		return mergeCol;
	}
	public void setMergeCol(String mergeCol) {
		this.mergeCol = mergeCol;
	}
}
