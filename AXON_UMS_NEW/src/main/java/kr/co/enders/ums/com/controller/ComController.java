/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.17
 * 설명 : 공통 Controller
 */
package kr.co.enders.ums.com.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import kr.co.enders.ums.com.service.CodeService;
import kr.co.enders.ums.com.vo.CodeVO;
import kr.co.enders.ums.com.vo.DownloadVO;
import kr.co.enders.ums.com.vo.UploadVO;
import kr.co.enders.util.PropertiesUtil;

@Controller
@RequestMapping("/com")
public class ComController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private CodeService codeService;
	
	@Autowired
	private PropertiesUtil properties;
	
	/**
	 * 사용자 목록 조회
	 * @param metaJoinVO
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/getUserList")
	public ModelAndView getUserList(@ModelAttribute CodeVO codeVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("getUserList deptNo = " + codeVO.getDeptNo());
		
		// 사용자 목록 조회
		CodeVO userVO = new CodeVO();
		userVO.setDeptNo(codeVO.getDeptNo());
		userVO.setStatus("000");
		List<CodeVO> userList = null;
		try {
			userList = codeService.getUserList(userVO);
		} catch(Exception e) {
			logger.error("codeService.getUserList error = " + e);
		}
		
		// jsonView 생성
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("userList", userList);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);
		
		return modelAndView;
	}
	
	@RequestMapping(value="/uploadP")
	public String goUploadMain(@ModelAttribute UploadVO uploadVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUpload ext = " + uploadVO.getExt());
		
		model.addAttribute("upload", uploadVO);
		
		return "com/uploadP";
	}
	
	@RequestMapping(value = "/upload")
	public String goUploadProc(MultipartHttpServletRequest multipartRequest, @ModelAttribute UploadVO uploadVO, Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		logger.debug("goUploadProc folder = " + uploadVO.getFolder());
		logger.debug("goUploadProc title = " + uploadVO.getTitle());
		logger.debug("goUploadProc charset = " + uploadVO.getCharset());
		logger.debug("goUploadProc formName = " + uploadVO.getFormName());
		logger.debug("goUploadProc rFileName = " + uploadVO.getrFileName());
		logger.debug("goUploadProc vFileName = " + uploadVO.getvFileName());
		
		// 업로드 폴더
		String folder = uploadVO.getFolder();
		
		// 파일 디렉토리 체크, 없으면 생성
		String addressFileDirStr  = properties.getProperty("FILE.UPLOAD_PATH") + "/" + folder;
		
		logger.debug("goUploadProc addressFileDirStr = " + addressFileDirStr);
		
		File addressFileDir = new File(addressFileDirStr);
		if(!addressFileDir.exists()) {
			addressFileDir.mkdirs();
		}
		
		// 업로드 파일 처리, 파일이름을 yyyyMMddHHmmss_idx 형식으로 변경하여 저장.
		Iterator<String> files = multipartRequest.getFileNames();
		MultipartFile multipartFile = null;
		String oldFileName = null;
		String newFileName = null;
		while(files.hasNext()) {
			multipartFile = multipartRequest.getFile(files.next());
			if(!multipartFile.isEmpty()) {
				oldFileName		= multipartFile.getOriginalFilename();
				String newFileLong	= Long.toString(System.currentTimeMillis());
				newFileName = newFileLong + "-" + oldFileName;
				String fileLocNm	= addressFileDirStr + "/" + newFileName;
				
				logger.debug("goUploadProc oldFileName = " + oldFileName);
				logger.debug("goUploadProc newFileName = " + newFileName);
				
				try {
					File file = new File(fileLocNm);
					multipartFile.transferTo(file);
				} catch(Exception e) {
					
				}
			}
		}

		model.addAttribute("result", "Success");
		model.addAttribute("uploadVO", uploadVO);
		model.addAttribute("oldFileName", oldFileName);
		model.addAttribute("newFileName", newFileName);
		
		return "com/upload";
	}
	
	@RequestMapping(value = "/down")
	public void fileDownload(@ModelAttribute DownloadVO downloadVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("fileDownload downType = " + downloadVO.getDownType());
		
		String fileName = "";
		String filePath = "";
		
		// 파일연동 샘플 다운로드
		if("003".equals(downloadVO.getDownType())) {
			fileName = "sample01.csv";
			filePath = properties.getProperty("FILE.UPLOAD_PATH") + "/sample/" + fileName; 
		
		// 파일연동 업로드한 파일 다운로드
		} else if("002".equals(downloadVO.getDownType())) {
			logger.debug("fileDownload tempFlPath = " + downloadVO.getTempFlPath());
			logger.debug("fileDownload segFlPath = " + downloadVO.getSegFlPath());
			
			fileName = downloadVO.getTempFlPath();
			filePath = properties.getProperty("FILE.UPLOAD_PATH") + "/" + downloadVO.getSegFlPath();
		}
		
		logger.debug("fileDownload fileName = " + fileName);
		logger.debug("fileDownload filePath = " + filePath);
		
		byte fileBytes[] = FileUtils.readFileToByteArray(new File(filePath));
		
		response.setContentType("application/octet-stream");
		response.setContentLength(fileBytes.length);
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(fileName,"UTF-8") + "\";");
		response.setHeader("Content-Trasfer-Encoding", "binary");
		response.getOutputStream().write(fileBytes);
		
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
}