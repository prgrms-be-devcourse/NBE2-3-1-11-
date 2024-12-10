package com.example.order.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
public class OrderResponse {
    private long orderId;
    private String email;
    private String address;
    private String zipcode;
    private int totalPrice;
    private LocalDate date;
    private List<OrderItemDetail> items; //version2
}
