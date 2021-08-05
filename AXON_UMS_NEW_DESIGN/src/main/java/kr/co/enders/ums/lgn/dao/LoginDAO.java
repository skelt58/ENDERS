/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 로그인 데이터 처리
 */
package kr.co.enders.ums.lgn.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.sys.vo.UserProgVO;
import kr.co.enders.ums.sys.vo.UserVO;
import kr.co.enders.ums.lgn.vo.LoginHistVO;
import kr.co.enders.ums.lgn.vo.LoginVO;

@Repository
public class LoginDAO implements LoginMapper {
	@Autowired
	SqlSession sqlSessionEms;

	@Override
	public UserVO isValidUser(LoginVO loginVO) throws Exception {
		return sqlSessionEms.getMapper(LoginMapper.class).isValidUser(loginVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(String userId) throws Exception {
		return sqlSessionEms.getMapper(LoginMapper.class).getUserProgList(userId);		
	}

	@Override
	public void insertLoginHist(LoginHistVO histVO) throws Exception {
		sqlSessionEms.getMapper(LoginMapper.class).insertLoginHist(histVO);
	}

}
