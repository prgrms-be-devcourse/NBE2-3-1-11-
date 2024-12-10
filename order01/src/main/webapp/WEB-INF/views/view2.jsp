<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script type="text/javascript">
        let currentView = "product";

        // 상태 토글을 통해 화면을 동적으로 바꿈
        function toggleView(viewType) {
            currentView = viewType; // 상태 저장

            const dataTypeDiv = document.getElementById("data-type");
            const contentList = document.getElementById("contents-list");

            dataTypeDiv.style.display = "none";
            dataTypeDiv.innerHTML = "";
            contentList.innerHTML = "";


            if (viewType === "product") {
                showProductManagement();
            } else if (viewType === "order") {
                showOrderManagement();
            }
        }

        // 상품 목록 관리 UI 표시
        function showProductManagement() {
            const summaryDiv = document.getElementById('summary-container');
            summaryDiv.innerHTML = `

            <h3 id="right-panel-title">상품 추가</h3>
            <br>
            <form>
                <div class="mb-3">
                    <label for="name" class="form-label">상품명</label>
                    <input type="text" class="form-control" id="name">
                </div>
                <div class="mb-3">
                    <label for="price" class="form-label">가격</label>
                    <input type="text" class="form-control" id="price">
                </div>
                <div class="mb-3">
                    <label for="imgsrc" class="form-label">상품 이미지</label>
                    <input type="text" class="form-control" id="imgsrc">
                </div>
                <input type="hidden" id="product-id">
            </form>
            <button class="btn btn-dark col-12" onclick="handleSubmit()">등록하기/수정하기</button>
            `;
        }
        // 주문 목록 관리 UI 표시
        function showOrderManagement() {
            const summaryDiv = document.getElementById('summary-container');
                summaryDiv.innerHTML = `
                <h4>주문상세</h4>
                <div><p>왼쪽의 '상세보기' 버튼을 눌러 주문의 내용을 확인할 수 있습니다.</p></div>
                `;


        }

        document.addEventListener('DOMContentLoaded', () => {
            const adminBtn = document.getElementById('user-btn');

            adminBtn.addEventListener('click', () => {
                window.location.href = "/view";
            });
        });

        function getAllProducts() {
            toggleView("product");

            // 데이터 형식 표시
            const dataTypeDiv = document.getElementById("data-type");
            dataTypeDiv.style.display = "block";
            dataTypeDiv.innerHTML = `
                <div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px;
               display: flex; justify-content: center; align-items: center;">
               <div class="product-id" style="flex: 1;">ID</div>
                <div class="product-name" style="flex: 22; text-align: center;">이미지</div>
                <div class="product-name" style="flex: 14; text-align: left;">상품명</div>
                <div class="product-price" style="flex: 29" text-align:center;>가격</div>

            </div>
            `;


            const xhr = new XMLHttpRequest();
            xhr.open("GET", "/admin/products", true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const products = JSON.parse(xhr.responseText);
                    const productTableBody = document.getElementById("contents-list");

                    productTableBody.innerHTML = ""; // 데이터 초기화
                    products.forEach(product => {
                        // 상품이미지 설정
                        console.log(product.imgsrc);
                        console.log(product);

                        const row = `
                           <div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px;
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
                                <button class="btn btn-outline-secondary edit-btn" onclick="getProductById(\${product.productId})">수정</button>
                            </div>
                            <div class="button-container" style="flex: 1;">
                                <button class="btn btn-outline-secondary delete-btn" onclick="removeProduct(\${product.productId})">삭제</button>
                            </div>
                        </div>
                            `;
                        productTableBody.innerHTML += row;

                    });
                }
            };
            xhr.send();
        }

        // 첫 접속 시 상품 목록 가져오기 API 호출
        document.addEventListener("DOMContentLoaded", function () {
            getAllProducts();
        });

        // 상품 아이디로 상품 조회 API -수정
        function getProductById(productId) {
            // 선택된 아이템 productId 저장
            document.getElementById("product-id").value = productId;
            document.getElementById("right-panel-title").textContent = "상품 수정";

            const xhr = new XMLHttpRequest();
            xhr.open("GET", `/admin/product/\${productId}`, true);

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const product = JSON.parse(xhr.responseText);

                        console.log(product);

                        // 폼에 값 채우기
                        document.getElementById("name").value = product.name || '';
                        document.getElementById("price").value = product.price || '';
                        document.getElementById("imgsrc").value = product.imgsrc || '';
                    } else {
                        alert("상품 정보를 불러오는 중 오류가 발생했습니다.");
                    }
                }
            };

            xhr.send();
        }

        // 상품 등록 / 수정 버튼 클릭 시 분기
        function handleSubmit() {
            const productId = document.getElementById("product-id").value; // productId 값 가져오기
            const name = document.getElementById("name").value;
            const price = document.getElementById("price").value;
            const imgsrc = document.getElementById("imgsrc").value;

            if (!productId) {
                addProduct(productId, name, price, imgsrc);
            } else {
                updateProduct(productId, name, price, imgsrc);
            }

            return false;
        }

        // 상품 수정 API 호출
        function updateProduct(productId, name, price, imgsrc) {
            console.log(productId, name, price, imgsrc);
            if(confirm("수정하시겠습니까?")) {
                const updatedProduct = {
                    productId: productId,
                    name: name,
                    price: price,
                    imgsrc: imgsrc
                };


                const xhr = new XMLHttpRequest();
                xhr.open("PUT", "/admin/product", true);
                xhr.setRequestHeader("Content-Type", "application/json");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            alert("수정이 완료되었습니다.");
                            console.log(imgsrc);
                            location.reload();

                            // 선택되었던 product-id 초기화
                            document.getElementById("product-id").value = "";
                        } else {
                           alert("수정에 실패했습니다.");
                        }
                    }
                };

                xhr.send(JSON.stringify(updatedProduct));
            }
        }

        // 상품 추가
        // TODO: 상품 추가 API 호출 함수 구현 필요
        // ??? : 상품 조회할지 상품 추가할지에 대한 구현이 제대로 되지 않은것 같습니다 (현욱)
        // (가빈) 수정 버튼 클릭 시, 상품 내용이 조회되고 이후 수정 가능합니다. 수정 버튼이 클릭되지 않았을 때(form이 비어있는 상태)에 정보를 입력하고 버튼을 누르면 등록이 됩니다.
        function addProduct() {
            if (confirm("추가하시겠습니까?")) {
                const productId = document.getElementById("product-id").value;
                const name = document.getElementById("name").value;
                const price = document.getElementById("price").value;
                const imgsrc = document.getElementById("imgsrc").value;
                const addedProduct = {
                    productId: productId,
                    name: name,
                    price: price,
                    imgsrc: imgsrc
                };

                const xhr = new XMLHttpRequest();
                xhr.open("POST", "/admin/product", true);
                xhr.setRequestHeader("Content-Type", "application/json");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 201) {
                            alert("새 상품 등록이 완료되었습니다 ^ㅇ^/\"");
                            location.reload();
                        } else {
                            alert("상품 등록중 오류가 발생했습니다 ㅠ_ㅠ");
                            location.reload();
                        }
                    }
                };

                xhr.send(JSON.stringify(addedProduct));

                // const imgsrc = document.getElementById("imgsrc").value;

            }
        }

        // 상품 삭제 API 호출
        function removeProduct(productId) {
            // 삭제 확인 alert 창
            if (confirm("삭제하시겠습니까?")) {
                const xhr = new XMLHttpRequest();
                xhr.open("DELETE", `/admin/product/\${productId}`, true);
                xhr.setRequestHeader("Content-Type", "application/json");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            alert("삭제가 완료되었습니다.");
                            location.reload();
                        } else {
                            alert("삭제 중 오류가 발생했습니다.");
                        }
                    }
                };

                xhr.send();
            }
        }

        // 주문 목록 조회 API 호출
        function getAllOrders() {
            toggleView("order");

            const dataTypeDiv = document.getElementById("data-type");
            dataTypeDiv.style.display = "block";
            dataTypeDiv.innerHTML = `
                <div class="product-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px;
               display: flex; justify-content: center; align-items: center;">
               <div class="order-id" style="flex: 1;">ID</div>
                <div class="order-date" style="flex: 5; text-align: center;">주문 일자</div>
                <div class="order-address" style="flex: 4; text-align: center;">주소</div>
                <div class="order-zipcode" style="flex: 3; text-align: center;">우편번호</div>
                <div class="order-totalprice" style="flex: 3; text-align: center;">총액</div>
                <div class="button-container" style="flex: 4; text-align: center;">

                </div>
            </div>
            `;

            const xhr = new XMLHttpRequest();
            xhr.open("GET", "/admin/orders", true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const orders = JSON.parse(xhr.responseText);
                    const orderTableBody = document.getElementById("contents-list");

                    orderTableBody.innerHTML = ""; // 데이터 초기화
                    orders.forEach(order => {
                        console.log(order);
                        const row = `
                        <div class="order-row" style="border: 1px solid #ddd; padding: 10px; margin: 5px;
                           display: flex; justify-content: center; align-items: center;">
                        <div class="order-id" style="flex: 1;">\${order.orderId}</div>
                        <div class="order-date" style="flex: 5; text-align: center;">\${order.date}</div>
                        <div class="order-address" style="flex: 4; text-align: center;">\${order.address}</div>
                        <div class="order-zipcode" style="flex: 3; text-align: center;">\${order.zipcode}</div>
                        <div class="order-totalprice" style="flex: 3;">\${order.totalPrice}원</div>
                        <div class="button-container" style="flex: 4;">
                            <button class="btn btn-outline-secondary edit-btn" onclick="getOrderDetail(\${order.orderId})">상세보기</button>
                        </div>
                    </div>

                    `;
                        orderTableBody.innerHTML += row;
                    });


                }
            };
            xhr.send();

        }

        function getOrderDetail(orderId) {
            const xhr = new XMLHttpRequest();

            xhr.open("GET", `/admin/orders-detail/\${orderId}`, true); // API 호출 (orderId를 포함하여)

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const orderDetails = JSON.parse(xhr.responseText);
                    console.log(orderDetails);

                    // 결과를 summary-container에 동적으로 렌더링
                    const summaryDiv = document.getElementById('summary-container');

                    // 상품 목록을 동적으로 렌더링
                    let productListHTML = "";
                    if (orderDetails.items && Array.isArray(orderDetails.items)) {

                        productListHTML = orderDetails.items.map(item =>
                            `<hr><li style="margin-bottom: 15px; border: 1px solid #ddd; padding: 10px; border-radius: 5px; display: flex; align-items: center;">
                                <img src="\${item.imgsrc}" onerror="this.src='https://i.imgur.com/HKOFQYa.jpeg';"  style="width: 50px; height: 50px; margin-right: 15px;" alt="이미지">
                            <div>
                                <p><b>상품명:</b> \${item.name}</p>
                                <p><b>수량:</b> \${item.quantity}</p>
                                <p><b>가격:</b> \${item.price} 원</p>
                            </div>
                        </li>`
                        ).join('');
                    }

                    summaryDiv.innerHTML = `
                            <h4>주문 상세정보</h4>
                            <p><b>주문 ID:</b> \${orderDetails.orderId}</p>
                            <p><b>주문 날짜:</b> \${orderDetails.date}</p>
                            <p><b>총 금액:</b> \${orderDetails.totalPrice} 원</p>
                            <p><b>배송지:</b> \${orderDetails.address}, \${orderDetails.zipcode}</p>
                            <p><b>상품 목록:</b></p>
                            <ul style="list-style: none; padding: 0;">
                                \${productListHTML}
                            </ul>
                        `;
                } else if (xhr.readyState === 4) {
                    alert("주문 상세정보를 가져오는 중 오류가 발생했습니다.");
                }
            };

            xhr.send();

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
    </style>
    <title>Product Management</title>
</head>
<body class="container-fluid">

<!-- 사용자용 버튼 -->
<div class="my-4 d-flex justify-content-center">
    <h1 class="m-4" id="main-title" class="mb-0">Grids & Circle</h1>
    <button class="m-4 btn btn-outline-secondary" id="user-btn">사용자용</button>
</div>

<div class="card">
    <div class="row">
        <div class="col-md-8 mt-4 d-flex flex-column align-items-start p-3 pt-0">
            <div class="d-flex justify-content-center mb-3">
                <button class="btn btn-outline-secondary ms-2" id="product-btn" onclick="getAllProducts()"><b>상품 목록</b></button>
                <button class="btn btn-outline-secondary ms-2"  id="order-manage-btn" onclick="getAllOrders()"><b>주문관리</b></button>
            </div>
            <div id="data-type" class="data-type" style="display: none; width: -webkit-fill-available;"></div>
            <ul class="list-group products" id="contents-list" style="width: -webkit-fill-available;"></ul>
        </div>
        <div class="col-md-4 summary p-4" id="summary-container">
        </div>
    </div>
</div>

</body>
</html>
