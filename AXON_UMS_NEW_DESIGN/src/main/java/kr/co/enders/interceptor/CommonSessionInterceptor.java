/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 공통 인터셉터 정의(로그인 체크)
 */
package kr.co.enders.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.enders.ums.main.service.MainService;
import kr.co.enders.ums.main.vo.MenuVO;
import kr.co.enders.ums.sys.vo.SysMenuVO;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;


public class CommonSessionInterceptor extends HandlerInterceptorAdapter {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private MainService mainService;
	
	@Autowired
	private PropertiesUtil properties;

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String contextRoot = request.getContextPath();
		String requestUri = request.getRequestURI();
		
		logger.debug("## preHandle requestUri = " + requestUri);
		
		boolean result = false;
		HttpSession session = request.getSession();
		
		// 사용자 세션 체크
		if(session.getAttribute("NEO_USER_ID") == null || "".equals((String)session.getAttribute("NEO_USER_ID"))) {
			if(requestUri.indexOf("/index.ums") >= 0 || requestUri.indexOf("/service.ums") >= 0) {
				response.sendRedirect(contextRoot + "/lgn/lgnP.ums");
			} else {
				response.sendRedirect(contextRoot + "/lgn/timeout.ums");
			}
			result = false;
		} else {
			// Disable browser caching
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			
			// 현재 메뉴 경로 설정(메뉴 클릭시 넘어오는값으로 설정)
			// => 메뉴에서 클릭하지 않고 화면 전환되는 경우는 세션에 남아 있는 값을 사용, 기본 경로 지정은 ums.properties 파일에 설정
			String pMenuId = (String)request.getParameter("pMenuId");
			String menuId = (String)request.getParameter("menuId");
			if(pMenuId == null || "".equals(pMenuId)) {
				pMenuId = (String)session.getAttribute("NEO_P_MENU_ID");
				if(pMenuId == null || "".equals(pMenuId)) {
					if(requestUri.indexOf("/ems/") >= 0) {
						pMenuId = properties.getProperty("MENU.EMS_INIT_P_MENU_ID");
					} else if(requestUri.indexOf("/rns/") >= 0) {
						pMenuId = properties.getProperty("MENU.RNS_INIT_P_MENU_ID");
					} else {
						// 추가 작업 필요
					}
				}
			}
			if(menuId == null || "".equals(menuId)) {
				menuId = (String)session.getAttribute("NEO_MENU_ID");
				if(menuId == null || "".equals(menuId)) {
					if(requestUri.indexOf("/ems/") >= 0) {
						menuId = properties.getProperty("MENU.EMS_INIT_MENU_ID");
					} else if(requestUri.indexOf("/rns/") >= 0) {
						menuId = properties.getProperty("MENU.RNS_INIT_MENU_ID");
					} else {
						// 추가 작업 필요
					}
				}
			}
			session.setAttribute("NEO_P_MENU_ID", pMenuId);
			session.setAttribute("NEO_MENU_ID", menuId);
			
			// 메뉴명 설정
			if(!StringUtil.isNull(request.getParameter("pMenuId"))) {
				SysMenuVO menuInfo = null;
				try {
					menuInfo = mainService.getMenuBasicInfo(menuId);
				} catch(Exception e) {
					logger.debug("mainService.getMenuBasicInfo error =" + e);
				}
				session.setAttribute("NEO_MENU_NM", menuInfo.getMenuNm());
			}
			
			result = true;
		}
		
		return result;
	}

}
