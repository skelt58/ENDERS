/**
 * 설정 정보 조회를 위한 Utility이다.
 * /WEB-INF/config/properties/ums.properties
 * 
 * @author	Kimsangjin
 * @since	2021-07-02
 */
package kr.co.enders.util;

import java.util.Locale;
import org.springframework.context.support.MessageSourceAccessor;

public class PropertiesUtil {
	
	private MessageSourceAccessor msa;
	
	public void setPropertiesSourceAccessor(MessageSourceAccessor msa){
		this.msa = msa;
	}
	
	public String getProperty(String key){
		return msa.getMessage(key);
	}
	
	public String getProperty(String key, Object[] objs){
		return msa.getMessage(key, objs, Locale.getDefault());
	}
}
