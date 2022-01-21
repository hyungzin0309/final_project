package com.kh.hana.mbti.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.hana.mbti.model.vo.Mbti;
import com.kh.hana.mbti.model.vo.MbtiData;

public interface MbtiDao {

	List<Mbti> selectMbtiList(Map<String, Object> number);

	int insertList(Map<Integer, Integer> resultOfNo, String memberId);

	List<Map<String, Object>> selectMbtiResult(String memberId);

	int selectAddMbtiProfilet(String memberId);



	

	

}