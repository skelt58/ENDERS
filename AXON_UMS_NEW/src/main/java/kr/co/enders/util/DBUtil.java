/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.07
 * 설명 : DB 연결 작업 처리.
 */
package kr.co.enders.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import kr.co.enders.ums.ems.sys.vo.MetaColumnVO;

public class DBUtil {
	Logger logger = Logger.getLogger(this.getClass());
	
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
	
	/**
	 * DB별 테이블 목록을 조회한다.
	 * @param dbTy
	 * @param dbDriver
	 * @param dbUrl
	 * @param loginId
	 * @param loginPwd
	 * @return
	 */
	public List<String> getRealTableList(String dbTy, String dbDriver, String dbUrl, String loginId, String loginPwd) {
		logger.debug("getRealTableList dbTy = " + dbTy);
		List<String> tableList = new ArrayList<String>();
		
		String sql = "";
		Connection conn = null;
		PreparedStatement pstm = null;
		ResultSet rss = null;
		try {
			conn = getConnection(dbDriver, dbUrl, loginId, loginPwd);
			
			if(Code.DB_VENDOR_ORACLE.equals(dbTy)) {	// Oracle
				sql =  "SELECT OBJECT_NAME TABLE_NAME ";
				sql += "  FROM USER_OBJECTS ";
				sql += " WHERE OBJECT_TYPE IN ('TABLE','VIEW') ";
				sql += "   AND NOT OBJECT_NAME LIKE 'NEO_%' ";
				sql += "   AND STATUS = 'VALID' ";
				sql += " ORDER BY OBJECT_NAME ";
			} else if(Code.DB_VENDOR_MSSQL.equals(dbTy)) {		//MSSQL
				sql =  "SELECT A.NAME TABLE_NAME ";
				sql += "  FROM SYSOBJECTS A, SYSUSERS B ";
				sql += " WHERE A.UID = B.UID ";
				sql += "   AND A.TYPE IN ('U','V') ";
				sql += "   AND A.NAME NOT LIKE 'NEO_%' ";
				sql += " ORDER BY A.NAME ";
			} else if(Code.DB_VENDOR_INFORMIX.equals(dbTy)) {	//INFORMIX
				sql =  "SELECT TABNAME TABLE_NAME ";
				sql += "  FROM SYSTABLES ";
				sql += " WHERE TABTYPE IN ('T','V') ";
				sql += "   AND TABNAME NOT LIKE 'NEO_%' ";
				sql += "   AND TABID >= 100 ";
				sql += " ORDER BY TABNAME ";
			} else if(Code.DB_VENDOR_SYBASE.equals(dbTy)) {	//SYBASE
				sql =  "SELECT name TABLE_NAME ";
				sql += "  FROM sysobjects ";
				sql += " WHERE type IN ('U','V') ";
				sql += "   AND name NOT LIKE 'NEO_%' ";
				sql += " ORDER BY name ";
			} else if(Code.DB_VENDOR_MYSQL.equals(dbTy)) {		//MYSQL
				sql =  "SELECT A.NAME TABLE_NAME ";
				sql += "  FROM SYSOBJECTS A, SYSUSERS B ";
				sql += " WHERE A.UID = B.UID ";
				sql += "   AND A.TYPE IN ('U','V') ";
				sql += "   AND A.NAME NOT LIKE 'NEO_%' ";
				sql += " ORDER BY A.NAME ";
			} else if(Code.DB_VENDOR_CUBRID.equals(dbTy)) {		//CUBRID
				sql =  "SELECT class_name AS TABLE_NAME ";
				sql += "  FROM db_class ";
				sql += " WHERE class_name  NOT LIKE 'neo_%' ";
				sql += "  AND class_name NOT LIKE 'db_%' ";
			} else if(Code.DB_VENDOR_UNISQL.equals(dbTy)) {	//UNISQL
			} else if(Code.DB_VENDOR_INGRES.equals(dbTy)) {	//INGRES
			} else if(Code.DB_VENDOR_DB2.equals(dbTy)) {		//DB2
				sql =  "SELECT TABNAME TABLE_NAME ";
				sql += "  FROM SYSCAT.TABLES ";
				sql += " WHERE TABSCHEMA = '" +loginId.toUpperCase() + "' ";
				sql += "   AND TABNAME NOT LIKE 'NEO_%' ";
				sql += " ORDER BY TABNAME ";
			} else if(Code.DB_VENDOR_POSTGRES.equals(dbTy)) {	//POSTGRES
			} else {
				sql = "";
			}
			
			if(Code.DB_VENDOR_MYSQL.equals(dbTy)) {		//MYSQL
				String catalog = "";
				if(dbUrl.indexOf("?") > 0) {
					catalog = dbUrl.substring(0,dbUrl.indexOf("?"));
				}
				catalog = dbUrl.split("/")[dbUrl.split("/").length-1];
				DatabaseMetaData metaData = conn.getMetaData();
				
				rss = metaData.getTables(catalog, loginId, null, new String[]{"TABLE"});
				while(rss.next()) {
					tableList.add(rss.getString("TABLE_NAME").toUpperCase());
				}
			} else {
				pstm = conn.prepareStatement(sql);
				rss = pstm.executeQuery();
				while(rss.next()) {
					tableList.add(rss.getString("TABLE_NAME"));
				}
			}
		} catch(Exception e) {
			System.out.println("getRealTableList error = " + e);
		} finally {
			if(rss != null) try { rss.close(); } catch(Exception ex) {}
			if(pstm != null) try { pstm.close(); } catch(Exception ex) {}
			if(conn != null) try { conn.close(); } catch(Exception ex) {}
		}
		
		return tableList;
	}
	
