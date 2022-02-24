package com.kh.hana.group.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.group.model.service.GroupService;
import com.kh.hana.group.model.vo.Group;
import com.kh.hana.group.model.vo.GroupBoard;
import com.kh.hana.group.model.vo.GroupBoardComment;
import com.kh.hana.group.model.vo.GroupCalendar;
import com.kh.hana.group.model.vo.GroupMemberList;
import com.kh.hana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/group")
@Slf4j
public class GroupController {

	
	@Autowired
	private GroupService groupService;
	
	@Autowired
	private ServletContext application;

	
	private void getGroupInfo(String groupId, Model model) {
		Group group = groupService.selectOneGroup(groupId);// 그룹정보 가져오기
		log.debug("group = {}", group);
		model.addAttribute(group);
		
		List<Map<String,String>> groupMembers = groupService.selectGroupMemberList(group.getGroupId());
		log.info("groupMembers = {}",groupMembers);
		model.addAttribute("groupMembers",groupMembers);
		model.addAttribute("memberCount",groupMembers.size());
	}
	
	@GetMapping("/groupPage/{groupId}")
	public String groupPage(@PathVariable String groupId, Model model, @AuthenticationPrincipal Member member) {
		getGroupInfo(groupId,model);
		
		List<GroupBoard> groupBoardList = groupService.selectGroupBoardList(groupId);
		log.info("groupBoardList = {}", groupBoardList);
		model.addAttribute("groupBoardList", groupBoardList);
		
		return "group/groupPage";
	}

	@GetMapping("/groupList")
	public void groupList(@AuthenticationPrincipal Member member, Model model) {
		List<Group> groupList = groupService.selectGroupList(member);
		model.addAttribute("groupList",groupList); // 가입된 소모임 리스트
		log.info("loginMember = {}",member);
		log.info("groupList = {}", groupList);
		
    	List<String> list = groupService.selectHashtagList(); // 해시태그 목록
		model.addAttribute("hashtagList",list);
		log.info("list = {}",list);
		
		List<String> likeHashtagList = groupService.selectLikeHashtagList(member);//내가 좋아하는 해시태그 목록
		model.addAttribute("likeHashtagList",likeHashtagList);
		
		List<Group> recommendedGroupList = groupService.selectRecommendedGroupList(member);
		model.addAttribute("recommendedGroupList",recommendedGroupList);
		log.info("recommendedGroupList = {}",recommendedGroupList);
	}
	
	@GetMapping("/createGroupForm")
	public void createGroupForm(Model model) {
		List<String> list = groupService.selectHashtagList();
		model.addAttribute("hashtag",list);
		log.info("list = {}",list);
	}
	
	@PostMapping("/createGroup")
	public String insertGroup(Group group,
		@RequestParam(name="profileImage",required=false)MultipartFile[] profileImage,
		RedirectAttributes redirectAttr) throws IllegalStateException, IOException {
		try{
			log.info("leaderId = {}",group.getLeaderId());
			String saveDirectory = application.getRealPath("/resources/upload/group/profile");
			MultipartFile image = profileImage[0];
			if(!image.isEmpty()) {
				String originalFilename = image.getOriginalFilename();
				String renamedFilename = HanaUtils.rename(originalFilename);
				
				File dest = new File(saveDirectory, renamedFilename);
				log.info("dest = {}", dest);
				Path path = Paths.get(dest.toString()).toAbsolutePath();
				log.info("path = {}", path);
				image.transferTo(path.toFile());
				
				group.setImage(renamedFilename);
			}
			
			int result = groupService.insertOneGroup(group);
			
			redirectAttr.addFlashAttribute("msg", "소모임 등록 성공!");	
			redirectAttr.addFlashAttribute("result", result);	
			return "redirect:/group/groupPage/"+group.getGroupId();
		
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			redirectAttr.addFlashAttribute("msg", "소모임 등록 실패 : 관리자에게 문의하세요.");	
			return "redirect:/group/groupList";
		}
	}

	@GetMapping("/groupBoardForm/{groupId}")
	public String groupBoardForm(@AuthenticationPrincipal Member member, @PathVariable String groupId, Model model){
		List<Map<String,String>> members = groupService.selectGroupMemberList(groupId);
		log.info("members = {}",members);
		model.addAttribute("groupId",groupId);
		model.addAttribute("members",members);
		return "/group/groupBoardForm";
	}
	
