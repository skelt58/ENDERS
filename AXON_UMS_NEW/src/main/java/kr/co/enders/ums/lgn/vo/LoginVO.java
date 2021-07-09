/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 로그인 VO
 */
package kr.co.enders.ums.lgn.vo;

public class LoginVO {
	private String pUserId;
	private String pUserPwd;
	public String getpUserId() {
		return pUserId;
	}
	public void setpUserId(String pUserId) {
		this.pUserId = pUserId;
	}
	public String getpUserPwd() {
		return pUserPwd;
	}
	public void setpUserPwd(String pUserPwd) {
		this.pUserPwd = pUserPwd;
	}
}
