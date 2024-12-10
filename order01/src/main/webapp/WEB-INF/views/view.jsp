<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <script type="text/javascript">
    var selectedProducts = new Map();
    var orderRequest = new Map();
    var items = [];
    var totalPrice;
    var globalEmail;

    // 버튼 리스너 모음
    document.addEventListener('DOMContentLoaded', () => {
      const adminBtn = document.getElementById('user-btn');

      adminBtn.addEventListener('click', () => {
        window.location.href = "/view2";
      });

      document.getElementById("selectedProducts").addEventListener("click", function (e) {
        // 갯수 증가 버튼
        if (e.target.classList.contains("add-item")) {
          const quantityBadge = e.target.closest(".row").querySelector(".quantity");
          let currentQuantity = parseInt(quantityBadge.textContent.replace("개", ""));
          currentQuantity++; // 갯수 증가
          quantityBadge.textContent = `\${currentQuantity}개`;

          const productName = e.target.closest(".row").getAttribute("data-product");
          const product = selectedProducts.get(productName);
          product.quantity = currentQuantity;  // 수량만 변경
          selectedProducts.set(productName, product);  // 다시 설정

          updateTotalPrice();
        }

        // 갯수 감소 버튼
        if (e.target.classList.contains("subtract-item")) {
          const quantityBadge = e.target.closest(".row").querySelector(".quantity");
          let currentQuantity = parseInt(quantityBadge.textContent.replace("개", ""));
          if (currentQuantity >= 1) {
            currentQuantity--; // 갯수 감소
            quantityBadge.textContent = `\${currentQuantity}개`;
            updateTotalPrice();


            const productName = e.target.closest(".row").getAttribute("data-product");
            const product = selectedProducts.get(productName);
            product.quantity = currentQuantity;  // 수량만 변경
            selectedProducts.set(productName, product);  // 다시 설정
          }
          // 갯수가 0일 경우 해당 품목 삭제
          if (currentQuantity === 0) {
            const item = e.target.closest(".row");
            item.remove();
            updateTotalPrice();  // 총 가격 업데이트
          }
        }
      });
    });

    function updateTotalPrice() {
      // 상품 추가시 주문가격 갱신
      let total =0;
      // 상품별 price 값 total에 더해준다
      selectedProducts.forEach(item => {
        const price = parseFloat(item.price)*parseFloat(item.quantity) ;
        if (!isNaN(price)) {
          total += price;
        }
      });
      totalPrice = total;
      document.getElementById("totalPrice").textContent = total+"원";

    }

    // 주문삭제
    function deleteOrder(event) {
      // 클릭된 버튼 요소 가져오기
      const button = event.target;

      const divRow = button.closest(".product-row");

      const productIdElement = divRow.querySelector('.product-id');
      const productId = productIdElement ? productIdElement.textContent.trim() : null;

      if (confirm("삭제하시겠습니까?")) {
        debugger;
        const xhr = new XMLHttpRequest();
        xhr.open("DELETE", "/user/order/" + productId, true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function () {
          if (xhr.readyState === 4) {
            if (xhr.status === 200) {
              alert("삭제가 완료되었습니다.");
              orderInquiry();
            } else {
              alert("삭제 중 오류가 발생했습니다.");
            }
          }
        };

        xhr.send();
      }
    }


    function getOrderDetail(orderId) {
      const xhr = new XMLHttpRequest();

      xhr.open("GET", `/admin/orders-detail/\${orderId}`, true); // API 호출 (orderId를 포함하여)

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          const orderDetails = JSON.parse(xhr.responseText);
          console.log(orderDetails);

          // 결과를 summary-container에 동적으로 렌더링
          const selectedContainer = document.getElementById('selectedProducts');
          // 상품 목록을 동적으로 렌더링
          let productListHTML = "";
          if (orderDetails.items && Array.isArray(orderDetails.items)) {
            productListHTML += orderDetails.items.map(item =>
                    `<hr><li style="margin-bottom: 15px; border: 1px solid #ddd; padding: 10px; border-radius: 5px; display: flex; align-items: center;">
                        <img src="\${item.imgsrc}" onerror="this.src='https://i.imgur.com/HKOFQYa.jpeg';"  style="width: 50px; height: 50px; margin-right: 15px;" alt="이미지">
                        <div>
                            <p><b>상품명:</b> \${item.name}</p>
                            <p><b>가격:</b> \${item.price} 원</p>
                             <p><b>수량:</b> \${item.quantity} 개</p>
                          </div>
                    </li>`
            ).join('');
          }

          selectedContainer.innerHTML = `
                <p><b>주문 ID:</b> \${orderDetails.orderId}</p>
                <p><b>주문 날짜:</b> \${orderDetails.date}</p>
                <p><b>총 금액:</b> \${orderDetails.totalPrice} 원</p>
                <p><b>배송지:</b> \${orderDetails.address}, \${orderDetails.zipcode}</p>
                <p><b>상품 목록:</b></p>
                <ul style="list-style: none; padding: 0;">
                    \${productListHTML}
                </ul>
                <button class="mb-3 btn-dark col-12" style="width:100%;" id="back" onclick="history.back()" >돌아가기</button>
            `;

        } else if (xhr.readyState === 4) {
          alert("주문 상세정보를 가져오는 중 오류가 발생했습니다.");
        }
      };
      xhr.send();
    }


    // 주문조회
    function orderInquiry() {
      const email = document.getElementById('email').value;
      globalEmail = email;
      // 값 비어있는지 체크
      if ( email =="" ) {
        alert('이메일을 입력 해주세요');
        return false;  // 폼 제출을 막음
      }

      const xhr = new XMLHttpRequest();
      xhr.open("GET", "/user/order/"+email , true);
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {

          const orders = JSON.parse(xhr.responseText);
          const productTableBody = document.getElementById("products-list");

          productTableBody.innerHTML = ""; // 데이터 초기화
          productTableBody.innerHTML +='<h5 className="flex-grow-0"><b>주문 목록</b></h5>'
          productTableBody.innerHTML += `<div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px; width: -webkit-fill-available;
                                             display: flex; justify-content: center; align-items: center;">
                                              <div class="product-id" style="flex: 2; text-align: center;">ID</div>
                                              <div class="product-name" style="flex: 2; text-align: center;">날짜</div>
                                              <div class="product-price" style="flex: 3;">총액</div>
                                          </div>`
          productTableBody.innerHTML +='<ul className="list-group products">'

          console.log(orders);
          // 주문목록 그리기
          orders.forEach(order => {
            const date = order.date.split("-").join("");

            const row = `
              <div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px; width: -webkit-fill-available;
                 display: flex; justify-content: center; align-items: center;">
                  <div class="product-id" style="flex: 2; text-align: center;">\${order.orderId}</div>
                  <div class="product-name" style="flex: 2; text-align: center;">\${order.date}</div>
                  <div class="product-price" style="flex: 2;">\${order.totalPrice}원</div>
                  <div class="button-container" style="flex: 1;">
                      <button class="btn btn-outline-secondary delete-btn" onclick="getOrderDetail(\${order.orderId})">상세</button>
                  </div>
                  <div class="button-container" style="flex: 1;">
                      <button class="btn btn-outline-secondary delete-btn" onclick="deleteOrder(event)">삭제</button>
                  </div>
              </div>
                  `;
            productTableBody.innerHTML += row;
          });

          productTableBody.innerHTML += '</ul>';

          // 금일 주문 목록 그리기
          orders.forEach(order => {
            order.items.forEach(item => {
              // Form 그리기
              const selectedContainer = document.getElementById('selectedProducts')
            });
            // 총금액
            const totalPrice = order.totalPrice;
            document.getElementById("totalPrice").textContent = totalPrice+'원'
          });

          // 기존 요소 숨기기
          document.getElementById("orderDetailsContainer").style.display='none';


          document.getElementById("right-panel-title").innerHTML = "<b>주문 내역 확인</b>";

        }
      };
      xhr.send();
    }

    // 상품 목록 가져오기 API 호출
    document.addEventListener("DOMContentLoaded", function () {
      const xhr = new XMLHttpRequest();
      xhr.open("GET", "/user/products", true);
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          const products = JSON.parse(xhr.responseText);
          const productTableBody = document.getElementById("products-list");

          productTableBody.innerHTML = ""; // 데이터 초기화
          productTableBody.innerHTML +='<h5 className="flex-grow-0"><b>상품 목록</b></h5>'
          productTableBody.innerHTML +=`<div class="product-row" style="border: 1px solid #ddd; padding: 10px; width: -webkit-fill-available;
                                             display: flex; justify-content: center; align-items: center;">
                                             <div class="product-id" style="flex: 25;">ID</div>
                                              <div class="product-name" style="flex: 25; text-align: left;">이미지</div>
                                              <div class="product-name" style="flex: 25; text-align: left;">상품명</div>
                                              <div class="product-price" style="flex: 25" text-align:center;>가격</div>
                                          </div>`
          productTableBody.innerHTML +='<ul className="list-group products">'

          products.forEach(product => {
            const row = `
                        <div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px; width: -webkit-fill-available;
                           display: flex; justify-content: center; align-items: center;">
                           <div class="product-id" style="flex: 1;">\${product.productId}</div>
                            <div class="product-image">
                                <img id="img" src="\${product.imgsrc}" alt="이미지" style="width: 50px; height: 50px"
                                onerror="this.src='https://i.imgur.com/HKOFQYa.jpeg';">
                                <%--<img src="https://i.imgur.com/HKOFQYa.jpeg" alt="이미지.." style="width: 50px; height: 50px">--%>
                            </div>
                            <div class="product-name" style="flex: 2; text-align: center;">\${product.name}</div>
                            <div class="product-price" style="flex: 1;">\${product.price}원</div>
                            <div class="button-container" style="flex: 1;">
                                <button class="btn btn-outline-secondary " onclick="addOrderProduct(event)">추가</button>
                            </div>

                        </div>


                            `;

            productTableBody.innerHTML += row;
          });
          productTableBody.innerHTML += '</ul>';
        }
      };
      xhr.send();
    });

    function addOrderProduct(event) {
      // 클릭된 버튼 요소 가져오기
      const button = event.target;

      // 버튼의 상위 요소(<li>) 찾기
      const productRow = button.closest('.product-row');

      // productId와 price 요소 찾기
      const productNameElement = productRow.querySelector('.product-name');
      const productIdElement = productRow.querySelector('.product-id');
      const priceElement = productRow.querySelector('.product-price');

      // 값 가져오기
      const productName = productNameElement ? productNameElement.textContent.trim() : null;
      const price = priceElement ? priceElement.textContent.trim() : null;
      const productId = productIdElement ? productIdElement.textContent.trim() : null;
      const selectedContainer = document.getElementById('selectedProducts')

      if (selectedProducts.has(productName) && selectedProducts.get(productName).quantity >0 ) {
        const productInfo = selectedProducts.get(productName)
        productInfo.quantity += 1;
        productInfo.price =  price ;
        selectedProducts.set(productName, productInfo );

        const productRow = document.querySelector(`[data-product="\${productName}"]`);
        productRow.querySelector('span').textContent = `\${productInfo.quantity}개`;
      } else {

        selectedProducts.set(productName, { price: price, quantity: 1,productId : productId });
        const newRow = document.createElement('div');
        newRow.className = 'row';
        newRow.setAttribute('data-product', productName);
        newRow.innerHTML = `<div>
          <h5 className="m-0 p-0"><b>장바구니</b></h5>
        </div>`;
        newRow.innerHTML = `
          <h6 class="p-0">\${productName}<span class="badge bg-dark text-light quantity">1개</span>
                <button class="btn btn-success  btn-sm add-item">+</button>
                <button class="btn btn-warning btn-sm subtract-item">-</button>
        `;
        selectedContainer.appendChild(newRow);
      }

      // 총가격 갱신
      updateTotalPrice();

    }


    // 주문하기
    function pay() {
      //유효성 체크
      if (!validateForm()) {
        return ;
      }

      // 2. OrderTO 객체 만들기 (OrderRequest의 order)
      let orderTO = {
        email: document.getElementById('email').value,
        address: document.getElementById('address').value,
        zipcode: document.getElementById('zipcode').value,
        date: getCurrentDate(),
      };
        totalPrice: totalPrice;

      console.log(selectedProducts)
      selectedProducts.forEach((value, key) => {
        debugger;
           let orderItem = {
            productName: key,
            productId: value.productId,
            quantity: value.quantity,
            price: value.price,
            email: document.getElementById('email').value,
            date: getCurrentDate(),
            address: document.getElementById('address').value,
            zipcode: document.getElementById('zipcode').value
          };

        items.push(orderItem);
      });

      // 최종 제출폼에 데이터 추가
      orderRequest.set("order", orderTO);
      orderRequest.set("items", items);
      debugger;

      const xhr = new XMLHttpRequest();
      xhr.open("POST", "/user/order", true);
      // 요청 헤더 설정
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 201) {
          alert("결제가 완료 되었습니다.")
          window.location.href = "/view"
        }
      };
      // 요청 전송 (JSON 문자열로 변환)
      xhr.send(JSON.stringify(Object.fromEntries(orderRequest)));

      location.reload();
    }

    function validateForm() {
      // 각 입력 요소 가져오기
      const email = document.getElementById('email').value;
      const address = document.getElementById('address').value;
      const zipcode = document.getElementById('zipcode').value;

      // 값 비어있는지 체크
      if (!email || !address || !zipcode) {
        alert('모든 필드를 입력해주세요!');
        return false;  // 폼 제출을 막음
      }

      // 이메일 형식 체크
      const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
      if (!emailPattern.test(email)) {
        alert('유효한 이메일 주소를 입력해주세요!');
        return false;  // 이메일이 유효하지 않으면 제출 안됨
      }

      return true;
    }

    function getCurrentDate() {
      const today = new Date();

      // 날짜 정보 추출
      const year = today.getFullYear();
      const month = String(today.getMonth() + 1).padStart(2, '0');  // 월은 0부터 시작하므로 1을 더함
      const day = String(today.getDate()).padStart(2, '0');

      // YYYY-MM-DD 형식으로 반환
      //return `${year}-${month}-${day}`;
      return year +'-'+month+'-'+day;
    }

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
      flex-direction: row;
      box-shadow: 0 6px 20px 0 rgba(0, 0, 0, 0.19);
      border-radius: 1rem;
      border: transparent
    }

    .add-item {
      background-color: #212529;
      padding: .35em .65em;
    }

    .subtract-item{
      background-color: #212529;
      color: #fff;
      padding: .35em .65em;
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

<div class="my-4 d-flex justify-content-center">
  <h1 class="m-4" id="main-title" class="mb-0">Grids & Circle</h1>
  <button class="m-4 btn btn-outline-secondary" id="user-btn">관리자용</button>
</div>

<div class="card">
  <div class="row">
    </div>
    <div class="col-md-8 mt-4 d-flex flex-column align-items-start p-3 pt-0" id="products-list">

    </div>
    <div class="col-md-4 summary p-4">
      <div>
        <h5 class="m-0 p-0" id="right-panel-title"><b>장바구니</b></h5>
      </div>
      <br>
      <div id="selectedProducts">
        <div id="order-form">

        </div>
      </div>
      <hr>
      <div id="orderDetailsContainer">
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
            <label for="zipcode" class="form-label">우편번호</label>
            <input type="text" class="form-control" id="zipcode">
          </div>
          <div>당일 오후 2시 이후의 주문은 다음날 배송을 시작합니다.</div>
        </form>
        <div class="row pt-2 pb-2 border-top">
          <h5 class="col">총금액</h5>
          <h5 class="col text-end" id="totalPrice">원</h5>
        </div>
        <button class="mb-3 btn btn-dark col-12" style="width:48%;"  onclick="pay()">결제하기</button>
        <button class="mb-3 btn btn-dark col-12" style="width:48%;"  onclick="orderInquiry()">주문조회</button>
      </div>

    </div>

<div class="col-md-4 summary p-4" id="summary-container">


  </div>
</div>
</body>
</html>