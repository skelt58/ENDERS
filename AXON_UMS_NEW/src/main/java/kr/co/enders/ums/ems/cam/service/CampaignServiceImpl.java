/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 서비스 구현
 */
package kr.co.enders.ums.ems.cam.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.cam.dao.CampaignDAO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public class CampaignServiceImpl implements CampaignService {
	@Autowired
	private CampaignDAO campaignDAO;

	@Override
	public List<CampaignVO> getCampaignList(CampaignVO campaignVO) throws Exception {
		return campaignDAO.getCampaignList(campaignVO);
	}

	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return campaignDAO.getMailList(taskVO);
	}

}
