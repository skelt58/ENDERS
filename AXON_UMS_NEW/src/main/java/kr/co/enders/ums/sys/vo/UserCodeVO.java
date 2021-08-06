/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.16
 * 설명 : 캠페인 목적관리(코드) VO
 */
package kr.co.enders.ums.sys.vo;

public class UserCodeVO {
	private String cdGrp;		// 코드그룹
	private String cdGrpNm;		// 코드그룹명
	private String cd;			// 코드
	private String cdNm;		// 코드명
	private String uilang;		// 언어권
	private String uilangNm;	// 언어권명
	private String cdDtl;		// 코드설명
	private String useYn;		// 사용여부
	
	public String getCdGrp() {
		return cdGrp;
	}
	public void setCdGrp(String cdGrp) {
		this.cdGrp = cdGrp;
	}
	public String getCdGrpNm() {
		return cdGrpNm;
	}
	public void setCdGrpNm(String cdGrpNm) {
		this.cdGrpNm = cdGrpNm;
	}
	public String getCd() {
		return cd;
	}
	public void setCd(String cd) {
		this.cd = cd;
	}
	public String getCdNm() {
		return cdNm;
	}
	public void setCdNm(String cdNm) {
		this.cdNm = cdNm;
	}
	public String getUilang() {
		return uilang;
	}
	public void setUilang(String uilang) {
		this.uilang = uilang;
	}
	public String getUilangNm() {
		return uilangNm;
	}
	public void setUilangNm(String uilangNm) {
		this.uilangNm = uilangNm;
	}
	public String getCdDtl() {
		return cdDtl;
	}
	public void setCdDtl(String cdDtl) {
		this.cdDtl = cdDtl;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
}
