package kr.co.enders.ums.ems.sys.vo;

import java.io.Serializable;

public class UserProgVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private int progId;			// 프로그램아이디
	private String progNm;		// 프로그램명
	private String userId;		// 사용자아이디
	private String userNm;		// 사용자명
	
	private String progTarget;	// 프로그램대상
	private String progDomain;	// 프로그램도메인
	private String progScript;	// 수행스크립트
	
	public int getProgId() {
		return progId;
	}
	public void setProgId(int progId) {
		this.progId = progId;
	}
	public String getProgNm() {
		return progNm;
	}
	public void setProgNm(String progNm) {
		this.progNm = progNm;
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
	public String getProgTarget() {
		return progTarget;
	}
	public void setProgTarget(String progTarget) {
		this.progTarget = progTarget;
	}
	public String getProgDomain() {
		return progDomain;
	}
	public void setProgDomain(String progDomain) {
		this.progDomain = progDomain;
	}
	public String getProgScript() {
		return progScript;
	}
	public void setProgScript(String progScript) {
		this.progScript = progScript;
	}
}
