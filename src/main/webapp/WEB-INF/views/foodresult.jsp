<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 메뉴 추천 결과</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">

  <!-- ✅ home.jsp와 동일한 공통 CSS -->
  <link rel="stylesheet" href="<c:url value='/home.css'/>">

  <style>
    /* ✅ home.css에 없는 추가 토큰만 정의 */
    :root{
      --ring:#ede9fe;
      --ring-strong:0 0 0 4px var(--ring);

      --gold:#ffc83a; --gold-deep:#f7b500;
      --silver:#cfd8dc; --silver-deep:#9ea7ad;
      --bronze:#e7a26a; --bronze-deep:#c77c3a;
    }

    /* ✅ 로그아웃 버튼: 줄바꿈 방지 (home.css 스타일 유지) */
    .logout-btn{
      white-space: nowrap;
    }

    /* ====== 페이지 타이틀 영역 ====== */
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

    /* ====== 추천 없음(빈 상태) 안내 박스 ====== */
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

    /* ====== 추천 카드 목록 ====== */
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

    /* 순위 배지 */
    .rank-badge{
      position:absolute; left:18px; top:14px;
      display:inline-flex; align-items:center; gap:6px;
      font-weight:800; font-size:12px;
      background:#fff7e0; color:#553b00;
      border-radius:20px; padding:6px 10px;
      box-shadow:var(--shadow);
      z-index:1;
    }

    /* 카드 내부 헤더 */
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

    /* 찜/벤 버튼 영역 */
    .menu-actions{
      display:flex;
      gap:16px;
      flex-shrink:0;
    }
    .icon-btn{
      position:relative;
      width:44px;
      height:44px;
      border-radius:12px;
      border:1px solid var(--border);
      background:#fff;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      cursor:pointer;
      padding:0;
      transition:
        background .12s ease,
        transform .12s ease,
        box-shadow .12s ease,
        border-color .12s ease;
      overflow:visible;
    }
    .icon-btn svg{
      width:24px;
      height:24px;
      stroke:var(--muted);
      fill:none;
      stroke-width:2.1;
    }
    .icon-btn:hover{
      transform:translateY(-1px);
      box-shadow:0 4px 10px rgba(15,23,42,.12);
      border-color:var(--brand);
      background:var(--brand-light);
    }

    /* 🔹 찜 버튼 - 기본은 회색 ♡, active일 때만 분홍 ♥ */
    .icon-btn.wish-btn{
      color:var(--muted);
    }
    .icon-btn.wish-btn .icon-heart{
      font-size:24px;
      line-height:1;
      display:block;
    }

    /* 🔹 벤 버튼 - X는 검은 계열 */
    .icon-btn.ban-btn svg{
      stroke:#222;
    }

    .icon-btn.active{
      box-shadow:0 0 0 1px rgba(0,0,0,.05), 0 4px 10px rgba(15,23,42,.18);
      transform:translateY(-1px);
    }
    .icon-btn.wish-btn.active{
      background:#ffe5ee;
      border-color:#ff4b7d;
      color:#ff164d;
    }
    .icon-btn.ban-btn.active{
      background:#f3f3f3;
      border-color:#222;
    }
    .icon-btn.ban-btn.active svg{
      stroke:#000;
    }

    /* 하트 뿅 이펙트 */
    .heart-pop{
      position:absolute;
      left:50%;
      top:50%;
      transform:translate(-50%,-50%);
      font-size:18px;
      color:#ff4b7d;
      pointer-events:none;
      animation:heart-pop .6s ease-out forwards;
      text-shadow:0 2px 6px rgba(0,0,0,.15);
    }
    @keyframes heart-pop{
      0%{
        opacity:0;
        transform:translate(-50%,-40%) scale(.6);
      }
      40%{
        opacity:1;
        transform:translate(-50%,-80%) scale(1.05);
      }
      100%{
        opacity:0;
        transform:translate(-50%,-130%) scale(0.8);
      }
    }

    .menu-desc{
      margin-top:4px;
      color:var(--muted);
      font-size:13px;
      line-height:1.6;
      padding-left:72px;
    }

    /* 음식 사진 */
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

    /* 별점 박스 */
    .rating-box{
      margin:10px 0 6px;
      padding:14px 14px 12px;
      border:1px dashed var(--border);
      border-radius:14px;
      background:#fafafa;
    }
    .rating-title{
      font-weight:800;
      margin-bottom:8px;
      display:flex;
      align-items:center;
      gap:8px;
      font-size:13px;
    }
    .rating-title span{
      color:var(--muted);
      font-weight:600;
    }

    .rating-stars{
      display:flex;
      gap:10px;
      align-items:center;
      position:relative;
    }
    .rating-stars .star{
      display:inline-flex;
      width:32px;
      height:32px;
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
      transform:scale(1.15);
      filter:drop-shadow(0 2px 6px rgba(0,0,0,.15));
    }
    .rating-stars .rating-hint{
      font-size:12px;
      color:var(--muted);
      font-weight:600;
      min-width:34px;
    }

    /* 스파클 효과 */
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

    /* 지도/배달 섹션 */
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

    /* 🔹 버튼 공통 + 글자 그림자 스타일 (네가 준 HTML 그대로 반영) */
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

      /* 버튼 그림자 */
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

    /* 🔥 먹게배달 (Full Color Button) */
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

    /* 다시 추천 버튼 */
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

    /* 순위별 컬러 테마 */
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

    /* 🔹 추천 1~2개일 때 추가되는 "조건 부족" 안내 카드 스타일 */
    .card.card-empty{
      background:#f9fafb;
      border-style:dashed;
      border-color:var(--border);
      box-shadow:none;
    }
    .card.card-empty::before{
      background:linear-gradient(90deg, rgba(148,163,184,.18), rgba(148,163,184,0));
    }
    .card-empty .menu-title{
      font-size:18px;
      color:#4b5563;
    }
    .card-empty .menu-desc{
      padding-left:0;
      font-size:13px;
      color:var(--muted);
    }

    /* 🔹 토스트 (룰렛 스타일 비슷하게 중앙 하단 스낵바 느낌) */
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
    <h2>상위 추천 메뉴</h2>
    <p>당신의 취향을 분석해서 골라본 오늘의 메뉴입니다.</p>
  </div>

  <!-- 🔹 추천 결과가 없을 때 / 있을 때 분기 -->
  <c:choose>
    <c:when test="${empty results}">
      <div class="empty-box">
        <h3>추천할 수 있는 메뉴가 없어요</h3>
        <p>선택하신 벤 / 알레르기 조건에 맞는 메뉴가 더 이상 남아 있지 않습니다.</p>
        <p>일부 벤 또는 알레르기 항목을 해제하시거나, 다른 조건으로 다시 설문을 진행해 주세요.</p>
      </div>
    </c:when>

    <c:otherwise>
      <div class="card-wrap">
        <c:forEach var="item" items="${results}" varStatus="st">
          <!-- 🔹 메뉴 이름을 data-food-name으로 같이 넣어줌 -->
          <div class="card rank-${st.index + 1}"
               data-menu-id="${item.foodmenuIdx}"
               data-food-name="${item.foodmenuName}">
            <span class="rank-badge">
              #${st.index + 1}
            </span>

            <div class="menu-header">
              <h3 class="menu-title">${item.foodmenuName}</h3>

              <!-- 🔹 로그인한 회원만 찜/벤 버튼 표시 -->
              <c:if test="${not empty sessionScope.loginMember}">
                <div class="menu-actions">
                  <!-- 찜 버튼 -->
                  <button class="icon-btn wish-btn" type="button" aria-label="이 메뉴 찜하기">
                    <span class="icon-heart" aria-hidden="true">♡</span>
                  </button>

                  <!-- 벤 버튼 -->
                  <button class="icon-btn ban-btn" type="button" aria-label="이 메뉴 벤하기">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                      <path d="M6 6l12 12"></path>
                      <path d="M18 6L6 18"></path>
                    </svg>
                  </button>
                </div>
              </c:if>
            </div>

            <p class="menu-desc">
              오늘의 추천 메뉴입니다. 취향에 딱 맞는 한 끼를 즐겨보세요!
            </p>

            <c:choose>
              <c:when test="${not empty item.foodmenuImage}">
                <img class="menu-photo"
                     src="<c:url value='/images/food/${item.foodmenuImage}'/>"
                     alt="${item.foodmenuName} 대표 이미지" />
              </c:when>
              <c:otherwise>
                <img class="menu-photo"
                     src="https://via.placeholder.com/800x450?text=오늘+뭐먹게"
                     alt="기본 추천 이미지" />
              </c:otherwise>
            </c:choose>

            <div class="rating-box">
              <div class="rating-title">
                이 메뉴 추천, 마음에 드셨나요?
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
                <div class="section-label">지도에서 찾기</div>
                <div class="btn-row">
                  <a class="btn btn-naver" target="_blank"
                     href="https://map.naver.com/v5/search/${item.foodmenuName}">
                    Naver Map
                  </a>
                  <a class="btn btn-kakao" target="_blank"
                     href="https://map.kakao.com/?q=${item.foodmenuName}">
                    Kakao Map
                  </a>
                </div>
              </div>
              <div class="actions-col">
                <div class="section-label">배달 주문</div>
                <div class="btn-row">
                  <a class="btn btn-baemin" target="_blank"
                     href="https://www.baemin.com/search?keyword=${item.foodmenuName}">
                    Baemin
                  </a>
                  <a class="btn btn-yogiyo" target="_blank"
                     href="https://www.yogiyo.co.kr/search/?keyword=${item.foodmenuName}">
                    Yogiyo
                  </a>

                  <!-- 🔥 먹게배달: 메뉴 이름과 함께 /delivery 로 이동 -->
                  <c:url var="mukkeUrl" value="/delivery">
                    <c:param name="menuName" value="${item.foodmenuName}"/>
                  </c:url>
                  <a class="btn btn-mukke" href="${mukkeUrl}">
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
    <a class="retry-btn" href="<c:url value='/main-food'/>">
      다시 추천 받기
    </a>
  </div>
