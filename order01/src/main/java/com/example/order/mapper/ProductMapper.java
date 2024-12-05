package com.example.order.mapper;

import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper {
    // 상품 수정
    @Update("UPDATE product SET name = #{name}, price = #{price} WHERE productId = #{productId}")
    int updateProduct(ProductTO product);
}
