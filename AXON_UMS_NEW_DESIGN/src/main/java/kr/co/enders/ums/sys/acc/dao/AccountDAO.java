/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 데이터 처리==>계정관리 데이터 처리
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.dao ==> kr.co.enders.ums.sys.acc.dao
 *                계정관리외의 함수제거
 */
package kr.co.enders.ums.sys.acc.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.sys.acc.vo.DeptVO;
import kr.co.enders.ums.sys.acc.vo.UserProgVO;
import kr.co.enders.ums.sys.acc.vo.UserVO;

@Repository
public class AccountDAO implements AccountMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<DeptVO> getDeptList(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).getDeptList(deptVO);
	}

	@Override
	public DeptVO getDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).getDeptInfo(deptVO);
	}

	@Override
	public int insertDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).insertDeptInfo(deptVO);
	}

	@Override
	public int updateDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).updateDeptInfo(deptVO);
	}

	@Override
	public List<UserVO> getUserList(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).getUserList(deptVO);
	}

	@Override
	public UserVO getUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).getUserInfo(userVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).getUserProgList(userVO);
	}

	@Override
	public List<UserVO> userIdCheck(String userId) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).userIdCheck(userId);
	}

	@Override
	public int insertUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).insertUserInfo(userVO);
	}

	@Override
	public int insertUserProgInfo(UserProgVO userProgVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).insertUserProgInfo(userProgVO);
	}

	@Override
	public int updateUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).updateUserInfo(userVO);
	}

	@Override
	public int deleteUserProgInfo(String userId) throws Exception {
		return sqlSessionEms.getMapper(AccountMapper.class).deleteUserProgInfo(userId);
	}
}
