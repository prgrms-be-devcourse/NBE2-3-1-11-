package com.example.order.dao;

import com.example.order.dto.OrderItemTO;

import com.example.order.dto.OrderTO;
import com.example.order.dto.OrderRequest;

import com.example.order.dto.ProductTO;
import com.example.order.mapper.OrderMapper;
import com.example.order.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OrderDAO {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private ProductMapper productMapper;

    public void createOrder(OrderRequest orderRequest) {

        List<ProductTO> products = orderMapper.productAll();
        Map<Long, Integer> productPriceMap = new HashMap<>();

        for (ProductTO product : products) {
            productPriceMap.put(product.getProductId(), product.getPrice());
        }

        // 총 가격 계산
        int totalPrice = 0;

        // 각 아이템 가격을 가져와서 총 가격을 계산
        for (OrderItemTO item : orderRequest.getItems()) {
            Integer price = productPriceMap.get(item.getProductId()); // 가격 조회
            if (price != null) {
                totalPrice += price * item.getQuantity(); // 가격 계산
            } else {
                throw new IllegalArgumentException("Product not found: " + item.getProductId());
            }
        }

        // 주문 객체에 총 가격 설정
        orderRequest.getOrder().setTotalPrice(totalPrice);

        // 주문 생성
        orderMapper.createOrder(orderRequest.getOrder());

        // 아이템 추가
        long newOrderId = orderRequest.getOrder().getOrderId();

        for (OrderItemTO item : orderRequest.getItems()) {
            item.setOrderId(newOrderId); // 생성된 orderId 설정
            orderMapper.createOrderItem(item);
        }
    }

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

    // 상품 목록 조회 메서드
    public ArrayList<ProductTO> productAll() { return orderMapper.productAll(); }
    // 관리자 ) 상품 등록 메서드
    // public int insert(ProductTO to) {
    // return orderMapper.insert(to);
    // }

    //전체 주문목록
    public ArrayList<OrderTO> orderList(String email ) {
        return orderMapper.orderList(email);
    }

    //금일 주문목록
    public List<Map<String, Object>> todayOrder(String email) {
        return orderMapper.todayOrder(email);
    }


}
