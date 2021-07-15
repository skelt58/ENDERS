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
import kr.co.enders.ums.ems.sys.vo.DbConnPermVO;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;
import kr.co.enders.ums.ems.sys.vo.DeptVO;
import kr.co.enders.ums.ems.sys.vo.LoginHistVO;
import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;
import kr.co.enders.ums.ems.sys.vo.MetaOperatorVO;
import kr.co.enders.ums.ems.sys.vo.MetaTableVO;
import kr.co.enders.ums.ems.sys.vo.MetaValueVO;
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
		result += systemDAO.updateUserInfo(userVO);
		
		// 사용자 프로그램 정보 삭제
		result += systemDAO.deleteUserProgInfo(userVO.getUserId());
		
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
				result += systemDAO.insertUserProgInfo(userProg);
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
	public List<DbConnPermVO> getDbConnPermList(DbConnPermVO dbConnPermVO) throws Exception {
		return systemDAO.getDbConnPermList(dbConnPermVO);
	}
	
	@Override
	public int saveDbConnPermInfo(DbConnPermVO dbConnPermVO) throws Exception {
		int result = 0;
		
		// DB 사용권한 정보 삭제
		result += systemDAO.deleteDbConnPermInfo(dbConnPermVO);
		
		// DB 사용권한 정보 삭제
		if(dbConnPermVO.getUserId() != null && !"".equals(dbConnPermVO.getUserId())) {
			String[] userIds = dbConnPermVO.getUserId().split(",");
			for(int i=0;i<userIds.length;i++) {
				DbConnPermVO permVO = new DbConnPermVO();
				permVO.setDbConnNo(dbConnPermVO.getDbConnNo());
				permVO.setUserId(userIds[i]);
				result += systemDAO.insertDbConnPermInfo(permVO);
			}
		}
		
		return result;
	}
	
	
	@Override
	public List<MetaTableVO> getMetaTableList(DbConnVO dbConnVO) throws Exception {
		return systemDAO.getMetaTableList(dbConnVO);
	}
	
	@Override
	public MetaTableVO getMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return systemDAO.getMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int insertMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		
		int tblNo = 0;
		// 메타 테이블 정보 등록
		systemDAO.insertMetaTableInfo(metaTableVO);
		
		// 메타 테이블 번호 조회
		tblNo = systemDAO.getMetaTableSeq();
		
		return tblNo;
	}
	
	@Override
	public int updateMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return systemDAO.updateMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int deleteMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		int result = 0;
		result += systemDAO.deleteMetaTableOperator(metaTableVO);
		result += systemDAO.deleteMetaTableValue(metaTableVO);
		result += systemDAO.deleteMetaTableColumn(metaTableVO);
		result += systemDAO.deleteMetaTableInfo(metaTableVO);
		
		return result;
	}
	
	@Override
	public List<MetaColumnVO> getMetaColumnList(int tblNo) throws Exception {
		return systemDAO.getMetaColumnList(tblNo);
	}

	@Override
	public int insertMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return systemDAO.insertMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int updateMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return systemDAO.updateMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int deleteMetaColumnInfo(int colNo) throws Exception {
		int result = 0;
		result += systemDAO.deleteMetaColumnOperator(colNo);
		result += systemDAO.deleteMetaColumnValue(colNo);
		result += systemDAO.deleteMetaColumnInfo(colNo);
		return result;
	}
	
	@Override
	public List<MetaOperatorVO> getMetaOperatorList(MetaOperatorVO metaOperatorVO) throws Exception {
		return systemDAO.getMetaOperatorList(metaOperatorVO);
	}

	@Override
	public int updateMetaOperatorInfo(MetaOperatorVO metaOperatorVO) throws Exception {
		
		systemDAO.deleteMetaColumnOperator(metaOperatorVO.getColNo());
		if(metaOperatorVO.getOperCd() != null && !"".equals(metaOperatorVO.getOperCd())) {
			String[] operCds = metaOperatorVO.getOperCd().split(",");
			for(int i=0;i<operCds.length;i++) {
				MetaOperatorVO operVO = new MetaOperatorVO();
				operVO.setColNo(metaOperatorVO.getColNo());
				operVO.setOperCd(operCds[i]);
				systemDAO.insertMetaOperatorInfo(operVO);
			}
		}
		
		return 1;
	}

	@Override
	public List<MetaValueVO> getMetaValueList(MetaValueVO metaValueVO) throws Exception {
		return systemDAO.getMetaValueList(metaValueVO);
	}
	
	@Override
	public int insertMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		int result = 0;
		if(metaValueVO.getValueNm() != null && !"".equals(metaValueVO.getValueNm())) {
			String[] valueNm = metaValueVO.getValueNm().split(",");
			String[] valueAlias = metaValueVO.getValueAlias().split(",");
			for(int i=0;i<valueNm.length;i++) {
				MetaValueVO valueVO = new MetaValueVO();
				valueVO.setColNo(metaValueVO.getColNo());
				valueVO.setValueNm(valueNm[i]);
				valueVO.setValueAlias(valueAlias[i]);
				result += systemDAO.insertMetaValueInfo(valueVO);
			}
		}
		return result;
	}
	

	@Override
	public int updateMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return systemDAO.updateMetaValueInfo(metaValueVO);
	}
	
	@Override
	public int deleteMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return systemDAO.deleteMetaValueInfo(metaValueVO);
	}
	
	@Override
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception {
		return systemDAO.getLoginHistList(loginHistVO);
	}
	
}
