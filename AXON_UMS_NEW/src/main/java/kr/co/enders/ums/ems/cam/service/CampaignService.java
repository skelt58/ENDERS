/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 서비스 인터페이스
 */
package kr.co.enders.ums.ems.cam.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public interface CampaignService {
	/**
	 * 캠페인 목록 조회
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public List<CampaignVO> getCampaignList(CampaignVO campaignVO) throws Exception;
	
	/**
	 * 메일 목록 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception;
	
	/**
	 * 캠페인 정보 조회
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public CampaignVO getCampaignInfo(CampaignVO campaignVO) throws Exception;
	
	/**
	 * 캠페인 정보 등록
	 * @param campaignVO
	 * @return
	 * @throws Exception
	 */
	public int insertCampaignInfo(CampaignVO campaignVO) throws Exception;
	
	/**
	 * 캠페인 정보 수정
	 * @param campaingVO
	 * @return
	 * @throws Exception
	 */
	public int updateCampaignInfo(CampaignVO campaingVO) throws Exception;
}
