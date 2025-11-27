<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 음료 추천 결과</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">

  <!-- ✅ home.jsp와 동일한 공통 CSS -->
  <link rel="stylesheet" href="<c:url value='/home.css'/>">

  <style>
    :root{
      --ring:#ede9fe;
      --ring-strong:0 0 0 4px var(--ring);

      --gold:#ffc83a; --gold-deep:#f7b500;
      --silver:#cfd8dc; --silver-deep:#9ea7ad;
      --bronze:#e7a26a; --bronze-deep:#c77c3a;
    }

    .logout-btn{
      white-space: nowrap;
    }

    .title-area{
      text-align:center;
      margin:26px 0 20px;
    }
    .title-area h2{
      font-size:26px;
      font-weight:900;
      letter-spacing:-.3px;
    }
    .title-area p{
      color:var(--muted);
      margin-top:6px;
      font-size:14px;
    }

    .empty-box{
      width:100%;
      max-width:720px;
      margin:0 auto 56px;
      padding:26px 22px 22px;
      background:var(--panel);
      border-radius:18px;
      border:1px dashed var(--border);
      box-shadow:var(--shadow);
      text-align:center;
    }
    .empty-box h3{
      font-size:18px;
      font-weight:900;
      margin-bottom:8px;
      letter-spacing:-.3px;
    }
    .empty-box p{
      font-size:14px;
      color:var(--muted);
      margin:4px 0;
      line-height:1.6;
    }

    .card-wrap{
      width:100%;
      max-width:900px;
      margin:0 auto 56px;
      display:flex;
      flex-direction:column;
      gap:24px;
    }
    .card{
      position:relative;
      background:var(--panel);
      border-radius:18px;
      box-shadow:var(--shadow);
      padding:24px 22px 22px;
      display:flex;
      flex-direction:column;
      gap:14px;
      border:2px solid var(--border);
      overflow:hidden;
    }
    .card::before{
      content:"";
      position:absolute; left:0; top:0; height:7px; width:100%;
      background:linear-gradient(90deg, rgba(0,0,0,.06), rgba(0,0,0,0));
    }

    .rank-badge{
      position:absolute; left:18px; top:14px;
      display:inline-flex; align-items:center; gap:6px;
      font-weight:800; font-size:12px;
      background:#fff7e0; color:#553b00;
      border-radius:20px; padding:6px 10px;
      box-shadow:var(--shadow);
      z-index:1;
    }

    .menu-header{
      display:flex;
      align-items:center;
      justify-content:space-between;
      width:100%;
      padding-left:72px;
      gap:10px;
    }
    .menu-title{
      font-size:20px;
      font-weight:800;
      letter-spacing:-.3px;
      flex:1;
      min-width:0;
    }

    .menu-desc{
      margin-top:4px;
      color:var(--muted);
      font-size:13px;
      line-height:1.6;
      padding-left:72px;
    }

    .menu-photo{
      width:100%;
      max-width:820px;
      border-radius:16px;
      margin:12px auto 4px;
      background:#f6f7f9;
      display:block;
      object-fit:cover;
      aspect-ratio:16/9;
      border:1px solid var(--border);
    }

    .section-label{
      margin-top:8px;
      margin-bottom:6px;
      font-size:12px;
      font-weight:800;
      color:#555;
      letter-spacing:-.2px;
      display:flex;
      align-items:center;
      gap:8px;
    }
    .section-label::before{
      content:"";
      width:7px; height:7px;
      border-radius:50%;
      background:var(--brand);
      display:inline-block;
    }

    .actions-row{
      width:100%;
      display:grid;
      grid-template-columns:1fr 1fr;
      gap:14px;
      align-items:start;
      margin-top:6px;
    }
    .actions-col{
      display:block;
    }

    .btn-row{
      display:flex;
      flex-wrap:wrap;
      gap:8px;
    }

    /* ───────── 버튼 공통 스타일 ───────── */
    .btn{
      flex:1;
      min-width:140px;
      padding:12px 14px;
      border-radius:12px;
      text-align:center;
      font-weight:900;
      font-size:15px;
      text-decoration:none;

      background:#ffffff;
      border:1px solid #d1d5db;
      cursor:pointer;

      box-shadow:0 2px 4px rgba(0,0,0,.12);

      transition:
        transform .15s ease,
        box-shadow .15s ease,
        border-color .15s ease,
        background .15s ease;
    }
    .btn:hover{
      transform:translateY(-2px);
      box-shadow:0 4px 10px rgba(0,0,0,.14);
      border-color:#b9bec6;
      background:#fafafa;
    }

    /* NAVER */
    .btn-naver{
      color:#00c73c;
      text-shadow:1px 1px 0 #13a02c;
    }

    /* KAKAO */
    .btn-kakao{
      color:#f0b400;
      text-shadow:1px 1px 0 #a07812;
    }

    /* BAEMIN */
    .btn-baemin{
      color:#00c7ae;
      text-shadow:1px 1px 0 #139f8c;
    }

    /* YOGIYO */
    .btn-yogiyo{
      color:#e0113b;
      text-shadow:1px 1px 0 #ad3621;
    }

    /* ───────── 먹게배달 (Full Color Button) ───────── */
    .btn-mukke{
      flex-basis:100%;
      margin-top:4px;

      background:#6c5ce7;
      color:#ffffff;
      border-color:#6c5ce7;

      font-weight:900;
      font-size:16px;

      box-shadow:0 4px 12px rgba(88,28,135,.35);
      text-shadow:1px 1px 0 rgba(0,0,0,0.5);
    }
    .btn-mukke:hover{
      background:#7560ff;
      box-shadow:0 6px 16px rgba(88,28,135,.45);
    }

    .retry-wrap{
      width:100%;
      max-width:900px;
      margin:0 auto 80px;
      text-align:center;
      position:relative;
    }
    .retry-btn{
      position:relative;
      display:inline-block;
      background:var(--brand);
      color:#fff;
      border:none;
      border-radius:16px;
      padding:13px 24px;
      font-weight:900;
      font-size:17px;
      letter-spacing:-.2px;
      box-shadow:
        0 0 24px rgba(111,70,255,.55),
        0 0 48px rgba(111,70,255,.35);
      cursor:pointer;
      text-decoration:none;
      transition:transform .15s ease, box-shadow .15s ease, filter .15s ease;
      isolation:isolate;
    }
    .retry-btn::after{
      content:"";
      position:absolute;
      left:50%; top:50%;
      transform:translate(-50%,-50%);
      width:125%; height:155%;
      border-radius:22px;
      pointer-events:none;
      z-index:-1;
      background:
        radial-gradient(circle at center,
          rgba(171,146,255,.45) 0%,
          rgba(111,70,255,.28) 45%,
          rgba(111,70,255,0) 70%);
      filter:blur(16px);
    }
    .retry-btn:hover{
      transform:translateY(-2px);
      box-shadow:
        0 0 32px rgba(111,70,255,.7),
        0 0 64px rgba(111,70,255,.45);
      filter:saturate(1.05);
    }
    .retry-btn:active{
      transform:translateY(0);
    }

    .card.rank-1{
      border-color:var(--gold);
      box-shadow:0 10px 24px rgba(247,181,0,.18);
    }
    .card.rank-1::before{
      background:linear-gradient(90deg, var(--gold) 0%, var(--gold-deep) 100%);
    }
    .card.rank-1 .rank-badge{
      background:#fff3c4;
      color:#6a5200;
    }

    .card.rank-2{
      border-color:var(--silver);
      box-shadow:0 10px 24px rgba(158,167,173,.18);
    }
    .card.rank-2::before{
      background:linear-gradient(90deg, var(--silver) 0%, var(--silver-deep) 100%);
    }
    .card.rank-2 .rank-badge{
      background:#eef3f6;
      color:#3f4a52;
    }

    .card.rank-3{
      border-color:var(--bronze);
      box-shadow:0 10px 24px rgba(199,124,58,.18);
    }
    .card.rank-3::before{
      background:linear-gradient(90deg, var(--bronze) 0%, var(--bronze-deep) 100%);
    }
    .card.rank-3 .rank-badge{
      background:#ffe7d3;
      color:#5a3518;
    }

    /* 🔹 별점 박스 (음료용) */
    .rating-box{
      margin:10px 0 6px;
      padding:12px;
      border:1px dashed var(--border);
      border-radius:14px;
      background:#fafafa;
    }
    .rating-title{
      font-weight:800;
      margin-bottom:6px;
      font-size:13px;
      display:flex;
      align-items:center;
      gap:8px;
    }
    .rating-title span{
      color:var(--muted);
      font-weight:600;
    }
    .rating-stars{
      display:flex;
      gap:9px;
      align-items:center;
      position:relative;
    }
    .rating-stars .star{
      display:inline-flex;
      width:30px;
      height:30px;
      cursor:pointer;
      user-select:none;
    }
    .rating-stars .star svg{
      width:100%;
      height:100%;
      stroke:#f1c40f;
      fill:transparent;
      stroke-width:2.2;
      stroke-linejoin:round;
      stroke-linecap:round;
      transition:transform .12s ease, filter .12s ease, fill .12s ease, stroke .12s ease;
    }
    .rating-stars .star.filled svg{
      fill:#ffd14a;
      stroke:#ffb300;
    }
    .rating-stars .star:hover svg{
      transform:scale(1.12);
      filter:drop-shadow(0 2px 6px rgba(0,0,0,.15));
    }
    .rating-stars .rating-hint{
      font-size:12px;
      color:var(--muted);
      font-weight:600;
      min-width:34px;
    }

    .sparkle{
      position:absolute;
      width:8px; height:8px;
      border-radius:50%;
      pointer-events:none;
      opacity:0;
      transform:translate(-50%,-50%) scale(0.6);
      background:radial-gradient(circle, #ffe07a 0%, #ffc300 60%, transparent 70%);
      animation:sparkle-pop .6s ease-out forwards;
    }
    @keyframes sparkle-pop{
      0%{
        opacity:0;
        transform:translate(var(--x), var(--y)) scale(.5);
      }
      15%{
        opacity:1;
        transform:translate(calc(var(--x) + var(--dx)*6px), calc(var(--y) + var(--dy)*6px)) scale(1.1);
      }
      100%{
        opacity:0;
        transform:translate(calc(var(--x) + var(--dx)*22px), calc(var(--y) + var(--dy)*22px)) scale(.2);
      }
    }

    /* 🔹 토스트 */
    .toast{
      position:fixed;
      left:50%;
      bottom:24px;
      transform:translateX(-50%) translateY(16px);
      background:#111827;
      color:#fff;
      padding:10px 16px;
      border-radius:999px;
      font-size:13px;
      font-weight:600;
      box-shadow:0 10px 25px rgba(15,23,42,.35);
      opacity:0;
      pointer-events:none;
      transition:opacity .22s ease, transform .22s ease;
      z-index:9999;
      white-space:nowrap;
    }
    .toast.show{
      opacity:1;
      transform:translateX(-50%) translateY(0);
    }

    @media (max-width:560px){
      .menu-header{
        padding-left:0;
        flex-direction:column;
        align-items:flex-start;
        gap:6px;
      }
      .menu-desc{
        padding-left:0;
      }
      .actions-row{
        grid-template-columns:1fr;
      }
      .btn{
        min-width:0;
      }
      .retry-btn{
        width:100%;
      }
      .toast{
        max-width:90%;
        white-space:normal;
        text-align:center;
      }
    }
  </style>
</head>

<body>

<header class="nav">
  <div class="nav-inner">
    <div class="nav-brand">오늘 뭐먹게</div>
    <a href="<c:url value='/logout'/>" class="logout-btn">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M15 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h8"></path>
        <path d="M10 17l5-5-5-5"></path>
        <path d="M15 12H3"></path>
      </svg>
      로그아웃
    </a>
  </div>
</header>

<main class="wrap">
  <div class="quick-nav-wrap">
    <nav class="quick-nav" aria-label="주요 메뉴">
      <a class="qitem" href="<c:url value='/home'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M3 10.5L12 3l9 7.5"></path>
          <path d="M5 10.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9.5"></path>
        </svg>
        <span class="label">홈</span>
      </a>
      <a class="qitem" href="<c:url value='/roulette'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M12 6v6l4 2"></path>
          <circle cx="12" cy="12" r="2"></circle>
        </svg>
        <span class="label">룰렛 돌리기</span>
      </a>
      <a class="qitem" href="<c:url value='/charts'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M3 20h18"></path>
          <path d="M7 20V9"></path>
          <path d="M12 20V4"></path>
          <path d="M17 20v-6"></path>
        </svg>
        <span class="label">인기차트</span>
      </a>
      <a class="qitem" href="<c:url value='/mypage'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="8" r="4"></circle>
          <path d="M4 21a8 8 0 0 1 16 0"></path>
        </svg>
        <span class="label">마이페이지</span>
      </a>
    </nav>
  </div>

  <div class="title-area">
    <h2>상위 추천 음료</h2>
    <p>당신의 취향을 분석해서 골라본 오늘의 음료입니다.</p>
  </div>

  <c:choose>
    <c:when test="${empty results}">
      <div class="empty-box">
        <h3>추천할 수 있는 음료가 아직 없어요</h3>
        <p>현재는 음료 추천 모델을 준비 중이에요.</p>
        <p>조금만 기다렸다가, 나중에 다시 음료 설문을 진행해 주세요.</p>
      </div>
    </c:when>

    <c:otherwise>
      <div class="card-wrap">
        <c:forEach var="item" items="${results}" varStatus="st">
          <div class="card rank-${st.index + 1}" data-beverage-name="${item.name}">
            <span class="rank-badge">
              #${st.index + 1}
            </span>

            <div class="menu-header">
              <h3 class="menu-title">
                <c:out value="${item.name}" default="이름 없는 음료" />
              </h3>
            </div>

            <p class="menu-desc">
              지금 취향에 잘 어울리는 음료예요. 한 잔으로 오늘 기분을 채워보세요 ☕️
            </p>

            <c:choose>
              <c:when test="${not empty item.imageUrl}">
                <img class="menu-photo"
                     src="<c:url value='/images/beverage/${item.imageUrl}'/>"
                     alt="${item.name} 대표 이미지" />
              </c:when>
              <c:otherwise>
                <img class="menu-photo"
                     src="https://via.placeholder.com/800x450?text=오늘+뭐마실래"
                     alt="기본 추천 이미지" />
              </c:otherwise>
            </c:choose>

            <!-- 🔹 음료 별점 박스 -->
            <div class="rating-box">
              <div class="rating-title">
                이 음료 추천, 어떠셨나요?
                <span>별점을 남겨주세요!</span>
              </div>
              <div class="rating-stars" role="radiogroup" aria-label="별점 주기">
                <span class="star" aria-label="1점" data-value="1">
                  <svg viewBox="0 0 24 24">
                    <path d="M12 2.5c1.3 0 2.5.7 3.1 1.9l1 2.1 2.3.3c1.3.2 2.3 1.1 2.6 2.4.3 1.2-.2 2.5-1.2 3.2l-1.8 1.3.5 2.4c.3 1.3-.2 2.6-1.3 3.3-1.1.8-2.5.8-3.6.1L12 19.8l-2.6 1.7c-1.1.7-2.5.7-3.6-.1-1.1-.8-1.6-2-1.3-3.3l.5-2.4-1.8-1.3c-1-.7-1.5-2-1.2-3.2.3-1.3 1.3-2.2 2.6-2.4l2.3-.3 1-2.1C9.5 3.2 10.7 2.5 12 2.5z"/>
                  </svg>
                </span>
                <span class="star" aria-label="2점" data-value="2">
                  <svg viewBox="0 0 24 24">
                    <path d="M12 2.5c1.3 0 2.5.7 3.1 1.9l1 2.1 2.3.3c1.3.2 2.3 1.1 2.6 2.4.3 1.2-.2 2.5-1.2 3.2l-1.8 1.3.5 2.4c.3 1.3-.2 2.6-1.3 3.3-1.1.8-2.5.8-3.6.1L12 19.8l-2.6 1.7c-1.1.7-2.5.7-3.6-.1-1.1-.8-1.6-2-1.3-3.3l.5-2.4-1.8-1.3c-1-.7-1.5-2-1.2-3.2.3-1.3 1.3-2.2 2.6-2.4l2.3-.3 1-2.1C9.5 3.2 10.7 2.5 12 2.5z"/>
                  </svg>
                </span>
                <span class="star" aria-label="3점" data-value="3">
                  <svg viewBox="0 0 24 24">
                    <path d="M12 2.5c1.3 0 2.5.7 3.1 1.9l1 2.1 2.3.3c1.3.2 2.3 1.1 2.6 2.4.3 1.2-.2 2.5-1.2 3.2l-1.8 1.3.5 2.4c.3 1.3-.2 2.6-1.3 3.3-1.1.8-2.5.8-3.6.1L12 19.8l-2.6 1.7c-1.1.7-2.5.7-3.6-.1-1.1-.8-1.6-2-1.3-3.3l.5-2.4-1.8-1.3c-1-.7-1.5-2-1.2-3.2.3-1.3 1.3-2.2 2.6-2.4l2.3-.3 1-2.1C9.5 3.2 10.7 2.5 12 2.5z"/>
                  </svg>
                </span>
                <span class="star" aria-label="4점" data-value="4">
                  <svg viewBox="0 0 24 24">
                    <path d="M12 2.5c1.3 0 2.5.7 3.1 1.9l1 2.1 2.3.3c1.3.2 2.3 1.1 2.6 2.4.3 1.2-.2 2.5-1.2 3.2l-1.8 1.3.5 2.4c.3 1.3-.2 2.6-1.3 3.3-1.1.8-2.5.8-3.6.1L12 19.8l-2.6 1.7c-1.1.7-2.5.7-3.6-.1-1.1-.8-1.6-2-1.3-3.3l.5-2.4-1.8-1.3c-1-.7-1.5-2-1.2-3.2.3-1.3 1.3-2.2 2.6-2.4l2.3-.3 1-2.1C9.5 3.2 10.7 2.5 12 2.5z"/>
                  </svg>
                </span>
                <span class="star" aria-label="5점" data-value="5">
                  <svg viewBox="0 0 24 24">
                    <path d="M12 2.5c1.3 0 2.5.7 3.1 1.9l1 2.1 2.3.3c1.3.2 2.3 1.1 2.6 2.4.3 1.2-.2 2.5-1.2 3.2l-1.8 1.3.5 2.4c.3 1.3-.2 2.6-1.3 3.3-1.1.8-2.5.8-3.6.1L12 19.8l-2.6 1.7c-1.1.7-2.5.7-3.6-.1-1.1-.8-1.6-2-1.3-3.3l.5-2.4-1.8-1.3c-1-.7-1.5-2-1.2-3.2.3-1.3 1.3-2.2 2.6-2.4l2.3-.3 1-2.1C9.5 3.2 10.7 2.5 12 2.5z"/>
                  </svg>
                </span>
                <span class="rating-hint">0/5</span>
              </div>
            </div>

            <div class="actions-row">
              <div class="actions-col">
                <div class="section-label">근처 카페에서 찾기</div>
                <div class="btn-row">
                  <a class="btn btn-naver" target="_blank"
                     href="https://map.naver.com/v5/search/${item.name}">
                    Naver Map
                  </a>
                  <a class="btn btn-kakao" target="_blank"
                     href="https://map.kakao.com/?q=${item.name}">
                    Kakao Map
                  </a>
                </div>
              </div>
              <div class="actions-col">
                <div class="section-label">배달 주문</div>
                <div class="btn-row">
                  <a class="btn btn-baemin" target="_blank"
                     href="https://www.baemin.com/search?keyword=${item.name}">
                    Baemin
                  </a>
                  <a class="btn btn-yogiyo" target="_blank"
                     href="https://www.yogiyo.co.kr/search/?keyword=${item.name}">
                    Yogiyo
                  </a>
                  <!-- 🔥 먹게배달: 추천 음료 이름을 들고 /delivery 로 이동 -->
                  <c:url var="bevMukkeUrl" value="/delivery">
                    <c:param name="menuName" value="${item.name}"/>
                  </c:url>
                  <a class="btn btn-mukke" href="${bevMukkeUrl}">
                    먹게배달로 주문하기
                  </a>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

  <div class="retry-wrap">
    <a class="retry-btn" href="<c:url value='/beverage'/>">
      다시 음료 추천 받기
    </a>
  </div>
</main>

<script>
  // 🔸 공통 토스트 함수
  (function(){
    let toastEl = null;
    let toastTimer = null;

    window.showToast = function(message){
      if (!toastEl) {
        toastEl = document.createElement('div');
        toastEl.className = 'toast';
        document.body.appendChild(toastEl);
      }
      toastEl.textContent = message;
      toastEl.classList.add('show');

      if (toastTimer) clearTimeout(toastTimer);
      toastTimer = setTimeout(() => {
        toastEl.classList.remove('show');
      }, 2000);
    };
  })();

  // 🔹 카드별 음료 별점 전송
  document.querySelectorAll('.card').forEach(card => {
    const starsWrap = card.querySelector('.rating-stars');
    if (!starsWrap) return;

    const drinkName = card.getAttribute('data-beverage-name') ||
                      (card.querySelector('.menu-title')?.textContent || '').trim();

    const stars = Array.from(starsWrap.querySelectorAll('.star'));
    const hint  = starsWrap.querySelector('.rating-hint');
    let lockedValue = 0;
    let ratingSubmitted = false;

    const fillUntil = (value) => {
      stars.forEach(s => s.classList.toggle('filled', Number(s.dataset.value) <= value));
      if (hint) hint.textContent = value + '/5';
    };

    function spawnSparkles(x, y){
      const N = 8 + Math.floor(Math.random()*5);
      for (let i = 0; i < N; i++) {
        const sp = document.createElement('span');
        sp.className = 'sparkle';
        const angle = (Math.PI * 2) * (i / N);
        const jitter = (Math.random() * 0.6 - 0.3);
        sp.style.setProperty('--x', x + 'px');
        sp.style.setProperty('--y', y + 'px');
        sp.style.setProperty('--dx', Math.cos(angle + jitter));
        sp.style.setProperty('--dy', Math.sin(angle + jitter));
        starsWrap.appendChild(sp);
        setTimeout(() => sp.remove(), 620);
      }
    }

    function sendBeverageRating(score){
      if (!drinkName) return;

      fetch('<c:url value="/rating/beverage"/>', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: 'beverageName=' + encodeURIComponent(drinkName) +
              '&score=' + encodeURIComponent(score)
      })
      .then(res => res.text())
      .then(text => {
        console.log('[BEV-RATING]', text);
        if (text === 'NOT_LOGIN') {
          alert('별점을 남기려면 먼저 로그인 해주세요.');
          window.location.href = '<c:url value="/login"/>';
        } else if (text === 'OK') {
          console.log('음료 별점 저장 완료');
        } else {
          alert('별점 저장 중 오류가 발생했습니다.');
        }
      })
      .catch(err => {
        console.error('[BEV-RATING-ERROR]', err);
        alert('서버 통신 중 오류가 발생했습니다.');
      });
    }

    stars.forEach(star => {
      star.addEventListener('mouseenter', () => fillUntil(Number(star.dataset.value)));
      star.addEventListener('mouseleave', () => fillUntil(lockedValue));
      star.addEventListener('click', (e) => {
        if (ratingSubmitted) {
          showToast('이미 이 음료에 별점을 남기셨어요.');
          return;
        }

        ratingSubmitted = true;

        lockedValue = Number(star.dataset.value);
        fillUntil(lockedValue);

        const rect = starsWrap.getBoundingClientRect();
        const cx = e.clientX - rect.left;
        const cy = e.clientY - rect.top;
        spawnSparkles(cx, cy);

        const svg = star.querySelector('svg');
        svg.style.transition = 'transform .18s cubic-bezier(.2,1.5,.4,1), filter .18s';
        svg.style.transform = 'scale(1.3)';
        svg.style.filter = 'drop-shadow(0 6px 16px rgba(255,179,0,.55))';
        setTimeout(() => {
          svg.style.transform = '';
          svg.style.filter = '';
        }, 200);

        console.log('[음료 별점 제출]', { drinkName, score: lockedValue });
        sendBeverageRating(lockedValue);
      });
    });

    fillUntil(0);
  });
</script>

</body>
</html>
