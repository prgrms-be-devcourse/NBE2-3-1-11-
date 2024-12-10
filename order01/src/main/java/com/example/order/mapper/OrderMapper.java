package com.example.order.mapper;


import com.example.order.dto.*;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;
import java.util.List;

@Mapper
public interface OrderMapper {

    long createOrder(OrderTO ordertO);

    void createOrderItem(OrderItemTO orderItemtO);

    // 주문 삭제
    @Delete("DELETE FROM orders WHERE orderId = #{orderId} AND DATE(date) = CURDATE()")
    int deleteOrder(long orderId);


    // 상품 조회( /admin/products )
    ArrayList<ProductTO> productList();
    // 주문 수정에서 orders 와 orderitem 두개 테이블 수정
    int orderUpdate(OrderTO orderTO);
    int orderitemUpdate(OrderItemTO orderItemTO);
    int productPrice(long productid);

    ArrayList<ProductTO> productAll();


    // 주문목록
    ArrayList<OrderResponse> orderList(String email);
    List<OrderItemDetail> getOrderItems(long orderId);

    // 관리자 페이지 - 모든 주문 조회
    ArrayList<OrderTO> getAllOrders();

    // 관리자 페이지 - 모든 주문 조회
    OrderResponse getOrderDetail(long orderId);
}
