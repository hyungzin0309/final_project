package com.kh.hana.mbti.model.vo;
import java.io.Serializable;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Data;
import lombok.ToString;
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class MemberMbti implements Serializable{
    private static final long serialVersionUID = 1L;
    
    private String memberId;
    private String mbti;
}