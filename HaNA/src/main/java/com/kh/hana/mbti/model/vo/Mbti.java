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
public class Mbti implements Serializable{
    
    private static final long serialVersionUID = 1L;
    private int no;
    private String question;
    private String type;
}