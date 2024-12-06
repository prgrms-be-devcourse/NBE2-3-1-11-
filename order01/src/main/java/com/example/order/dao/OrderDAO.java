package com.example.order.dao;

import com.example.order.dto.ProductTO;
import com.example.order.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public class OrderDAO {
    @Autowired
    private OrderMapper orderMapper;

    // 상품 목록 조회 메서드
    public ArrayList<ProductTO> productAll() { return orderMapper.productAll(); }
}
