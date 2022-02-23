package com.kh.hana.mbti.model.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kh.hana.mbti.model.dao.MbtiDao;
import com.kh.hana.mbti.model.vo.Mbti;
import com.kh.hana.mbti.model.vo.MemberMbti;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MbtiServicelmpl implements MbtiService {

	@Autowired
	private MbtiDao mbtiDao;

	@Override
	public List<Mbti> selectMbtiList(Map<String, Object> number) {
		return mbtiDao.selectMbtiList(number);
	}

	@Override
	public int insertList(Map<Integer, Integer> resultOfNo, String memberId) {
		return mbtiDao.insertList(resultOfNo, memberId);
	}

	@Override
	public List<Map<String, Object>> selectMbtiResult(String memberId) {
		return mbtiDao.selectMbtiResult(memberId);
	}

	@Override
	public int addMbtiProfile(Map<String, Object> map) {
		MemberMbti selectResult = mbtiDao.selectProfile(map);

		if (selectResult == null) {
			int insertResult = mbtiDao.insertProfile(map);
			return insertResult;
		} else {
			int updateResult = mbtiDao.updateProfile(map);
			return updateResult;
		}
	}
}