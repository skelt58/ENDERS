/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 서비스 인터페이스
 */
package kr.co.enders.ums.ems.cam.service;

import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.cam.vo.TestUserVO;
import kr.co.enders.util.PropertiesUtil;

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
	
	/**
	 * 캠페인 주업무 및 보조업무 승인처리(발송대기 -> 발송승인)
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int updateMailAdmit(TaskVO taskVO) throws Exception; 
	
	public List<Vector<String>> mailAliasParser(TaskVO taskVO, List<CodeVO> mergeList, PropertiesUtil properties) throws Exception;
	
	/**
	 * 메일 정보를 등록한다.(주업무 -> 보조업무 -> 첨부파일 -> 링크)
	 * @param taskVO
	 * @param attachList
	 * @param linkList
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int insertMailInfo(TaskVO taskVO, List<AttachVO> attachList, List<LinkVO> linkList) throws Exception;
	
	/**
	 * 캠페인 주업무 및 보조업무 상태변경(사용중지, 삭제)
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int updateMailStatus(TaskVO taskVO) throws Exception;
	
	/**
	 * 메일 정보를 복사한다.(주업무, 보조업무, 첨부파일 복사)
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int copyMailInfo(TaskVO taskVO, PropertiesUtil properties) throws Exception;
	
	/**
	 * 테스트 사용자 목록 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<TestUserVO> getTestUserList(String userId) throws Exception;
	
	/**
	 * 테스트 사용자 정보 등록
	 * @param testUserVO
	 * @return
	 * @throws Exception
	 */
	public int insertTestUserInfo(TestUserVO testUserVO) throws Exception;
	
	/**
	 * 테스트 사용자 정보 수정
	 * @param testUserVO
	 * @return
	 * @throws Exception
	 */
	public int updateTestUserInfo(TestUserVO testUserVO) throws Exception;
	
	/**
	 * 테스트 사용자 정보 삭제
	 * @param testUserVO
	 * @return
	 * @throws Exception
	 */
	public int deleteTestUserInfo(TestUserVO testUserVO) throws Exception;
	
	/**
	 * 테스트메일 발송 정보 등록
	 * @param testUserVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int sendTestMail(TestUserVO testUserVO, HttpSession session) throws Exception;
	
	/**
	 * 메일 정보(캠페인 주업무,보조업무) 정보 조회
	 * @param taskVO
	 * @return
	 * @throws Exception
	 */
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception;
	
	/**
	 * 첨부파일 목록 조회
	 * @param taskNo
	 * @return
	 * @throws Exception
	 */
	public List<AttachVO> getAttachList(int taskNo) throws Exception;
}