	public List<MetaColumnVO> getRealColumnList(String dbTy, String dbDriver, String dbUrl, String loginId, String loginPwd, String tblNm) {
		logger.debug("getRealTableList dbTy = " + dbTy);
		List<MetaColumnVO> columnList = new ArrayList<MetaColumnVO>();
		
		String sql = "";
		Connection conn = null;
		PreparedStatement pstm = null;
		ResultSet rss = null;
		try {
			conn = getConnection(dbDriver, dbUrl, loginId, loginPwd);
			
			if(Code.DB_VENDOR_ORACLE.equals(dbTy)) {			//오라클
				sql =  " SELECT TABLE_NAME TBL_NM,          ";
				sql += "		   COLUMN_NAME COL_NM,		";
				sql += "		   DATA_TYPE COL_DATA_TY,	";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "   FROM USER_TAB_COLUMNS			";
				sql += "	 WHERE TABLE_NAME = '" + tblNm + "'";
			} else if(Code.DB_VENDOR_MSSQL.equals(dbTy)) {		//MSSQL
				sql =  " SELECT B.NAME TBL_NM, 				";
				sql += "		   A.NAME COL_NM,			";
				sql += "		   C.NAME COL_DATA_TY,		";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "   FROM SYSCOLUMNS A,				";
				sql += "	       SYSOBJECTS B,			";
				sql += "		   SYSTYPES C				";
				sql += "	 WHERE A.ID = B.ID				";
				sql += "	   AND B.NAME = '" + tblNm + "'	";
				sql += "	   AND A.XTYPE = C.XUSERTYPE";
			} else if(Code.DB_VENDOR_INFORMIX.equals(dbTy)) {	//INFORMIX
				sql =  " SELECT B.TABNAME TBL_NM, 			";
				sql += "		   A.COLNAME COL_NM,		";
				sql += "		   A.COLTYPE COL_DATA_TY,	";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "   FROM SYSCOLUMNS A,				";
				sql += "	       SYSTABLES B				";
				sql += "	 WHERE A.TABID = B.TABID		";
				sql += "	   AND B.TABNAME = '" + tblNm + "'";
			} else if(Code.DB_VENDOR_SYBASE.equals(dbTy)) {	//SYBASE
				sql =  " SELECT B.name TBL_NM, 				";
				sql += "		   A.name COL_NM,			";
				sql += "		   C.name COL_DATA_TY,		";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "   FROM syscolumns A,				";
				sql += "	       sysobjects B,			";
				sql += "		   systypes C				";
				sql += "	 WHERE A.id = B.id				";
				sql += "	   AND B.name = '" + tblNm + "'	";
				sql += "	   AND A.usertype = C.usertype	";
			} else if(Code.DB_VENDOR_MYSQL.equals(dbTy)) {		//MYSQL
				sql =  " SELECT B.NAME TBL_NM, 			";
				sql += "		   A.NAME COL_NM,			";
				sql += "		   C.NAME COL_DATA_TY,		";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "   FROM SYSCOLUMNS A,				";
				sql += "	       SYSOBJECTS B,			";
				sql += "		   SYSTYPES C				";
				sql += "	 WHERE A.ID = B.ID				";
				sql += "	   AND B.NAME = '" + tblNm + "'	";
				sql += "	   AND A.XTYPE = C.XUSERTYPE	";
			} else if(Code.DB_VENDOR_CUBRID.equals(dbTy)) {		//CUBRID
				sql =  " SELECT class_name AS TBL_NM, attr_name AS COL_NM, [DATA_TYPE] AS COL_DATA_TY, '' COL_DATA_TY_JDBC ";
				sql += "	from db_attribute 		     	         ";
				sql += "	 WHERE class_name ='" + tblNm + "'";
			} else if(Code.DB_VENDOR_UNISQL.equals(dbTy)) {	//UNISQL
			} else if(Code.DB_VENDOR_INGRES.equals(dbTy)) {	//INGRES
			} else if(Code.DB_VENDOR_DB2.equals(dbTy)) {		//DB2
				sql =  " SELECT TABNAME TBL_NM,				";
				sql += "   	   COLNAME COL_NM,				";
				sql += "		   TYPENAME COL_DATA_TY,	";
				sql += "		   '' COL_DATA_TY_JDBC		";
				sql += "	  FROM SYSCAT.COLUMNS			";
				sql += "  WHERE TABSCHEMA = '" + loginId.toUpperCase() + "'	";
				sql += "	   AND TABNAME = '" + tblNm + "'";
			} else if(Code.DB_VENDOR_POSTGRES.equals(dbTy)) {	//POSTGRES
			} else {
				sql = "";
			}
			
			
			if(Code.DB_VENDOR_MYSQL.equals(dbTy)) {		//MYSQL
				/*
				String catalog = "";
				if(dbUrl.indexOf("?") > 0) {
					catalog = dbUrl.substring(0,dbUrl.indexOf("?"));
				}
				catalog = dbUrl.split("/")[dbUrl.split("/").length-1];
				DatabaseMetaData metaData = conn.getMetaData();
				
				rss = metaData.getTables(catalog, loginId, null, new String[]{"TABLE"});
				while(rss.next()) {
					tableList.add(rss.getString("TABLE_NAME").toUpperCase());
				}
				*/
			} else {
				pstm = conn.prepareStatement(sql);
				rss = pstm.executeQuery();
				while(rss.next()) {
					MetaColumnVO metaColumn = new MetaColumnVO();
					metaColumn.setTblNm(rss.getString("TBL_NM"));
					metaColumn.setColNm(rss.getString("COL_NM"));
					metaColumn.setColDataTy(rss.getString("COL_DATA_TY"));
					metaColumn.setColDataTyJdbc(rss.getString("COL_DATA_TY_JDBC"));
					
					logger.debug("COL NM = " + rss.getString("COL_NM"));
					
					columnList.add(metaColumn);
				}
			}
		} catch(Exception e) {
			System.out.println("getRealColumnList error = " + e);
		} finally {
			if(rss != null) try { rss.close(); } catch(Exception ex) {}
			if(pstm != null) try { pstm.close(); } catch(Exception ex) {}
			if(conn != null) try { conn.close(); } catch(Exception ex) {}
		}
		
		return columnList;
		
	}
	
