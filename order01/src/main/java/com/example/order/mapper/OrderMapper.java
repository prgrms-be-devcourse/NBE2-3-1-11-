package com.example.order.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {
    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId} AND DATE(date) = CURDATE()")
    int deleteOrder(long orderId);
}
