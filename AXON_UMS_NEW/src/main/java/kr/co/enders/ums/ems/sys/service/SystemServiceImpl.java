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
import org.springframework.transaction.annotation.Transactional;

import kr.co.enders.ums.ems.sys.dao.SystemDAO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
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
	public List<UserVO> userIdCheck(String userId) throws Exception {
		return systemDAO.userIdCheck(userId);
	}

	@Override
	public int insertUserInfo(UserVO userVO) throws Exception {
		systemDAO.insertUserInfo(userVO);
		List<UserProgVO> userProgList = null;
		if(userVO.getProgId() != null && !"".equals(userVO.getProgId())) {
			userProgList = new ArrayList<UserProgVO>();
			String[] userProgs = userVO.getProgId().split(",");
			for(int i=0;i<userProgs.length;i++) {
				UserProgVO userProg = new UserProgVO();
				userProg.setUserId(userVO.getUserId());
				userProg.setProgId(Integer.parseInt(userProgs[i]));
			}
		}
		return 1;
	}
}
