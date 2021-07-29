/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 서비스 구현
 */
package kr.co.enders.ums.ems.cam.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tagfree.util.Constant;
import com.tagfree.util.MimeUtil;

import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.cam.dao.CampaignDAO;
import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.util.PropertiesUtil;
import kr.co.enders.util.StringUtil;

@Service
public class CampaignServiceImpl implements CampaignService {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CampaignDAO campaignDAO;

	@Override
	public List<CampaignVO> getCampaignList(CampaignVO campaignVO) throws Exception {
		return campaignDAO.getCampaignList(campaignVO);
	}

	@Override
	public List<TaskVO> getMailList(TaskVO taskVO) throws Exception {
		return campaignDAO.getMailList(taskVO);
	}

	@Override
	public CampaignVO getCampaignInfo(CampaignVO campaignVO) throws Exception {
		return campaignDAO.getCampaignInfo(campaignVO);
	}

	@Override
	public int insertCampaignInfo(CampaignVO campaignVO) throws Exception {
		return campaignDAO.insertCampaignInfo(campaignVO);
	}

	@Override
	public int updateCampaignInfo(CampaignVO campaingVO) throws Exception {
		return campaignDAO.updateCampaignInfo(campaingVO);
	}

	@Override
	public int updateMailAdmit(TaskVO taskVO) throws Exception {
		int result = 0;
		
		// 캠페인 주업무 승인
		result += campaignDAO.updateTaskStatus(taskVO);
		
		// 캠페인 보조업무 승인
		result += campaignDAO.updateSubTaskStatus(taskVO);
		
		return result;
	}