</main>

<script>
  // 🔸 공통 토스트 함수 (룰렛처럼 alert 대신 사용)
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

  // 🔹 추천 카드가 1~2개일 때, 부족한 순위(#2, #3)에 조건 안내 카드 자동 추가
  (function(){
    const wrap = document.querySelector('.card-wrap');
    if (!wrap) return;

    const cards = wrap.querySelectorAll('.card');
    const count = cards.length;
    const maxSlots = 3;

    if (count <= 0 || count >= maxSlots) return;

    for (let i = count + 1; i <= maxSlots; i++) {
      const emptyCard = document.createElement('div');
      emptyCard.className = `card rank-${i} card-empty`;
      emptyCard.innerHTML = `
        <span class="rank-badge">#${i}</span>
        <div class="menu-header" style="padding-left:0;">
          <h3 class="menu-title">이 위치에 추천할 메뉴가 없어요</h3>
        </div>
        <p class="menu-desc" style="padding-left:0;">
          선택하신 벤 / 알레르기 조건으로 이 순위에 들어올 수 있는 메뉴가 부족합니다.<br/>
          다른 메뉴도 보고 싶다면, 일부 벤 또는 알레르기 항목을 조정하고 다시 추천을 받아보세요.
        </p>
      `;
      wrap.appendChild(emptyCard);
    }
  })();

  // ⭐ 카드별 별점 + 찜/벤 인터랙션
  document.querySelectorAll('.card').forEach(card => {
    const starsWrap = card.querySelector('.rating-stars');
    const menuId = card.getAttribute('data-menu-id');
    const menuName = card.getAttribute('data-food-name');

    // ----- 별점 -----
    if (starsWrap) {
      const stars = Array.from(starsWrap.querySelectorAll('.star'));
      const hint = starsWrap.querySelector('.rating-hint');
      let lockedValue = 0;
      // ⭐ 이 카드(메뉴)에 대해 이미 별점 제출했는지
      let ratingSubmitted = false;

      const fillUntil = (value) => {
        stars.forEach(s => s.classList.toggle('filled', Number(s.dataset.value) <= value));
        if (hint) hint.textContent = value + '/5';
      };

      function spawnSparkles(x, y) {
        const N = 10 + Math.floor(Math.random() * 6);
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

      // 🔹 서버로 음식 별점 전송
      function sendFoodRating(score){
        if (!menuName) return;

        fetch('<c:url value="/rating/food"/>', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
          },
          body: 'foodName=' + encodeURIComponent(menuName) +
                '&score=' + encodeURIComponent(score)
        })
        .then(res => res.text())
        .then(text => {
          console.log('[FOOD-RATING]', text);
          if (text === 'NOT_LOGIN') {
            alert('별점을 남기려면 먼저 로그인 해주세요.');
            window.location.href = '<c:url value="/login"/>';
          } else if (text === 'OK') {
            console.log('별점 저장 완료');
          } else {
            alert('별점 저장 중 오류가 발생했습니다.');
          }
        })
        .catch(err => {
          console.error('[FOOD-RATING-ERROR]', err);
          alert('서버 통신 중 오류가 발생했습니다.');
        });
      }

      stars.forEach(star => {
        star.addEventListener('mouseenter', () => fillUntil(Number(star.dataset.value)));
        star.addEventListener('mouseleave', () => fillUntil(lockedValue));
        star.addEventListener('click', (e) => {
          // ⭐ 이미 이 카드에 별점 준 경우, 다시 전송하지 않기 → 토스트로 안내
          if (ratingSubmitted) {
            showToast('이미 이 메뉴에 별점을 남기셨어요.');
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
          svg.style.transform = 'scale(1.35)';
          svg.style.filter = 'drop-shadow(0 6px 16px rgba(255,179,0,.55))';
          setTimeout(() => {
            svg.style.transform = '';
            svg.style.filter = '';
          }, 200);

          console.log('[별점 제출]', { menuId, menuName, score: lockedValue });
          sendFoodRating(lockedValue);
        });
      });

      fillUntil(0);
    }

    // ----- 찜/벤 버튼 -----
    const wishBtn = card.querySelector('.wish-btn');
    const banBtn = card.querySelector('.ban-btn');

    function spawnHeart(btn){
      const heart = document.createElement('span');
      heart.className = 'heart-pop';
      heart.textContent = '❤';
      btn.appendChild(heart);
      setTimeout(() => heart.remove(), 650);
    }

    function addWishlist() {
      if (!menuName) {
        console.warn('메뉴 이름 없음, 찜 요청 취소');
        return;
      }

      fetch('<c:url value="/wish/add"/>', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: 'foodName=' + encodeURIComponent(menuName)
      })
      .then(res => res.text())
      .then(text => {
        console.log('[WISHLIST] 응답:', text);
        if (text === 'NOT_LOGIN') {
          window.location.href = '<c:url value="/login"/>';
        }
      })
      .catch(err => {
        console.error('[WISHLIST] 에러:', err);
      });
    }

    function addDislike() {
      if (!menuName) {
        console.warn('메뉴 이름 없음, dislike 요청 취소');
        return;
      }

      fetch('<c:url value="/dislike/add"/>', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: 'foodName=' + encodeURIComponent(menuName)
      })
      .then(res => res.text())
      .then(text => {
        console.log('[DISLIKE] 응답:', text);
        if (text === 'NOT_LOGIN') {
          window.location.href = '<c:url value="/login"/>';
        }
      })
      .catch(err => {
        console.error('[DISLIKE] 에러:', err);
      });
    }

    if (wishBtn) {
      wishBtn.addEventListener('click', () => {
        if (wishBtn.classList.contains('locked')) {
          return;
        }

        wishBtn.classList.add('active', 'locked');
        wishBtn.disabled = true;

        const heartSpan = wishBtn.querySelector('.icon-heart');
        if (heartSpan) {
          heartSpan.textContent = '♥';
        }
        spawnHeart(wishBtn);

        addWishlist();

        if (banBtn) {
          banBtn.classList.remove('active');
        }
      });
    }

    if (banBtn) {
      banBtn.addEventListener('click', () => {
        if (banBtn.classList.contains('locked')) {
          return;
        }

        banBtn.classList.add('active', 'locked');
        banBtn.disabled = true;

        console.log('[벤 ON]', { menuId, menuName });
        addDislike();

        if (wishBtn) {
          wishBtn.classList.remove('active');
          const heartSpan = wishBtn.querySelector('.icon-heart');
          if (heartSpan) {
            heartSpan.textContent = '♡';
          }
        }
      });
    }
  });
</script>

</body>
</html>
