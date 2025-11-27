<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>먹게배달 | ${menuName} 주문하기</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- 폰트 (원하면 home.css에서 공통으로 빼도 됨) -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">

  <style>
    :root{
      --bg:#ffffff;           /* 🔹 전체 배경 흰색으로 */
      --panel:#ffffff;
      --brand:#6c5ce7;
      --border:#e5e7eb;
      --text:#111827;
      --muted:#6b7280;
      --shadow:0 18px 45px rgba(15,23,42,.06);
      --radius-xl:24px;
    }

    *{box-sizing:border-box;margin:0;padding:0;}
    body{
      font-family:"Noto Sans KR",system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
      background:var(--bg);
      color:var(--text);
      min-height:100vh;
      display:flex;
      flex-direction:column;
    }

    /* 헤더 */
    .nav{
      position:sticky;
      top:0;
      z-index:10;
      backdrop-filter:blur(12px);
      background:rgba(255,255,255,.9); /* 🔹 거의 흰색 */
      border-bottom:1px solid rgba(148,163,184,.18);
    }
    .nav-inner{
      max-width:1040px;
      margin:0 auto;
      padding:14px 18px;
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:16px;
    }
    .brand-wrap{
      display:flex;
      align-items:center;
      gap:10px;
      font-weight:900;
      letter-spacing:-.03em;
    }
    .brand-main{
      font-size:20px;
    }
    .brand-sub{
      font-size:18px;
      color:var(--brand);
    }
    .brand-badge{
      font-size:11px;
      padding:3px 8px;
      border-radius:999px;
      border:1px solid rgba(124,58,237,.3);
      color:#6d28d9;
      background:rgba(237,233,254,.8);
    }
    .nav-actions{
      display:flex;
      align-items:center;
      gap:10px;
      font-size:13px;
      color:var(--muted);
    }
    .nav-chip{
      padding:4px 9px;
      border-radius:999px;
      background:#fff;
      border:1px solid rgba(148,163,184,.35);
    }
    .nav-close-btn{
      border:0;
      background:transparent;
      font-size:13px;
      cursor:pointer;
      color:var(--muted);
    }

    /* 메인 레이아웃 */
    .wrap{
      max-width:1040px;
      margin:0 auto;
      padding:22px 18px 40px;
      flex:1;
    }

    .page-header{
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap:18px;
      margin-bottom:18px;
    }
    .page-title{
      font-size:26px;
      font-weight:900;
      letter-spacing:-.03em;
      margin-bottom:6px;
    }
    .page-sub{
      font-size:14px;
      color:var(--muted);
    }
    .pill-row{
      display:flex;
      align-items:center;
      gap:8px;
      margin-top:6px;
      flex-wrap:wrap;
    }
    .pill{
      font-size:11px;
      padding:4px 9px;
      border-radius:999px;
      border:1px solid var(--border);
      color:var(--muted);
      background:rgba(255,255,255,.9);
    }
    .pill-strong{
      border-color:rgba(124,58,237,.4);
      color:#5b21b6;
      background:rgba(237,233,254,.95);
    }

    .summary-card{
      background:var(--panel);
      border-radius:var(--radius-xl);
      box-shadow:var(--shadow);
      border:1px solid var(--border);
      padding:16px 18px;
      display:flex;
      align-items:center;
      gap:14px;
      margin-bottom:18px;
    }
    .summary-icon{
      width:38px;height:38px;
      border-radius:18px;
      background:linear-gradient(135deg,#a855f7,#6366f1);
      display:flex;
      align-items:center;
      justify-content:center;
      color:#fff;
      font-size:20px;
    }
    .summary-text-main{
      font-size:14px;
      font-weight:700;
      margin-bottom:2px;
    }
    .summary-text-sub{
      font-size:12px;
      color:var(--muted);
    }

    /* ===== 가게 리스트 전체 박스 ===== */
    .store-section{
      background:#ffffff;
      border-radius:var(--radius-xl);
      border:1px solid var(--border);
      box-shadow:var(--shadow);
      padding:16px 18px 12px;
    }
    .store-section-title{
      font-size:14px;
      font-weight:700;
      margin-bottom:6px;
    }
    .store-section-sub{
      font-size:12px;
      color:var(--muted);
      margin-bottom:10px;
    }

    /* 가게 리스트: 한 줄씩 */
    .store-grid{
      display:flex;
      flex-direction:column;
      gap:10px;
      margin-top:4px;
    }

    .store-card{
      background:#fafafa;
      border-radius:16px;
      border:1px solid var(--border);
      box-shadow:0 4px 14px rgba(15,23,42,.04);
      padding:10px 12px;
      cursor:pointer;
      transition:.16s transform,.16s box-shadow,.16s border-color,.16s background;
      display:flex;
      align-items:stretch;
      gap:12px;
    }
    .store-card:hover{
      transform:translateY(-2px);
      box-shadow:0 10px 30px rgba(15,23,42,.06);
      border-color:rgba(129,140,248,.8);
      background:#ffffff;
    }

    .store-thumb{
      flex:0 0 88px;
      height:88px;
      border-radius:14px;
      overflow:hidden;
      background:#e5e7eb;
      display:flex;
      align-items:center;
      justify-content:center;
      font-size:26px;
    }
    .store-thumb img{
      width:100%;
      height:100%;
      object-fit:cover;
      display:block;
    }

    .store-body{
      flex:1;
      display:flex;
      flex-direction:column;
      gap:4px;
    }

    .store-header{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:8px;
    }
    .store-name{
      font-size:15px;
      font-weight:800;
    }
    .store-tag{
      font-size:11px;
      padding:3px 7px;
      border-radius:999px;
      background:#eff6ff;
      color:#1d4ed8;
      border:1px solid rgba(129,140,248,.45);
      white-space:nowrap;
    }
    .store-meta{
      font-size:12px;
      color:var(--muted);
      display:flex;
      flex-wrap:wrap;
      gap:6px 10px;
      align-items:center;
    }
    .dot{
      width:3px;height:3px;
      border-radius:999px;
      background:rgba(148,163,184,.8);
    }
    .store-footer{
      display:flex;
      justify-content:space-between;
      align-items:center;
      margin-top:6px;
      gap:10px;
    }
    .price-info{
      font-size:11px;
      color:var(--muted);
    }
    .price-info strong{
      font-size:13px;
      color:#111827;
    }
    .select-btn{
      padding:7px 12px;
      border-radius:999px;
      border:0;
      font-size:12px;
      font-weight:700;
      cursor:pointer;
      background:var(--brand);
      color:#fff;
      white-space:nowrap;
    }

    /* 모달 */
    .modal-backdrop{
      position:fixed;
      inset:0;
      background:rgba(15,23,42,.42);
      display:flex;
      align-items:center;
      justify-content:center;
      z-index:50;
      padding:18px;
    }
    .hidden{display:none;}
    .modal-panel{
      width:100%;
      max-width:520px;
      background:#fdfbff;
      border-radius:26px;
      box-shadow:0 22px 60px rgba(15,23,42,.35);
      border:1px solid rgba(212,212,255,.9);
      padding:22px 22px 18px;
      position:relative;
    }
    .modal-header-row{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:8px;
      margin-bottom:10px;
    }
    .modal-title{
      font-size:18px;
      font-weight:800;
      letter-spacing:-.03em;
    }
    .modal-step{
      font-size:11px;
      color:#6d28d9;
      padding:4px 9px;
      border-radius:999px;
      background:rgba(237,233,254,.9);
    }
    .modal-close{
      border:0;
      background:transparent;
      cursor:pointer;
      font-size:18px;
      line-height:1;
      color:var(--muted);
    }

    .modal-section{
      background:#fff;
      border-radius:18px;
      padding:14px 14px 12px;
      border:1px solid var(--border);
      margin-top:8px;
    }
    .modal-store-name{
      font-size:16px;
      font-weight:800;
      margin-bottom:2px;
    }
    .modal-menu-name{
      font-size:14px;
      color:var(--muted);
      margin-bottom:8px;
    }
    .modal-row{
      display:flex;
      justify-content:space-between;
      font-size:13px;
      margin-bottom:4px;
      color:var(--muted);
    }
    .modal-row strong{
      color:#111827;
    }
    .modal-divider{
      height:1px;
      background:rgba(229,231,235,.9);
      margin:8px 0;
    }

    .modal-total-row{
      display:flex;
      justify-content:space-between;
      align-items:center;
      font-size:15px;
      font-weight:800;
      margin-top:4px;
    }
    .modal-total-amount{
      font-size:18px;
      color:#4c1d95;
    }

    .modal-actions{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:10px;
      margin-top:14px;
    }
    .btn-secondary{
      flex:1;
      border-radius:999px;
      border:1px solid var(--border);
      background:#fff;
      padding:11px 14px;
      font-size:13px;
      cursor:pointer;
      color:var(--muted);
    }
    .btn-primary{
      flex:2;
      border-radius:999px;
      border:0;
      background:linear-gradient(135deg,#8b5cf6,#6366f1);
      color:#fff;
      font-size:14px;
      font-weight:800;
      padding:11px 16px;
      cursor:pointer;
      box-shadow:0 6px 18px rgba(79,70,229,.18);
    }
    .btn-primary span{
      font-size:12px;
      opacity:.9;
      margin-left:6px;
    }

    @media (max-width:640px){
      .page-header{
        flex-direction:column;
      }
      .summary-card{
        flex-direction:row;
        align-items:flex-start;
      }
      .store-card{
        flex-direction:row;
      }
      .modal-panel{
        padding:18px 16px 14px;
        border-radius:22px;
      }
    }
  </style>
</head>
<body>

<header class="nav">
  <div class="nav-inner">
    <div class="brand-wrap">
      <div class="brand-main">오늘 뭐먹게</div>
      <div class="brand-sub">먹게배달</div>
      <span class="brand-badge">데모 · 원스텝 주문</span>
    </div>
    <div class="nav-actions">
      <div class="nav-chip">1단계 · 가게 선택</div>
      <button class="nav-close-btn" onclick="window.history.back()">돌아가기</button>
    </div>
  </div>
</header>

<main class="wrap">
  <div class="page-header">
    <div>
      <h1 class="page-title">${menuName}, 어디서 주문해볼까요?</h1>
      <p class="page-sub">
        추천받은 메뉴 <strong>"${menuName}"</strong>를 바로 배달로 주문할 수 있는 가게를 골라보세요. (임의 데이터 · 데모)
      </p>
      <div class="pill-row">
        <span class="pill pill-strong">오늘 뭐먹게 추천 연동</span>
        <span class="pill">${menuName} 기반 주변 가게 리스트</span>
        <span class="pill">선택 후 한 번에 결제 페이지 진입</span>
      </div>
    </div>
  </div>

  <section class="summary-card">
    <div class="summary-icon">🍽️</div>
    <div>
      <div class="summary-text-main">현재 선택된 메뉴 · ${menuName}</div>
      <div class="summary-text-sub">
        아래 가게 중 하나를 선택하면, 먹게배달 결제 모달이 뜨면서
        <strong>가게 · 메뉴 · 예상 금액</strong>이 한 번에 정리됩니다.
      </div>
    </div>
  </section>

  <!-- 🔹 가게 리스트 전체 흰색 박스 -->
  <section class="store-section">
    <div class="store-section-title">주변 "${menuName}" 배달 가능 가게 (데모)</div>
    <div class="store-section-sub">실제 위치/가격과는 무관한 임의 데이터입니다.</div>

    <div class="store-grid">
      <!-- 가게 1 : 음식/음료 둘 다 어울리는 이름 -->
      <article class="store-card"
               data-store="민성 다이닝"
               data-menu="${menuName}"
               data-price="8900"
               data-fee="2000"
               data-eta="25~35분">
        <div class="store-thumb">
          <!-- 🔹 이미지도 그냥 데모용 (원하면 교체) -->
          <img src="<c:url value='/images/민성규동.png'/>"
               alt="민성 다이닝 대표 이미지">
        </div>
        <div class="store-body">
          <div class="store-header">
            <div>
              <div class="store-name">민성 다이닝</div>
              <div class="store-meta">
                ⭐ 4.8 (1,250+)
                <span class="dot"></span>
                배달 <strong>25~35분</strong>
                <span class="dot"></span>
                식사/음료 모두 인기
              </div>
            </div>
            <span class="store-tag">다이닝 · 카페</span>
          </div>
          <div class="store-footer">
            <div class="price-info">
              <div>최소 주문금액 <strong>9,000원</strong></div>
              <div>배달팁 2,000원</div>
            </div>
            <button class="select-btn">이 가게에서 주문</button>
          </div>
        </div>
      </article>

      <!-- 가게 2 -->
      <article class="store-card"
               data-store="선아 키친"
               data-menu="${menuName}"
               data-price="8200"
               data-fee="3000"
               data-eta="30~40분">
        <div class="store-thumb">
          <img src="<c:url value='/images/선아규동.png'/>"
               alt="선아 키친 대표 이미지">
        </div>
        <div class="store-body">
          <div class="store-header">
            <div>
              <div class="store-name">선아 키친</div>
              <div class="store-meta">
                ⭐ 4.6 (980+)
                <span class="dot"></span>
                배달 <strong>30~40분</strong>
                <span class="dot"></span>
                브런치·디저트까지
              </div>
            </div>
            <span class="store-tag">키친 · 카페</span>
          </div>
          <div class="store-footer">
            <div class="price-info">
              <div>최소 주문금액 <strong>8,000원</strong></div>
              <div>배달팁 3,000원</div>
            </div>
            <button class="select-btn">이 가게에서 주문</button>
          </div>
        </div>
      </article>

      <!-- 가게 3 -->
      <article class="store-card"
               data-store="지윤네 테이블"
               data-menu="${menuName}"
               data-price="9500"
               data-fee="1500"
               data-eta="20~30분">
        <div class="store-thumb">
          <img src="<c:url value='/images/지윤규동.png'/>"
               alt="지윤네 테이블 대표 이미지">
        </div>
        <div class="store-body">
          <div class="store-header">
            <div>
              <div class="store-name">지윤네 테이블</div>
              <div class="store-meta">
                ⭐ 4.9 (530+)
                <span class="dot"></span>
                배달 <strong>20~30분</strong>
                <span class="dot"></span>
                식사와 커피 모두 호평
              </div>
            </div>
            <span class="store-tag">레스토랑 · 카페</span>
          </div>
          <div class="store-footer">
            <div class="price-info">
              <div>최소 주문금액 <strong>10,000원</strong></div>
              <div>배달팁 1,500원</div>
            </div>
            <button class="select-btn">이 가게에서 주문</button>
          </div>
        </div>
      </article>
    </div>
  </section>
</main>

<!-- ✅ 결제 모달 -->
<div class="modal-backdrop hidden" id="orderModal">
  <div class="modal-panel">
    <div class="modal-header-row">
      <div>
        <div class="modal-step">2 · 메뉴 확인 & 결제 준비</div>
        <h2 class="modal-title">먹게배달에서 바로 주문하기</h2>
      </div>
      <button class="modal-close" id="modalCloseBtn">&times;</button>
    </div>

    <section class="modal-section">
      <!-- 기본값은 아무 이름이나, 실제론 JS가 선택한 가게명으로 덮어씀 -->
      <div class="modal-store-name" id="modalStoreName">선택한 가게</div>
      <div class="modal-menu-name" id="modalMenuName">${menuName} · 기본(보통 사이즈)</div>

      <div class="modal-row">
        <span>예상 배달시간</span>
        <strong id="modalEta">25~35분</strong>
      </div>
      <div class="modal-row">
        <span>메뉴 금액</span>
        <strong id="modalMenuPrice">8,900원</strong>
      </div>
      <div class="modal-row">
        <span>배달비</span>
        <strong id="modalFee">2,000원</strong>
      </div>

      <div class="modal-divider"></div>

      <div class="modal-total-row">
        <span>총 결제 예상 금액</span>
        <span class="modal-total-amount" id="modalTotal">10,900원</span>
      </div>
    </section>

    <div class="modal-actions">
      <button class="btn-secondary" id="modalBackBtn">가게 다시 고르기</button>
      <button class="btn-primary" id="modalPayBtn">
        먹게배달 결제 페이지로 이동
        <span>(데모)</span>
      </button>
    </div>
  </div>
</div>

<script>
  // 금액 포맷용 헬퍼
  function formatCurrency(num){
    return Number(num).toLocaleString("ko-KR") + "원";
  }

  const modal = document.getElementById("orderModal");
  const modalStoreName = document.getElementById("modalStoreName");
  const modalMenuName  = document.getElementById("modalMenuName");
  const modalEta       = document.getElementById("modalEta");
  const modalMenuPrice = document.getElementById("modalMenuPrice");
  const modalFee       = document.getElementById("modalFee");
  const modalTotal     = document.getElementById("modalTotal");

  document.querySelectorAll(".store-card").forEach(card => {
    card.addEventListener("click", () => {
      const store = card.dataset.store;
      const menu  = card.dataset.menu || "${menuName}";
      const price = Number(card.dataset.price || 8900);
      const fee   = Number(card.dataset.fee || 2000);
      const eta   = card.dataset.eta || "25~35분";

      modalStoreName.textContent = store;
      modalMenuName.textContent  = menu + " · 기본(보통 사이즈)";
      modalEta.textContent       = eta;
      modalMenuPrice.textContent = formatCurrency(price);
      modalFee.textContent       = formatCurrency(fee);
      modalTotal.textContent     = formatCurrency(price + fee);

      modal.classList.remove("hidden");
    });

    // 카드 안의 버튼만 눌러도 동일하게 동작
    const btn = card.querySelector(".select-btn");
    if (btn){
      btn.addEventListener("click", (e) => {
        e.stopPropagation();
        card.click();
      });
    }
  });

  document.getElementById("modalCloseBtn").onclick = () => {
    modal.classList.add("hidden");
  };
  document.getElementById("modalBackBtn").onclick = () => {
    modal.classList.add("hidden");
  };

  // 결제 페이지 이동(데모용)
  document.getElementById("modalPayBtn").onclick = () => {
    alert("데모 화면입니다. 나중에 여기에서 '결제 완료 페이지'로 이동하도록 연동하면 됩니다.");
  };

  // 배경 클릭하면 닫기 (모달 밖 영역 클릭)
  modal.addEventListener("click", (e) => {
    if (e.target === modal){
      modal.classList.add("hidden");
    }
  });
</script>

</body>
</html>
