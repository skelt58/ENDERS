/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 메인화면 서비스 구현
 */
package kr.co.enders.ums.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.main.dao.MainDAO;
import kr.co.enders.ums.main.vo.MenuVO;
import kr.co.enders.ums.sys.vo.SysMenuVO;

@Service
public class MainServiceImpl implements MainService {
	@Autowired
	private MainDAO mainDAO;

	@Override
	public List<MenuVO> getTopMenuList(String uilang)  throws Exception {
		return mainDAO.getTopMenuList(uilang);
	}

	@Override
	public SysMenuVO getMenuBasicInfo(String menuId) throws Exception {
		return mainDAO.getMenuBasicInfo(menuId);
	}

}
