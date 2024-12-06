package com.example.order.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Alias(value="orderTO")
public class OrderTO {
    private long orderId;
    private String email;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;
    private String address;
    private String zipcode;

    private int totalPrice;

}