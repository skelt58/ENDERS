/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 발송대상(세그먼트)관리 데이터 처리
 */
package kr.co.enders.ums.ems.seg.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.ems.sys.vo.DbConnVO;

@Repository
public class SegmentDAO implements SegmentMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).getSegmentList(segmentVO);
	}

	@Override
	public int insertSegmentInfo(SegmentVO segmentVO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).insertSegmentInfo(segmentVO);
	}

	@Override
	public int updateSegmentInfo(SegmentVO segmentvO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).updateSegmentInfo(segmentvO);
	}
	
	@Override
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).getDbConnList(dbConnVO);
	}

	@Override
	public int updateSegmentStatus(SegmentVO segmentVO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).updateSegmentStatus(segmentVO);
	}

	@Override
	public SegmentVO getSegmentInfo(SegmentVO segmentVO) throws Exception {
		return sqlSessionEms.getMapper(SegmentMapper.class).getSegmentInfo(segmentVO);
	}


}
