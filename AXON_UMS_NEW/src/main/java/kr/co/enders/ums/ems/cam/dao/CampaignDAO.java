/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 데이터 처리
 */
package kr.co.enders.ums.ems.cam.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.SendTestLogVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.cam.vo.TestUserVO;

@Repository
public class CampaignDAO implements CampaignMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<CampaignVO> getCampaignList(CampaignVO campaignVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getCampaignList(campaignVO);
	}

	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getMailList(taskVO);
	}

	@Override
	public CampaignVO getCampaignInfo(CampaignVO campaignVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getCampaignInfo(campaignVO);
	}

	@Override
	public int insertCampaignInfo(CampaignVO campaignVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertCampaignInfo(campaignVO);
	}

	@Override
	public int updateCampaignInfo(CampaignVO campaingVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateCampaignInfo(campaingVO);
	}

	@Override
	public int updateTaskStatusAdmit(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateTaskStatusAdmit(taskVO);
	}

	@Override
	public int updateSubTaskStatusAdmit(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateSubTaskStatusAdmit(taskVO);
	}

	@Override
	public int insertTaskInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertTaskInfo(taskVO);
	}

	@Override
	public int getTaskNo() throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getTaskNo();
	}

	@Override
	public int getSubTaskNo(int taskNo) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getSubTaskNo(taskNo);
	}

	@Override
	public int insertSubTaskInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertSubTaskInfo(taskVO);
	}

	@Override
	public int insertAttachInfo(AttachVO attachVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertAttachInfo(attachVO);
	}

	@Override
	public int insertLinkInfo(LinkVO linkVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertLinkInfo(linkVO);
	}

	@Override
	public int updateTaskStatus(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateTaskStatus(taskVO);
	}

	@Override
	public int updateSubTaskStatus(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateSubTaskStatus(taskVO);
	}

	@Override
	public TaskVO getTaskInfo(int seq) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getTaskInfo(seq);
	}

	@Override
	public TaskVO getSubTaskInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getSubTaskInfo(taskVO);
	}

	@Override
	public int insertTaskInfoForCopy(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertTaskInfoForCopy(taskVO);
	}

	@Override
	public int insertSubTaskInfoForCopy(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertSubTaskInfoForCopy(taskVO);
	}

	@Override
	public List<AttachVO> getAttachList(int taskNo) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getAttachList(taskNo);
	}

	@Override
	public List<TestUserVO> getTestUserList(String userId) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getTestUserList(userId);
	}

	@Override
	public int insertTestUserInfo(TestUserVO testUserVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertTestUserInfo(testUserVO);
	}

	@Override
	public int updateTestUserInfo(TestUserVO testUserVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateTestUserInfo(testUserVO);
	}

	@Override
	public int deleteTestUserInfo(TestUserVO testUserVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).deleteTestUserInfo(testUserVO);
	}

	@Override
	public int insertTaskInfoForTestSend(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertTaskInfoForTestSend(taskVO);
	}

	@Override
	public int insertSubTaskInfoForTestSend(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).insertSubTaskInfoForTestSend(taskVO);
	}

	@Override
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getMailInfo(taskVO);
	}

	@Override
	public int updateTaskInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateTaskInfo(taskVO);
	}

	@Override
	public int updateSubTaskInfo(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).updateSubTaskInfo(taskVO);
	}

	@Override
	public int deleteAttachInfo(int taskNo) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).deleteAttachInfo(taskNo);
	}

	@Override
	public List<TaskVO> getMailTestTaskList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getMailTestTaskList(taskVO);
	}

	@Override
	public List<SendTestLogVO> getMailTestSendLogList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(CampaignMapper.class).getMailTestSendLogList(taskVO);
	}
	
}
