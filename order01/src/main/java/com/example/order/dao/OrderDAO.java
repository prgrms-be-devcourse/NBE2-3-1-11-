package com.example.order.dao;

import com.example.order.dto.OrderTO;
import com.example.order.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class OrderDAO {

    @Autowired
    private OrderMapper orderMapper;

    // 주문 삭제
    public boolean deleteOrder(long orderId) {
        return orderMapper.deleteOrder(orderId) > 0;
    }



    //전체 주문목록
    public ArrayList<OrderTO> orderList(String email ) {
        return orderMapper.orderList(email);
    }

    //금일 주문목록
    public List<Map<String, Object>> todayOrder(String email) {
        return orderMapper.todayOrder(email);
    }

}