	@PostMapping("/enrollGroupBoard")
	public String enrollGroupBoard(GroupBoard groupBoard,
			@RequestParam(name="file", required=false) MultipartFile[] files){
		try {
			log.info("groupBoard = {}",groupBoard);

			List<String> fileList = new ArrayList<>();
			
			for(MultipartFile file : files) {
				if(!file.isEmpty()) {
					String originalFilename = file.getOriginalFilename();
					String renamedFilename = HanaUtils.rename(originalFilename);
					String saveDirectory = application.getRealPath("/resources/upload/group/board");
					
					File dest = new File(saveDirectory,renamedFilename);
					file.transferTo(dest);
					
					fileList.add(renamedFilename);
				}
			}
			
			log.info("fileList = {}",fileList);
			if(!fileList.isEmpty()) {
				String[] fileArray = fileList.toArray(new String[0]);
				groupBoard.setImage(fileArray);
			}
			
			log.info("groupBoard = {}",groupBoard);
			
			int result = groupService.insertGroupBoard(groupBoard);
			
			return "redirect:/group/groupPage/"+groupBoard.getGroupId();
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return "redirect:/group/enrollGroupBoard";
		}
	}

	@GetMapping("/groupBoardDetail/{no}")
	public ResponseEntity<Map<String,Object>> groupBoardDetail(@AuthenticationPrincipal Member loginMember, @PathVariable int no, Model model) {
		Map<String, Object> map = new HashMap<>();

		//게시물 정보
		GroupBoard groupBoard = groupService.selectOneBoard(no);
		log.info("groupBoard = {}",groupBoard);
		//태그멤버
		if(groupBoard.getTagMembers()!=null) {
			List<Member> tagMembers = groupService.selectTagMemberList(groupBoard);
			log.info("tagMembers = {}",tagMembers);
			map.put("tagMembers",tagMembers);
		}
		//좋아요여부
		Map<String,Object> param = new HashMap<>();
		param.put("memberId",loginMember.getId());
		param.put("boardNo", no);
		Map<String,Object> likeLog = groupService.selectOneLikeLog(param);
		boolean isLiked = likeLog == null? false : true;
		log.info("isLiked = {}",isLiked);
		
		map.put("groupBoard",groupBoard);
		map.put("isLiked",isLiked);
		
		return ResponseEntity.ok(map);
	}
	
	@PostMapping("/enrollGroupBoardComment")
	@ResponseBody
	public Map<String,Object> enrollGroupBoardComment(@RequestBody GroupBoardComment groupBoardComment){
		log.info("groupBoardComment = {}",groupBoardComment);
		int result = groupService.insertGroupBoardComment(groupBoardComment);
		
		Map<String,Object> map = new HashMap<>();
		map.put("msg", "댓글 등록 성공");
		map.put("result",result);
		return map;
	}
	
	@GetMapping("/enrollGroupForm")
	public String enrollGroupForm(@RequestParam String groupId, @AuthenticationPrincipal Member member, Model model, RedirectAttributes redirectAttr) {
		Map<String, Object> map = new HashMap<>();
		map.put("groupId", groupId);
		map.put("memberId", member.getId());
		int count = groupService.selectGroupApplyLog(map); // 이미 제출한 가입신청이 있는지 확인
		
		if(count > 0) {
			redirectAttr.addFlashAttribute("msg","이미 가입신청서를 제출한 그룹입니다.");
			return "redirect:/group/groupPage/"+groupId;
		}
		
		model.addAttribute("groupId", groupId);
		return "/group/enrollGroupForm";
	}
	
	@PostMapping("/enrollGroupForm")
	public String enrolledGroupForm(
			@RequestParam Map<String, Object> map,
			Model model) {
		log.info("map = {}", map);
		int result = groupService.insertEnrollGroupForm(map);
		
		String msg = result > 0 ? "가입 신청 완료." : "가입 신청 실패.";
		log.info("msg ={}", msg);
		
		return "redirect:/group/groupPage/"+map.get("groupId");
	}

	
	@GetMapping("/getCommentList/{boardNo}")
	public ResponseEntity<List<GroupBoardComment>> getCommentList(@PathVariable int boardNo){
		log.info("boardNo = {}",boardNo);
		List<GroupBoardComment> list = groupService.selectGroupBoardCommentList(boardNo);
		log.info("list = {}",list);
		return ResponseEntity.ok(list);
	}
	

