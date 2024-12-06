package com.example.order.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Alias(value="orderItemTO")
public class OrderItemTO {
    private long orderItemId;
    private int quantity;
    private long productId;
    private long orderId;
}
