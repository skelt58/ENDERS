/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 매퍼
 */
package kr.co.enders.ums.ems.cam.dao;

import java.util.List;

import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

public interface CampaignMapper {
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
	
	/**
	 * 캠페인 주업무 상태 수정
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public int updateTaskStatus(TaskVO taskVO) throws Exception;
	
	/**
	 * 캠페인 보조업무 상태 수정
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public int updateSubTaskStatus(TaskVO taskVO) throws Exception;
	
	/**
	 * 주업무 정보 등록
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public int insertTaskInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 등록한 주업무 번호 조회
	 * @return
	 * @throws Exception
	 */
	public int getTaskNo() throws Exception;
	
	/**
	 * 보조업무 번호 조회
	 * @param taskNo
	 * @return
	 * @throws Exception
	 */
	public int getSubTaskNo(int taskNo) throws Exception;
	
	/**
	 * 보조업무 정보 등록
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public int insertSubTaskInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 첨부파일 정보 등록
	 * @param attachVO
	 * @return
	 * @throws Exception
	 */
	public int insertAttachInfo(AttachVO attachVO) throws Exception;
	
	/**
	 * 링크 정보 등록
	 * @param linkVO
	 * @return
	 * @throws Exception
	 */
	public int insertLinkInfo(LinkVO linkVO) throws Exception;
	
}
