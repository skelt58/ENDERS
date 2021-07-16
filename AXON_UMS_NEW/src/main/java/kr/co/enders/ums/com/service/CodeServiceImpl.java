/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 코드 조회 서비스 구현
 */
package kr.co.enders.ums.com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.com.dao.CodeDAO;
import kr.co.enders.ums.com.vo.CodeGroupVO;
import kr.co.enders.ums.com.vo.CodeVO;

@Service
public class CodeServiceImpl implements CodeService {
	@Autowired
	private CodeDAO codeDAO;

	@Override
	public List<CodeVO> getCodeList(CodeVO codeVO) throws Exception {
		return codeDAO.getCodeList(codeVO);
	}
	
	@Override
	public CodeGroupVO getCodeGrpInfo(CodeGroupVO codeGroupVO) throws Exception {
		return codeDAO.getCodeGrpInfo(codeGroupVO);
	}

	@Override
	public List<CodeVO> getTimezoneList(CodeVO code) throws Exception {
		return codeDAO.getTimezoneList(code);
	}

	@Override
	public List<CodeVO> getDeptList(CodeVO codeVO) throws Exception {
		return codeDAO.getDeptList(codeVO);
	}

	@Override
	public List<CodeVO> getAuthGroupList() throws Exception {
		return codeDAO.getAuthGroupList();
	}

	@Override
	public List<CodeVO> getProgramList(CodeVO codeVO) throws Exception {
		return codeDAO.getProgramList(codeVO);
	}

}
