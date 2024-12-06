package com.example.order.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderRequest {
    private OrderTO order;
    private List<OrderItemTO> items;
}
