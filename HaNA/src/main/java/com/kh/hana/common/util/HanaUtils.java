package com.kh.hana.common.util;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class HanaUtils {

	

	public static String rename(String originalFilename) {
		// 새파일명 생성
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
		DecimalFormat df = new DecimalFormat("000");

		// 확장자명
		String ext = "";
		int dot = originalFilename.lastIndexOf(".");
		if(dot > -1)
			ext = originalFilename.substring(dot);
		
		return sdf.format(new Date()) + df.format(Math.random() * 999) + ext;
	}
	
	
	/**
	 * 
	 * @param cPage
	 * @param numPerPage
	 * @param totalContent
	 * @param url
	 * 
	 * totalPage 전체페이지
	 * pagebarSize 페이지바 크기 5
	 * pageNo
	 * pageStart - pageEnd
	 * 
	 * @return
	 */
	public static String getPagebar(int cPage, int numPerPage, int totalContent, String url) {
		StringBuilder pagebar = new StringBuilder(); 
		url = url + "?cPage="; // pageNo 추가전 상태
		
		final int pagebarSize = 5;
		final int totalPage = (int) Math.ceil((double) totalContent / numPerPage);
		final int pageStart = (cPage - 1) / pagebarSize * pagebarSize + 1;
		int pageEnd = pageStart + pagebarSize - 1;
		pageEnd = totalPage < pageEnd ? totalPage : pageEnd;
		int pageNo = pageStart;
		
		pagebar.append("<nav aria-label=\"Page navigation example\">\n"
				+ "  <ul class=\"pagination justify-content-center\">");
		// [이전]
		if(pageNo == 1) {
			// cPage = 1, 2, 3, 4, 5
			/*
				<li class="page-item disabled">
			      <a class="page-link" href="#" tabindex="-1">Previous</a>
			    </li>
 
			 */
			pagebar.append(" <li class=\"page-item disabled\">\n"
					+ "      <a class=\"page-link\" href=\"#\" tabindex=\"-1\">Previous</a>\n"
					+ "    </li>");
			
		}
		else {
			/*
				<li class="page-item">
			      <a class="page-link" href="#" tabindex="-1">Previous</a>
			    </li>
			 */
			pagebar.append(" <li class=\"page-item \">\n"
					+ "      <a class=\"page-link\" href=\""+url + (pageNo - 1)+"\" tabindex=\"-1\">Previous</a>\n"
					+ "    </li>");

		}
		
		// pageNo
		while(pageNo <= pageEnd) {
			if(pageNo == cPage) {
				pagebar.append("    <li class=\"page-item active\">\n"
						+ "      <a class=\"page-link\" href=\""+url+pageNo+"\">"+pageNo+" <span class=\"sr-only\">(current)</span></a>\n"
						+ "    </li>");
			}
			else {
				pagebar.append("    <li class=\"page-item\"><a class=\"page-link\" href=\""+url+pageNo+"\">"+pageNo+"</a></li>\n"
						);
			}
			
			pageNo++;
		}
		
		
		// [다음]
		if(pageNo > totalPage) {
			pagebar.append(" <li class=\"page-item disabled\">\n"
					+ "      <a class=\"page-link\" href=\"#\" tabindex=\"-1\">Next</a>\n"
					+ "    </li>");
			 
		}

		else {
			pagebar.append(" <li class=\"page-item \">\n"
					+ "      <a class=\"page-link\" href=\""+url + pageNo+"\" tabindex=\"-1\">Next</a>\n"
					+ "    </li>");

		}
		pagebar.append("  </ul>\n"
				+ "</nav>");
		
		return pagebar.toString();
	}

	
	public static String getPagebarAjax(int cPage, int numPerPage, int totalContent, String func) {
		StringBuilder pagebar = new StringBuilder(); 
		
		final int pagebarSize = 5;
		final int totalPage = (int) Math.ceil((double) totalContent / numPerPage);
		final int pageStart = (cPage - 1) / pagebarSize * pagebarSize + 1;
		int pageEnd = pageStart + pagebarSize - 1;
		pageEnd = totalPage < pageEnd ? totalPage : pageEnd;
		int pageNo = pageStart;
		
		pagebar.append("<nav aria-label=\"Page navigation example\">\n"
				+ "  <ul class=\"pagination justify-content-center\">");
		// [이전]
		if(pageNo == 1) {
			pagebar.append(" <li class=\"page-item disabled\">\n"
					+ "      <a class=\"page-link\" href=\"#\" tabindex=\"-1\">Previous</a>\n"
					+ "    </li>");
			
		}
		else {
			pagebar.append(" <li class=\"page-item \">\n"
					+ "      <a class=\"page-link\" href=\"#\" onclick=\""+func+"("+(pageNo-1)+")\" tabindex=\"-1\">Previous</a>\n"
					+ "    </li>");

		}
		
		// pageNo
		while(pageNo <= pageEnd) {
			if(pageNo == cPage) {
				pagebar.append("    <li class=\"page-item active\">\n"
						+ "      <a class=\"page-link\" href=\"#\" onclick=\""+func+"("+pageNo+")\">"+pageNo+"<span class=\"sr-only\">(current)</span></a>\n"
						+ "    </li>");
			}
			else {
				pagebar.append("    <li class=\"page-item\"><a class=\"page-link\" href=\"#\" onclick=\""+func+"("+pageNo+")\">"+pageNo+"</a></li>\n"
						);
			}
			
			pageNo++;
		}
		
		
		// [다음]
		if(pageNo > totalPage) {
			pagebar.append(" <li class=\"page-item disabled\">\n"
					+ "      <a class=\"page-link\" href=\"#\" tabindex=\"-1\">Next</a>\n"
					+ "    </li>");
			 
		}

		else {
			pagebar.append(" <li class=\"page-item \">\n"
					+ "      <a class=\"page-link\" href=\"\" onclick=\""+func+"("+pageNo+") tabindex=\"-1\">Next</a>\n"
					+ "    </li>");

		}
		pagebar.append("  </ul>\n"
				+ "</nav>");
		
		return pagebar.toString();
	}
	
	public static String getPagebarAjax2(int cPage, int numPerPage, int pageBarSize, int totalContentCount) {
		StringBuilder str = new StringBuilder();
		
		int totalPage = (int)Math.ceil((double)totalContentCount/numPerPage);
		int endPage = (int)Math.ceil((double)cPage/pageBarSize)*pageBarSize;
		int startPage = endPage-pageBarSize+1;
		int pageNum = startPage;
		
		// 1. startPage가 1페이지가 아닌 경우 prev만들기
		if(startPage!=1) {
			str.append("<a class='pagebarBtn' data-page='"+(startPage-1)+"'>&nbsp;prev&nbsp;</a>");
		}
		// 2. 숫자만들기 (+ next버튼)
		// 토탈페이지가 엔드페이지보다 큰 경우 -> 숫자 끝까지 + next
		if(totalPage>endPage) {
			while(pageNum<=endPage) {
				if(pageNum!= cPage) {
					str.append("<a class='pagebarBtn' data-page='"+pageNum+"'>&nbsp;"+pageNum+"&nbsp;</a>");
				}
				else {
					str.append("<span class='cPage pagebarBtn'>&nbsp;"+cPage+"&nbsp;</span>");
				}
				pageNum++;
			}
			// next버튼 추가
			str.append("<a class='pagebarBtn' data-page='"+(endPage+1)+"'>&nbsp;next&nbsp;</a>");
		}
		// 토탈페이지가 엔드페이지보다 작거나 같은 경우 -> 토탈페이지까지 (next버튼 x)
		else {
			while(pageNum<=totalPage) {
				if(pageNum!= cPage) {
					str.append("<a class='pagebarBtn' data-page='"+pageNum+"'>&nbsp;"+pageNum+"&nbsp;</a>");
				}
				else {
					str.append("<span class='cPage pagebarBtn'>&nbsp;"+cPage+"&nbsp;</span>");
				}
				pageNum++;
			}
		}
		return str.toString();
	}
}
