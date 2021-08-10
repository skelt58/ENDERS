/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 매퍼==>계정관리 매퍼
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.dao ==> kr.co.enders.ums.sys.acc.dao
 *                계정관리외의 항목제거
 */
package kr.co.enders.ums.sys.acc.dao;

import java.util.List;

import kr.co.enders.ums.sys.acc.vo.DeptVO;
import kr.co.enders.ums.sys.acc.vo.UserProgVO;
import kr.co.enders.ums.sys.acc.vo.UserVO;

public interface AccountMapper {
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
	 * 사용자 정보 등록
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserInfo(UserVO userVO) throws Exception;
	
	/**
	 * 사용자 프로그램 정보 등록
	 * @param userProgVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserProgInfo(UserProgVO userProgVO) throws Exception;
	
	/**
	 * 사용자 정보 수정
	 * @param userVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserInfo(UserVO userVO) throws Exception;
	
	/**
	 * 사용자 프로그램 정보 삭제
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public int deleteUserProgInfo(String userId) throws Exception;
	
}
