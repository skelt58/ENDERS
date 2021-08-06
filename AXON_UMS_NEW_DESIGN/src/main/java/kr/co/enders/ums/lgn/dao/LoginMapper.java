/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 사용자 로그인 매퍼
 */
package kr.co.enders.ums.lgn.dao;

import java.util.List;

import kr.co.enders.ums.sys.vo.SysMenuVO;
import kr.co.enders.ums.sys.vo.UserProgVO;
import kr.co.enders.ums.sys.vo.UserVO;
import kr.co.enders.ums.lgn.vo.LoginHistVO;
import kr.co.enders.ums.lgn.vo.LoginVO;

public interface LoginMapper {
	/**
	 * 사용자 아이디 비밀번호 확인
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	public UserVO isValidUser(LoginVO loginVO) throws Exception;
	
	/**
	 * 사용자 프로그램 사용 권한 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<UserProgVO> getUserProgList(String userId) throws Exception;

	/**
	 * 사용자 로그인 이력 등록
	 * @param histVO
	 * @throws Exception
	 */
	public void insertLoginHist(LoginHistVO histVO) throws Exception;
	
	/**
	 * 사용자 권한 매핑 1단계 메뉴 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<SysMenuVO> getUserMenuLvl1List(String userId) throws Exception;
	
	/**
	 * 사용자 권한 매핑 1단계 메뉴 조회
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<SysMenuVO> getUserMenuLvl2List(String userId) throws Exception;
}
