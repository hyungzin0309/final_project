package com.kh.hana.member.model.vo;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
 
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class Member extends MemberEntity implements Serializable, UserDetails{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<SimpleGrantedAuthority> authorities;
	private String personality;
	private String interest;
	private List<Follower> followers;
	private int publicProfile;
	private int publicAdress;
	private int publicAge;
	private int publicFriend;
	
	@Builder
	public Member(String id, String name, String password, String picture, String personalId, int accountType,
			String addressFull, String addressAll, String introduce, boolean enabled, String locationX,
			String locationY, List<SimpleGrantedAuthority> authorities, String personality, String interest,
			List<Follower> followers, int publicProfile , int publicAdress, int publicAge, int publicFriend) {
		super(id, name, password, picture, personalId, accountType, addressFull, addressAll, introduce, enabled,
				locationX, locationY);
		this.authorities = authorities;
		this.personality = personality;
		this.interest = interest;
		this.followers = followers;
		this.publicProfile = publicProfile;
		this.publicAdress = publicAdress;
		this.publicAge = publicAge;
		this.publicFriend = publicFriend;
	}
 
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return getId();
	}
	
	

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}



 








}