	/*
	public static void main(String[] args) {
		DBUtil util = new DBUtil();
		Connection conn = null;
		//Statement stmt = null;
		ResultSet rss = null;
		try {
			conn = util.getConnection("com.mysql.cj.jdbc.Driver","jdbc:mysql://127.0.0.1:3306/UMS?useUnicode=true&characterEncoding=utf8","ums2","amway11!");
			
			//stmt = conn.createStatement();
			
			//rss = stmt.executeQuery("SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE IN ('TABLE','VIEW') AND STATUS = 'VALID' ORDER BY OBJECT_NAME");
			DatabaseMetaData metaData = conn.getMetaData();
			rss = metaData.getTables("UMS", "ums2", null, new String[]{"TABLE"});
			while(rss.next()) {
		         System.out.println("Table name: "+rss.getString("TABLE_NAME"));
		         System.out.println("Table type: "+rss.getString("TABLE_TYPE"));
		         System.out.println("Table schema: "+rss.getString("TABLE_SCHEM"));
		         System.out.println("Table catalog: "+rss.getString("TABLE_CAT"));
		         System.out.println("\n");
			}
			
		} catch(Exception e) {
			System.out.println("error = " + e);
		} finally {
			if(rss != null) try { rss.close(); } catch(Exception e) {}
			//if(stmt != null) try { stmt.close(); } catch(Exception e) {}
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}
	}
	*/
}
