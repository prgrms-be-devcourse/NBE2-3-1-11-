package com.example.order.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class BoardController {

    @RequestMapping("/sample")
    public String view() {
        return "sample";
    }

    @RequestMapping("/view2")
    public String view2() {
        return "view2";
    }

    @RequestMapping("/view")
    public String sample() {
        return "view";
    }
}
