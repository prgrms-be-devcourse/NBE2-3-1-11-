package com.example.order.controller;

import com.example.order.dao.OrderDAO;
import com.example.order.dto.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

@RestController
@RequestMapping("/user")
@Tag(name = "사용자 API")
public class OrderController {

    private final OrderDAO orderDAO;

    @Autowired
    public OrderController(OrderDAO orderDAO) {
        this.orderDAO = orderDAO;
    }

    @GetMapping("/products")
    @Operation(summary = "모든 상품 조회")
    public ResponseEntity<ArrayList<ProductTO>> getAllProducts() {
        ArrayList<ProductTO> products = orderDAO.productAll();
        return new ResponseEntity<>(products, HttpStatus.OK);
    }

    @GetMapping("/order/{email}")
    @Operation(summary = "email로 주문 조회")
    public ResponseEntity<ArrayList<OrderResponse>> getOrders(@PathVariable String email) {
        ArrayList<OrderResponse> orders = orderDAO.orderList(email);
        return new ResponseEntity<>(orders, HttpStatus.OK);
    }

    @PostMapping("/order")
    @Operation(summary = "주문하기")
    public ResponseEntity<String> createOrder(@RequestBody OrderRequest orderRequest) {
        orderDAO.createOrder(orderRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body("주문이 성공적으로 생성되었습니다.");
    }

    @PutMapping("/order/{orderItemId}")
    @Operation(summary = "해당 orderId의 주문 수정")
    public ResponseEntity<String> putOrder(@PathVariable String orderItemId,
                                           @RequestBody OrderRequest orderRequest) {
        orderRequest.getOrder().setOrderId(Long.parseLong(orderItemId));

        int updateResult = orderDAO.updateOrder(orderRequest);

        if (updateResult > 0) {
            return ResponseEntity.ok("주문이 성공적으로 수정되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("주문을 찾을 수 없습니다.");
        }
    }

    @DeleteMapping("/order/{id}")
    @Operation(summary = "해당 orderid의 주문 삭제")
    public ResponseEntity<String> deleteOrder(@PathVariable long id) {
        boolean isDeleted = orderDAO.deleteOrder(id);

        if (isDeleted) {
            return new ResponseEntity<>("주문이 성공적으로 삭제되었습니다.", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("주문을 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
        }
    }

}
