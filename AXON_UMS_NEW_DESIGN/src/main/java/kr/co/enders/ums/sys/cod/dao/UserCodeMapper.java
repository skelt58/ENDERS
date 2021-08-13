/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 매퍼==>사용자 코드 관리 매퍼
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.dao ==> kr.co.enders.ums.sys.cod.dao
 *                계정관리외의 항목제거 
 * 수정자 : 김준희
 * 수정일시 : 2021.08.11
 * 수정내역 : 코드그룹 관리 기능 추가                 
 */
package kr.co.enders.ums.sys.cod.dao;

import java.util.List;

import kr.co.enders.ums.sys.cod.vo.UserCodeVO;
import kr.co.enders.ums.sys.cod.vo.UserCodeGroupVO;

public interface UserCodeMapper {
	
	
	/**
	 * 코드그릅 목록 조회
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public List<UserCodeGroupVO> getUserCodeGroupList(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그릅 정보 조회
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public UserCodeGroupVO getUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그룹에 연관된 상위코드의 코드목록 조회
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public String getUserCodeGroupUpCdGrp(UserCodeVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그룹에 속해있는 코드갯수
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int getCodeCountUnderCodeGroup(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그룹 동일한 코드 그룹 갯수
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int getCodeGroupCountByCodeGroup(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그룹명 동일한 코드 그룹 갯수
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int getCodeGroupCountByCodeGroupNm(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그릅 등록
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그릅 수정
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception;
	
	/**
	 * 코드그릅 삭제
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception;

	/**
	 * 코드 목록 조회
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public List<UserCodeVO> getUserCodeList(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 코드 정보 조회
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public UserCodeVO getUserCodeInfo(UserCodeVO userCodeVO) throws Exception;	
	
	
	/**
	 * 코드 동일한 코드 그룹 갯수
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int getCodeCountByCode(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 코드명 동일한 코드 그룹 갯수
	 * @param userCodeGroupVO
	 * @return
	 * @throws Exception
	 */
	public int getCodeCountByCodeNm(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 코드 등록
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 코드 수정
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 코드삭제
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
}