	@DeleteMapping("/groupBoardCommentDelete/{no}")
	public ResponseEntity<Map<String,Object>> groupBoardCommentDelete(@PathVariable int no) {
		Map<String, Object> map = new HashMap<>();
		try{
			log.info("no = {}",no);
			int result = groupService.deleteBoardComment(no);
			log.info("result = {}",result);
			map.put("msg", "삭제 성공!");
			map.put("result",result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("msg", "삭제 실패, 관리자에게 문의");
		}
		return ResponseEntity.ok(map);
	}
    @GetMapping("/getGroupApplyRequest")
    public ResponseEntity<List<Map<String, Object>>> leaderGetGroupApplyRequest(@AuthenticationPrincipal Member member, @RequestParam String groupId) {
        log.info("groupId ={}", groupId);
        
        List<Map<String, Object>> groupApplyList = groupService.selectGroupApplyList(groupId);
        log.info("groupApplyList ={}", groupApplyList);
        
        return ResponseEntity.ok(groupApplyList);       
    }
	
    @PostMapping("/groupApplyProccess")
    @ResponseBody
    public ResponseEntity<Map<String,Object>> groupApplyProcess(@RequestParam Map<String, Object> map) {
        log.info("no = {}", map.get("no"));
        log.info("groupId = {}", map.get("groupId"));
        log.info("memberId = {}", map.get("memberId"));
        log.info("approvalYn = {}", map.get("approvalYn"));
        //승인(Y)
        int result = 0;
        Map<String,Object> resultMap = new HashMap<>();
        try {
        	if(map.get("approvalYn").equals("Y")) {
        		result = groupService.insertGroupMember(map);  // 그룹 멤버 추가            
        	}
        	//거절(N)
        	else {
        		result = groupService.updateApplyHandled(map); // 처리여부 + 승인여부 업데이트
        	}
        	resultMap.put("msg", "처리 완료");
        }catch(Exception e) {
        	resultMap.put("msg", "처리 실패");
        }
        
        return ResponseEntity.ok(resultMap);
    }
    
    @PostMapping("/deleteGroupBoard")
    public String deleteGroupBoard(@RequestParam int no, @RequestParam String groupId){
    	
    	try{
//    		int result = groupService.deleteGroupBoard(no);
    		log.info("no = {}",no);
    		log.info("groupId = {}",groupId);
    		int result = groupService.deleteGroupBoard(no);
    		
    	}catch(Exception e) {
    		log.error(e.getMessage(),e);
       	}
    	return "redirect:/group/groupPage/"+groupId;
    	
    }
    @PostMapping("/groupBoardModifying")
    public ResponseEntity<Map<String,Object>> groupBoardModifying(@RequestParam int no, @RequestParam String content) {

    	Map<String,Object> param = new HashMap<>();
    	Map<String,Object> resultMap = new HashMap<>();
    	
    	try {
    		log.info("no = {}",no);
    		log.info("content = {}",content);
    		
    		param.put("no", no);
    		param.put("content", content);
    		int result = groupService.updateBoardContent(param);
    		
    		resultMap.put("msg","게시물 수정 성공");
    		resultMap.put("result",result);
    	}catch(Exception e) {
    		log.error(e.getMessage(),e);
    		resultMap.put("msg","게시물 수정 실패");
    	}
    	
    	return ResponseEntity.ok(resultMap);
    	
    }
//    @PutMapping("/groupBoardModifying/{no}")
//    public ResponseEntity<Map<String,Object>> groupBoardModifying(@PathVariable int no, @RequestBody String content) {
//    	Map<String,Object> param = new HashMap<>();
//    	Map<String,Object> resultMap = new HashMap<>();
//    	
//    	try {
//    		log.info("no = {}",no);
//    		log.info("content = {}",content);
//    		
//    		param.put("no", no);
//    		param.put("content", content);
//    		int result = groupService.updateBoardContent(param);
//    		
//    		resultMap.put("msg","게시물 수정 성공");
//    		resultMap.put("result",result);
//    	}catch(Exception e) {
//    		log.error(e.getMessage(),e);
//    		resultMap.put("msg","게시물 수정 실패");
//    	}
//    	
//    	return ResponseEntity.ok(resultMap);
//    }

	@DeleteMapping("/unlike/{no}")
	public ResponseEntity<Map<String,Object>> unlike(@PathVariable int no, @AuthenticationPrincipal Member member) {
		Map<String,Object> map = new HashMap<>();
		
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",member.getId());
			param.put("boardNo",no);
			map.put("memberId",member.getId());
			map.put("boardNo",no);
			
			int result = groupService.deleteLikeLog(param);
			
			map.put("msg", "unlike 성공");
			map.put("result", result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("result", "unlike 실패");
		}
		
		
		return ResponseEntity.ok(map);
	}
    
    @GetMapping("/groupMemberList/{groupId}")
    public String leaderGroupMemberList(@AuthenticationPrincipal Member member, @PathVariable String groupId, Model model){
    	log.info("groupId ={}", groupId);
    	
    	List<Map<String,String>> groupMembers = groupService.selectGroupMemberList(groupId);
    	log.info("groupMembers = {}", groupMembers);
    	
    	model.addAttribute("groupMembers", groupMembers);
    	model.addAttribute("groupId",groupId);
    	return "/group/groupMemberList";
    }
    
	@PostMapping("/like")
	public ResponseEntity<Map<String,Object>> like(@RequestParam int no, @AuthenticationPrincipal Member member){
		Map<String,Object> map = new HashMap<>();
		
		try {
			log.info("no = {}",no);
			log.info("member = {}",member);
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",member.getId());
			param.put("boardNo",no);
			int result = groupService.insertLikeLog(param);
			
			map.put("msg", "like 성공");
			map.put("result", result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("result", "like 실패");
		}
		
		
		return ResponseEntity.ok(map);
	}
	
	@GetMapping("/getLikeCount/{no}")
	public ResponseEntity<Map<String,Object>> getLikeCount(@PathVariable int no){
		Map<String,Object> map = new HashMap<>();
		Map<String,Object> param = new HashMap<>();
		
		param.put("no",no);
		int likeCount = groupService.selectLikeCount(param);
		map.put("likeCount",likeCount);
		
		return ResponseEntity.ok(map);
	}
	
	@GetMapping("/groupCalendar/{groupId}")
	public String groupCalendar(@PathVariable String groupId, Model model) {
		getGroupInfo(groupId,model);
		return "/group/groupCalendar";
	}
	
	@PostMapping("/saveCalendarData/{groupId}")
	public ResponseEntity<Map<String,Object>> saveCalendarData(@RequestBody Map<String,Object> param[], @PathVariable String groupId) {
		Map<String,Object> map = new HashMap<>();
		
		// 1. 기존 데이터 초기화
		log.info("groupId = {}",groupId);
		int result = groupService.deleteAllCalendar(groupId);
		// param 배열이 비어있지 않으면
		if(param.length!=0) {
			log.info("param = {}",param);
			for(Map<String,Object> p : param) {
				p.put("groupId",groupId);
				result = groupService.insertCalendarData(p);
			}
		}
		return ResponseEntity.ok(map);
	}
	
	@GetMapping("/getCalendarData/{groupId}")
	public ResponseEntity<GroupCalendar[]> getCalendarData(@PathVariable String groupId){
		log.info("groupId = {}",groupId);
		List<GroupCalendar> list = groupService.selectCalendarData(groupId);
		GroupCalendar events[] = list.toArray(new GroupCalendar[list.size()]);
		log.info("events = {}",events);
		return ResponseEntity.ok(events);
	}

	@PostMapping("/deleteCalendarData/{groupId}")
	public ResponseEntity<Map<String,Object>> deleteCalendarData(@RequestBody Map<String,Object> param, @PathVariable String groupId){
		Map<String,Object> map = new HashMap<>();
		int result = 0;
		try {
			param.put("groupId", groupId);
			log.info("param = {}",param);
			result = groupService.deleteCalendarData(param);
			map.put("msg", "일정 삭제 성공");
			map.put("result", result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			
			map.put("msg", "일정 삭제 실패");
			map.put("result", result);
		}
		return ResponseEntity.ok(map);
	}
	
	
	@PostMapping(value = "/deleteGroupMember")
	public String deleteGroupMember (
			@RequestParam String memberId,
			@RequestParam String groupId) {
		int result = 0;
		try {			
			log.info("memberId ={}", memberId);
			log.info("groupId ={}", groupId);
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",memberId);
			param.put("groupId",groupId);
			result = groupService.deleteGroupMember(param);
			String msg = result > 0 ? "회원 탈퇴 성공" : "회원 탈퇴 실패";
			log.info("msg ={}", msg);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
		
		return "redirect:/group/groupMemberList/"+groupId;
	}
	
	@GetMapping("/searchLocation")
	public String searchLocation (GroupBoard groupBoard, Model model) {
		List<GroupBoard> groupBoardList = groupService.selectGroupBoardListByLocation(groupBoard);
		log.info("groupBoardList = {}", groupBoardList);
		model.addAttribute("groupBoardList", groupBoardList);
		GroupBoard locaInfo = groupBoard;
		model.addAttribute("locaInfo",locaInfo);
		return "/group/locationBoardPage";
	}
	
	// 등급 수정
		@PostMapping("/updateGroupMemberLevel")
		public String updateGroupGrade (String groupId, String memberId, String currentLevel, String updateLevel) {
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("groupId", groupId);
			param.put("memberId", memberId);
			param.put("updateLevel", updateLevel); //현재 레벨
			param.put("currentLevel", currentLevel);// 바꿀 레벨 
			
			int result = groupService.updateGroupMemberLevel(param);

			String msg = result > 0 ? "등급 변경 성공" : "등급 변경 실패";
			log.info("msg ={}", msg);
			
			return "redirect:/group/groupMemberList/"+groupId;
		}
		
		
	@GetMapping("/groupSetting/{groupId}")
	public String leaderGroupSetting(@AuthenticationPrincipal Member member, @PathVariable String groupId, Model model) {
		log.info("groupSetting groupId = {}", groupId);
		Group group = groupService.selectGroupInfo(groupId);
    	log.info("groupInfo ={}", group);
    	model.addAttribute(group);
    	List<String> list = groupService.selectHashtagList();
		model.addAttribute("hashtagList",list);
		log.info("list = {}",list);
    	return "/group/groupSetting";
	}
	
	@PostMapping("/groupUpdate")
	public String groupUpdate(Group group, @RequestParam MultipartFile upFile,
								RedirectAttributes redirectAttr) {
		String newProfile = upFile.getOriginalFilename();
		
		if(!newProfile.equals("")) {
			String saveDirectory = application.getRealPath("/resources/upload/group/profile");
			File file = new File(saveDirectory, group.getImage());
			boolean bool = file.delete();
			log.info("파일삭제여부 = {}", bool);
			
			String renamdeFilename = HanaUtils.rename(newProfile);
			File regFile = new File(saveDirectory, renamdeFilename);
			
			try {
				upFile.transferTo(regFile);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			group.setImage(renamdeFilename);
		}
		
		int result = groupService.updateGroup(group);
		
		String msg = result > 0 ? "프로필 편집 성공" : "프로필 편집 실패";
		redirectAttr.addFlashAttribute("msg",msg);
		log.info("msg ={}", msg);
		
		return "redirect:/group/groupSetting/"+group.getGroupId();
	}
	
	// 프로필 이미지만 수정 (+버튼)
	@PostMapping("/profileImage")
	public String profileImage(Group group, @RequestParam MultipartFile upFile) {
		String newProfile = upFile.getOriginalFilename();
		
		if(!newProfile.equals("")) {
			String saveDirectory = application.getRealPath("/resources/upload/group/profile");
			File file = new File(saveDirectory, group.getImage());
			boolean bool = file.delete();
			log.info("파일삭제여부 = {}", bool);
			
			String renamdeFilename = HanaUtils.rename(newProfile);
			File regFile = new File(saveDirectory, renamdeFilename);
			
			try {
				upFile.transferTo(regFile);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			group.setImage(renamdeFilename);
		}
		
		int result = groupService.profileImage(group);
		String msg  = result > 0 ? "프로필 사진 업로드 성공" : "프로필 사진 업로드 실패";
		log.info("msg ={}", msg);
		log.info("groupId={}", group.getGroupId());
		return "redirect:/group/groupPage/"+group.getGroupId();
	}
	
	@GetMapping("/groupStatistic/{groupId}")
	public String adminGroupStatistic(@AuthenticationPrincipal Member member, @PathVariable String groupId, Model model) {
		model.addAttribute("groupId",groupId);
		return "/group/groupStatistic";
	}
	
	@GetMapping("/getVisitGraph/{groupId}")
	public ResponseEntity<List<Map<String,Object>>> getVisitGraph(
			@PathVariable String groupId,
			@RequestParam int day){
		Map<String,Object> param = new HashMap<>();
		param.put("groupId",groupId);
		param.put("day",day);
		List<Map<String,Object>> list = groupService.selectVisitCountList(param);
		log.info("list = {}",list);
		return ResponseEntity.ok(list);
	}
	
	@GetMapping("/getCommentGraph/{groupId}")
	public ResponseEntity<List<Map<String,Object>>> getCommentGraph(@PathVariable String groupId, @RequestParam int day){
		Map<String,Object> param = new HashMap<>();
		param.put("groupId",groupId);
		param.put("day",day);
		List<Map<String,Object>> list = groupService.selectCommentCountList(param);
		log.info("list = {}",list);
		return ResponseEntity.ok(list);
	}
	
	@GetMapping("/getLikeGraph/{groupId}")
	public ResponseEntity<List<Map<String,Object>>> getLikeGraph(
			@PathVariable String groupId,
			@RequestParam int day){
		Map<String,Object> param = new HashMap<>();
		param.put("groupId",groupId);
		param.put("day",day);
		List<Map<String,Object>> list = groupService.selectLikeCountList(param);
		log.info("list = {}",list);
		return ResponseEntity.ok(list);
	}
	
	@PostMapping("/addHashtag")
	public ResponseEntity<Map<String,Object>> addHashtag(@RequestParam String name, @AuthenticationPrincipal Member member){
		Map<String,Object> param = new HashMap<>();
		param.put("member",member);
		param.put("name", name);
		int result = groupService.insertMemberLikeHashtag(param);
		Map<String,Object> map = new HashMap<>();
		map.put("msg","데이터베이스 처리 완료");
		map.put("result",result);
		return ResponseEntity.ok(map);
	}
	
	@PostMapping("/deleteHashtag")
	public ResponseEntity<Map<String,Object>> deleteHashtag(@RequestParam String name, @AuthenticationPrincipal Member member){
		Map<String,Object> param = new HashMap<>();
		param.put("member",member);
		param.put("name", name);
		int result = groupService.deleteMemberLikeHashtag(param);
		Map<String,Object> map = new HashMap<>();
		map.put("msg","데이터베이스 처리 완료");
		map.put("result",result);
		return ResponseEntity.ok(map);
	}
	
	@PostMapping("/deleteGroup")
	public String deleteGroup (@RequestParam String groupId) {
		
		log.info("groupId ={}", groupId);
		int result = 0;
		result = groupService.deleteGroup(groupId);
		String msg = result > 0 ? "그룹 삭제 성공" : "그룹 삭제 실패";
		
		return "redirect:/group/groupList";
	}
	
	@PostMapping("/leaveGroup")
	public String leaveGroup (@RequestParam String memberId, @RequestParam String groupId) {
		
	int result = 0;
	
	try {			
		log.info("memberId ={}", memberId);
		log.info("groupId ={}", groupId);
		Map<String,Object> param = new HashMap<>();
		param.put("memberId",memberId);
		param.put("groupId",groupId);
		result = groupService.deleteGroupMember(param);
		String msg = result > 0 ? "회원 탈퇴 성공" : "회원 탈퇴 실패";
		log.info("msg ={}", msg);
		
	}catch(Exception e) {
		log.error(e.getMessage(),e);
		throw e;
	}
		return "redirect:/group/groupList";
	}
	
	@GetMapping("/checkIdDuple")
	public ResponseEntity<Map<String,Object>> checkIdDuple(@RequestParam String id){
		Map<String,Object> map = new HashMap<>();
		try {
			int result = groupService.selectOneId(id);
			map.put("result", result);
			return ResponseEntity.ok(map);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			throw e;
		}
	}
	
	@GetMapping("/searchHashtag/{hashtag}")
	public String searchHashtag(@PathVariable String hashtag,Model model) {
		List<GroupBoard> groupBoardList = groupService.selectGroupBoardListByHashtag(hashtag);
		log.info("groupBoardList = {}", groupBoardList);
		model.addAttribute("groupBoardList", groupBoardList);
		
		model.addAttribute("hashtag",hashtag);
		return "/group/hashtagBoardPage";
	}
	

	
	@GetMapping("/getGroupRanking/visit")
	public ResponseEntity<Map<String,Object>> getGroupRankingByVisit(@RequestParam(value="hashtag[]", required=false) String[] hashtag, int cPage){
		Map<String, Object> param = new HashMap<>();
		
		// 그룹 리스트
		int limit = 6;
		int offset = (cPage-1)*limit;
		int pagebarSize = 5;
		
		param.put("limit",limit);
		param.put("offset",offset);
		if(hashtag!=null) {
			param.put("hashtag", hashtag);			
		}
		
		List<Map<String,Object>> rankingGroupList = groupService.selectGroupListByVisitCount(param);
		log.info("list = {}",rankingGroupList);
		
		// 페이지 바
		int totalContent = 0;
		if(hashtag == null) {
			totalContent = groupService.selectAllGroupCount();			
		}else {
			totalContent = groupService.selectAllGroupCountByHashtag(param);
		}
		String pagebar = HanaUtils.getPagebarAjax2(cPage,limit,pagebarSize,totalContent);
		
		Map<String,Object> map = new HashMap<>();
		map.put("rankingGroupList", rankingGroupList);
		map.put("pagebar", pagebar);
		
		return ResponseEntity.ok(map);
	}
	@GetMapping("/getGroupRanking/member")
	public ResponseEntity<Map<String,Object>> getGroupRankingByMember(@RequestParam(value="hashtag[]", required=false) String[] hashtag, int cPage){
		Map<String, Object> param = new HashMap<>();
		// 그룹 리스트
		int limit = 6;
		int offset = (cPage-1)*limit;
		int pagebarSize = 5;
		
		param.put("limit",limit);
		param.put("offset",offset);
		if(hashtag!=null) {
			param.put("hashtag", hashtag);			
		}
		
		List<Map<String,Object>> rankingGroupList = groupService.selectGroupListByMemberCount(param);
		log.info("list = {}",rankingGroupList);
		
		// 페이지 바
		int totalContent = 0;
		if(hashtag == null) {
			totalContent = groupService.selectAllGroupCount();			
		}else {
			totalContent = groupService.selectAllGroupCountByHashtag(param);
		}
		String pagebar = HanaUtils.getPagebarAjax2(cPage,limit,pagebarSize,totalContent);
		
		Map<String,Object> map = new HashMap<>();
		map.put("rankingGroupList", rankingGroupList);
		map.put("pagebar", pagebar);
		
		return ResponseEntity.ok(map);
	}
	
	@GetMapping("/getGroupRanking/apply")
	public ResponseEntity<Map<String,Object>> getGroupRankingByApply(@RequestParam(value="hashtag[]", required=false) String[] hashtag, int cPage){
		Map<String, Object> param = new HashMap<>();
		// 그룹 리스트
		int limit = 6;
		int offset = (cPage-1)*limit;
		int pagebarSize = 5;
		
		param.put("limit",limit);
		param.put("offset",offset);
		if(hashtag!=null) {
			param.put("hashtag", hashtag);			
		}
		
		List<Map<String,Object>> rankingGroupList = groupService.selectGroupListByApplyCount(param);
		log.info("list = {}",rankingGroupList);
		
		// 페이지 바
		int totalContent = 0;
		if(hashtag == null) {
			totalContent = groupService.selectAllGroupCount();			
		}else {
			totalContent = groupService.selectAllGroupCountByHashtag(param);
		}
		String pagebar = HanaUtils.getPagebarAjax2(cPage,limit,pagebarSize,totalContent);
		
		Map<String,Object> map = new HashMap<>();
		map.put("rankingGroupList", rankingGroupList);
		map.put("pagebar", pagebar);
		
		return ResponseEntity.ok(map);
	}
	
	
}


