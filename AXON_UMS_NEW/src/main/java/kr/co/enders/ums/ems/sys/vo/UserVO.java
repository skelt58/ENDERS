/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 정보 VO
 */
package kr.co.enders.ums.ems.sys.vo;

import kr.co.enders.ums.com.vo.CommonVO;

public class UserVO extends CommonVO {
	/*
		  F.CD_NM UILANG_NM
	 */
	
	private String userId;		// 아이디
	private String userPwd;		// 비밀번호
	private String userEm;		// 이메일
	private String userTel;		// 연락처
	private String userDesc;	// 사용자설명
	private String userNm;		// 사용자이름
	private int deptNo;			// 부서번호
	private String deptNm;		// 부서명
	private String status;		// 상태(000:정상, 001:사용중지, 002:삭제)
	private String statusNm;	// 상태명
	private String returnEm;	// Return이메일
	private String replyToEm;	// 회신이메일
	private String mailFromEm;	// 발송자이메일
	private String mailFromNm;	// 발송자명
	private String charset;		// 문자셋
	private String charsetNm;	// 문자셋명
	private String tzCd;		// 타임존
	private String tzNm;		// 타임존명
	private String tzTerm;		// 시간차
	private String uilang;		// UI언어권
	private String uilangNm;	// UI언어권명
	private String regId;		// 등록자
	private String regDt;		// 등록일자
	private String upId;		// 수정자
	private String upDt;		// 수정일자
	private String font;		// 폰트
	
	// 프로그램을 위해 추가
	private int selDeptNo;	// 콤보박스 부서번호
	private String progId;		// 프로그램ID
	private String userStatus;	// 사용자상태
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPwd() {
		return userPwd;
	}
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}
	public String getUserEm() {
		return userEm;
	}
	public void setUserEm(String userEm) {
		this.userEm = userEm;
	}
	public String getStatusNm() {
		return statusNm;
	}
	public void setStatusNm(String statusNm) {
		this.statusNm = statusNm;
	}
	public String getUserTel() {
		return userTel;
	}
	public void setUserTel(String userTel) {
		this.userTel = userTel;
	}
	public String getUserDesc() {
		return userDesc;
	}
	public void setUserDesc(String userDesc) {
		this.userDesc = userDesc;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getReturnEm() {
		return returnEm;
	}
	public void setReturnEm(String returnEm) {
		this.returnEm = returnEm;
	}
	public String getReplyToEm() {
		return replyToEm;
	}
	public void setReplyToEm(String replyToEm) {
		this.replyToEm = replyToEm;
	}
	public String getMailFromEm() {
		return mailFromEm;
	}
	public void setMailFromEm(String mailFromEm) {
		this.mailFromEm = mailFromEm;
	}
	public String getMailFromNm() {
		return mailFromNm;
	}
	public void setMailFromNm(String mailFromNm) {
		this.mailFromNm = mailFromNm;
	}
	public String getCharset() {
		return charset;
	}
	public void setCharset(String charset) {
		this.charset = charset;
	}
	public String getCharsetNm() {
		return charsetNm;
	}
	public void setCharsetNm(String charsetNm) {
		this.charsetNm = charsetNm;
	}
	public String getTzCd() {
		return tzCd;
	}
	public void setTzCd(String tzCd) {
		this.tzCd = tzCd;
	}
	public String getTzNm() {
		return tzNm;
	}
	public void setTzNm(String tzNm) {
		this.tzNm = tzNm;
	}
	public String getTzTerm() {
		return tzTerm;
	}
	public void setTzTerm(String tzTerm) {
		this.tzTerm = tzTerm;
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
	public String getFont() {
		return font;
	}
	public void setFont(String font) {
		this.font = font;
	}
	public int getSelDeptNo() {
		return selDeptNo;
	}
	public void setSelDeptNo(int selDeptNo) {
		this.selDeptNo = selDeptNo;
	}
	public String getProgId() {
		return progId;
	}
	public void setProgId(String progId) {
		this.progId = progId;
	}
	public String getUserStatus() {
		return userStatus;
	}
	public void setUserStatus(String userStatus) {
		this.userStatus = userStatus;
	}
}
