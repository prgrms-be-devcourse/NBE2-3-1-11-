package com.example.order.dao;

import com.example.order.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDAO {

    @Autowired
    private OrderMapper orderMapper;

    // 주문 삭제
    public boolean deleteOrder(long orderId) {
        return orderMapper.deleteOrder(orderId) > 0;
    }
}
