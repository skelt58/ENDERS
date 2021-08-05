/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 발송대상(세그먼트)관리 매퍼
 */
package kr.co.enders.ums.ems.seg.dao;

import java.util.List;

import kr.co.enders.ums.ems.seg.vo.SegmentVO;
import kr.co.enders.ums.sys.vo.DbConnVO;

public interface SegmentMapper {
	/**
	 * 발송대상(세그먼트) 목록 조회
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception;
	
	/**
	 * 발송대상(세그먼트) 정보 등록
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public int insertSegmentInfo(SegmentVO segmentVO) throws Exception;
	
	/**
	 * 발송대상(세그먼트) 정보 수정
	 * @param segmentvO
	 * @return
	 * @throws Exception
	 */
	public int updateSegmentInfo(SegmentVO segmentvO) throws Exception;
	
	/**
	 * 발송대상(세그먼트) 상태 수정(중지,삭제)
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public int updateSegmentStatus(SegmentVO segmentVO) throws Exception;
	
	/**
	 * 권한 있는 DB연결 목록 조회
	 * @param dbConnVO
	 * @return
	 * @throws Exception
	 */
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception;
	
	/**
	 * 발송대상(세그먼트) 정보 조회
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public SegmentVO getSegmentInfo(SegmentVO segmentVO) throws Exception;
}
