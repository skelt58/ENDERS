/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 인터페이스==>계정관리 서비스 인터페이스
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.service ==> kr.co.enders.ums.sys.acc.service
 *                계정관련 외의 함수 및 Import 제거 
 */
package kr.co.enders.ums.sys.acc.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.enders.ums.sys.acc.vo.DeptVO;
import kr.co.enders.ums.sys.acc.vo.UserProgVO;
import kr.co.enders.ums.sys.acc.vo.UserVO;

@Service
public interface AccountService {
	/**
	 * 부서 목록 조회
	 * @param deptVO
	 * @return
	 * @throws Exception
	 */
	public List<DeptVO> getDeptList(DeptVO deptVO) throws Exception;
	
	/**
	 * 부서 정보 조회
	 * @param deptVO
	 * @return
	 * @throws Exception
	 */
	public DeptVO getDeptInfo(DeptVO deptVO) throws Exception;
	
	/**
	 * 부서 정보 등록
	 * @param deptVO
	 * @return
	 * @throws Exception
	 */
	public int insertDeptInfo(DeptVO deptVO) throws Exception;
	
	/**
	 * 부서 정보 수정
	 * @param deptVO
	 * @return
	 * @throws Exception
	 */
	public int updateDeptInfo(DeptVO deptVO) throws Exception;
	
	/**
	 * 사용자 목록 조회
	 * @param deptVO
	 * @return
	 * @throws Exception
	 */
	public List<UserVO> getUserList(DeptVO deptVO) throws Exception;
	
	/**
	 * 사용자 정보 조회
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	public UserVO getUserInfo(UserVO userVO) throws Exception;
	
	/**
	 * 사용자 프로그램 정보 조회
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	public List<UserProgVO> getUserProgList(UserVO userVO) throws Exception;
	
	/**
	 * 사용자 아이디를 체크한다. 중복 방지용
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<UserVO> userIdCheck(String userId) throws Exception;
	
	/**
	 * 사용자 정보 등록 및 사용자 프로그램 정보 등록
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int insertUserInfo(UserVO userVO) throws Exception;
	
	/**
	 * 사용자 정보 수정
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int updateUserInfo(UserVO userVO) throws Exception;
}
