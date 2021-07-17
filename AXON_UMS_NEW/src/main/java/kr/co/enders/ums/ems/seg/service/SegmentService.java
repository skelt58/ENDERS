/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 발송대상(세그먼트)관리 서비스 인터페이스
 */
package kr.co.enders.ums.ems.seg.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.seg.vo.SegmentVO;

@Service
public interface SegmentService {
	/**
	 * 발송대상(세그먼트) 목록 조회
	 * @param segmentVO
	 * @return
	 * @throws Exception
	 */
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception;
}
