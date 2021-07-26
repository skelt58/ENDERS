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

import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

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
	
}
