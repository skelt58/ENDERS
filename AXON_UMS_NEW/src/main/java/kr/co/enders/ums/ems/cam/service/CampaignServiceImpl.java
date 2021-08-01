/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.22
 * 설명 : 캠페인관리 서비스 구현
 */
package kr.co.enders.ums.ems.cam.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.ems.cam.dao.CampaignDAO;
import kr.co.enders.ums.ems.cam.vo.AttachVO;
import kr.co.enders.ums.ems.cam.vo.CampaignVO;
import kr.co.enders.ums.ems.cam.vo.LinkVO;
import kr.co.enders.ums.ems.cam.vo.TaskVO;
import kr.co.enders.ums.ems.cam.vo.TestUserVO;
import kr.co.enders.util.Code;
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
		result += campaignDAO.updateTaskStatusAdmit(taskVO);
		
		// 캠페인 보조업무 승인
		result += campaignDAO.updateSubTaskStatusAdmit(taskVO);
		
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
				attach.setTaskNo(taskNo);
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

	@Override
	public int updateMailStatus(TaskVO taskVO) throws Exception {
		int result = 0;
		if(!StringUtil.isNull(taskVO.getTaskNos())) {
			String[] taskNo = taskVO.getTaskNos().split(",");
			String[] subTaskNo = taskVO.getSubTaskNos().split(",");
			for(int i=0;i<taskNo.length;i++) {
				TaskVO task = new TaskVO();
				task.setTaskNo(Integer.parseInt(taskNo[i]));
				task.setSubTaskNo(Integer.parseInt(subTaskNo[i]));
				task.setStatus(taskVO.getStatus());
				task.setUpId(taskVO.getUpDt());
				task.setUpDt(taskVO.getUpDt());
				
				result += campaignDAO.updateTaskStatus(task);		// 주업무 업데이트
				result += campaignDAO.updateSubTaskStatus(task);	// 보조업무 업데이트
			}
		}
		
		return result;
	}

	@Override
	public int copyMailInfo(TaskVO taskVO, PropertiesUtil properties) throws Exception {
		int result = 0;
		
		// 기존 주업무 읽기
		TaskVO copyTask = campaignDAO.getTaskInfo(taskVO.getTaskNo());
		
		// Content 파일 복사
		String currDtm = StringUtil.getDate(Code.TM_YMDHMS);
		String newFlPath = copyTask.getContFlPath().substring(0, copyTask.getContFlPath().lastIndexOf("/")+1) + currDtm + ".tmp";
		String oldFullFlPath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + copyTask.getContFlPath();
		String newFullFlPath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + newFlPath;
		
		File oldFile = new File(oldFullFlPath);
		File newFile = new File(newFullFlPath);
		
		FileInputStream input = new FileInputStream(oldFile);
		FileOutputStream output = new FileOutputStream(newFile);
		
		byte[] buff = new byte[1024];
		int read;
		while((read = input.read(buff)) > 0) {
			output.write(buff, 0, read);
			output.flush();
		}
		input.close();
		output.close();
		
		// 복사한 주업무 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
		copyTask.setUserId(taskVO.getUserId());
		copyTask.setExeUserId("");
		copyTask.setDeptNo(taskVO.getDeptNo());
		copyTask.setContFlPath(newFlPath);
		copyTask.setStatus("000");
		copyTask.setRecoStatus("000");
		copyTask.setRegId(taskVO.getRegId());
		copyTask.setRegDt(currDtm);
		copyTask.setTaskNm( copyTask.getTaskNm() + (copyTask.getTaskNm().indexOf(" - [copy]")> 0 ? "": " - [copy]") );
		
		result += campaignDAO.insertTaskInfoForCopy(copyTask);
		
		
		// 신규 등록 업무번호 조회
		int taskNo = campaignDAO.getTaskNo();
		
		// 기존 보조업무 읽기
		TaskVO copySubTask = campaignDAO.getSubTaskInfo(taskVO);
		
		// 복사한 보조업무 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
		copySubTask.setSubTaskNo(1);
		copySubTask.setTaskNo(taskNo);
		copySubTask.setEndDt("");
		copySubTask.setWorkStatus("000");
		copySubTask.setStatus("000");
		
		result += campaignDAO.insertSubTaskInfoForCopy(copySubTask);
		
		// 첨부파일 목록 읽기
		List<AttachVO> copyAttachList = campaignDAO.getAttachList(taskVO.getTaskNo());
		if(copyAttachList != null && copyAttachList.size() > 0) {
			for(AttachVO attach:copyAttachList) {
				
				// 첨부파일 복사
				String newAttachPath = "attach/" + System.currentTimeMillis() + "_" + attach.getAttNm();
				String oldFullAttachPath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + attach.getAttFlPath();
				String newFullAttachPath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + newAttachPath;
				
				File oldAttachFile = new File(oldFullAttachPath);
				File newAttachFile = new File(newFullAttachPath);
				
				FileInputStream inputAttach = new FileInputStream(oldAttachFile);
				FileOutputStream outputAttach = new FileOutputStream(newAttachFile);
				
				buff = new byte[1024];
				while((read = inputAttach.read(buff)) > 0) {
					outputAttach.write(buff, 0, read);
					outputAttach.flush();
				}
				inputAttach.close();
				outputAttach.close();
				
				// 복사한 첨부파일 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
				attach.setAttFlPath(newAttachPath);
				attach.setTaskNo(taskNo);
				
				result += campaignDAO.insertAttachInfo(attach);
			}
		}
		
		return result;
	}

	@Override
	public List<TestUserVO> getTestUserList(String userId) throws Exception {
		return campaignDAO.getTestUserList(userId);
	}

	@Override
	public int insertTestUserInfo(TestUserVO testUserVO) throws Exception {
		return campaignDAO.insertTestUserInfo(testUserVO);
	}

	@Override
	public int updateTestUserInfo(TestUserVO testUserVO) throws Exception {
		return campaignDAO.updateTestUserInfo(testUserVO);
	}

	@Override
	public int deleteTestUserInfo(TestUserVO testUserVO) throws Exception {
		return campaignDAO.deleteTestUserInfo(testUserVO);
	}

	@Override
	public int sendTestMail(TestUserVO testUserVO, HttpSession session) throws Exception {
		int result = 0;
		
		// 기존 주업무 읽기
		TaskVO sendTask = campaignDAO.getTaskInfo(Integer.parseInt(testUserVO.getTaskNos()));
		
		// 테스트발송 주업무 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
		sendTask.setUserId((String)session.getAttribute("NEO_USER_ID"));
		sendTask.setExeUserId((String)session.getAttribute("NEO_USER_ID"));
		sendTask.setDeptNo((int)session.getAttribute("NEO_DEPT_NO"));
		sendTask.setStatus("000");
		sendTask.setRecoStatus("001");
		sendTask.setRegId((String)session.getAttribute("NEO_USER_ID"));
		sendTask.setRegDt(testUserVO.getSendDt()+"00");
		sendTask.setTaskNm(sendTask.getTaskNm() + " - [test]");
		
		result += campaignDAO.insertTaskInfoForTestSend(sendTask);
		
		// 신규 등록 업무번호 조회
		int taskNo = campaignDAO.getTaskNo();
		
		// 기존 보조업무 읽기
		TaskVO taskVO = new TaskVO();
		taskVO.setTaskNo(Integer.parseInt(testUserVO.getTaskNos()));
		taskVO.setSubTaskNo(Integer.parseInt(testUserVO.getSubTaskNos()));
		
		TaskVO sendSubTask = campaignDAO.getSubTaskInfo(taskVO);
		
		// 테스트발송 보조업무 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
		sendSubTask.setTaskNo(taskNo);
		sendSubTask.setSubTaskNo(1);
		sendSubTask.setSendDt(testUserVO.getSendDt());
		sendSubTask.setEndDt("");
		sendSubTask.setWorkStatus("001");
		sendSubTask.setSendTestYn("Y");
		sendSubTask.setSendTestEm(testUserVO.getTestEmail());
		sendSubTask.setSendTestTaskNo(taskVO.getTaskNo());
		sendSubTask.setSendTestSubTaskNo(taskVO.getSubTaskNo());
		
		result += campaignDAO.insertSubTaskInfoForTestSend(sendSubTask);
		
		
		// 첨부파일 목록 읽기
		List<AttachVO> copyAttachList = campaignDAO.getAttachList(taskVO.getTaskNo());
		if(copyAttachList != null && copyAttachList.size() > 0) {
			for(AttachVO attach : copyAttachList) {
				// 복사한 첨부파일 값 설정(설정하지 않은 경우 기존값 사용) 및 등록
				attach.setTaskNo(taskNo);
				
				result += campaignDAO.insertAttachInfo(attach);
			}
		}
		
		return result;
	}

	@Override
	public TaskVO getMailInfo(TaskVO taskVO) throws Exception {
		return campaignDAO.getMailInfo(taskVO);
	}

	@Override
	public List<AttachVO> getAttachList(int taskNo) throws Exception {
		return campaignDAO.getAttachList(taskNo);
	}
}
