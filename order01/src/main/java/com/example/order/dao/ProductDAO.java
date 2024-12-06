package com.example.order.dao;

import com.example.order.dto.ProductTO;
import com.example.order.mapper.OrderMapper;
import com.example.order.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public class ProductDAO {
    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private OrderMapper orderMapper;

    // 상품 수정
    public boolean updateProduct(ProductTO product) {
        return productMapper.updateProduct(product) > 0;
    }

    public int insert(ProductTO to) {
        return productMapper.insert(to);
    }
}
