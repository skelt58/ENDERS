/**
 * Spring 메시지를 추출하기 위한 Utility이다.
 * /WEB-INF/config/message/message.properties
 * 
 * @author	Kimsangjin
 * @since	2021-07-02
 */
package kr.co.enders.util;

import java.util.Locale;

import org.springframework.context.support.MessageSourceAccessor;

public class MessageUtil {
	
	private MessageSourceAccessor msa;
	
	public void setMessageSourceAccessor(MessageSourceAccessor msa){
		this.msa = msa;
	}
	
	public String getMessage(String key){
		return msa.getMessage(key, Locale.getDefault());
	}
	
	public String getMessage(String key, Object[] objs){
		return msa.getMessage(key, objs, Locale.getDefault());
	}	
}
