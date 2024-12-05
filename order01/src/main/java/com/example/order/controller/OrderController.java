package com.example.order.controller;

import com.example.order.dao.OrderDAO;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
public class OrderController {

    @Autowired
    private OrderDAO orderDAO;

    @GetMapping("/products")
    public ArrayList<ProductTO> getAllProducts() {
        return new ArrayList<>(); // 실제 상품 목록으로 대체 필요 테스트
    }

    @PostMapping("/order")
    public String addOrder(@RequestBody OrderTO orderto) {
        return "Order added successfully"; // 실제 주문 처리 로직에 따라 조정 필요
    }

    @GetMapping("/order/{email}")
    public ArrayList<OrderTO> getOrders(@PathVariable String email) {
        ArrayList<OrderTO> lists = orderDAO.orderList(email);
        return lists;
    }

    @GetMapping("/order/{email}/today")
    public List<Map<String,Object>> getTodayOrders(@PathVariable String email) {
        List<Map<String,Object>> lists = orderDAO.todayOrder(email);
        return lists;
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
