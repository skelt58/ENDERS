/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 코드 조회 서비스
 */
package kr.co.enders.ums.com.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.com.vo.CodeGroupVO;
import kr.co.enders.ums.com.vo.CodeVO;

@Service
public interface CodeService {
	/**
	 * 코드 목록 조회
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getCodeList(CodeVO codeVO) throws Exception;
	
	/**
	 * 코드그룹 정보 조회
	 * @param codeGroupVO
	 * @return
	 * @throws Exception
	 */
	public CodeGroupVO getCodeGrpInfo(CodeGroupVO codeGroupVO) throws Exception;
	
	/**
	 * 타임존 목록 조회
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getTimezoneList(CodeVO codeVO) throws Exception;
	
	/**
	 * 부서 목록 조회
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getDeptList(CodeVO codeVO) throws Exception;
	
	/**
	 * 사용자 목록 조회
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getUserList(CodeVO codeVO) throws Exception;
	
	/**
	 * 권한그룹 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getAuthGroupList() throws Exception;
	
	/**
	 * 프로그램 목록 조회
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getProgramList(CodeVO codeVO) throws Exception;
}
