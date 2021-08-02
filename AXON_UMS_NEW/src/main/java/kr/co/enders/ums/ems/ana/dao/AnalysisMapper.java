/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 매퍼
 */
package kr.co.enders.ums.ems.ana.dao;

import java.util.List;

import kr.co.enders.ums.ems.cam.vo.TaskVO;

public interface AnalysisMapper {
	
	/**
	 * 메일 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception; 
}
