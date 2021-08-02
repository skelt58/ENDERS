/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 서비스 구현
 */
package kr.co.enders.ums.ems.ana.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.ems.ana.dao.AnalysisDAO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Service
public class AnalysisServiceImpl implements AnalysisService {

	@Autowired
	private AnalysisDAO analysisDAO;
	
	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return analysisDAO.getMailList(taskVO);
	}

}
