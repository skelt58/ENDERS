/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.16
 * 설명 : 캠페인 목적관리(코드) VO ==> 사용자에 의한 코드 관리 VO
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : sys.vo -->sys.cod.vo 
 */
package kr.co.enders.ums.sys.cod.vo;

import kr.co.enders.ums.com.vo.CommonVO;

public class UserCodeVO extends CommonVO {
	private String cdGrp;		// 코드그룹
	private String cdGrpNm;		// 코드그룹명
	private String cd;			// 코드
	private String cdNm;		// 코드명
	private String uilang;		// 언어권
	private String uilangNm;	// 언어권명
	private String cdDtl;		// 코드설명
	private String cdNmShort;	// 코드약어
	private String useYn;		// 사용여부
	private String upCd;		// 상위코드
	private String upCdNm;		// 상위코드명
	
	// 검색
	private String searchCdGrpNm;	// 코드그룹명 검색
	private String searchCdGrp;		// 코드그룹 검색
	private String searchUiLang;	// 언어 검색
	
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
	public String getCdNmShort() {
		return cdNmShort;
	}
	public void setCdNmShort(String cdNmShort) {
		this.cdNmShort = cdNmShort;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getUpCd() {
		return upCd;
	}
	public void setUpCd(String upCd) {
		this.upCd = upCd;
	}
	public String getUpCdNm() {
		return upCdNm;
	}
	public void setUpCdNm(String upCdNm) {
		this.upCdNm = upCdNm;
	}
	public String getSearchCdGrpNm() {
		return searchCdGrpNm;
	}
	public void setSearchCdGrpNm(String searchCdGrpNm) {
		this.searchCdGrpNm = searchCdGrpNm;
	}
	public String getSearchCdGrp() {
		return searchCdGrp;
	}
	public void setSearchCdGrp(String searchCdGrp) {
		this.searchCdGrp = searchCdGrp;
	}
	public String getSearchUiLang() {
		return searchUiLang;
	}
	public void setSearchUiLang(String searchUiLang) {
		this.searchUiLang = searchUiLang;
	}
}
