/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.30
 * 설명 : 테스트 유저 VO
 */
package kr.co.enders.ums.ems.cam.vo;

public class TestUserVO {
	private int testUserNo;			// 테스트사용자번호
	private String testUserNm;		// 테스트사용자명
	private String testUserEm;		// 테스트사용자이메일
	private String userId;			// 사용자아이디
	
	// 추가정보
	private String taskNos;			// 주업무번호
	private String subTaskNos;		// 보조업무번호
	public int getTestUserNo() {
		return testUserNo;
	}
	public void setTestUserNo(int testUserNo) {
		this.testUserNo = testUserNo;
	}
	public String getTestUserNm() {
		return testUserNm;
	}
	public void setTestUserNm(String testUserNm) {
		this.testUserNm = testUserNm;
	}
	public String getTestUserEm() {
		return testUserEm;
	}
	public void setTestUserEm(String testUserEm) {
		this.testUserEm = testUserEm;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTaskNos() {
		return taskNos;
	}
	public void setTaskNos(String taskNos) {
		this.taskNos = taskNos;
	}
	public String getSubTaskNos() {
		return subTaskNos;
	}
	public void setSubTaskNos(String subTaskNos) {
		this.subTaskNos = subTaskNos;
	}
}
