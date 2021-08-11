/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 서비스 인터페이스
 */
package kr.co.enders.ums.ems.ana.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.ana.vo.MailDomainVO;
import kr.co.enders.ums.ems.ana.vo.MailErrorVO;
import kr.co.enders.ums.ems.ana.vo.MailSummVO;
import kr.co.enders.ums.ems.ana.vo.RespLogVO;
import kr.co.enders.ums.ems.ana.vo.SendLogVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public interface AnalysisService {
	
	/**
	 * 메일별분석 메일 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 메일 정보 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 결과요약 메일 발송결과 조회
	 * @param taskVO
	 * @return
	 */
	public MailSummVO getMailSummResult(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 결과요약 메일 세부에러 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailErrorVO> getMailSummDetail(TaskVO taskVO) throws Exception;
	
	/**
	 * 발송 실패 목록 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public List<SendLogVO> getFailList(SendLogVO sendLogVO) throws Exception;
	
	/**
	 * 메일별분석 세부에러 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailErrorVO> getMailErrorList(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 도메인별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailDomainVO> getMailDomainList(TaskVO taskVO) throws Exception;
	
	/**
	 * 발송시간별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<SendLogVO> getMailSendHourList(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 발송시간별 합계 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public SendLogVO getMailSendHourSum(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 응답시간별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<RespLogVO> getMailRespHourList(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 응답시간별 합계 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public RespLogVO getMailRespHourSum(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일별분석 고객별로그 목록 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public List<SendLogVO> getCustLogList(SendLogVO sendLogVO) throws Exception;
	
	/**
	 * 메일별분석 병합분석 메일 목록 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getJoinMailList(SendLogVO sendLogVO) throws Exception;
	
	
	/**
	 * 메일별분석 병합분석 발송결과 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public RespLogVO getJoinSendResult(SendLogVO sendLogVO) throws Exception;
	
	/**
	 * 메일별분석 병합분석 세부에러 목록 조회
	 * @param sendLogVO
	 * @return
	 * @throws Exception
	 */
	public List<MailErrorVO> getJoinErrorList(SendLogVO sendLogVO) throws Exception;
	
	/**
	 * 정기메일분석 메일 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getTaskList(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 메일 정보 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public TaskVO getTaskInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 결과요약 메일 발송결과 조회
	 * @param taskVO
	 * @return
	 */
	public MailSummVO getTaskSummResult(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 결과요약 메일 세부에러 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailErrorVO> getTaskSummDetail(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일별분석 세부에러 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailErrorVO> getTaskErrorList(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 도메인별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<MailDomainVO> getTaskDomainList(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 발송시간별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<SendLogVO> getTaskSendHourList(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 발송시간별 합계 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public SendLogVO getTaskSendHourSum(TaskVO taskVO) throws Exception;
	
	
	/**
	 * 정기메일분석 응답시간별 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<RespLogVO> getTaskRespHourList(TaskVO taskVO) throws Exception;
	
	/**
	 * 정기메일분석 응답시간별 합계 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public RespLogVO getTaskRespHourSum(TaskVO taskVO) throws Exception;
	
	/**
	 * 캠페인별분석 캠페인 정보 조회
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public CampaignVO getCampaignInfo(CampaignVO campaignVO) throws Exception;
	
	/**
	 * 캠페인별분석 캠페인 메일 목록 조회
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public List<MailSummVO> getCampMailList(CampaignVO campaignVO) throws Exception;
	
	/**
	 * 캠페인별분석 캠페인 메일 합계 조회
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public MailSummVO getCampMailTotal(CampaignVO campaignVO) throws Exception;
}
