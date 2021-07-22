/**
 * 작성자 : 김상진
 * 작성일시 : 2021.07.06
 * 설명 : 문자열 관련 처리 모음
 */
package kr.co.enders.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class StringUtil {
	
	/**
	 * Null 문자열인 경우 0을 반환한다. Null이 아닌 경우 문자열을 숫자로 변환한다.
	 * @param str
	 * @return
	 */
	public static int setNullToInt(String str) {
		if(str == null || "".equals(str)) {
			return 0;
		} else {
			return Integer.parseInt(str);
		}
	}
	
	/**
	 * 전달받은 숫자(i)가 0인 경우 res 값을 반환하고. 0이 아닌 경우 해당 숫자로 변환한다.(받은 값이 없을 경우 1로 세팅하기 위함)
	 * @param str
	 * @return
	 */
	public static int setNullToInt(int i, int res) {
		if(i == 0) {
			return res;
		} else {
			return i;
		}
	}
	
	/**
	 * 대문자로 변환하여 반환한다.
	 * @param str
	 * @return
	 */
	public static String setUpperString(String str) {
		if(str == null) {
			return "";
		} else {
			return str.toUpperCase();
		}
	}
	
	/**
	 * 현재 날짜에서 기간을 계산한 날짜를 지정한 양식(format)으로 반환한다.
	 * durType => D:Date, M:Month, Y:Year<br/>
	 * @param dur
	 * @param durType
	 * @param format
	 * @return
	 */
	public static String getCalcDateFromCurr(int dur, String durType, String format) {
		Date curDate = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(curDate);
		if("D".equals(durType)) {
			cal.add(Calendar.DATE, dur);
		} else if("M".equals(durType)) {
			cal.add(Calendar.MONTH, dur);
		} else if("Y".equals(durType)) {
			cal.add(Calendar.YEAR, dur);
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(cal.getTime());
	}
	
    /**
    *
    * 현재 시간을 읽어온다.
    * @param   int		시간 포맷
	 *					<pre>
    *   				레벨 :  TM_YMDHMS(1) ==> 년월일시분초, TM_MDHMS(2) ==> 월일시분초,
    *          				TM_DHMS(3) ==> 일시분초, TM_HMS(4) ==> 시분초,
    *          				TM_MS(5) ==> 분초,  TM_S(6) ==> 초,
    *          				TM_YMD(7) ==> 년월일, TM_YMDHM(8) ==> 년월일시분
    *					</pre>
    *
    */
   public static String getDate(int level) {
       Calendar cal = Calendar.getInstance();
       
       String Y = Integer.toString(cal.get(Calendar.YEAR));
       String M = lPad(Integer.toString(cal.get(Calendar.MONTH)+1),2,"0");
       String D = lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)),2,"0");
       String H = lPad(Integer.toString(cal.get(Calendar.HOUR_OF_DAY)),2,"0");
       String MI = lPad(Integer.toString(cal.get(Calendar.MINUTE)),2,"0");
       String S = lPad(Integer.toString(cal.get(Calendar.SECOND)),2,"0");
       String MS = lPad(Integer.toString(cal.get(Calendar.MILLISECOND)),4,"0"); 
       
       String retval = "";
       
		switch(level) {
		
			case Code.TM_Y:		//년
					retval = Y;
					break;
			case Code.TM_M:		//월
					retval = M;
					break;
			case Code.TM_D:		//일
					retval = D;
					break;
			case Code.TM_H:		//시
					retval = H;
					break;
			case Code.TM_MI:	//분
					retval = MI;
					break;
			case Code.TM_S:		//초
					retval = S;
					break;
			case Code.TM_YM:	//년월
					retval = Y+M;
					break;
			case Code.TM_YMD:	//년월일
					retval = Y+M+D;
					break;
			case Code.TM_YMDH:	//년월일시
					retval = Y+M+D+H;
					break;
			case Code.TM_YMDHM:	//년월일시분
					retval = Y+M+D+H+MI;
					break;
			case Code.TM_YMDHMS:	//년월일시분초
					retval = Y+M+D+H+MI+S;
					break;
			case Code.TM_MDHMS:		//월일시분초
					retval = M+D+H+MI+S;
					break;
			case Code.TM_DHMS:		//일시분초
					retval = D+H+MI+S;
					break;
			case Code.TM_HMS:		//시분초
					retval = H+MI+S;
					break;
			case Code.TM_MS:		//분초
					retval = MI+S;
					break;
			case Code.TM_YMDHMSM:	//년월일시분초밀리세컨
					retval = Y+M+D+H+MI+S+MS;
					break;
		
		}					
		return retval;
   }
   
	/**
	 * 0 필러
	 * @param		data		해당 데이터
	 * 				size		단윈
	 *				filler		채울값
	 * @return		String		변형문자열
	 */
	public static String lPad(String data, int size, String filler) {
		int csize = data.trim().length();
		if(size == csize) return data;

		String retstr = data;	
		for(int i = 0; i < (size-csize); i++) {
			retstr = "0" + retstr;
		}
		return retstr;
	}
	
	/**
	 * 
	 * 특정날짜의 특정 시간 이전이나 이후의 날짜를 구한다. <br>
	 * 예를 들어 20030210의 7시간 후 날짜는 언제인가 ?
	 * 
	 * @param stand_date
	 *            기준 일자
	 * @param interval
	 *            간격(시간, +시간, -시간)
	 * @return String 날짜(space면 포맷상의 문제)
	 * 
	 */
	public static String getIntervalTime(String stand_date, String interval) {
		return getIntervalTime(stand_date, parseLong(interval));
	}

	/**
	 * 
	 * 특정날짜의 특정 시간 이전이나 이후의 날짜를 구한다. <br>
	 * 예를 들어 20030210의 7시간 후 날짜는 언제인가 ?
	 * 
	 * @param stand_date
	 *            기준 일자
	 * @param interval
	 *            간격(시간, +시간, -시간)
	 * @return String 날짜(space면 포맷상의 문제)
	 * 
	 */
	public static String getIntervalTime(String stand_date, long interval) {
		if (stand_date == null) {
			return "";
		}

		int length = stand_date.length();

		int year, month, day, hour, minute, second;

		String retval = "";

		Calendar cal = null;

		long stand_date_long, interval_long, temp_long;

		try {

			switch (length) {

			case 8:
				year = Integer.parseInt(stand_date.substring(0, 4));
				month = Integer.parseInt(stand_date.substring(4, 6)) - 1;
				day = Integer.parseInt(stand_date.substring(6, 8));

				// 기준 날짜 설정
				cal = Calendar.getInstance();
				cal.clear();
				cal.set(year, month, day);

				// 기준 날짜의 밀리세컨 총수
				stand_date_long = (cal.getTime()).getTime();

				// 간격에 대한 밀리세컨 총수
				interval_long = interval * (60 * 1000);

				temp_long = stand_date_long + interval_long;

				cal.clear();
				cal.setTime(new Date(temp_long));

				retval = Integer.toString(cal.get(Calendar.YEAR))
						+ lPad(Integer.toString(cal.get(Calendar.MONTH) + 1), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)), 2,
								"0");
				break;

			case 10:
				year = Integer.parseInt(stand_date.substring(0, 4));
				month = Integer.parseInt(stand_date.substring(4, 6)) - 1;
				day = Integer.parseInt(stand_date.substring(6, 8));
				hour = Integer.parseInt(stand_date.substring(8, 10));
				minute = 0;

				// 기준 날짜 설정
				cal = Calendar.getInstance();
				cal.clear();
				cal.set(year, month, day, hour, minute);

				// 기준 날짜의 밀리세컨 총수
				stand_date_long = (cal.getTime()).getTime();

				// 간격에 대한 밀리세컨 총수
				interval_long = interval * (60 * 1000);

				temp_long = stand_date_long + interval_long;

				cal.clear();
				cal.setTime(new Date(temp_long));

				retval = Integer.toString(cal.get(Calendar.YEAR))
						+ lPad(Integer.toString(cal.get(Calendar.MONTH) + 1), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)), 2,
								"0")
						+ lPad(Integer.toString(cal.get(Calendar.HOUR_OF_DAY)), 2,
								"0");
				break;

			case 12:
				year = Integer.parseInt(stand_date.substring(0, 4));
				month = Integer.parseInt(stand_date.substring(4, 6)) - 1;
				day = Integer.parseInt(stand_date.substring(6, 8));
				hour = Integer.parseInt(stand_date.substring(8, 10));
				minute = Integer.parseInt(stand_date.substring(10, 12));

				// 기준 날짜 설정
				cal = Calendar.getInstance();
				cal.clear();
				cal.set(year, month, day, hour, minute);

				// 기준 날짜의 밀리세컨 총수
				stand_date_long = (cal.getTime()).getTime();

				// 간격에 대한 밀리세컨 총수
				interval_long = interval * (60 * 1000);

				temp_long = stand_date_long + interval_long;

				cal.clear();
				cal.setTime(new Date(temp_long));

				retval = Integer.toString(cal.get(Calendar.YEAR))
						+ lPad(Integer.toString(cal.get(Calendar.MONTH) + 1), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.HOUR_OF_DAY)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.MINUTE)), 2, "0");
				break;

			case 14:
				year = Integer.parseInt(stand_date.substring(0, 4));
				month = Integer.parseInt(stand_date.substring(4, 6)) - 1;
				day = Integer.parseInt(stand_date.substring(6, 8));
				hour = Integer.parseInt(stand_date.substring(8, 10));
				minute = Integer.parseInt(stand_date.substring(10, 12));
				second = Integer.parseInt(stand_date.substring(12, 14));

				// 기준 날짜 설정
				cal = Calendar.getInstance();
				cal.clear();
				cal.set(year, month, day, hour, minute, second);

				// 기준 날짜의 밀리세컨 총수
				stand_date_long = (cal.getTime()).getTime();

				// 간격에 대한 밀리세컨 총수
				interval_long = interval * (60 * 1000);

				temp_long = stand_date_long + interval_long;

				cal.clear();
				cal.setTime(new Date(temp_long));

				retval = Integer.toString(cal.get(Calendar.YEAR))
						+ lPad(Integer.toString(cal.get(Calendar.MONTH) + 1), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.HOUR_OF_DAY)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.MINUTE)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.SECOND)), 2, "0");
				break;

			case 18:
				year = Integer.parseInt(stand_date.substring(0, 4));
				month = Integer.parseInt(stand_date.substring(4, 6)) - 1;
				day = Integer.parseInt(stand_date.substring(6, 8));
				hour = Integer.parseInt(stand_date.substring(8, 10));
				minute = Integer.parseInt(stand_date.substring(10, 12));
				second = Integer.parseInt(stand_date.substring(12, 14));

				// 기준 날짜 설정
				cal = Calendar.getInstance();
				cal.clear();
				cal.set(year, month, day, hour, minute, second);

				// 기준 날짜의 밀리세컨 총수
				stand_date_long = (cal.getTime()).getTime();

				// 간격에 대한 밀리세컨 총수
				interval_long = interval * (60 * 1000);

				temp_long = stand_date_long + interval_long;

				cal.clear();
				cal.setTime(new Date(temp_long));

				retval = Integer.toString(cal.get(Calendar.YEAR))
						+ lPad(Integer.toString(cal.get(Calendar.MONTH) + 1), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.DAY_OF_MONTH)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.HOUR_OF_DAY)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.MINUTE)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.SECOND)), 2, "0")
						+ lPad(Integer.toString(cal.get(Calendar.MILLISECOND)), 4, "0");
				break;

			default:
				retval = "";

			}
		} catch (Exception e) {
			return "";
		}

		return retval;

	}
	
	/**
	 * 해당 데이터를 long형으로 변경한다(null이거나 space일 경우 0).
	 * 
	 * @param input
	 *            변형할 데이터
	 * @return long 리턴 데이터
	 */
	public static long parseLong(String input) {
		if (input == null || input.equals("")) {
			return 0;
		} else {
			return Long.parseLong(input);
		}
	}
	
	/**
	 * 
	 * 날짜포맷으로 변환한다. <br>
	 * 20010830 --> 2001/08/30 또는 2001-08-30 또는 2001년 08월 30일 로 변환한다.
	 * 
	 * @param datestr
	 *            날짜데이터
	 * @param type
	 *            출력 포맷<br>
	 *            (DT_FMT1(1) --> xxxx/xx/xx, DT_FMT2(2) --> xxxx-xx-xx,
	 *            DT_KOR(3) --> xxxx년 xx월 xx일)
	 * @return String 날짜 출력 형식 변환 데이터
	 * 
	 */
	public static String getFDate(String datestr, int type) {
		if(datestr == null || "".equals(datestr)) {
			return "";
		} else {
			int length = datestr.length();
			String fdate = null;
			switch (type) {
			case Code.DT_FMT1:
				switch (length) {
				case 8:
					fdate = datestr.substring(0, 4);
					fdate += "/";
					fdate += datestr.substring(4, 6);
					fdate += "/";
					fdate += datestr.substring(6, 8);
					break;
				case 12:
					fdate = datestr.substring(0, 4);
					fdate += "/";
					fdate += datestr.substring(4, 6);
					fdate += "/";
					fdate += datestr.substring(6, 8);
					fdate += " ";
					fdate += datestr.substring(8, 10);
					fdate += ":";
					fdate += datestr.substring(10, 12);
					break;
				case 14:
					fdate = datestr.substring(0, 4);
					fdate += "/";
					fdate += datestr.substring(4, 6);
					fdate += "/";
					fdate += datestr.substring(6, 8);
					fdate += " ";
					fdate += datestr.substring(8, 10);
					fdate += ":";
					fdate += datestr.substring(10, 12);
					fdate += " ";
					fdate += datestr.substring(12, 14);
					break;
				default:
					fdate = "";
				}
				break;
			case Code.DT_FMT2:
				switch (length) {
				case 8:
					fdate = datestr.substring(0, 4);
					fdate += "-";
					fdate += datestr.substring(4, 6);
					fdate += "-";
					fdate += datestr.substring(6, 8);
					break;
				case 12:
					fdate = datestr.substring(0, 4);
					fdate += "-";
					fdate += datestr.substring(4, 6);
					fdate += "-";
					fdate += datestr.substring(6, 8);
					fdate += " ";
					fdate += datestr.substring(8, 10);
					fdate += ":";
					fdate += datestr.substring(10, 12);
					break;
				case 14:
					fdate = datestr.substring(0, 4);
					fdate += "-";
					fdate += datestr.substring(4, 6);
					fdate += "-";
					fdate += datestr.substring(6, 8);
					fdate += " ";
					fdate += datestr.substring(8, 10);
					fdate += ":";
					fdate += datestr.substring(10, 12);
					fdate += ":";
					fdate += datestr.substring(12, 14);
					break;
				default:
					fdate = "";
				}
				break;
			case Code.DT_KOR:
				switch (length) {
				case 8:
					fdate = datestr.substring(0, 4);
					fdate += "년 ";
					fdate += datestr.substring(4, 6);
					fdate += "월 ";
					fdate += datestr.substring(6, 8);
					fdate += "일";
					break;
				case 12:
					fdate = datestr.substring(0, 4);
					fdate += "년 ";
					fdate += datestr.substring(4, 6);
					fdate += "월 ";
					fdate += datestr.substring(6, 8);
					fdate += "일 ";
					fdate += datestr.substring(8, 10);
					fdate += "시 ";
					fdate += datestr.substring(10, 12);
					fdate += "분";
					break;
				case 14:
					fdate = datestr.substring(0, 4);
					fdate += "년 ";
					fdate += datestr.substring(4, 6);
					fdate += "월 ";
					fdate += datestr.substring(6, 8);
					fdate += "일 ";
					fdate += datestr.substring(8, 10);
					fdate += "시 ";
					fdate += datestr.substring(10, 12);
					fdate += "분 ";
					fdate += datestr.substring(12, 14);
					fdate += "초";
					break;
				default:
					fdate = "";
				}
				break;
			default:
				fdate = "";
			}
			return fdate;
		}
	}

}
