package com.example.order.controller;

import com.example.order.dao.ProductDAO;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

/**
 * 관리자 controller
 */
@RestController
@RequestMapping("/admin") // 공통 URL
public class AdminController {
    @Autowired
    private ProductDAO productDAO;

    @GetMapping("/products")
    public ArrayList<ProductTO> getAllProducts() {
        return new ArrayList<>(); // 실제 상품 목록으로 대체 필요
    }

    @PostMapping("/product")
    public String addProduct(@RequestBody ProductTO productto) {
        return "Product added successfully"; // 실제 상품 등록 로직에 따라 조정 필요
    }

    @PutMapping("/product")
    public ResponseEntity<String> modifyProduct(@RequestBody ProductTO product) {
        // 상품 수정
        boolean isUpdated = productDAO.updateProduct(product);

        // 수정 결과에 따라 응답
        if (isUpdated) {
            return new ResponseEntity<>("Product updated successfully", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Product not found", HttpStatus.NOT_FOUND);
        }
    }


    @DeleteMapping("/product/{id}")
    public String deleteProduct(@PathVariable long id) {
        return "Product deleted successfully"; // 실제 삭제 로직에 따라 조정 필요
    }

    @GetMapping("/orders")
    public ArrayList<OrderTO> getAllOrders() {
        return new ArrayList<>(); // 실제 주문 목록으로 대체 필요
    }
}
