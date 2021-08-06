/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 로그인 서비스 구현
 */
package kr.co.enders.ums.lgn.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.lgn.dao.LoginDAO;
import kr.co.enders.ums.lgn.vo.LoginHistVO;
import kr.co.enders.ums.lgn.vo.LoginVO;
import kr.co.enders.ums.sys.vo.UserProgVO;
import kr.co.enders.ums.sys.vo.UserVO;

@Service
public class LoginServiceImpl implements LoginService {
	@Autowired
	private LoginDAO loginDAO;

	@Override
	public UserVO isValidUser(LoginVO loginVO) throws Exception {
		return loginDAO.isValidUser(loginVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(String userId) throws Exception {
		return loginDAO.getUserProgList(userId);
	}

	@Override
	public void insertLoginHist(LoginHistVO histVO) throws Exception {
		loginDAO.insertLoginHist(histVO);
	}

}
