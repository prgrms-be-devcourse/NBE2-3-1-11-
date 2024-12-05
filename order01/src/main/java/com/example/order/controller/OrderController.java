package com.example.order.controller;

import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

@RestController
public class OrderController {

    @GetMapping("/products")
    public ArrayList<ProductTO> getAllProducts() {
        return new ArrayList<>(); // 실제 상품 목록으로 대체 필요
    }

    @PostMapping("/order")
    public String addOrder(@RequestBody OrderTO orderto) {
        return "Order added successfully"; // 실제 주문 처리 로직에 따라 조정 필요
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
    public String deleteOrder(@PathVariable long id) {
        return "Order deleted successfully"; // 실제 삭제 로직에 따라 조정 필요
    }

    @GetMapping("/orders/{id}/show")
    public String showProduct(@PathVariable String id) {
        return "Showing details for order ID: " + id; // 실제 제품 상세정보로 대체 필요
    }
}
