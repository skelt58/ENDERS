/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 발송대상(세그먼트)관리 서비스 구현
 */
package kr.co.enders.ums.ems.seg.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.seg.dao.SegmentDAO;
import kr.co.enders.ums.ems.seg.vo.SegmentVO;

@Service
public class SegmentServiceImpl implements SegmentService {
	@Autowired
	private SegmentDAO segmentDAO;

	@Override
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception {
		return segmentDAO.getSegmentList(segmentVO);
	}

}
