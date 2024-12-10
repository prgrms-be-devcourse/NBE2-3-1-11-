package com.example.order.dao;

import com.example.order.dto.*;
import com.example.order.mapper.OrderMapper;
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

    // 사용자 페이지 - 주문하기
    public void createOrder(OrderRequest orderRequest) {
        List<ProductTO> products = orderMapper.productAll();
        Map<Long, Integer> productPriceMap = createProductPriceMap(products);

        int totalPrice = calculateTotalPrice(orderRequest.getItems(), productPriceMap);
        orderRequest.getOrder().setTotalPrice(totalPrice);

        orderMapper.createOrder(orderRequest.getOrder());
        long newOrderId = orderRequest.getOrder().getOrderId();
        addOrderItems(orderRequest.getItems(), newOrderId);
    }

    // 사용자 페이지 - 주문 삭제
    public boolean deleteOrder(long orderId) {
        return orderMapper.deleteOrder(orderId) > 0;
    }


    // 사용자 페이지 - 해당 email 주문 수정
    public int updateOrder(OrderRequest orderRequest) {
        OrderTO orderTO = orderRequest.getOrder();
        List<OrderItemTO> itemList = orderRequest.getItems();

        int totalPrice = calculateTotalPriceForUpdate(itemList);
        orderTO.setTotalPrice(totalPrice);

        // 주문 아이템과 주문 업데이트
        return updateOrderItems(itemList) && orderMapper.orderUpdate(orderTO) > 0 ? 1 : 0;
    }


    // 사용자 페이지 - 모든 상품 조회
    public ArrayList<ProductTO> productAll() {
        return orderMapper.productAll();
    }

    // 사용자 페이지 - 전체 주문 목록 조회
    public ArrayList<OrderResponse> orderList(String email) {
        ArrayList<OrderResponse> orders = orderMapper.orderList(email);
        for (OrderResponse order : orders) {
            order.setItems(orderMapper.getOrderItems(order.getOrderId())); // 주문 아이템 추가
        }
        return orders;
    }

    // 관리자 페이지 - 모든 상품 조회
    public ArrayList<ProductTO> product_list() {
        return orderMapper.productList();
    }

    // 관리자 페이지 - 모든 주문 조회
    public ArrayList<OrderTO> getAllOrders() {
        return orderMapper.getAllOrders();
    }

    // 관리자 페이지 - 주문 상세 보기
    public OrderResponse getOrdersDetail(long orderId) {
        return orderMapper.getOrderDetail(orderId);
    }

    // Helper 메서드: 상품 가격 맵 생성
    private Map<Long, Integer> createProductPriceMap(List<ProductTO> products) {
        Map<Long, Integer> productPriceMap = new HashMap<>();
        for (ProductTO product : products) {
            productPriceMap.put(product.getProductId(), product.getPrice());
        }
        return productPriceMap;
    }

    // Helper 메서드: 총 가격 계산
    private int calculateTotalPrice(List<OrderItemTO> items, Map<Long, Integer> productPriceMap) {
        int totalPrice = 0;
        for (OrderItemTO item : items) {
            Integer price = productPriceMap.get(item.getProductId());
            if (price != null) {
                totalPrice += price * item.getQuantity();
            } else {
                throw new IllegalArgumentException("Product not found: " + item.getProductId());
            }
        }
        return totalPrice;
    }

    // Helper 메서드: 주문 아이템 추가
    private void addOrderItems(List<OrderItemTO> items, long orderId) {
        for (OrderItemTO item : items) {
            item.setOrderId(orderId);
            orderMapper.createOrderItem(item);
        }
    }

    // Helper 메서드: 주문 수정 시 가격 계산
    private int calculateTotalPriceForUpdate(List<OrderItemTO> itemList) {
        int totalPrice = 0;
        for (OrderItemTO item : itemList) {
            totalPrice += item.getQuantity() * orderMapper.productPrice(item.getProductId());
        }
        return totalPrice;
    }

    // Helper 메서드: 주문 아이템 업데이트
    private boolean updateOrderItems(List<OrderItemTO> itemList) {
        boolean allUpdated = true;
        for (OrderItemTO item : itemList) {
            if (orderMapper.orderitemUpdate(item) == 0) {
                allUpdated = false;
            }
        }
        return allUpdated;
    }
}
