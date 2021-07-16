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
	public List<DbConnPermVO> getDbConnPermList(DbConnPermVO dbConnPermVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getDbConnPermList(dbConnPermVO);
	}
	
	@Override
	public int insertDbConnPermInfo(DbConnPermVO dbConnPermVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertDbConnPermInfo(dbConnPermVO);
	}

	@Override
	public int deleteDbConnPermInfo(DbConnPermVO dbConnPermVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteDbConnPermInfo(dbConnPermVO);
	}
	
	@Override
	public int getMetaTableSeq() throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaTableSeq();
	}
	
	@Override
	public List<MetaTableVO> getMetaTableList(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaTableList(dbConnVO);
	}
	
	@Override
	public MetaTableVO getMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int insertMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertMetaTableInfo(metaTableVO);
	}

	@Override
	public int updateMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int deleteMetaTableOperator(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaTableOperator(metaTableVO);
	}

	@Override
	public int deleteMetaTableValue(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaTableValue(metaTableVO);
	}

	@Override
	public int deleteMetaTableColumn(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaTableColumn(metaTableVO);
	}

	@Override
	public int deleteMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaTableInfo(metaTableVO);
	}

	@Override
	public List<MetaColumnVO> getMetaColumnList(int tblNo) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaColumnList(tblNo);
	}
	
	@Override
	public int insertMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int updateMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int deleteMetaColumnOperator(int colNo) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaColumnOperator(colNo);
	}

	@Override
	public int deleteMetaColumnValue(int colNo) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaColumnValue(colNo);
	}

	@Override
	public int deleteMetaColumnInfo(int colNo) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaColumnInfo(colNo);
	}
	
	@Override
	public List<MetaOperatorVO> getMetaOperatorList(MetaOperatorVO metaOperatorVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaOperatorList(metaOperatorVO);
	}

	@Override
	public int insertMetaOperatorInfo(MetaOperatorVO metaOperatorVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertMetaOperatorInfo(metaOperatorVO);
	}
	
	@Override
	public List<MetaValueVO> getMetaValueList(MetaValueVO metaValueVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaValueList(metaValueVO);
	}
	
	@Override
	public int insertMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertMetaValueInfo(metaValueVO);
	}
	
	@Override
	public int updateMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateMetaValueInfo(metaValueVO);
	}
	
	@Override
	public int deleteMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaValueInfo(metaValueVO);
	}
	
	@Override
	public List<MetaJoinVO> getMetaJoinList(MetaJoinVO metaJoinVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getMetaJoinList(metaJoinVO);
	}
	
	@Override
	public int insertMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertMetaJoinInfo(metaJoinVO);
	}
	
	@Override
	public int updateMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateMetaJoinInfo(metaJoinVO);
	}

	@Override
	public int deleteMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteMetaJoinInfo(metaJoinVO);
	}
	
	@Override
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getLoginHistList(loginHistVO);
	}

	@Override
	public List<UserCodeVO> getUserCodeList(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).getUserCodeList(userCodeVO);
	}

	@Override
	public int insertUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).insertUserCodeInfo(userCodeVO);
	}

	@Override
	public int updateUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).updateUserCodeInfo(userCodeVO);
	}

	@Override
	public int deleteUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(SystemMapper.class).deleteUserCodeInfo(userCodeVO);
	}


}
