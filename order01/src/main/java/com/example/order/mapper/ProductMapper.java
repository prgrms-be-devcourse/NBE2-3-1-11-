package com.example.order.mapper;

import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.*;

@Mapper
public interface ProductMapper {
    // 상품 수정
    @Update("UPDATE product SET name = #{name}, price = #{price} , imgsrc = #{imgsrc} WHERE productId = #{productId}")
    int updateProduct(ProductTO product);

    //상품 삭제
    @Delete("delete from product where productId = #{id}")
    int deleteProduct(long id );

    // 관리자 - 상품 등록
    @Insert("INSERT INTO product (productId, name, price, imgsrc) VALUES (#{productId}, #{name}, #{price}, #{imgsrc})")
    int insert(ProductTO to);

    @Select("SELECT * FROM product WHERE productId=${productId}")
    ProductTO selectProductById(long id);
}
