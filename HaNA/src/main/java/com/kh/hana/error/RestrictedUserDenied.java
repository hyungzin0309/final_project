package com.kh.hana.error;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/error")
public class RestrictedUserDenied {

	@GetMapping("/restrictedUserDenied")
	public String restrictedUserDenied(@AuthenticationPrincipal Member member) {
		log.info("에러감지");
		log.info("memberAUthorities = {}", member.getAuthorities());
		if(!member.getAuthorities().contains("ROLE_USER")) {
			// 제제된 경우 ROLE_USER가 삭제되어 신고유저 제제페이지 이동
			return "forward:/WEB-INF/views/common/error/reportedUserPage.jsp";
		}
		// 일반 403 제제 시 일반 에러페이지
		return "forward:/WEB-INF/views/common/error/forbidden.jsp";
	}
}
