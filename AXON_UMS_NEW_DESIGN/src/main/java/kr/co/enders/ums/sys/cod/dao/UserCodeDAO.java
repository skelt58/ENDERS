/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 데이터 처리==>사용자 코드 관리 데이터 처리
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.dao ==> kr.co.enders.ums.sys.cod.dao
 *                코드관리외의 함수제거
 * 수정자 : 김준희
 * 수정일시 : 2021.08.11
 * 수정내역 : 코드그룹 관리 기능 추가 
 */
package kr.co.enders.ums.sys.cod.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.sys.cod.vo.UserCodeVO;
import kr.co.enders.ums.sys.cod.vo.UserCodeGroupVO;

@Repository
public class UserCodeDAO implements UserCodeMapper {
	@Autowired
	private SqlSession sqlSessionEms;
	
	//Code Group........
	@Override
	public List<UserCodeGroupVO> getUserCodeGroupList(UserCodeGroupVO userCodeGroupVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).getUserCodeGroupList(userCodeGroupVO);
	}
	
	@Override
	public UserCodeGroupVO getUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).getUserCodeGroupInfo(userCodeGroupVO);
	}

	@Override
	public int insertUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).insertUserCodeGroupInfo(userCodeGroupVO);
	}

	@Override
	public int updateUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).updateUserCodeGroupInfo(userCodeGroupVO);
	}

	@Override
	public int deleteUserCodeGroupInfo(UserCodeGroupVO userCodeGroupVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).deleteUserCodeGroupInfo(userCodeGroupVO);
	}
	
	//Code..........
	@Override
	public List<UserCodeVO> getUserCodeList(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).getUserCodeList(userCodeVO);
	}

	@Override
	public UserCodeVO getUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).getUserCodeInfo(userCodeVO);
	}	
	@Override
	public int insertUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).insertUserCodeInfo(userCodeVO);
	}

	@Override
	public int updateUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).updateUserCodeInfo(userCodeVO);
	}

	@Override
	public int deleteUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return sqlSessionEms.getMapper(UserCodeMapper.class).deleteUserCodeInfo(userCodeVO);
	}

}
