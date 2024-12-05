package com.example.order.controller;

import com.example.order.dao.OrderDAO;
import com.example.order.dto.OrderRequest;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

@RestController
public class OrderController {

    private final OrderDAO orderDAO;

    @Autowired
    public OrderController(OrderDAO orderDAO) {
        this.orderDAO = orderDAO;
    }

    // 상품 목록 조회 - 영신
    @GetMapping("/products")
    public ArrayList<ProductTO> getAllProducts() {
        return orderDAO.productAll();
    }

    @PostMapping("/order")
    public ResponseEntity<String> createOrder(@RequestBody OrderRequest orderRequest) {
        orderDAO.createOrder(orderRequest);
        return ResponseEntity.ok("Order created successfully");
    }

    @GetMapping("/orders")
    public ArrayList<OrderTO> getOrders(@RequestParam String email) {
        return new ArrayList<>(); // 실제 주문 목록으로 대체 필요
    }

    @PutMapping("/order/{id}")
    public String modifyOrder(@PathVariable long id, @RequestBody OrderTO orderto) {
        return "Order modified successfully"; // 실제 수정 로직에 따라 조정 필요
    }

    @DeleteMapping("/order/{id}")
    public ResponseEntity<String> deleteOrder(@PathVariable long id) {
        boolean isDeleted = orderDAO.deleteOrder(id);
        if (isDeleted) {
            return new ResponseEntity<>("order delete success", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("order not found", HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/orders/{id}/show")
    public String showProduct(@PathVariable String id) {
        return "Showing details for order ID: " + id; // 실제 제품 상세정보로 대체 필요
    }
}
