/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.21
 * 설명 : Segment Member VO
 */
package kr.co.enders.ums.ems.seg.vo;

import java.util.HashMap;
import java.util.List;

public class SegmentMemberVO {
	private int totalCount;								// 전체건수
	private List<HashMap<String,String>> memberList;	// 멤버목록
	private HashMap<String,String> member;				// 멤버정보
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public List<HashMap<String, String>> getMemberList() {
		return memberList;
	}
	public void setMemberList(List<HashMap<String, String>> memberList) {
		this.memberList = memberList;
	}
	public HashMap<String, String> getMember() {
		return member;
	}
	public void setMember(HashMap<String, String> member) {
		this.member = member;
	}
}