	@Override
	public List<Vector<String>> mailAliasParser(TaskVO taskVO, List<CodeVO> mergeList, PropertiesUtil properties) throws Exception {
		int inc = 100;

		List<Vector<String>> dataList = new ArrayList<Vector<String>>();
		String composerValue = taskVO.getComposerValue();
		
		String ID = mergeList.get(2).getCdNm();
		
		if(inc >= 100) inc = 10;
		
		String tmpCV = "";
		StringBuffer returnValue = new StringBuffer();
		String TM = Long.toString(System.currentTimeMillis());
		
		try {
			MimeUtil mimeUtil = new MimeUtil();											// com.tagfree.util.MimeUtil 생성
			mimeUtil.setMimeValue(composerValue);										// 작성된 본문 + 포함된 이진 파일의 MIME 값 지정
			mimeUtil.setInCharEncoding("utf-8");
			mimeUtil.setOutCharEncoding("utf-8");
			mimeUtil.setRename(true);													// 파일을 저장 시에 새로운 이름을 생성할 것인지를 설정
			mimeUtil.setHtmlRange(Constant.HTML_INNER_BODY);							// well-form 변환 시 완전한 html 문서를 만들어냄으로
																						// Inner Body나 Outer Body의 값을 가져오기 위해서는 이를 설정해야 한다.
																						// HTML_INNER_BODY : body 태그 제외한 값
																						// HTML_OUTER_BODY : body 태그까지 합친 값
																						// 기본 값 : <html> ~ </html>
			mimeUtil.processDecoding();													// MIME 값의 디코딩 -> 이 때 포함된 파일은 모두 웹 서버에 저장된다.
			composerValue = mimeUtil.getDecodedHtml(false);
			composerValue = StringUtil.repStr(composerValue, "\r\n", "_NEOCR_");

			String strTag = "";				// <a ... <map.. 테그의 처음에서 끝까지 모든 값(<a href.....>내용</a>)
			String tmpHTag = "";
			String temp = "";
			int pos = 0;
			int s_pos = 0;
			int e_pos = 0;
			tmpCV = composerValue;

			String tempValue = "";
			while(true) {
				s_pos = tmpCV.indexOf("<!--NEO__LINKCLICK__START-->");
				if(s_pos != -1) {
					returnValue.append(tmpCV.substring(0, s_pos));

					e_pos = tmpCV.indexOf("<!--NEO__LINKCLICK__END-->");
					if(e_pos != -1) e_pos += 26;

					if(e_pos < s_pos) {
						returnValue.append(tmpCV.substring(0, e_pos));
						tmpCV = tmpCV.substring(e_pos);
						continue;
					}

					strTag = tmpCV.substring(s_pos, e_pos);
					tmpCV = tmpCV.substring(e_pos);

					tempValue ="<A href="+strTag.substring(strTag.lastIndexOf("|")+1, strTag.indexOf("<!--NEO__LINKCLICK__END-->"));

					returnValue.append(tempValue.replaceAll("\"", ""));
				} else {
					returnValue.append(tmpCV);
					break;
				}
			}

			tmpCV = returnValue.toString();

			returnValue = new StringBuffer();

			tmpCV = StringUtil.repStr(tmpCV,"<!--NEO__REJECT__START--><A","<!--NEO__REJECT__CONVERT__START-->");
			tmpCV = StringUtil.repStr(tmpCV,"</A><!--NEO__REJECT__END-->","<!--NEO__REJECT__CONVERT__END-->");

			while( (s_pos = tmpCV.toLowerCase().indexOf("<a ")) != -1) {

				Vector<String> bodyData = new Vector<String>();
				TM = Long.toString(System.currentTimeMillis());
				if(inc >= 100) inc = 10;

				returnValue.append(tmpCV.substring(0, s_pos));

				e_pos = tmpCV.toLowerCase().indexOf("</a>");
				if(e_pos != -1) e_pos += 4;

				if(e_pos < s_pos) {
					returnValue.append(tmpCV.substring(0, e_pos));
					tmpCV = tmpCV.substring(e_pos);
					continue;
				}

				strTag = tmpCV.substring(s_pos, e_pos);
				tmpCV = tmpCV.substring(e_pos);

				// 이미지 인지 텍스트 링크인지 처리
				if(strTag.toLowerCase().indexOf("<img ") != -1) tmpHTag = "000";    // 이미지(000)
				else tmpHTag = "001";                                               // 텍스트(001)
				bodyData.add(tmpHTag);

				// 링크 URL 찾기
				pos = strTag.toLowerCase().indexOf("href=") + 5;
				temp = strTag.substring(pos, strTag.indexOf(">"));
				if(temp.indexOf(" ") != -1) temp = temp.substring(0, temp.indexOf(" "));
				if(temp.charAt(0) == '"' || temp.charAt(0) == '\'') temp = temp.substring(1, temp.length() - 1);

				if(temp.length() < 7 || !temp.substring(0, 7).toLowerCase().equals("http://")) {
					returnValue.append(strTag);
					continue;
				}

				bodyData.add(temp);

				// 링크 내용(이미지 또는 텍스트:a테그에 둘러 싸인 부분)
				tmpHTag = strTag.substring(strTag.indexOf(">") + 1, strTag.lastIndexOf("<"));
				bodyData.add(tmpHTag);
				
				returnValue.append("<!--NEO__LINKCLICK__START-->"+
									StringUtil.repStr(strTag,
												temp,
												properties.getProperty("TRACKING_URL")+
												"?$:RESP_END_DT:$|002|$:"+ID+":$|$:TASK_NO:$|$:SUB_TASK_NO:$|$:DEPT_NO:$|$:USER_ID:$|$:CAMP_TY:$|$:CAMP_NO:$|"+
												TM+
												Integer.toString(inc) +
												"|" +
												temp)+
									"<!--NEO__LINKCLICK__END-->"
									);

				// 번호
				bodyData.add(TM+Integer.toString(inc));
				inc++;
				dataList.add(bodyData);
            }

			// image map 테그 처리
			tmpCV = returnValue.toString() + tmpCV;
			returnValue = new StringBuffer();
			int mapNo = 0;
			String mapNm = "";

			while( (s_pos = tmpCV.toLowerCase().indexOf("<map ")) != -1 ) {
				returnValue.append(tmpCV.substring(0, s_pos));

				e_pos = tmpCV.toLowerCase().indexOf("</map>");
				if(e_pos != -1) e_pos += 6;

				if(e_pos < s_pos) {
					returnValue.append(tmpCV.substring(0, e_pos));
					tmpCV = tmpCV.substring(e_pos);
					continue;
				}

				strTag = tmpCV.substring(s_pos, e_pos);
				tmpCV = tmpCV.substring(e_pos);

				// 이미지 맵 이름 구하는 부분
				mapNm = strTag.substring(strTag.toLowerCase().indexOf("name=")+5, strTag.indexOf(">"));
				if(mapNm.indexOf(" ") != -1) mapNm = mapNm.substring(0, mapNm.indexOf(" "));
				if(mapNm.charAt(0) == '"' || mapNm.charAt(0) == '\'') mapNm = mapNm.substring(1, mapNm.length() - 1);

				strTag = strTag.substring(strTag.indexOf(">") + 1);
				mapNo = 0;

				returnValue.append("<MAP NAME="+mapNm+">");

				while( (s_pos = strTag.toLowerCase().indexOf("<area ")) != -1 ) {
					Vector<String> bodyData = new Vector<String>();
					TM = Long.toString(System.currentTimeMillis());
					if(inc >= 100) inc = 10;
					mapNo++;

					// 이미지 맵 처리
					tmpHTag = "003";       // 이미지 맵
					bodyData.add(tmpHTag);

					// 링크 URL 찾기
					pos = strTag.toLowerCase().indexOf("href=") + 5;
					temp = strTag.substring(pos, strTag.indexOf(">"));
					if(temp.indexOf(" ") != -1) temp = temp.substring(0, temp.indexOf(" "));
					if(temp.charAt(0) == '"' || temp.charAt(0) == '\'') temp = temp.substring(1, temp.length() - 1);

					String strMap = strTag.substring(0,strTag.indexOf(">")+1);

					strTag = strTag.substring(strTag.indexOf(">") + 1);

					if(temp.length() < 7 || !temp.substring(0, 7).toLowerCase().equals("http://")) {
						returnValue.append(strTag);
						continue;
					}
					bodyData.add(temp);

					// 링크 내용
					tmpHTag = mapNm + Integer.toString(mapNo);
					bodyData.add(tmpHTag);

					returnValue.append("<!--NEO__LINKCLICK__START-->"+
										StringUtil.repStr(strMap,
													temp,
													properties.getProperty("TRACKING_URL")+
													"?$:RESP_END_DT:$|002|$:"+ID+":$|$:TASK_NO:$|$:SUB_TASK_NO:$|$:DEPT_NO:$|$:USER_ID:$|$:CAMP_TY:$|$:CAMP_NO:$|"+
													TM+
													Integer.toString(inc) +
													"|" +
													temp) +
										"<!--NEO__LINKCLICK__END-->"
										);
					
					// 번호
					bodyData.add(TM+Integer.toString(inc));
					inc++;
					dataList.add(bodyData);
                }
				returnValue.append("</MAP>");
            }



            temp = StringUtil.repStr(returnValue.toString() + tmpCV, "_NEOCR_", "\r\n");

			temp = StringUtil.repStr(temp,"<!--NEO__REJECT__CONVERT__START-->","<!--NEO__REJECT__START--><a");
			temp = StringUtil.repStr(temp,"<!--NEO__REJECT__CONVERT__END-->","</a><!--NEO__REJECT__END-->");

			composerValue = temp;
			
		} catch(Exception e) {
			logger.error("Mail Alias Parsing Error = " + e);
			composerValue = "";
		}
		
		taskVO.setComposerValue(composerValue);
		
		return dataList;
	}

	@Override
	public int insertMailInfo(TaskVO taskVO, List<AttachVO> attachList, List<LinkVO> linkList) throws Exception {
		int result = 0;
		
		// 메일 주업무 등록
		result += campaignDAO.insertTaskInfo(taskVO);
		
		// 메일 보조업무 등록
		int taskNo = campaignDAO.getTaskNo();
		int subTaskNo = campaignDAO.getSubTaskNo(taskNo);
		taskVO.setTaskNo(taskNo);
		taskVO.setSubTaskNo(subTaskNo);
		result +=campaignDAO.insertSubTaskInfo(taskVO);
		
		// 첨부파일 등록
		if(attachList != null && attachList.size() > 0) {
			for(AttachVO attach:attachList) {
				result +=campaignDAO.insertAttachInfo(attach);
			}
		}
		
		// 링크정보 등록
		if(linkList != null && linkList.size() > 0) {
			for(LinkVO link:linkList) {
				result +=campaignDAO.insertLinkInfo(link);
			}
		}
		
		return result;
	}
}
