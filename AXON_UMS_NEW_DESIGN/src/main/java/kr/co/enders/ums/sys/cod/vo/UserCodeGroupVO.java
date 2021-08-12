/*
 * 작성자 : 김준희
 * 작성일시 : 2021.08.10
 * 설명 :  사용자에 의한 코드그룹 관리 VO  
 */
package kr.co.enders.ums.sys.cod.vo;

import kr.co.enders.ums.com.vo.CommonVO;

public class UserCodeGroupVO extends CommonVO {
	private String cdGrp;		// 코드그룹
	private String cdGrpNm;		// 코드그룹명
	private String uilang;			// 언어권	
	private String uilangNm;	// 언어권명
	private String cdGrpDtl;	// 코드그룹설명
	private String useYn;		// 사용여부
	private String sysYn;		// 시스템 코드 여부
	private String upCdGrp;		// 상위코드그룹
	private String upCdGrpNm;	// 상위코드그룹명 
	
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
	public String getCdGrpDtl() {
		return cdGrpDtl;
	}
	public void setCdGrpDtl(String cdGrpDtl) {
		this.cdGrpDtl = cdGrpDtl;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getSysYn() {
		return sysYn;
	}
	public void setSysYn(String sysYn) {
		this.sysYn = sysYn;
	}
	public String getUpCdGrp() {
		return upCdGrp;
	}
	public void setUpCdGrp(String upCdGrp) {
		this.upCdGrp = upCdGrp;
	}
	public String getUpCdGrpNm() {
		return upCdGrpNm;
	}
	public void setUpCdGrpNm(String upCdGrpNm) {
		this.upCdGrpNm = upCdGrpNm;
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
