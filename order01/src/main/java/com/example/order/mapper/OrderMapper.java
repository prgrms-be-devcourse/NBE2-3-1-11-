package com.example.order.mapper;

import com.example.order.dto.OrderTO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Mapper
public interface OrderMapper {
    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId} AND DATE(date) = CURDATE()")
    int deleteOrder(long orderId);

    // 주문목록
    ArrayList<OrderTO> orderList(String email);

    // 오늘 주문내역
    List<Map<String, Object>> todayOrder(String email) ;

}
