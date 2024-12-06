package com.example.order.dao;

import com.example.order.dto.ProductTO;
import com.example.order.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductDAO {
    @Autowired
    private ProductMapper productMapper;

    // 상품 수정
    public boolean updateProduct(ProductTO product) {
        return productMapper.updateProduct(product) > 0;
    }


    // 상품 삭제
    public int deleteProduct(long id ) {
        return productMapper.deleteProduct(id);
    }
}
