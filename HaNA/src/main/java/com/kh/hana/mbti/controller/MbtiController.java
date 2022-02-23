package com.kh.hana.mbti.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.kh.hana.mbti.model.service.MbtiService;
import com.kh.hana.mbti.model.vo.Mbti;
import com.kh.hana.mbti.model.vo.MbtiData;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.member.model.vo.MemberEntity;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mbti")
@Slf4j
public class MbtiController {
	@Autowired
	private MbtiService mbtiService;

	// 메인 페이지
	@GetMapping("/mbti.do")
	public String mbtiMain() {
		return "/mbti/mbtiMain";
	}

	// mbti 문항 불러오기
	@GetMapping("/mbtiList.do")
	public String mbtiList(HttpServletRequest request, Authentication authentication, Model model,
			@RequestParam("cPage") int cPage, MbtiData data) {
		// memberId 가져와서 MbtiData에 넣어주기
		MemberEntity id = (MemberEntity) authentication.getPrincipal();
		data.setMemberId(id.getId());
		// 페이지 처리
		int endPage = cPage + 5;
		Map<String, Object> number = new HashMap<>();
		number.put("cPage", cPage);
		number.put("endPage", endPage);
		List<Mbti> mbtiList = mbtiService.selectMbtiList(number);
		cPage += 6;
		if (data.getNo() != null) {
			int[] no = data.getNo();

			Map<Integer, Integer> resultOfNo = new HashMap<>();
			String memberId = data.getMemberId();

			int i = 0;
			for (int per : no) {
				// input tag의 name 값이 name="memberResult-${list.no}" 이걸로 문항 번호가 달라져서 들어가니까 그 부분을
				// 반복문 통해서 넣어주었고
				// 그 값을 최종으로는 int로 받아야하니까 형변환을 해주었다
				int value = Integer.parseInt(request.getParameter("memberResult-" + per));
				resultOfNo.put(per, value);
			}
			int result = mbtiService.insertList(resultOfNo, memberId);
		}
		model.addAttribute("mbtiList", mbtiList);
		model.addAttribute("cPage", cPage);
		return "mbti/mbtiList";
	}

	// mbti 결과 불러오기
	@GetMapping("/mbtiResult.do")
	public String mbtiResult(HttpServletRequest request, Authentication authentication, Model model, MbtiData data) {
		// memberId 가져와서 MbtiData에 넣어주기
		MemberEntity id = (MemberEntity) authentication.getPrincipal();
		data.setMemberId(id.getId());
		if (data.getNo() != null) {
			int[] no = data.getNo();
			Map<Integer, Integer> resultOfNo = new HashMap<>();
			String memberId = data.getMemberId();

			for (int per : no) {
				// input tag의 name 값이 memberResult 매번 달라서 반복문 통해서 넣어주었다
				int value = Integer.parseInt(request.getParameter("memberResult-" + per));
				resultOfNo.put(per, value);
			}

			mbtiService.insertList(resultOfNo, memberId);
		}
		String memberId = data.getMemberId();
		List<Map<String, Object>> mbtiResult = mbtiService.selectMbtiResult(memberId);
		List<String> memberMbti = new ArrayList<>();
		int num = 0;
		int mbti = 0;
		int I = 0;
		int E = 0;
		int T = 0;
		int F = 0;
		int S = 0;
		int N = 0;
		int P = 0;
		int J = 0;
		for (Map<String, Object> map : mbtiResult) {
			String no = (String) map.get("question_no");
			String result = (String) map.get("result");
			num = Integer.parseInt(String.valueOf(map.get("QUESTION_NO")));
			mbti = Integer.parseInt(String.valueOf(map.get("RESULT")));
			if (num >= 1 && num < 6 && mbti == 1) {
				E += 1;
			}
			if (num >= 1 && num < 6 && mbti == 2) {
				I += 1;
			}
			if (num >= 6 && num < 10 && mbti == 1) {
				I += 1;
			}
			if (num >= 6 && num < 10 && mbti == 2) {
				E += 1;
			}
			if (num >= 10 && num < 15 && mbti == 1) {
				F += 1;
			}
			if (num >= 10 && num < 15 && mbti == 2) {
				T += 1;
			}
			if (num >= 15 && num < 19 && mbti == 1) {
				T += 1;
			}
			if (num >= 15 && num < 19 && mbti == 2) {
				F += 1;
			}
			if (num >= 19 && num < 24 && mbti == 1) {
				N += 1;
			}
			if (num >= 19 && num < 24 && mbti == 2) {
				S += 1;
			}
			if (num >= 24 && num < 28 && mbti == 1) {
				S += 1;
			}
			if (num >= 24 && num < 28 && mbti == 2) {
				N += 1;
			}
			if (num >= 28 && num < 33 && mbti == 1) {
				J += 1;
			}
			if (num >= 28 && num < 33 && mbti == 2) {
				P += 1;
			}
			if (num >= 33 && num < 37 && mbti == 1) {
				P += 1;
			}
			if (num >= 33 && num < 37 && mbti == 2) {
				J += 1;
			}
		}
		if (I > E) {
			memberMbti.add("I");
		} else {
			memberMbti.add("E");
		}
		if (S > N) {
			memberMbti.add("S");
		} else {
			memberMbti.add("N");
		}
		if (T > F) {
			memberMbti.add("T");
		} else {
			memberMbti.add("F");
		}
		if (P > J) {
			memberMbti.add("P");
		} else {
			memberMbti.add("J");
		}
		model.addAttribute("memberMbti", memberMbti);
		model.addAttribute("memberId", memberId);
		return "mbti/mbtiResult";
	}

	// mbti 프로필 반영
	@GetMapping("/addMbtiProfile.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> addMbtiProfile(Authentication authentication, String mbti) {
		Member member = (Member) authentication.getPrincipal();
		String memberId = member.getId();
		Map<String, Object> map = new HashMap<>();
		map.put("memberId", memberId);
		map.put("mbti", mbti);
		int addProfile = mbtiService.addMbtiProfile(map);
		return ResponseEntity.ok(map);
	}
}
