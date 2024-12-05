package com.example.order.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Alias("to")
public class OrderTO {
    private long orderId;
    private String email;
    private String price;
    private String quantity;
    private Timestamp date;
    private String address;
    private String zipcode;
}