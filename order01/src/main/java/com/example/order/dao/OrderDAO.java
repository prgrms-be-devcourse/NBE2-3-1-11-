package com.example.order.dao;

import com.example.order.dto.OrderItemTO;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import com.example.order.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public class OrderDAO {

    @Autowired
    private OrderMapper orderMapper;

    // 주문 삭제
    public boolean deleteOrder(long orderId) {
        return orderMapper.deleteOrder(orderId) > 0;
    }
    // 상품 조회
    public ArrayList<ProductTO> product_list() {
        return orderMapper.productList();
    }
    // 주문 수정
    public int order_update(OrderTO orderTO) {
        return orderMapper.orderUpdate(orderTO);
    }
    public int orderitem_update(OrderItemTO orderItemTO) {
        return orderMapper.orderitemUpdate(orderItemTO);
    }
}
