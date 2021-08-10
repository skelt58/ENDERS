/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 구현==>시스템 로그관리 서비스 구현
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.service ==> kr.co.enders.ums.sys.log.service
 *               로그인히스토리 외의 함수 제거  나중에 각종 로그 정보 추가해야함 
 */
package kr.co.enders.ums.sys.log.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.sys.log.dao.SystemLogDAO;
import kr.co.enders.ums.sys.log.vo.LoginHistVO;

@Service
public class SystemLogServiceImpl implements SystemLogService {
	@Autowired
	private SystemLogDAO systemLogDAO;
 
	@Override
	public List<LoginHistVO> getLoginHistList(LoginHistVO loginHistVO) throws Exception {
		return systemLogDAO.getLoginHistList(loginHistVO);
	}  
}
