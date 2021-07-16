package kr.co.enders.util;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class StringTest {
	public static void main(String[] args) {
//		StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
//		String algorithm = "PBEWithMD5AndDES";
//		String password = "ENDERSUMS";
//		encryptor.setAlgorithm(algorithm);
//		encryptor.setPassword(password);
//		
//		//String newPass = encryptor.encrypt("amway11!");
//		//System.out.println("newPass = " + newPass);
//		
//		String oldPass = encryptor.decrypt("SEJsVP/Jfn5PS7xwa6qz+dNJ6jSPY2eb");
//		System.out.println("oldPass = " + oldPass);
		
//		String enc = EncryptUtil.getBase64EncodedString("enders");
//		String dec = EncryptUtil.getBase64DecodedString(enc);
//		
//		System.out.println("enc = " + enc);
//		System.out.println("enc = " + dec);
//		
//		String encPwd = EncryptUtil.getEncryptedSHA256("ADMIN");
//		System.out.println("encPwd = " + encPwd);
		
		/*
		String dbUrl = "jdbc:mysql://127.0.0.1:3306/UMS?useUnicode=true&characterEncoding=utf8";
		String catalog = "";
		if(dbUrl.indexOf("?") > 0) {
			catalog = dbUrl.substring(0,dbUrl.indexOf("?"));
		}
		catalog = catalog.split("/")[catalog.split("/").length-1];
		
		System.out.println(catalog);
		System.out.println(dbUrl);
		*/
		
		String str = " , ";
		String[] aa = str.split(",");
		System.out.println(aa.length);
		for(int i=0;i<aa.length;i++) {
			System.out.println(aa[i]);
		}
		
	}
	
	
}
