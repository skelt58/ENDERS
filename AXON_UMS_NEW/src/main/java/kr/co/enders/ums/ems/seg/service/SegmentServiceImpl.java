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
import kr.co.enders.ums.ems.sys.vo.DbConnVO;

@Service
public class SegmentServiceImpl implements SegmentService {
	@Autowired
	private SegmentDAO segmentDAO;

	@Override
	public List<SegmentVO> getSegmentList(SegmentVO segmentVO) throws Exception {
		return segmentDAO.getSegmentList(segmentVO);
	}

	@Override
	public int insertSegmentInfo(SegmentVO segmentVO) throws Exception {
		return segmentDAO.insertSegmentInfo(segmentVO);
	}

	@Override
	public List<DbConnVO> getDbConnList(DbConnVO dbConnVO) throws Exception {
		return segmentDAO.getDbConnList(dbConnVO);
	}

	@Override
	public int updateSegmentStatus(SegmentVO segmentVO) throws Exception {
		int result = 0;
		if(segmentVO.getSegNos() != null && "".equals(segmentVO.getSegNos())) {
			String[] segNo = segmentVO.getSegNos().split(",");
			for(int i=0;i<segNo.length;i++) {
				SegmentVO segment = new SegmentVO();
				
				segment.setSegNo(Integer.parseInt(segNo[i]));
				segment.setStatus(segmentVO.getStatus());
				segment.setUpId(segmentVO.getUpId());
				segment.setUpDt(segmentVO.getUpDt());
				
				result += segmentDAO.updateSegmentStatus(segment);
			}
		}
		return result;
	}

}
