package com.kh.hana.mbti.model.service;
import java.util.List;
import java.util.Map;
import com.kh.hana.mbti.model.vo.Mbti;
public interface MbtiService {
	
	List<Mbti> selectMbtiList(Map<String, Object> number);
    
	int insertList(Map<Integer, Integer> resultOfNo, String memberId);
    
	List<Map<String, Object>> selectMbtiResult(String memberId);
    
	int addMbtiProfile(Map<String, Object> map);

}