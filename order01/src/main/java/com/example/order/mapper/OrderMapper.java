package com.example.order.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {
    // 주문 상품 삭제
    @Delete("DELETE FROM orderitem WHERE orderId = #{orderId}")
    int deleteOrderItemsByOrderId(long orderId);

    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId}")
    int deleteOrder(long orderId);
}
