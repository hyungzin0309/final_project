 package com.kh.hana.member.controller;

 
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.member.model.service.MemberService;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.BoardComment;
import com.kh.hana.member.model.vo.Follower;
import com.kh.hana.member.model.vo.FollowingRequest;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.Shop;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member")
@Slf4j
@SessionAttributes({"publicProfile"})
public class MemberController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired
	private ServletContext application;
	
	@GetMapping("/login")
	public void loginMain() {
		
	}
	
	@GetMapping("/memberEnrollMain")
	public void memberEnrollMain() {
		
	}
	
	@PostMapping("/memberEnroll")
	public String memberEnroll(Member member, @RequestParam(name="pictureFile") MultipartFile upFile, RedirectAttributes redirectAttr) {
		
		log.info("member = {}", member);
		
		String password = member.getPassword();
		String encodedPassword = bcryptPasswordEncoder.encode(password);
		member.setPassword(encodedPassword);
		
		if(!upFile.getOriginalFilename().equals("")) {
			String originalFilename = upFile.getOriginalFilename();
			String renamedFilename = HanaUtils.rename(originalFilename);
			
			String saveDirectory = application.getRealPath("/resources/upload/member/profile");
			
			File saveImg = new File(saveDirectory, renamedFilename);
			try {
				upFile.transferTo(saveImg);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			
			member.setPicture(renamedFilename);					
		}
		
		int result = memberService.memberEnroll(member);
		
		redirectAttr.addFlashAttribute("msg", result > 0 ? "회원가입에 성공했습니다." : "회원가입에 실패했습니다.");
//		if(member.getAccountType() == 1) {
//			redirectAttr.addFlashAttribute("shopGuide", )
//		}
		return "redirect:/member/login";					
	}
	
	@GetMapping("/{view}/{id}")
	public String memberView(@PathVariable String id, @PathVariable String view, Model model,Authentication authentication) {
		//following 수 조회
		int followingCount = memberService.countFollowing(id);
		log.info("followingCount = {}", followingCount);
		model.addAttribute("followingCount", followingCount);
		
		//follower 수 조회
		int followerCount = memberService.countFollower(id);
		log.info("followerCount = {}", followerCount);
		model.addAttribute("followerCount", followerCount);
		
		//정보 가져오기
		Member member = memberService.selectOneMember(id);
		log.info("member={}", member);
		model.addAttribute("member", member);
		
		//게시글 목록 가져오기
		List<Board> boardList = memberService.selectBoardList(id);
		log.info("boardList = {}", boardList);
		
		model.addAttribute("boardList", boardList);
		
		//친구라면 
		 Member loginMember = (Member) authentication.getPrincipal();
		 String loginMemberId = loginMember.getId();
		 log.info("id={}",id);
		 log.info("loginMemberId={}",loginMemberId);
		 
		 Map<String, Object> map = new HashMap<>();
		 map.put("id", id);
		 map.put("loginMemberId", loginMemberId);
		 
		 int isFriend = memberService.checkFriend(map);
		 log.info("isFriend={}", isFriend);
		 model.addAttribute("isFriend", isFriend);
		 
		 //내가 팔로우했는가
		 int isFollow = memberService.checkFollow(map);
		 log.info("isFollow={}", isFollow);
		 model.addAttribute("isFollow", isFollow);
		 
		 //비공개계정에 요청중인지
		 int isRequest = memberService.isRequestFriend(map);
		 log.info("isRequest = {}", isRequest);
		 model.addAttribute("isRequest", isRequest);
		 
		//친구요청 유무 확인
		 int request = memberService.followingRequest(map);
		 log.info("request={}", request);
		 model.addAttribute("request", request);
		
		// 업체인 경우 shop 정보 + 리뷰 게시글 가져오기
		if(member.getAccountType() == 0) {
			Shop shopInfo = memberService.selectOneShopInfo(id);
			log.info("shopInfo = {}", shopInfo);
			model.addAttribute("shopInfo", shopInfo);
			
			List<Board> reviewList = memberService.selectShopReviewList(shopInfo.getId());
			model.addAttribute("reviewList", reviewList);
			log.info("reviewLIst = {}", reviewList);
			
			return "/member/"+"shopView";
		};
			return "/member/"+ view;
		}
	 
	
	@GetMapping("/memberSetting/{param}")
	public void memberSetting(@PathVariable String param) {
	}
	
	@GetMapping("/shopSetting/{param}")
	public void shopSetting(@PathVariable String param, Authentication authentication, Model model) {
		Member member = (Member) authentication.getPrincipal();
		String memberId = member.getId();
		try {
			if(param.equals("shopInfo")) {
				Shop shop = memberService.selectOneShopInfo(memberId);
				log.info("shop Setting ={}", shop);
				model.addAttribute(shop);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	
	
	//정보 수정하기
	@PostMapping("/memberUpdate")
    public String memberUpdate(Member member, @AuthenticationPrincipal Member oldMember, RedirectAttributes redirectAttr) {
		log.info("memberUpdate member = {}", member);
		log.info("authentication = {}", oldMember);
        
        int result = memberService.updateMember(member, oldMember);

        //spring-security memberController memberUpdate쪽
        oldMember.setName(member.getName());	
        oldMember.setIntroduce(member.getIntroduce());
        oldMember.setAddressFull(member.getAddressFull());
        oldMember.setAddressAll(member.getAddressAll());
        oldMember.setPersonality(member.getPersonality());
        oldMember.setInterest(member.getInterest());
        oldMember.setLocationX(member.getLocationX());
        oldMember.setLocationY(member.getLocationY());
        
        redirectAttr.addFlashAttribute("msg", result > 0? "프로필 편집에 성공했습니다." : "프로필 편집에 실패했습니다.");
        if(oldMember.getAccountType() == 1) {
        	return "redirect:/member/memberSetting/memberSetting";        	
        } else {
    		return "redirect:/member/shopSetting/personal";
        }
    }
	
	//친구추가
	@PostMapping("/addFollowing")
	public String addFollowing(@AuthenticationPrincipal Member member, @RequestParam String friendId, String myId, RedirectAttributes redirectAttr) {
		log.info("addFollowing.member={}", member.getId());
		
		Map<String, Object> map = new HashMap<>();
		map.put("myId", myId);
		map.put("friendId", friendId);
		log.info("map ={}", map);
		
		int result = memberService.addFollowing(map);
		log.info("result ={}", result);
		redirectAttr.addFlashAttribute("msg", result > 0? "친구 추가에 성공했습니다." : "친구 추가에 실패했습니다.");
		return "redirect:/member/memberView/"+friendId;
	}
	
	
	//팔로워리스트 가져오기
	@GetMapping("/followerList")
	@ResponseBody
	public List<Follower> followerList(@RequestParam String friendId, Model model) {
		List<Follower> follower = memberService.followerList(friendId);
		log.info("followerList.follower={}", follower);
		model.addAttribute("follower", follower);
		
		return follower;
		
	}
 
	//팔로잉리스트 가져오기
	@GetMapping("/followingList")
	@ResponseBody
	public List<Follower> followingList(@RequestParam String friendId, Model model){
		List<Follower> followingList = memberService.followingList(friendId);
		log.info("followingList.followingList={}", followingList);
		model.addAttribute("followingList", followingList);
		
		return followingList;
	}
	
	///요청팔로잉리스트 가져오기
	@GetMapping("/requestFollowingList")
	@ResponseBody
	public List<FollowingRequest> requestFollowingList(@RequestParam String myId, Model model){
		log.info("controller.myIddddddddddd={}", myId);
		List<FollowingRequest> requestFollowingList = memberService.requestFollowingList(myId);
		log.info("requestFollowingList.requestFollowingList={}", requestFollowingList);
		model.addAttribute("requestFollowingList", requestFollowingList);
		
		return requestFollowingList;
	}
	
	//친구요청 수락하기
		@PostMapping("/applyFollowing")
		public String applyFollowing(@AuthenticationPrincipal Member member, @RequestParam String reqId, String myId, String status, RedirectAttributes redirectAttr) {
			log.info("applyFollowing.reqId={}", reqId);
			log.info("applyFollowing.myId={}", myId);
			log.info("applyFollowing.status={}", status);
			
			Map<String, Object> map = new HashMap<>();
			map.put("reqId", reqId);
			map.put("myId", myId);
			map.put("status", status);
			
			int result = memberService.applyFollowing(map);
			log.info("result ={}", result);
			redirectAttr.addFlashAttribute("msg", result > 0? "수락하셨습니다." : "수락 실패");
			
			
    		if(result == 1) {
    			int addResult = 0;
    			addResult = memberService.addRequestFollowing(map);
    		}
    		
		
			return "redirect:/member/memberView/"+myId;
		}
		
		//친구요청 거절하기
		@PostMapping("/refuseFollowing")
		public String refuseFollowing(@AuthenticationPrincipal Member member, @RequestParam String reqId, String myId, String status, RedirectAttributes redirectAttr) {
			log.info("refuseFollowing.reqId={}", reqId);
			log.info("refuseFollowing.myId={}", myId);
			log.info("refuseFollowing.status={}", status);
			
			Map<String, Object> map = new HashMap<>();
			map.put("reqId", reqId);
			map.put("myId", myId);
			map.put("status", status);
			
			int refuseResult = memberService.refuseFollowing(map);
			log.info("refuseResult  ={}", refuseResult) ;
			redirectAttr.addFlashAttribute("msg", refuseResult  > 0? "거절하셨습니다." : "거절에 실패했습니다.");
			//redirectAttr.addFlashAttribute("refuseResult", refuseResult);
			return "redirect:/member/memberView/"+myId;
		}

		
	
	//이름과 일치하는 팔로잉 리스트
	@GetMapping("/followingListById")
	@ResponseBody
	public ResponseEntity<?> followingListById(@RequestParam String inputText, @AuthenticationPrincipal Member member){
		log.info("inputText = {}", inputText);
		
		String memberId = member.getId();
		
		Map<String, Object> map = new HashMap<>();
		map.put("inputText", inputText);
		map.put("memberId", memberId);
		
		List<Map<String, Object>> followingListById = memberService.followingListById(map);
		log.info("followingList By Id = {}", followingListById);
		
		return ResponseEntity.ok(followingListById);
	}
	
	
	@GetMapping("/boardForm")
	public void boardForm() {
	}
	
	@PostMapping("/shopSetting/shopInfo")
	public String updateShopInfo(Shop shop, RedirectAttributes redirectAttr) {
		log.info("updateShopInfo shop = {}", shop);
		int result = memberService.updateShopInfo(shop);
		
		String msg = "";
		if(result > 0) {
			msg = "수정되었습니다.";
		} else {
			msg = "수정에 실패했습니다.";
		}
		redirectAttr.addFlashAttribute("msg", msg);
		
		return "redirect:/member/shopSetting/shopInfo";
	}

 

	//게시글 작성하기
	@PostMapping("/memberBoardEnroll")
    public String insertMemberBoard(
            Member member,
            Board  board, 
            RedirectAttributes redirectAttr,
            Model model,
            @RequestParam(name="file", required = false) MultipartFile[] files)  {

		try {
			log.info("board = {}",board);

			List<String> fileList = new ArrayList<>();
			
			for(MultipartFile file : files) {
				if(!file.isEmpty()) {
					String originalFilename = file.getOriginalFilename();
					String renamedFilename = HanaUtils.rename(originalFilename);
					String saveDirectory = application.getRealPath("/resources/upload/member/board");
					
					File dest = new File(saveDirectory,renamedFilename);
					file.transferTo(dest);
					
					fileList.add(renamedFilename);
				}
			}
			
			log.info("fileList = {}",fileList);
			if(!fileList.isEmpty()) {
				String[] fileArray = fileList.toArray(new String[0]);
				board.setPicture(fileArray);
			}
			
			log.info("board = {}",board);
			
			int result = memberService.insertMemberBoard(board);
			
			return "redirect:/member/memberView/"+member.getId();
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			return "redirect:/member/memberView/"+member.getId();
		}
	}
	
	//게시글작성2
	@PostMapping("/insertBoard")
	public String insertBoard(Board board, @RequestParam(value="upFile") MultipartFile[] upFiles, RedirectAttributes redirectAttr, @AuthenticationPrincipal Member member) {
		String[] picArr = new String[upFiles.length];
		String saveDirectory = application.getRealPath("/resources/upload/member/board");
		
		int i = 0;
		for(MultipartFile file : upFiles) {
			String ofn = file.getOriginalFilename();
			String rfn = HanaUtils.rename(ofn);
			File uploadImg = new File(saveDirectory, rfn);
			try {
				file.transferTo(uploadImg);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			picArr[i] = rfn;
			i++;
		};
		board.setPicture(picArr);
		
		int result = memberService.insertMemberBoard(board);
		String msg = result > 0 ? "게시글이 등록되었습니다." : "등록 실패";
		
		redirectAttr.addFlashAttribute("msg", msg);
		
		if(member.getAccountType() == 1) {
			return "redirect:/member/memberView/"+member.getId();			
		} else {
			return "redirect:/member/shopView/"+member.getId();
		}
		
	};
	
	@PostMapping("/insertReview")
	public String insertReview(Board board, @RequestParam String reservationNo, @RequestParam int checkedVal,
			@RequestParam(value="upFile") MultipartFile[] upFiles, RedirectAttributes redirectAttr, @AuthenticationPrincipal Member member) {
		log.info("reservationNo = {}", reservationNo);
		log.info("checkedVal = {}", checkedVal);

		String[] picArr = new String[upFiles.length];
		String saveDirectory = application.getRealPath("/resources/upload/member/board");
		
		int i = 0;
		for(MultipartFile file : upFiles) {
			String ofn = file.getOriginalFilename();
			String rfn = HanaUtils.rename(ofn);
			File uploadImg = new File(saveDirectory, rfn);
			try {
				file.transferTo(uploadImg);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			picArr[i] = rfn;
			i++;
		};
		board.setPicture(picArr);
		
		Map<String, Object> map = new HashMap<>();
		map.put("board", board);
		map.put("reservationNo", reservationNo);
		map.put("checkedVal", checkedVal);
		
		int result = memberService.insertReview(map);
		String msg = result > 0 ? "게시글이 등록되었습니다." : "등록 실패";
		
		redirectAttr.addFlashAttribute("msg", msg);
		
		return "redirect:/member/memberSetting/myReservationList";		
	}
	

	@PostMapping("/profileUpdate")
	public String profileUpdate(@RequestParam MultipartFile upFile, RedirectAttributes redirectAttr, @AuthenticationPrincipal Member member) {
		String memberId = member.getId();
		
		log.info("member oldpic = {}", member.getPicture());
        
		String saveDirectory = application.getRealPath("/resources/upload/member/profile");
		File file = new	File(saveDirectory, member.getPicture());
		file.delete();
		  
		String renamedFilename = HanaUtils.rename(upFile.getOriginalFilename());
		File regFile = new File(saveDirectory, renamedFilename);
		  
		try {
			upFile.transferTo(regFile);
		} catch (IllegalStateException | IOException e) {
			log.error(e.getMessage(), e);
		}
		  
		member.setPicture(renamedFilename);	
		
		int result = memberService.updateMemberProfile(member);
		
		redirectAttr.addFlashAttribute("msg", result > 0 ? "프로필사진이 업데이트 되었습니다." : "프로필 사진 업데이트 실패");
		
		if(member.getAccountType() == 1) {
			return "redirect:/member/memberView/"+memberId;			
		} else {
			return "redirect:/member/shopView/"+memberId;
		}
	}
	
	
	//비밀번호 수정하기
	@PostMapping("/updatePassword")
	public String updatePassword(@RequestParam String password, 
								@RequestParam String newPassword, 
								@RequestParam String passwordCheck,
								Member updateMember, 
								@AuthenticationPrincipal Member oldMember,
								RedirectAttributes redirectAttr,
								Model model
								) {
			log.info("passwordUpdate.password= {}", password);
			log.info("passwordUpdate.newPassword= {}", newPassword);
			log.info("passwordUpdate.passwordCheck= {}", passwordCheck);
			log.info("passwordUpdate.updatemember= {}", updateMember);
			log.info("passwordUpdate.oldMember = {}", oldMember);

			if(bcryptPasswordEncoder.matches(password, oldMember.getPassword())) {
				String encodedPassword = bcryptPasswordEncoder.encode(newPassword);
				updateMember.setPassword(encodedPassword);
				int result = memberService.updatePassword(updateMember);
				String msg = result > 0 ? "비밀번호가 수정되었습니다." : "비밀번호 수정에 실패했습니다.";
				redirectAttr.addFlashAttribute("msg", msg);
				oldMember.setPassword(bcryptPasswordEncoder.encode(updateMember.getPassword()));
				
				log.info("oldMember.password = {}", oldMember.getPassword());
				log.info("SecurityContextHolder.getContext().getAuthentication() = {}",
						SecurityContextHolder.getContext().getAuthentication());
			 
					if(oldMember.getAccountType() == 1) {
						return "redirect:/member/memberView/"+oldMember.getId(); 
					} else {
						return "redirect:/member/shopSetting/password";
					}
			}else {
				String msg = "현재 비밀번호가 일치하지 않습니다.";
				model.addAttribute("msg",msg);
				return "/member/memberSetting/updatePassword";	
			}
	}
	
	
	//게시글 상세보기
	@GetMapping("/memberBoardDetail/{no}")
	public ResponseEntity<Map<String,Object>> boardDetail(@ModelAttribute Member member,
				@AuthenticationPrincipal Member loginMember, @PathVariable int no, Model model) { 
	
	//게시글 정보
	Board  boardDetail = memberService.selectOneBoard(no);
	log.info("boardDetail = {}", boardDetail);
	
	//좋아요여부
	Map<String,Object> param = new HashMap<>();
	param.put("memberId",loginMember.getId());
	param.put("boardNo", no);
	Map<String,Object> likeLog = memberService.selectOneLikeLog(param);
	boolean isLiked = likeLog == null? false : true;
	log.info("isLiked = {}",isLiked);
	
	Map<String, Object> map = new HashMap<>();
	map.put("boardDetail", boardDetail);
	map.put("isLiked",isLiked);
	
	return ResponseEntity.ok()
						.body(map);
	}
	
	//게시글 삭제하기
	 @PostMapping("/deleteBoard")
	    public String deleteBoard(@RequestParam int no, @RequestParam String id){
	    	
	    	try{
	    		log.info("delete.no = {}",no);
	    		log.info("delete.member.id = {}",id);
	    		int result = memberService.deleteBoard(no);
	    		
	    	}catch(Exception e) {
	    		log.error(e.getMessage(),e);
	       	}
	    	return "redirect:/member/memberView/"+id;
	    	
	    }
	
	 //게시글수정하기
	 @PostMapping("/boardModifying")
	    public ResponseEntity<Map<String,Object>> boardModifying(@RequestParam int no, @RequestParam String content) {

	    	Map<String,Object> param = new HashMap<>();
	    	Map<String,Object> resultMap = new HashMap<>();
	    	
	    	try {
	    		log.info("no = {}",no);
	    		log.info("content = {}",content);
	    		
	    		param.put("no", no);
	    		param.put("content", content);
	    		int result = memberService.updateBoardContent(param);
	    		
	    		resultMap.put("msg","게시물 수정 성공");
	    		resultMap.put("result",result);
	    	}catch(Exception e) {
	    		log.error(e.getMessage(),e);
	    		resultMap.put("msg","게시물 수정 실패");
	    	}
	    	
	    	return ResponseEntity.ok(resultMap);
	    	
	    }
	//댓글등록
	@PostMapping("/enrollBoardComment")
	@ResponseBody
	public Map<String,Object> enrollBoardComment(@RequestBody BoardComment boardComment){
		log.info("boardComment = {}",boardComment);
		int result = memberService.enrollBoardComment(boardComment);
		
		Map<String,Object> map = new HashMap<>();
		map.put("msg", "댓글 등록 성공");
		map.put("result",result);
		return map;
	}
	
	//댓글리스트 가져오기
	@GetMapping("/getCommentList/{boardNo}")
	public ResponseEntity<List<BoardComment>> getCommentList(@PathVariable int boardNo){
		log.info("리스트!!!!!!!boardNo = {}",boardNo);
		List<BoardComment> list = memberService.selectBoardCommentList(boardNo);
		log.info("list = {}",list);
		return ResponseEntity.ok(list);
	}
	
	//댓글 삭제하기
	@DeleteMapping("/boardCommentDelete/{no}")
	public ResponseEntity<Map<String,Object>> boardCommentDelete(@PathVariable int no) {
		Map<String, Object> map = new HashMap<>();
		try{
			log.info("댓글삭제하기.no = {}",no);
			int result = memberService.deleteBoardComment(no);
			log.info("result = {}",result);
			map.put("msg", "삭제 성공!");
			map.put("result",result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("msg", "삭제 실패, 관리자에게 문의");
		}
		return ResponseEntity.ok(map);
	}	
	
	//좋아요
	@PostMapping("/like")
	public ResponseEntity<Map<String,Object>> like(@RequestParam int no, @AuthenticationPrincipal Member member){
		Map<String,Object> map = new HashMap<>();
		
		try {
			log.info("좋아요 no = {}",no);
			log.info("좋아요 member = {}",member);
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",member.getId());
			param.put("boardNo",no);
			int result = memberService.insertLikeLog(param);
			
			map.put("msg", "like 성공");
			map.put("result", result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("result", "like 실패");
		}
		
		
		return ResponseEntity.ok(map);
	}
	
	//싫어요
	@DeleteMapping("/unlike/{no}")
	public ResponseEntity<Map<String,Object>> unlike(@PathVariable int no, @AuthenticationPrincipal Member member) {
		Map<String,Object> map = new HashMap<>();
		
		try {
			Map<String,Object> param = new HashMap<>();
			param.put("memberId",member.getId());
			param.put("boardNo",no);
			map.put("memberId",member.getId());
			map.put("boardNo",no);
			
			int result = memberService.deleteLikeLog(param);
			
			map.put("msg", "unlike 성공");
			map.put("result", result);
		}catch(Exception e) {
			log.error(e.getMessage(),e);
			map.put("result", "unlike 실패");
		}
		
		
		return ResponseEntity.ok(map);
	}
	
	@GetMapping("/getLikeCount/{no}")
	public ResponseEntity<Map<String,Object>> getLikeCount(@PathVariable int no){
		Map<String,Object> map = new HashMap<>();
		Map<String,Object> param = new HashMap<>();
		
		param.put("no",no);
		int likeCount = memberService.selectLikeCount(param);
		map.put("likeCount",likeCount);
		
		return ResponseEntity.ok(map);
	}
	
	
	//계정 비공개
	@PostMapping("/accountPrivate")
	 public String checkAccountPrivate(@RequestParam String id, @RequestParam (defaultValue ="1")int publicProfile, Model model, Member member,RedirectAttributes redirectAttr){
    	
    	try{
    		log.info("checkAccountPrivate.member.id = {}",id);
    		log.info("checkAccountPrivate.publicProfile = {}",publicProfile);
    		
    		Map<String,Object> map = new HashMap<>();
    		map.put("id",id);
    		map.put("publicProfile",publicProfile);
    		map.put("member",member);
    		
    		int result = memberService.checkAccountPrivate(map);
    		
    		redirectAttr.addFlashAttribute("msg", result > 0 ? "변경되었습니다." : "변경에 실패했습니다.");
    		model.addAttribute("publicProfile",publicProfile);
    		
    	}catch(Exception e) {
    		log.error(e.getMessage(),e);
       	}
    	return "redirect:/member/memberSetting/accountPrivate";
    	
    }
	 
	
	//팔로잉 요청
		@PostMapping("/requestFollowing")
		 public String requestFollowing(@RequestParam String myId, @RequestParam String friendId, @RequestParam String status,RedirectAttributes redirectAttr){
	    	
	    	try{
	    		log.info("requestFollowing.myId = {}",myId);
	    		log.info("requestFollowing.friendId = {}",friendId);
	    		log.info("requestFollowing.status = {}",status);
	    		
	    		Map<String,Object> map = new HashMap<>();
	    		map.put("myId",myId);
	    		map.put("friendId",friendId);
	    		map.put("status",status);
	    		
	    		int result = memberService.requestFollowing(map);
	    	 
	    		redirectAttr.addFlashAttribute("msg", result > 0 ? "팔로잉을 요청했습니다." : "팔로잉 요청에 실패했습니다.");
	    	
	    	}catch(Exception e) {
	    		log.error(e.getMessage(),e);
	       	}
	    	return "redirect:/member/memberView/" + friendId;
	    	
	    }
	
		@PostMapping("/reportUser")
		public ResponseEntity<?> reportUser(@RequestParam String reportUser, @RequestParam String reportedUser, @RequestParam String content) {
			Map<String, Object> map = new HashMap<>();
			map.put("reportUser", reportUser);
			map.put("reportedUser", reportedUser);
			map.put("content", content);
			
			int result = memberService.insertReport(map);
			
			return ResponseEntity.ok(result);
		}
	
		@GetMapping("/selectRestrictionData")
		public ResponseEntity<?> selectRestrictionData(@RequestParam String id){
			log.info("id = {}", id);
			
			Map<String, Object> data = memberService.selectRestrictionData(id);
			log.info("data = {}", data);
			
			return ResponseEntity.ok(data);
		}
	
		@PostMapping("/appealMyDistriction")
		public ResponseEntity<?> appealMyDistriction(@RequestParam String id){
			int result = memberService.appealMyDistriction(id);
			
			return ResponseEntity.ok(result);
		}

}
