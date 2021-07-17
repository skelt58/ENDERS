/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 발송대상(세그먼트)관리 매퍼
 */
package kr.co.enders.ums.ems.seg.dao;

import java.util.List;

import kr.co.enders.ums.ems.seg.vo.SegmentVO;

public interface SegmentMapper {
	/**
	 * 발송대상(세그먼트) 목록 조회
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception;
}
