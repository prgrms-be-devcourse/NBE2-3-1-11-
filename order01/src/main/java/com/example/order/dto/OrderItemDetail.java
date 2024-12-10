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
@Alias(value="OrderItemDetail")
public class OrderItemDetail {
    private long orderItemId;
    private int quantity;
    private String name;
    private int price;
    private String imgsrc;
    private long productId;
    private long orderId;
}
