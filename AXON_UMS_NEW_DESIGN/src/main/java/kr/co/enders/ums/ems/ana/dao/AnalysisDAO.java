/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 데이터 처리
 */
package kr.co.enders.ums.ems.ana.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.ems.ana.vo.MailDomainVO;
import kr.co.enders.ums.ems.ana.vo.MailErrorVO;
import kr.co.enders.ums.ems.ana.vo.MailSummVO;
import kr.co.enders.ums.ems.ana.vo.RespLogVO;
import kr.co.enders.ums.ems.ana.vo.SendLogVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Repository
public class AnalysisDAO implements AnalysisMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailList(taskVO);
	}

	@Override
	public MailSummVO getMailSummResult(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailSummResult(taskVO);
	}

	@Override
	public List<MailErrorVO> getMailSummDetail(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailSummDetail(taskVO);
	}

	@Override
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailInfo(taskVO);
	}

	@Override
	public List<SendLogVO> getFailList(SendLogVO sendLogVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getFailList(sendLogVO);
	}

	@Override
	public List<MailErrorVO> getMailErrorList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailErrorList(taskVO);
	}

	@Override
	public List<MailDomainVO> getMailDomainList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailDomainList(taskVO);
	}

	@Override
	public List<SendLogVO> getMailSendHourList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailSendHourList(taskVO);
	}

	@Override
	public SendLogVO getMailSendHourSum(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailSendHourSum(taskVO);
	}

	@Override
	public List<RespLogVO> getMailRespHourList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailRespHourList(taskVO);
	}

	@Override
	public RespLogVO getMailRespHourSum(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailRespHourSum(taskVO);
	}

	@Override
	public List<SendLogVO> getCustLogList(SendLogVO sendLogVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getCustLogList(sendLogVO);
	}

	@Override
	public List<TaskVO> getJoinMailList(SendLogVO sendLogVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getJoinMailList(sendLogVO);
	}
	
}
