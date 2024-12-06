package com.example.order.mapper;

import com.example.order.dto.ProductTO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper {
    // 상품 수정
    @Update("UPDATE product SET name = #{name}, price = #{price} WHERE productId = #{productId}")
    int updateProduct(ProductTO product);

    //상품 삭제
    @Delete("delete from product where productId = #{id}")
    int deleteProduct(long id );
}
