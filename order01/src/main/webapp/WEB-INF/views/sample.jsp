<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <script type="text/javascript">

    document.addEventListener("DOMContentLoaded", function () {
      document.getElementById("checkOrders").addEventListener("click", function () {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "/samplePage/orders-list/customer@example.com", true);
        xhr.onreadystatechange = function () {
          if (xhr.readyState === 4 && xhr.status === 200) {
            var json = JSON.parse(xhr.responseText) ;
            //list, orderform 그리기
            document.getElementById("orderList").innerHTML =json.sbHtml_list;
            document.getElementById("orderForm").innerHTML =json.sbHtml_form;

            //리스트 카테고리 listCateg
            document.getElementById("listCateg").innerHTML = "<b>주문 목록</b>"
            //버튼처리
            document.getElementById("pay").style.display ="none"
            document.getElementById("checkOrders").style.display ="none"
            document.getElementById("home").style.display =""
          }
        };
        xhr.send();
      });
    });


  </script>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">
  <style>
    body {
      background: #ddd;
    }

    .card {
      margin: auto;
      max-width: 950px;
      width: 90%;
      box-shadow: 0 6px 20px 0 rgba(0, 0, 0, 0.19);
      border-radius: 1rem;
      border: transparent
    }

    .summary {
      background-color: #ddd;
      border-top-right-radius: 1rem;
      border-bottom-right-radius: 1rem;
      padding: 4vh;
      color: rgb(65, 65, 65)
    }

    @media (max-width: 767px) {
      .summary {
        border-top-right-radius: unset;
        border-bottom-left-radius: 1rem
      }
    }

    .row {
      margin: 0
    }

    .title b {
      font-size: 1.5rem
    }

    .col-2,
    .col {
      padding: 0 1vh
    }

    img {
      width: 3.5rem
    }

    hr {
      margin-top: 1.25rem
    }
    .products {
      width: 100%;
    }
    .products .price, .products .action {
      line-height: 38px;
    }
    .products .action {
      line-height: 38px;
    }

  </style>
  <title>Hello, world!</title>
</head>
<body class="container-fluid">
<div class="row justify-content-center m-4">
  <h1 class="text-center">Grids & Circle</h1>
</div>
<div class="card">
  <div class="row">
    <div class="col-md-8 mt-4 d-flex flex-column align-items-start p-3 pt-0">
      <h5 class="flex-grow-0" id="listCateg"><b>상품 목록</b></h5>
      <ul class="list-group products"  id="orderList">

      </ul>
    </div>
    <div class="col-md-4 summary p-4" id="orderForm">
      <div>
        <h5 class="m-0 p-0"><b>Summary</b></h5>
      </div>
      <hr>
<%--      <div class="row">--%>
<%--        <h6 class="p-0">Columbia Nariñó <span class="badge bg-dark text-">2개</span></h6>--%>
<%--      </div>--%>
<%--      <div class="row">--%>
<%--        <h6 class="p-0">Brazil Serra Do Caparaó <span class="badge bg-dark">2개</span></h6>--%>
<%--      </div>--%>
<%--      <div class="row">--%>
<%--        <h6 class="p-0">Columbia Nariñó <span class="badge bg-dark">2개</span></h6>--%>
<%--      </div>--%>
      <form>
        <div class="mb-3">
          <label for="email" class="form-label">이메일</label>
          <input type="email" class="form-control mb-1" id="email">
        </div>
        <div class="mb-3">
          <label for="address" class="form-label">주소</label>
          <input type="text" class="form-control mb-1" id="address">
        </div>
        <div class="mb-3">
          <label for="postcode" class="form-label">우편번호</label>
          <input type="text" class="form-control" id="postcode">
        </div>
        <div>당일 오후 2시 이후의 주문은 다음날 배송을 시작합니다.</div>
      </form>
      <div class="row pt-2 pb-2 border-top">
        <h5 class="col">총금액</h5>
        <h5 class="col text-end">15000원</h5>
      </div>
      <button class="btn btn-dark col-12" id="pay" style="width:45%;">결제하기</button>
      <button class="btn btn-dark col-12" id="checkOrders"  style="width:45%;">주문조회</button>
      <button class="btn btn-dark col-12" id="home"  style="width:100%;display:none;  ">돌아가기</button>


    </div>
  </div>
</div>
</body>
</html>