/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 데이터 처리
 */
package kr.co.enders.ums.ems.sys.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.UserProgVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;

@Repository
public class SystemDAO implements SystemMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<DeptVO> getDeptList(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getDeptList(deptVO);
	}

	@Override
	public DeptVO getDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getDeptInfo(deptVO);
	}

	@Override
	public int insertDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertDeptInfo(deptVO);
	}

	@Override
	public int updateDeptInfo(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateDeptInfo(deptVO);
	}

	@Override
	public List<UserVO> getUserList(DeptVO deptVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getUserList(deptVO);
	}

	@Override
	public UserVO getUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getUserInfo(userVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getUserProgList(userVO);
	}

	@Override
	public List<UserVO> userIdCheck(String userId) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).userIdCheck(userId);
	}

	@Override
	public int insertUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertUserInfo(userVO);
	}

	@Override
	public int insertUserProgInfo(UserProgVO userProgVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertUserProgInfo(userProgVO);
	}

	@Override
	public int updateUserInfo(UserVO userVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateUserInfo(userVO);
	}

	@Override
	public int deleteUserProgInfo(String userId) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteUserProgInfo(userId);
	}

	@Override
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getDbConnList(dbConnVO);
	}

	@Override
	public int insertDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertDbConnInfo(dbConnVO);
	}

	@Override
	public DbConnVO getDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getDbConnInfo(dbConnVO);
	}

	@Override
	public int updateDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateDbConnInfo(dbConnVO);
	}

	@Override
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getLoginHistList(loginHistVO);
	}

}
