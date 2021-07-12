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


public class CommonSessionInterceptor extends HandlerInterceptorAdapter {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private MainService mainService;

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String contextRoot = request.getContextPath();
		String requestUri = request.getRequestURI();
		
		logger.debug("## preHandle requestUri = " + requestUri);
		
		boolean result = false;
		HttpSession session = request.getSession();
		
		// 사용자 세션 체크
		if(session.getAttribute("NEO_USER_ID") == null || "".equals((String)session.getAttribute("NEO_USER_ID")) || session.getAttribute("USER_PROG_LIST") == null) {
			//session.setAttribute("requestUri", requestUri);
			
			response.sendRedirect(contextRoot + "/lgn/lgnP.ums");
			result = false;
		} else {
			// Disable browser caching
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);

			String topMenuId = (String)request.getParameter("topMenuId");
			if(topMenuId == null || "".equals(topMenuId)) {
				topMenuId = (String)session.getAttribute("topMenuId");
				if(topMenuId == null || "".equals(topMenuId)) {
					topMenuId = "4";
				}
			}
			session.setAttribute("topMenuId", topMenuId);
			
			String uilang = (String)session.getAttribute("NEO_UILANG");
			// TOP 메뉴 조회
			List<MenuVO> menuList = null;
			try {
				menuList = mainService.getTopMenuList(uilang);
			} catch(Exception e) {
				logger.error("mainService.getTopMenuList Error = " + e);
			}
			request.setAttribute("menuList", menuList);
			
			result = true;
		}
		
		return result;
	}

}
