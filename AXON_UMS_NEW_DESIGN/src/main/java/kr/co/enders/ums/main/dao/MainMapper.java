/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 메인화면 매퍼
 */
package kr.co.enders.ums.main.dao;

import java.util.List;

import kr.co.enders.ums.main.vo.MenuVO;
import kr.co.enders.ums.sys.vo.SysMenuVO;

public interface MainMapper {
	/**
	 * 상단 메뉴 목록 조회
	 * @param uilang
	 * @return
	 * @throws Exception
	 */
	public List<MenuVO> getTopMenuList(String uilang) throws Exception;

	/**
	 * 메뉴 기본 정보 조회
	 * @param menuId
	 * @return
	 * @throws Exception
	 */
	public SysMenuVO getMenuBasicInfo(String menuId) throws Exception;
}
