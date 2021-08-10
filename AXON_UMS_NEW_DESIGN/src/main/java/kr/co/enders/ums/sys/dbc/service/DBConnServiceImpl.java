/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 구현==>데이터베이스 연계 서비스 구현
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.service ==> kr.co.enders.ums.sys.dbc.service
 *                데이터베이스연계 외의 함수 제거 
 */
package kr.co.enders.ums.sys.dbc.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.sys.dbc.dao.DBConnDAO;
import kr.co.enders.ums.sys.dbc.vo.DbConnPermVO;
import kr.co.enders.ums.sys.dbc.vo.DbConnVO;
import kr.co.enders.ums.sys.dbc.vo.MetaColumnVO;
import kr.co.enders.ums.sys.dbc.vo.MetaJoinVO;
import kr.co.enders.ums.sys.dbc.vo.MetaOperatorVO;
import kr.co.enders.ums.sys.dbc.vo.MetaTableVO;
import kr.co.enders.ums.sys.dbc.vo.MetaValueVO;

@Service
public class DBConnServiceImpl implements DBConnService {
	@Autowired
	private DBConnDAO dbConnDAO;
 
	@Override
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception {
		return dbConnDAO.getDbConnList(dbConnVO);
	}

	@Override
	public int insertDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return dbConnDAO.insertDbConnInfo(dbConnVO);
	}

	@Override
	public DbConnVO getDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return dbConnDAO.getDbConnInfo(dbConnVO);
	}

	@Override
	public int updateDbConnInfo(DbConnVO dbConnVO) throws Exception {
		return dbConnDAO.updateDbConnInfo(dbConnVO);
	}
	
	@Override
	public List<DbConnPermVO> getDbConnPermList(DbConnPermVO dbConnPermVO) throws Exception {
		return dbConnDAO.getDbConnPermList(dbConnPermVO);
	}
	
	@Override
	public int saveDbConnPermInfo(DbConnPermVO dbConnPermVO) throws Exception {
		int result = 0;
		
		// DB 사용권한 정보 삭제
		result += dbConnDAO.deleteDbConnPermInfo(dbConnPermVO);
		
		// DB 사용권한 정보 삭제
		if(dbConnPermVO.getUserId() != null && !"".equals(dbConnPermVO.getUserId())) {
			String[] userIds = dbConnPermVO.getUserId().split(",");
			for(int i=0;i<userIds.length;i++) {
				DbConnPermVO permVO = new DbConnPermVO();
				permVO.setDbConnNo(dbConnPermVO.getDbConnNo());
				permVO.setUserId(userIds[i]);
				result += dbConnDAO.insertDbConnPermInfo(permVO);
			}
		}		
		return result;
	}
	
	@Override
	public List<MetaTableVO> getMetaTableList(DbConnVO dbConnVO) throws Exception {
		return dbConnDAO.getMetaTableList(dbConnVO);
	}
	
	@Override
	public MetaTableVO getMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return dbConnDAO.getMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int insertMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		
		int tblNo = 0;
		// 메타 테이블 정보 등록
		dbConnDAO.insertMetaTableInfo(metaTableVO);
		
		// 메타 테이블 번호 조회
		tblNo = dbConnDAO.getMetaTableSeq();
		
		return tblNo;
	}
	
	@Override
	public int updateMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		return dbConnDAO.updateMetaTableInfo(metaTableVO);
	}
	
	@Override
	public int deleteMetaTableInfo(MetaTableVO metaTableVO) throws Exception {
		int result = 0;
		result += dbConnDAO.deleteMetaTableOperator(metaTableVO);
		result += dbConnDAO.deleteMetaTableValue(metaTableVO);
		result += dbConnDAO.deleteMetaTableColumn(metaTableVO);
		result += dbConnDAO.deleteMetaTableInfo(metaTableVO);
		
		return result;
	}
	
	@Override
	public List<MetaColumnVO> getMetaColumnList(MetaColumnVO metaColumnVO) throws Exception {
		return dbConnDAO.getMetaColumnList(metaColumnVO);
	}

	@Override
	public int insertMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return dbConnDAO.insertMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int updateMetaColumnInfo(MetaColumnVO metaColumnVO) throws Exception {
		return dbConnDAO.updateMetaColumnInfo(metaColumnVO);
	}

	@Override
	public int deleteMetaColumnInfo(int colNo) throws Exception {
		int result = 0;
		result += dbConnDAO.deleteMetaColumnOperator(colNo);
		result += dbConnDAO.deleteMetaColumnValue(colNo);
		result += dbConnDAO.deleteMetaColumnInfo(colNo);
		return result;
	}
	
	@Override
	public List<MetaOperatorVO> getMetaOperatorList(MetaOperatorVO metaOperatorVO) throws Exception {
		return dbConnDAO.getMetaOperatorList(metaOperatorVO);
	}

	@Override
	public int updateMetaOperatorInfo(MetaOperatorVO metaOperatorVO) throws Exception {
		
		dbConnDAO.deleteMetaColumnOperator(metaOperatorVO.getColNo());
		if(metaOperatorVO.getOperCd() != null && !"".equals(metaOperatorVO.getOperCd())) {
			String[] operCds = metaOperatorVO.getOperCd().split(",");
			for(int i=0;i<operCds.length;i++) {
				MetaOperatorVO operVO = new MetaOperatorVO();
				operVO.setColNo(metaOperatorVO.getColNo());
				operVO.setOperCd(operCds[i]);
				dbConnDAO.insertMetaOperatorInfo(operVO);
			}
		}		
		return 1;
	}

	@Override
	public List<MetaValueVO> getMetaValueList(MetaValueVO metaValueVO) throws Exception {
		return dbConnDAO.getMetaValueList(metaValueVO);
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
				result += dbConnDAO.insertMetaValueInfo(valueVO);
			}
		}
		return result;
	}
	
	@Override
	public int updateMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return dbConnDAO.updateMetaValueInfo(metaValueVO);
	}
	
	@Override
	public int deleteMetaValueInfo(MetaValueVO metaValueVO) throws Exception {
		return dbConnDAO.deleteMetaValueInfo(metaValueVO);
	}
	
	@Override
	public List<MetaJoinVO> getMetaJoinList(MetaJoinVO metaJoinVO) throws Exception {
		return dbConnDAO.getMetaJoinList(metaJoinVO);
	}
	
	@Override
	public int insertMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return dbConnDAO.insertMetaJoinInfo(metaJoinVO);
	}
	
	@Override
	public int updateMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return dbConnDAO.updateMetaJoinInfo(metaJoinVO);
	}

	@Override
	public int deleteMetaJoinInfo(MetaJoinVO metaJoinVO) throws Exception {
		return dbConnDAO.deleteMetaJoinInfo(metaJoinVO);
	}
}
