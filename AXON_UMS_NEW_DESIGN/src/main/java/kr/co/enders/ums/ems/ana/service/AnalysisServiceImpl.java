/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 서비스 구현
 */
package kr.co.enders.ums.ems.ana.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.ana.dao.AnalysisDAO;
import kr.co.enders.ums.ems.ana.vo.MailDomainVO;
import kr.co.enders.ums.ems.ana.vo.MailErrorVO;
import kr.co.enders.ums.ems.ana.vo.MailSummVO;
import kr.co.enders.ums.ems.ana.vo.RespLogVO;
import kr.co.enders.ums.ems.ana.vo.SendLogVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public class AnalysisServiceImpl implements AnalysisService {

	@Autowired
	private AnalysisDAO analysisDAO;
	
	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailList(taskVO);
	}

	@Override
	public MailSummVO getMailSummResult(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailSummResult(taskVO);
	}

	@Override
	public List<MailErrorVO> getMailSummDetail(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailSummDetail(taskVO);
	}

	@Override
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailInfo(taskVO);
	}

	@Override
	public List<SendLogVO> getFailList(SendLogVO sendLogVO) throws Exception {
		return analysisDAO.getFailList(sendLogVO);
	}

	@Override
	public List<MailErrorVO> getMailErrorList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailErrorList(taskVO);
	}

	@Override
	public List<MailDomainVO> getMailDomainList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailDomainList(taskVO);
	}

	@Override
	public List<SendLogVO> getMailSendHourList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailSendHourList(taskVO);
	}

	@Override
	public SendLogVO getMailSendHourSum(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailSendHourSum(taskVO);
	}

	@Override
	public List<RespLogVO> getMailRespHourList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailRespHourList(taskVO);
	}

	@Override
	public RespLogVO getMailRespHourSum(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailRespHourSum(taskVO);
	}

	@Override
	public List<SendLogVO> getCustLogList(SendLogVO sendLogVO) throws Exception {
		return analysisDAO.getCustLogList(sendLogVO);
	}

	@Override
	public List<TaskVO> getJoinMailList(SendLogVO sendLogVO) throws Exception {
		return analysisDAO.getJoinMailList(sendLogVO);
	}

	@Override
	public RespLogVO getJoinSendResult(SendLogVO sendLogVO) throws Exception {
		return analysisDAO.getJoinSendResult(sendLogVO);
	}
	
	@Override
	public List<MailErrorVO> getJoinErrorList(SendLogVO sendLogVO) throws Exception {
		return analysisDAO.getJoinErrorList(sendLogVO);
	}
	
	@Override
	public List<TaskVO> getTaskList(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskList(taskVO);
	}

	@Override
	public TaskVO getTaskInfo(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskInfo(taskVO);
	}

	@Override
	public MailSummVO getTaskSummResult(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskSummResult(taskVO);
	}

	@Override
	public List<MailErrorVO> getTaskSummDetail(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskSummDetail(taskVO);
	}

	@Override
	public List<MailErrorVO> getTaskErrorList(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskErrorList(taskVO);
	}

	@Override
	public List<MailDomainVO> getTaskDomainList(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskDomainList(taskVO);
	}

	@Override
	public List<SendLogVO> getTaskSendHourList(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskSendHourList(taskVO);
	}

	@Override
	public SendLogVO getTaskSendHourSum(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskSendHourSum(taskVO);
	}

	@Override
	public List<RespLogVO> getTaskRespHourList(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskRespHourList(taskVO);
	}

	@Override
	public RespLogVO getTaskRespHourSum(TaskVO taskVO) throws Exception {
		return analysisDAO.getTaskRespHourSum(taskVO);
	}

}
