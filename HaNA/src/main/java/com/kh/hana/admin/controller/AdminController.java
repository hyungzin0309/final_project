package com.kh.hana.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.hana.admin.model.service.AdminService;
import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.group.model.service.GroupService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private AdminService adminService;

	@Autowired
	private GroupService groupService;
	
	@GetMapping("/searchStatistics")
	public void searchStatistics() {}
	
	@GetMapping("/restrictionList")
	public void restrictionList(@RequestParam(defaultValue="1") int cPage, Model model) {
    	int limit = 10;
    	int offset = (cPage -1) * limit;
		
		List<Map<String, Object>> restrictedUserList = adminService.selectRestrictionList(limit, offset);
		
		int numPerPage = 10;
		int totalBoardCount = adminService.selectRestrictionListTotalCount();
		
		String url = "/hana/admin/restrictionList";
		
		String pageBar = HanaUtils.getPagebar(cPage, numPerPage, totalBoardCount, url);
		
		model.addAttribute("pageBar", pageBar);
		model.addAttribute("list", restrictedUserList);
	}
	
	@GetMapping("/restrictionAppealList")
	public void restrictionAppealList(@RequestParam(defaultValue="1") int cPage, Model model) {
    	int limit = 10;
    	int offset = (cPage -1) * limit;
		
		List<Map<String, Object>> appealUserList = adminService.selectAppealList(limit, offset);
		log.info("app userList = {}", appealUserList);
		
		int numPerPage = 10;
		int totalBoardCount = adminService.selectAppealListTotalCount();
		log.info("app totalCount = {}", totalBoardCount);
		
		String url = "/hana/admin/restrictionAppealList";
		
		String pageBar = HanaUtils.getPagebar(cPage, numPerPage, totalBoardCount, url);
		
		model.addAttribute("pageBar", pageBar);
		model.addAttribute("list", appealUserList);
	}
	
	@GetMapping("/reportedHistory")
	public ResponseEntity<?> reportedHistory(@RequestParam String id) {
		log.info("id = {}", id);
		List<Map<String, Object>> historyList = adminService.selectReportedHistory(id);
		log.info("historyList = {}", historyList);
		return ResponseEntity.ok(historyList);
	}
	
	@GetMapping("/acceptAppeal")
	public ResponseEntity<?> acceptAppeal(@RequestParam String id) {
		log.info("id = {}", id);
		int result = adminService.acceptAppeal(id);
		
		return ResponseEntity.ok(result);
	}
	
	

	@GetMapping("/getStatics")
	public ResponseEntity<List<Map<String,Object>>> getStatics(@RequestParam String category, @RequestParam int day){
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("category", category);
			param.put("day", day);
			List<Map<String,Object>> list = adminService.selectSearchStatistics(param);
		
			return ResponseEntity.ok(list);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
	
	@GetMapping("/modifyHashtag")
	public void modifyHashtag(Model model) {
		List<String> list = groupService.selectHashtagList();
		log.info("hashtagList = {}",list);
		model.addAttribute("hashtagList",list);
		
	}
	
	@PostMapping("/addHashtag")
	public String addHashtag(@RequestParam String name) {
		try {
			int result = adminService.insertHashtag(name);
			
			return "redirect:/admin/modifyHashtag";
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
		
	}
	
	@PostMapping("/deleteHashtag")
	public String deleteHashtag(@RequestParam String name) {
		try {
			int result = adminService.deleteHashtag(name);
			log.info("result = {}",result);
			return "redirect:/admin/modifyHashtag";
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}

}
