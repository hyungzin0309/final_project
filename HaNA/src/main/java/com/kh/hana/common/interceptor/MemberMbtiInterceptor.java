package com.kh.hana.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import com.kh.hana.member.model.vo.MemberEntity;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
// 로그인 후 mbti 검사 클릭시 해당 Id Mbtidata 삭제 
public class MemberMbtiInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private SqlSessionTemplate session;
	private String memberId;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberEntity id = (MemberEntity) authentication.getPrincipal();
		memberId = id.getId();

		// memberId가 null이 아니라면 해당 Id 데이터를 바로 delete 해준다
		if (memberId != null) {
			session.delete("mbti.deleteData", memberId);
		}

		return super.preHandle(request, response, handler);
	}

}
