package com.example.order.mapper;

import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.Delete;
import com.example.order.dto.OrderItemTO;
import com.example.order.dto.OrderTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;


@Mapper
public interface OrderMapper {

    long createOrder(OrderTO ordertO);

    void createOrderItem(OrderItemTO orderItemtO);

    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId} AND DATE(date) = CURDATE()")
    int deleteOrder(long orderId);

    ArrayList<ProductTO> productAll();
}
