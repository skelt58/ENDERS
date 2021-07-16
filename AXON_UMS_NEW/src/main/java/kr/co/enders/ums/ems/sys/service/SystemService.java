/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 인터페이스
 */
package kr.co.enders.ums.ems.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.enders.ums.ems.sys.vo.DbConnPermVO;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;
import kr.co.enders.ums.ems.sys.vo.MetaJoinVO;
import kr.co.enders.ums.ems.sys.vo.MetaOperatorVO;
import kr.co.enders.ums.ems.sys.vo.MetaTableVO;
import kr.co.enders.ums.ems.sys.vo.MetaValueVO;
import kr.co.enders.ums.ems.sys.vo.UserCodeVO;
import kr.co.enders.ums.ems.sys.vo.UserProgVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;

@Service
public interface SystemService {
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
	
	/**
	 * DB Connection 목록 조회
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * DB Connection 정보 조회
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public DbConnVO getDbConnInfo(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * DB Connection 정보 등록
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public int insertDbConnInfo(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * DB Connection 정보 수정
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public int updateDbConnInfo(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * DB 사용권한 목록 조회
	 * @param dbConnPermVO
	 * @return
	 * @throws Exception
	 */
	public List<DbConnPermVO> getDbConnPermList(DbConnPermVO dbConnPermVO) throws Exception;
	
	/**
	 * DB 사용권한 정보 저장
	 * @param dbConnPermVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int saveDbConnPermInfo(DbConnPermVO dbConnPermVO) throws Exception;
	
	/**
	 * 메타 테이블 목록 조회
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public List<MetaTableVO> getMetaTableList(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * 메타 테이블 정보 조회
	 * @param metaTableVO
	 * @return
	 * @throws Exception
	 */
	public MetaTableVO getMetaTableInfo(MetaTableVO metaTableVO) throws Exception;
	
	/**
	 * 메타 테이블 정보 등록
	 * @param metaTableVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int insertMetaTableInfo(MetaTableVO metaTableVO) throws Exception;
	
	/**
	 * 메타 테이블 정보 수정
	 * @param metaTableVO
	 * @return
	 * @throws Exception
	 */
	public int updateMetaTableInfo(MetaTableVO metaTableVO) throws Exception;
	
	/**
	 * 메타 테이블 정보 삭제(관계식 삭제 -> 관계값 삭제 -> 메타컬럼 삭제 -> 메타테이블 삭제)
	 * @param metaTableVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int deleteMetaTableInfo(MetaTableVO metaTableVO) throws Exception;
	
	/**
	 * 메타 컬럼 정보 조회
	 * @param tblNo
	 * @return
	 * @throws Exception
	 */
	public List<MetaColumnVO> getMetaColumnList(int tblNo) throws Exception;
	
	/**
	 * 메타 컬럼 정보를 등록
	 * @param metaColumnVO
	 * @return
	 * @throws Exception
	 */
	public int insertMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception;
	
	/**
	 * 메타 컬럼 정보를 수정
	 * @param metaColumnVO
	 * @return
	 * @throws Exception
	 */
	public int updateMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception;
	
	/**
	 * 메타 컬럼 정보 삭제(관계식 삭제 -> 관계값 삭제 -> 메타컬럼 삭제)
	 * @param colNo
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int deleteMetaColumnInfo(int colNo) throws Exception;
	
	/**
	 * 메타 관계식 목록 조회
	 * @param metaOperatorVO
	 * @return
	 * @throws Exception
	 */
	public List<MetaOperatorVO> getMetaOperatorList(MetaOperatorVO metaOperatorVO) throws Exception;
	
	/**
	 * 메타 관계식 수정(삭제 후 등록)
	 * @param metaOperatorVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int updateMetaOperatorInfo(MetaOperatorVO metaOperatorVO) throws Exception;
	
	/**
	 * 메타 관계값 목록 조회
	 * @param metaValueVO
	 * @return
	 * @throws Exception
	 */
	public List<MetaValueVO> getMetaValueList(MetaValueVO metaValueVO) throws Exception;
	
	/**
	 * 메타 관계값 등록
	 * @param metaValueVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int insertMetaValueInfo(MetaValueVO metaValueVO) throws Exception;
	
	/**
	 * 메타 관계값 수정
	 * @param metaValueVO
	 * @return
	 * @throws Exception
	 */
	public int updateMetaValueInfo(MetaValueVO metaValueVO) throws Exception;
	
	/**
	 * 메타 관계값 삭제
	 * @param metaValueVO
	 * @return
	 * @throws Exception
	 */
	public int deleteMetaValueInfo(MetaValueVO metaValueVO) throws Exception;
	
	/**
	 * 메타 조인 목록 조회
	 * @param metaJoinVO
	 * @return
	 * @throws Exception
	 */
	public List<MetaJoinVO> getMetaJoinList(MetaJoinVO metaJoinVO) throws Exception;
	
	/**
	 * 메타 조인 정보 등록
	 * @param metaJoinVO
	 * @return
	 * @throws Exception
	 */
	public int insertMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception;
	
	/**
	 * 메타 조인 정보 수정
	 * @param metaJoinVO
	 * @return
	 * @throws Exception
	 */
	public int updateMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception;
	
	/**
	 * 메타 조인 정보 삭제
	 * @param metaJoinVO
	 * @return
	 * @throws Exception
	 */
	public int deleteMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception;
	
	
	/**
	 * 사용자 로그인 이력 조회
	 * @param loginHistVO
	 * @return
	 * @throws Exception
	 */
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception;
	
	/**
	 * 캠페인 목적(사용자 코드) 목록 조회
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public List<UserCodeVO> getUserCodeList(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 캠페인 목적(사용자 코드) 등록
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(value="transactionManagerEms")
	public int insertUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 캠페인 목적(사용자 코드) 수정
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
	
	/**
	 * 캠페인 목적(사용자 코드) 삭제
	 * @param userCodeVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserCodeInfo(UserCodeVO userCodeVO) throws Exception;
}
