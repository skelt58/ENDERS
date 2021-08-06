/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 메인화면 서비스 인터페이스
 */
package kr.co.enders.ums.main.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.enders.ums.main.vo.MenuVO;
import kr.co.enders.ums.sys.vo.SysMenuVO;

@Service
public interface MainService {
	/**
	 * 상단 메뉴 목록 조회
	 * @param uilang
	 * @return
	 * @throws Exception
	 */
	public List<MenuVO> getTopMenuList(String uilang) throws Exception;
	
	/**
	 * 기본 실행 경로 조회
	 * @param menuId
	 * @return
	 * @throws Exception
	 */
	public SysMenuVO getMenuBasicInfo(String menuId) throws Exception;
}
