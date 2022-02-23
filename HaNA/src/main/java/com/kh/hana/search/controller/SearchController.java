package com.kh.hana.search.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.hana.group.model.vo.Group;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.search.model.service.SearchService;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;


@RequestMapping("/search")
@Slf4j
@RestController
public class SearchController {
	
	@Autowired
	private SearchService searchService;
	
	@GetMapping("/member")
	public ResponseEntity<List<Member>> selectMemberListBySearch(@RequestParam String keyword){
		try{
			List<Member> list = searchService.selectMemberListBySearch(keyword);
			log.info("list = {}",list);
			return ResponseEntity.ok(list);			
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
	@GetMapping("/group")
	public ResponseEntity<List<Group>> selectGroupListBySearch(@RequestParam String keyword){
		try{
			List<Group> list = searchService.selectGroupListBySearch(keyword);
			log.info("list = {}",list);
			return ResponseEntity.ok(list);			
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
	@GetMapping("/shop")
	public ResponseEntity<List<Member>> selectShopListBySearch(@RequestParam String keyword){
		try{
			List<Member> list = searchService.selectShopListBySearch(keyword);
			log.info("list = {}",list);
			return ResponseEntity.ok(list);			
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}

	@GetMapping("/location")
	public ResponseEntity<List<Map<String,Object>>> selectLocationListBySearch(@RequestParam String keyword){
		try{
			List<Map<String,Object>> list = searchService.selectLocationListBySearch(keyword);
			log.info("list = {}",list);
			return ResponseEntity.ok(list);			
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
	
	@PostMapping("/searchKeywordLog")
	public ResponseEntity<Map<String,Object>> searchKeywordLog(@RequestParam String keyword, @RequestParam String category, @AuthenticationPrincipal Member member){
		Map<String,Object> map = new HashMap<>();
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("keyword",keyword);
			param.put("category",category);
			param.put("member",member);
			int result = searchService.insertSearchKeywordLog(param);
			
			map.put("msg", "검색어 로깅 완료");
			map.put("result", result);
			return ResponseEntity.ok(map);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
}
