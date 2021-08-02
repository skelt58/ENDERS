/**
 * 작성자 : 김상진
 * 작성일시 : 2021.08.02
 * 설명 : 통계분석 데이터 처리
 */
package kr.co.enders.ums.ems.ana.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.enders.ums.ems.cam.vo.TaskVO;

@Repository
public class AnalysisDAO implements AnalysisMapper {
	@Autowired
	private SqlSession sqlSessionEms;

	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return sqlSessionEms.getMapper(AnalysisMapper.class).getMailList(taskVO);
	}
	
	
}
