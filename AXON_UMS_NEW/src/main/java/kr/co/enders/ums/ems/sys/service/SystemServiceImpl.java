/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 구현
 */
package kr.co.enders.ums.ems.sys.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.sys.dao.SystemDAO;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.UserProgVO;
import kr.co.enders.ums.ems.sys.vo.UserVO;

@Service
public class SystemServiceImpl implements SystemService {
	@Autowired
	private SystemDAO systemDAO;

	@Override
	public List<DeptVO> getDeptList(DeptVO deptVO) throws Exception {
		return systemDAO.getDeptList(deptVO);
	}

	@Override
	public DeptVO getDeptInfo(DeptVO deptVO) throws Exception {
		return systemDAO.getDeptInfo(deptVO);
	}

	@Override
	public int insertDeptInfo(DeptVO deptVO) throws Exception {
		return systemDAO.insertDeptInfo(deptVO);
	}

	@Override
	public int updateDeptInfo(DeptVO deptVO) throws Exception {
		return  systemDAO.updateDeptInfo(deptVO);
	}

	@Override
	public List<UserVO> getUserList(DeptVO deptVO) throws Exception {
		return systemDAO.getUserList(deptVO);
	}
	
	@Override
	public UserVO getUserInfo(UserVO userVO) throws Exception {
		return systemDAO.getUserInfo(userVO);
	}

	@Override
	public List<UserProgVO> getUserProgList(UserVO userVO) throws Exception {
		return systemDAO.getUserProgList(userVO);
	}

	@Override
	public List<UserVO> userIdCheck(String userId) throws Exception {
		return systemDAO.userIdCheck(userId);
	}

	@Override
	public int insertUserInfo(UserVO userVO) throws Exception {
		int result = 0;
		
		// 사용자 정보 등록
		systemDAO.insertUserInfo(userVO);
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
				systemDAO.insertUserProgInfo(userProg);
				result++;
			}
		}
		return result;
	}

	@Override
	public int updateUserInfo(UserVO userVO) throws Exception {
		int result = 0;
		
		// 사용자 정보 수정
		systemDAO.updateUserInfo(userVO);
		result++;
		
		// 사용자 프로그램 정보 삭제
		systemDAO.deleteUserProgInfo(userVO.getUserId());
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
				systemDAO.insertUserProgInfo(userProg);
				result++;
			}
		}
		
		return result;
	}

	@Override
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception {
		return systemDAO.getDbConnList(dbConnVO);
	}

	@Override
	public int insertDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return systemDAO.insertDbConnInfo(dbConnVO);
	}

	@Override
	public DbConnVO getDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return systemDAO.getDbConnInfo(dbConnVO);
	}

	@Override
	public int updateDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return systemDAO.updateDbConnInfo(dbConnVO);
	}

	@Override
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception {
		return systemDAO.getLoginHistList(loginHistVO);
	}
}
