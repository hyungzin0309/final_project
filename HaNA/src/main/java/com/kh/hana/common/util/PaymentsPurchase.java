package com.kh.hana.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PaymentsPurchase extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@PostMapping("/purchase/payments")
	private ResponseEntity<?> doPost(@RequestParam String impUid, @RequestParam String merchantUid, @RequestParam int amountToBePaid) throws ServletException, IOException {
		
		// 1. 결제내역 보내기
		
		// url 설정
		URL url = new URL("https://api.iamport.kr/users/getToken");
		
		// 연결 열기
		HttpURLConnection con = (HttpURLConnection)url.openConnection();
		// 요청 방법 설정
		con.setRequestMethod("POST");
		con.setRequestProperty("Content-Type", "application/json; utf-8");
		// 응답 데이터 형식 지정
		con.setRequestProperty("Accept", "application/json");
		
		// doOUtput 확인
		con.setDoOutput(true);
		
		
		// 요청 본문 생성
		String jsonInputString = "{\"imp_key\": \"3102689863625731\", \"imp_secret\": \"e4568ee8b5be247f55457ea7ae9d453569fc24ed358481bbcfc8ed4fcfefe6ec2a3f114e0988fe40\"}";
		
		try(OutputStream os = con.getOutputStream()){
			byte[] input = jsonInputString.getBytes("utf-8");
			os.write(input, 0, input.length);
		}

		String requestString = "";
		
		StringBuilder responseData = new StringBuilder();
		try(BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
			System.out.println("con.getin@@: " + con.getInputStream());
			String responseLine = null;
			while((responseLine = br.readLine()) != null) {
				responseData.append(responseLine.trim());
				System.out.println("resLIne@" + responseLine);
			}
			requestString = responseData.toString();
		}
		
		// connection 종료
		con.disconnect();
		
		JSONParser jsonParser = new JSONParser();
		String token = "";
		try {
			JSONObject jsonObj = (JSONObject) jsonParser.parse(requestString);
			JSONObject getToken = (JSONObject) jsonObj.get("response");
			System.out.println("getToken@: "+getToken.get("access_token") );
			token = (String) getToken.get("access_token");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		// 2. 검증하기
		
		url = new URL("https://api.iamport.kr/payments/"+impUid);
		
		// 연결 열기
		con = (HttpURLConnection)url.openConnection();
		// 요청 방법 설정
		con.setRequestMethod("GET");
		con.setRequestProperty("Authorization", token);
		
		con.setDoOutput(true);
		
		StringBuilder responseData2 = new StringBuilder();
		try(BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
			System.out.println("con.getin@@: " + con.getInputStream());
			String responseLine = null;
			while((responseLine = br.readLine()) != null) {
				responseData2.append(responseLine.trim());
				System.out.println("resLIne@" + responseLine);
			}
			requestString = responseData2.toString();
		}
		System.out.println("paymentData2 : "+ requestString);
		
		// connection 종료
		con.disconnect();
		
		Map<String, Object> map = new HashMap<>();
		// 값 불러오기
		try {
			JSONObject jsonObj = (JSONObject) jsonParser.parse(requestString);
			JSONObject getRes = (JSONObject) jsonObj.get("response");
			long amount = (long)getRes.get("amount");
			String status = (String) getRes.get("status");
			System.out.println("amount : "+amount + " / status : " + status);
			
			// 검증 후 response
			if(amount == (long)amountToBePaid && status.equals("paid")) {
				map.put("msg", "결제 성공");
			} else {
				map.put("msg", "결제 실패(위변조 데이터)");
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(map);
	
	}
}
