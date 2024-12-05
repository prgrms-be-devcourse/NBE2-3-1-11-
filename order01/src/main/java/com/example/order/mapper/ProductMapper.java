package com.example.order.mapper;

import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper {
    // 상품 수정
    @Update("UPDATE product SET name = #{name}, price = #{price} WHERE productId = #{productId}")
    int updateProduct(ProductTO product);

    // 관리자 - 상품 등록
    @Insert("INSERT INTO product (productId, name, price) VALUES (#{productId}, #{name}, #{price})")
    int insert(ProductTO to);
}
