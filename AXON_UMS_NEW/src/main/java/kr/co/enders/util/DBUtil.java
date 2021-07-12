/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : DB 연결 작업 처리.
 */
package kr.co.enders.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
	
	/**
	 * DB Connection을 생성한다.
	 * @param dbDriver
	 * @param dbUrl
	 * @param loginId
	 * @param loginPwd
	 * @return
	 * @throws Exception
	 */
	public Connection getConnection(String dbDriver, String dbUrl, String loginId, String loginPwd) throws Exception {
		Connection conn = null;
		
		Class.forName(dbDriver);
		conn = DriverManager.getConnection(dbUrl, loginId, loginPwd);
		
		return conn;
	}
}
