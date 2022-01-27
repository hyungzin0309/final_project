 package com.kh.hana.member.controller;

 
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.hana.common.util.HanaUtils;
import com.kh.hana.member.model.service.MemberService;
import com.kh.hana.member.model.vo.Board;
import com.kh.hana.member.model.vo.Follower;
import com.kh.hana.member.model.vo.Member;
import com.kh.hana.shop.model.vo.Shop;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member")
@Slf4j
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
		
		log.info("upFile = {}", upFile);
		log.info("upFile.getogName = {}", upFile.getOriginalFilename());
		
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
		return "redirect:/member/login";					
	}
	
	@GetMapping("/{view}/{id}")
	public String memberView(@PathVariable String id, @PathVariable String view, Model model, Authentication authentication) {
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
		
		Member checkMember = (Member) authentication.getPrincipal();
		log.info("checkMember = {}", checkMember);
		if(checkMember.getAccountType() == 0) {
			Shop shopInfo = memberService.selectOneShopInfo(id);
			log.info("shopInfo = {}", shopInfo);
			model.addAttribute("shopInfo", shopInfo);
		}
		
		return "/member/"+view;
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
				if(shop != null) {
					model.addAttribute(shop);
				} else {
					model.addAttribute("msg", "등록된 정보가 없습니다. 매장정보를 입력해주세요.");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	
	
	@PostMapping("/memberUpdate")
    public String memberUpdate(Member member, @RequestParam MultipartFile upFile,
                                @AuthenticationPrincipal Member oldMember,
                                RedirectAttributes redirectAttr) {
        log.info("member={}", member);
        log.info("oldMember={}", oldMember);
        
        String oldProfile = member.getPicture();
        
        if(oldProfile != null) {
			String saveDirectory = application.getRealPath("/resources/upload/member/profile");
			File file = new	File(saveDirectory, oldProfile);
			boolean bool = file.delete();
			log.info("bool = {}", bool);
			  
			String renamedFilename = HanaUtils.rename(upFile.getOriginalFilename());
			  
			File regFile = new File(saveDirectory, renamedFilename);
			  
			try {
				upFile.transferTo(regFile);
			} catch (IllegalStateException | IOException e) {
				log.error(e.getMessage(), e);
			}
			  
			member.setPicture(renamedFilename);	
		}
        
        int result = memberService.updateMember(member, oldMember);

        //spring-security memberController memberUpdate쪽
        oldMember.setName(member.getName());
		oldMember.setName(member.getName());
		if(!upFile.getOriginalFilename().equals("")) {
			oldMember.setPicture(member.getPicture());			
		}
        oldMember.setIntroduce(member.getIntroduce());
        oldMember.setAddressFull(member.getAddressFull());
        oldMember.setAddressAll(member.getAddressAll());
        oldMember.setPersonality(member.getPersonality());
        oldMember.setInterest(member.getInterest());
        oldMember.setLocationX(member.getLocationX());
        oldMember.setLocationY(member.getLocationY());

        redirectAttr.addFlashAttribute("msg", result > 0? "프로필 편집에 성공했습니다." : "프로필 편집에 실패했습니다.");
        if(member.getAccountType() == 1) {
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
            Board board, 
            RedirectAttributes redirectAttr,
            @RequestParam(name="uploadFile", required = false) MultipartFile[] uploadFiles) throws IllegalStateException, IOException {
        String saveDirectory  = application.getRealPath("/resources/upload/member/board");

            
        	//String[] picture = new String[2];

        for(int i = 0; i<uploadFiles.length; i++) {
            MultipartFile uploadFile = uploadFiles[i];
            if(!uploadFile.isEmpty()) {
                String originalFilename = uploadFile.getOriginalFilename();
                File dest = new File(saveDirectory);
                uploadFile.transferTo(dest);
                for(int j = 0; j< originalFilename.length(); j++) { 
                	//board.getPicture(0) = originalFilename;
                }
                 
            }
        }
        log.info("insertMemberBoard board = {}", board);
        int result = memberService.insertMemberBoard(board);

        return "redirect:/member/memberView/"+ member.getId();

    }
	
	@PostMapping("/testModal")
	public void testModal(@RequestParam MultipartFile upFile) {
		 log.info("upFile = {}", upFile);

		 
	}


}
