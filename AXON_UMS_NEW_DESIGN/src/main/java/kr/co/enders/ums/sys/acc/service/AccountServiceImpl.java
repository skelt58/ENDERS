/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 구현 ==>계정관리 서비스 구현
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.service ==> kr.co.enders.ums.sys.acc.service
 *                계정 관련 외의 함수 제거 
 */
package kr.co.enders.ums.sys.acc.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.sys.acc.dao.AccountDAO;
import kr.co.enders.ums.sys.acc.vo.DeptVO;
import kr.co.enders.ums.sys.acc.vo.UserVO;
import kr.co.enders.ums.sys.acc.vo.UserProgVO;

@Service
public class AccountServiceImpl implements AccountService {
	@Autowired
	private AccountDAO accountDAO;

	@Override
	public List<DeptVO> getDeptList(DeptVO deptVO) throws Exception {
		return accountDAO.getDeptList(deptVO);
	}

	@Override
	public DeptVO getDeptInfo(DeptVO deptVO) throws Exception {
		return accountDAO.getDeptInfo(deptVO);
	}

	@Override
	public int insertDeptInfo(DeptVO deptVO) throws Exception {
		return accountDAO.insertDeptInfo(deptVO);
	}

	@Override
	public int updateDeptInfo(DeptVO deptVO) throws Exception {
		return  accountDAO.updateDeptInfo(deptVO);
	}

	@Override
	public List<UserVO> getUserList(DeptVO deptVO) throws Exception {
		return accountDAO.getUserList(deptVO);
	}
	
	@Override
	public UserVO getUserInfo(UserVO userVO) throws Exception {
		return accountDAO.getUserInfo(userVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(UserVO userVO) throws Exception {
		return accountDAO.getUserProgList(userVO);
	}

	@Override
	public List<UserVO> userIdCheck(String userId) throws Exception {
		return accountDAO.userIdCheck(userId);
	}

	@Override
	public int insertUserInfo(UserVO userVO) throws Exception {
		int result = 0;
		
		// 사용자 정보 등록
		accountDAO.insertUserInfo(userVO);
		result++;
		
		// 사용자 프로그램 정보 등록
		List<UserProgVO> userProgList = null;
		if(userVO.getProgId() != null && !"".equals(userVO.getProgId())) {
			userProgList = new ArrayList<UserProgVO>();
			String[] userProgs = userVO.getProgId().split(",");
			for(int i=0;i<userProgs.length;i++) {
				UserProgVO userProg = new UserProgVO();
				userProg.setUserId(userVO.getUserId());
				userProg.setProgId(Integer.parseInt(userProgs[i]));
				userProgList.add(userProg);
				accountDAO.insertUserProgInfo(userProg);
				result++;
			}
		}
		return result;
	}

	@Override
	public int updateUserInfo(UserVO userVO) throws Exception {
		int result = 0;
		
		// 사용자 정보 수정
		result += accountDAO.updateUserInfo(userVO);
		
		// 사용자 프로그램 정보 삭제
		result += accountDAO.deleteUserProgInfo(userVO.getUserId());
		
		// 사용자 프로그램 정보 등록
		List<UserProgVO> userProgList = null;
		if(userVO.getProgId() != null && !"".equals(userVO.getProgId())) {
			userProgList = new ArrayList<UserProgVO>();
			String[] userProgs = userVO.getProgId().split(",");
			for(int i=0;i<userProgs.length;i++) {
				UserProgVO userProg = new UserProgVO();
				userProg.setUserId(userVO.getUserId());
				userProg.setProgId(Integer.parseInt(userProgs[i]));
				userProgList.add(userProg);
				result += accountDAO.insertUserProgInfo(userProg);
			}
		}		
		return result;
	}
}
