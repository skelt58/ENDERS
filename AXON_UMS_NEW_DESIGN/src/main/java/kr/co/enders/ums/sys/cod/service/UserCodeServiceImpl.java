/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : 시스템 서비스 구현==>사용자코드관리 서비스 구현
 * 수정자 : 김준희
 * 수정일시 : 2021.08.10
 * 수정내역 : 패키지명수정 및 sys관련 분리에 의한 소스 변경  kr.co.enders.ums.sys.service ==> kr.co.enders.ums.sys.cod.service
 *               로그인히스토리 외의 함수 제거  나중에 각종 로그 정보 추가해야함 
 */
package kr.co.enders.ums.sys.cod.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.sys.cod.dao.UserCodeDAO;
import kr.co.enders.ums.sys.cod.vo.UserCodeVO;
//import kr.co.enders.ums.sys.cod.vo.UserCodeGroupVO;

@Service
public class UserCodeServiceImpl implements UserCodeService {
	@Autowired
	private UserCodeDAO userCodeDAO;
	
	@Override
	public List<UserCodeVO> getUserCodeList(UserCodeVO userCodeVO) throws Exception {
		return userCodeDAO.getUserCodeList(userCodeVO);
	}

	@Override
	public int insertUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		int result = 0;
		String[] uilang = userCodeVO.getUilang().split(",");
		String[] cdNm = userCodeVO.getCdNm().split(",");
		String[] cdDtl = userCodeVO.getCdDtl().split(",");
		for(int i=0;i<uilang.length;i++) {
			UserCodeVO code = new UserCodeVO();
			code.setUilang(uilang[i]);
			code.setCdGrp(userCodeVO.getCdGrp());
			code.setCd(userCodeVO.getCd());
			code.setCdNm(cdNm[i].trim());
			code.setUseYn(userCodeVO.getUseYn());
			code.setCdDtl(cdDtl[i].trim());
			result += userCodeDAO.insertUserCodeInfo(code);
		}
		return result;
	}

	@Override
	public int updateUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return userCodeDAO.updateUserCodeInfo(userCodeVO);
	}

	@Override
	public int deleteUserCodeInfo(UserCodeVO userCodeVO) throws Exception {
		return userCodeDAO.deleteUserCodeInfo(userCodeVO);
	}
	
}
