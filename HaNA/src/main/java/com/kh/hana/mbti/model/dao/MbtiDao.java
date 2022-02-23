package com.kh.hana.mbti.model.dao;
import java.util.List;
import java.util.Map;
import com.kh.hana.mbti.model.vo.Mbti;
import com.kh.hana.mbti.model.vo.MemberMbti;
public interface MbtiDao {
   
	List<Mbti> selectMbtiList(Map<String, Object> number);
    
	int insertList(Map<Integer, Integer> resultOfNo, String memberId);
    
	List<Map<String, Object>> selectMbtiResult(String memberId);
    
	MemberMbti selectProfile(Map<String, Object> map);
    
	int insertProfile(Map<String, Object> map);
    
	int updateProfile(Map<String, Object> map);
    
    
    
    
}