/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 서비스 인터페이스
 */
package kr.co.enders.ums.ems.ana.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.ana.vo.MailSummVO;
import kr.co.enders.ums.ems.ana.vo.SendLogVO;
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
	
	/**
	 * 메일 정보 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 결과요약 메일 발송결과 조회
	 * @param taskVO
	 * @return
	 */
	public MailSummVO getMailSummResult(TaskVO taskVO) throws Exception;
	
	/**
	 * 결과요약 메일 세부에러 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailSummVO> getMailSummDetail(TaskVO taskVO) throws Exception;
	
	/**
	 * 발송 실패 목록 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public List<SendLogVO> getFailList(SendLogVO sendLogVO) throws Exception;
}
