package com.example.order.mapper;

import com.example.order.dto.OrderItemTO;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;

@Mapper
public interface OrderMapper {
    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId} AND DATE(date) = CURDATE()")
    int deleteOrder(long orderId);

    // 상품 조회( /admin/products )
    ArrayList<ProductTO> productList();
    // 주문 수정( /order/{orderId} : put )
    // 주문 수정에서 orders 와 orderitem 두개 테이블 수정
    int orderUpdate(OrderTO orderTO);
    int orderitemUpdate(OrderItemTO orderItemTO);
}
