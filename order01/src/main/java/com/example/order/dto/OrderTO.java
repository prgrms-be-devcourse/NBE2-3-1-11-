package com.example.order.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderTO {
    private long orderId;
    private String email;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;
    private String address;
    private String zipcode;
    private int totalPrice;
}