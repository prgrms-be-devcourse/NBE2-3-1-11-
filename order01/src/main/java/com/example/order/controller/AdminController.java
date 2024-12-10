package com.example.order.controller;

import com.example.order.dao.OrderDAO;
import com.example.order.dao.ProductDAO;
import com.example.order.dto.OrderResponse;
import com.example.order.dto.OrderTO;
import com.example.order.dto.ProductTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

@RestController
@RequestMapping("/admin")
@Tag(name = "관리자 API")
public class AdminController {

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private OrderDAO orderDAO;

    @GetMapping("/products")
    @Operation(summary = "모든 상품 조회")
    public ResponseEntity<ArrayList<ProductTO>> products() {
        ArrayList<ProductTO> productList = orderDAO.product_list();

        return new ResponseEntity<>(productList, HttpStatus.OK);
    }

    @GetMapping("/product/{id}")
    @Operation(summary = "개별 상품 조회")
    public ResponseEntity<ProductTO> getProductById(@PathVariable long id) {
        ProductTO product = productDAO.getProductById(id);
        if (product != null) {
            return new ResponseEntity<>(product, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/orders")
    @Operation(summary = "모든 주문 조회")
    public ResponseEntity<ArrayList<OrderTO>> getAllOrders() {
        ArrayList<OrderTO> orders = orderDAO.getAllOrders();

        return new ResponseEntity<>(orders, HttpStatus.OK);
    }

    @GetMapping("/orders-detail/{id}")
    @Operation(summary = "개별 주문 상세 조회")
    public ResponseEntity<OrderResponse> getOrdersDetail(@PathVariable long id) {
        OrderResponse orderDetail = orderDAO.getOrdersDetail(id);

        if (orderDetail != null) {
            return new ResponseEntity<>(orderDetail, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/product")
    @Operation(summary = "개별 상품 추가")
    public ResponseEntity<String> addProduct(@RequestBody ProductTO product) {
        ProductTO to = new ProductTO();

        long productId = product.getProductId();
        to.setProductId(productId);
        to.setName(product.getName());
        int price = product.getPrice();
        to.setPrice(price);
        to.setImgsrc(product.getImgsrc());

        int flag = productDAO.insert(to);
        if (flag == 1) {
            return new ResponseEntity<>("상품이 성공적으로 추가되었습니다.", HttpStatus.CREATED);
        } else if (flag == 0) {
            return new ResponseEntity<>("상품 추가에 실패했습니다.", HttpStatus.BAD_REQUEST);
        } else {
            return new ResponseEntity<>("서버 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/product")
    @Operation(summary = "개별 상품 수정")
    public ResponseEntity<String> modifyProduct(@RequestBody ProductTO product) {
        boolean isUpdated = productDAO.updateProduct(product);

        if (isUpdated) {
            return new ResponseEntity<>("상품이 성공적으로 수정되었습니다.", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("상품을 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/product/{id}")
    @Operation(summary = "개별 상품 삭제")
    public ResponseEntity<String> deleteProduct(@PathVariable long id) {
        int result = productDAO.deleteProduct(id);

        if (result == 1) {
            return new ResponseEntity<>("상품이 성공적으로 삭제되었습니다.", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("상품을 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
        }
    }


}
