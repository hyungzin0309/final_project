package com.kh.hana.common.aspect;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import com.kh.hana.shop.model.service.ShopService;
import com.kh.hana.shop.model.vo.Reservation;
import com.kh.hana.shop.model.vo.Table;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@Aspect
public class ShopTableAspect {
	
	@Autowired
	public ShopService shopService;

	@Pointcut("execution(* com.kh.hana.shop.controller.ShopController.updateShopTable(..)) || execution(* com.kh.hana.shop.controller.ShopController.deleteShopTable(..))")
	public void aroundManageTablePointcut() {};
	
	@Around("aroundManageTablePointcut()")
	public Object aroundManageShopTable(ProceedingJoinPoint joinPoint) {
		try {
			Object[] arg = joinPoint.getArgs();
			Table table = (Table) arg[0];
			
			String callMethod = joinPoint.getSignature().toString();
			log.info("method contains keyword = {}", callMethod.contains("update"));
			
			Map<String, Object> infoMap = new HashMap<>();
			infoMap.put("tableId", table.getTableId());
			
			List<Reservation> resultTable = shopService.selectTableReservation(infoMap);
			
			log.info("resultTable EMpty? = {}", resultTable.isEmpty());
			if(resultTable.isEmpty()) {
				if(callMethod.contains("update")) {
					table.setUpdatable("Y");
				}
			} else {
				if(callMethod.contains("update")){
					table.setUpdatable("N");
					int result = shopService.updateTable(table);
					if(result > 0) {
						throw new Throwable();											
					}
				}
				if(callMethod.contains("delete")) {
					throw new Throwable();														
				}
			}
				
			Object returnObj = joinPoint.proceed();
				
			return returnObj;
		} catch (Throwable e) {
			return ResponseEntity.status(404).build();
		}
		
		
	}
}
