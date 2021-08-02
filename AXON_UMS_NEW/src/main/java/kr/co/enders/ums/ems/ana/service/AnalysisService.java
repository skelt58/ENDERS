/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 서비스 인터페이스
 */
package kr.co.enders.ums.ems.ana.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public interface AnalysisService {
	
	/**
	 * 메일 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception; 
}
