<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 룰렛 돌리기</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <!-- ✅ home.jsp와 동일한 공통 CSS 사용 -->
  <link rel="stylesheet" href="<c:url value='/home.css'/>">
  <style>
    /* ✅ 로그아웃: home.css 스타일 유지 + 줄바꿈만 방지 */
    .logout-btn{
      white-space: nowrap;
    }

    /* 🔹 추천 결과 이미지 스타일 (이미지 쏠림/잘림 방지) */
    .dish-img{
      width:100%;
      max-width:420px;
      max-height:260px;
      display:block;
      margin:14px auto 10px;
      border-radius:16px;
      background:#f6f7f9;
      border:1px solid var(--border);
      object-fit:contain;
      object-position:center;
    }

    /* ====== 룰렛 영역(페이지 전용) ====== */
    .panel{
      background:var(--panel);
      border:1px solid var(--border);
      border-radius:24px;
      box-shadow:0 4px 12px rgba(0,0,0,.06);
      padding:60px 24px 70px;
      display:flex;
      justify-content:center;
      align-items:center;
      min-height:220px;
    }
    .panel:hover{
      box-shadow:0 12px 28px rgba(0,0,0,.12);
    }

    .roulette{
      position:relative;
      width:min(55vw, 500px);
      aspect-ratio:1/1;
      display:grid;
      place-items:center;
    }
    .wheel{
      width:100%;
      height:100%;
      border-radius:50%;
      box-shadow: inset 0 0 0 14px #fff, 0 4px 12px rgba(0,0,0,.06);
      background: conic-gradient(
        #f7c6d0 0deg 45deg, #ffc3b0 45deg 90deg, #ffe9a6 90deg 135deg, #c9edc7 135deg 180deg,
        #bfe4ff 180deg 225deg, #cfc6ff 225deg 270deg, #f1c9ff 270deg 315deg, #ffd6e0 315deg 360deg
      );
      position:relative;
      overflow:visible;
    }
    .wheel.ringing{
      box-shadow: inset 0 0 0 14px #fff,
                  0 0 0 8px #ede9fe,
                  0 4px 12px rgba(0,0,0,.06);
    }

    @keyframes spin {
      from { transform: rotate(var(--from)); }
      to   { transform: rotate(var(--to)); }
    }
    .spinning{
      animation: spin var(--dur) cubic-bezier(.14,.78,.18,.99) forwards;
    }

    .hub{
      position:absolute;
      width:32%;
      aspect-ratio:1/1;
      border-radius:50%;
      background: radial-gradient(circle at 30% 30%, #cbb8ff, #8d6bff);
      display:grid;
      place-items:center;
      color:#fff;
      font-weight:900;
      box-shadow: 0 12px 24px rgba(111,70,255,.35),
                  inset 0 0 0 10px #fff;
      cursor:pointer;
      user-select:none;
      z-index:2;
      font-size: clamp(24px, 7vw, 32px);
      line-height:1;
      letter-spacing:.5px;
    }
    .hub::after{
      content:"GO";
    }

    .pointer{
      position:absolute;
      top:-14px;
      left:50%;
      transform: translate(-50%, 0);
      width:0;
      height:0;
      border-left:12px solid transparent;
      border-right:12px solid transparent;
      border-bottom:16px solid var(--brand);
      filter: drop-shadow(0 6px 8px rgba(111,70,255,.25));
      z-index:1;
    }

    /* ====== 모달 디자인 (높이 살짝 줄인 버전) ====== */
    .roulette-modal-backdrop{
      position:fixed;
      inset:0;
      background:rgba(15,23,42,.55);
      display:none;
      align-items:center;
      justify-content:center;
      z-index:1000;
      padding:20px;
    }
    .roulette-modal-backdrop.show{
      display:flex;
    }
    .roulette-modal{
      background:var(--panel);
      border-radius:24px;
      border:2px solid var(--brand);
      box-shadow:0 24px 60px rgba(15,23,42,.55);
      width:min(500px, 92vw);
      padding:14px 18px 12px; /* 🔻 패딩 조금 축소 */
      position:relative;
    }
    .roulette-modal-header{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:10px;
      margin-bottom:8px;
    }
    .roulette-modal-title{
      font-size:24px;  /* 🔻 살짝 줄임 */
      font-weight:900;
      letter-spacing:-.35px;
    }
    .roulette-modal-close{
      border:none;
      background:transparent;
      cursor:pointer;
      padding:4px;
      margin:-4px -4px 0 0;
    }
    .roulette-modal-close svg{
      width:20px;
      height:20px;
      stroke:#666;
      stroke-width:2;
    }
    .roulette-modal-image-wrap{
      width:100%;
      border-radius:18px;
      overflow:hidden;
      background:#f3f4f6;
      margin-bottom:6px;
    }
    .roulette-modal-image-wrap img{
      width:100%;
      display:block;
      max-height:190px; /* 🔻 세로 사이즈 살짝 줄임 */
      object-fit:cover;
    }

    .section-label{
      margin-top:8px;
      margin-bottom:4px;
      font-size:12px;       /* 살짝 작은 느낌 유지 */
      font-weight:800;
      color:#555;
      letter-spacing:-.2px;
      display:flex;
      align-items:center;
      gap:6px;
    }
    .section-label::before{
      content:"";
      width:7px; height:7px;
      border-radius:50%;
      background:var(--brand);
      display:inline-block;
    }

    /* 🔹 버튼: 가로 구조 유지 + 세로 높이/폰트만 줄이기 */
    .btn-row{
      display:flex;
      flex-wrap:wrap;
      gap:8px;
      margin-bottom:6px;
    }

    .btn{
      flex:1;
      min-width:130px;
      padding:7px 10px;          /* 🔻 세로 사이즈 줄임 */
      border-radius:10px;
      text-align:center;
      font-weight:800;
      font-size:12px;            /* 🔻 살짝 작게 */
      text-decoration:none;
      background:#ffffff;
      color:#111827;
      border:1px solid #d1d5db;
      cursor:pointer;
      display:inline-block;
      box-shadow:0 1px 3px rgba(0,0,0,.12);
      transition:
        transform .15s ease,
        box-shadow .15s ease,
        border-color .15s ease,
        background .15s ease;
    }
    .btn:hover{
      transform:translateY(-1px);
      box-shadow:0 3px 8px rgba(0,0,0,.14);
      border-color:#b9bec6;
      background:#fafafa;
    }

    /* 🔹 지도/배달 브랜드 색 + 글자 그림자 */
    .btn-naver{
      color:#00c73c;
      text-shadow:1px 1px 0 #13a02c;
    }
    .btn-kakao{
      color:#f0b400;
      text-shadow:1px 1px 0 #a07812;
    }
    .btn-baemin{
      color:#00c7ae;
      text-shadow:1px 1px 0 #139f8c;
    }
    .btn-yogiyo{
      color:#e0113b;
      text-shadow:1px 1px 0 #ad3621;
    }

    /* 🔥 먹게배달: 풀 컬러 버튼 (배민/요기요 아래에 전체 폭) */
    .btn-mukke{
      flex-basis:100%;
      margin-top:2px;

      background:#6c5ce7;
      color:#ffffff;
      border-color:#6c5ce7;

      font-weight:900;
      font-size:14px;  /* 살짝 강조 */
      box-shadow:0 4px 12px rgba(88,28,135,.35);
      text-shadow:1px 1px 0 rgba(0,0,0,0.5);
    }
    .btn-mukke:hover{
      background:#7560ff;
      box-shadow:0 6px 16px rgba(88,28,135,.45);
    }

    /* 🔹 다시 돌리기: 슬림 */
    .btn-outline{
      background:#fff;
      color:#111827;
      border:1px solid var(--border);
      text-shadow:none;
      box-shadow:none;
      font-size:12px;
      padding:7px 13px;
    }
    .btn-outline:hover{
      background:#f9fafb;
      box-shadow:0 1px 3px rgba(0,0,0,.1);
    }

    /* ▽▽▽ 별점 디자인 ▽▽▽ */
    .cate-badge{
      display:none !important;
    }

    .rating-box{
      margin:6px 0 4px;
      padding:10px 10px;
      border:1px dashed var(--border);
      border-radius:14px;
      background:#fafafa;
      transform:scale(.9);    /* 살짝 축소 */
      transform-origin:center;
    }
    .rating-title{
      font-weight:800;
      margin-bottom:4px;
      display:flex;
      align-items:center;
      gap:6px;
      justify-content:center;
      font-size:13px;
    }
    .rating-stars{
      display:flex;
      gap:8px;
      align-items:center;
      position:relative;
      justify-content:center;
    }
    .star{
      display:inline-flex;
      width:28px;
      height:28px;
      cursor:pointer;
      user-select:none;
    }
    .star svg{
      width:100%;
      height:100%;
      stroke:#f1c40f;
      fill:transparent;
      stroke-width:2.2;
      stroke-linejoin:round;
      stroke-linecap:round;
      transition:transform .12s ease,
                 filter .12s ease,
                 fill .12s ease,
                 stroke .12s ease;
    }
    .star.filled svg{
      fill:#ffd14a;
      stroke:#ffb300;
    }
    .star:hover svg{
      transform:scale(1.12);
      filter:drop-shadow(0 2px 6px rgba(0,0,0,.15));
    }
    .rating-hint{
      font-weight:800;
      color:#8a8f98;
      min-width:40px;
      text-align:center;
      font-size:12px;
    }

    .sparkle{
      position:absolute;
      width:8px;
      height:8px;
      border-radius:50%;
      pointer-events:none;
      opacity:0;
      transform:translate(-50%,-50%) scale(0.6);
      background: radial-gradient(circle, #ffe07a 0%, #ffc300 60%, transparent 70%);
      animation: sparkle-pop .6s ease-out forwards;
    }
    @keyframes sparkle-pop{
      0%{
        opacity:0;
        transform:translate(var(--x), var(--y)) scale(.5);
      }
      15%{
        opacity:1;
        transform:translate(calc(var(--x) + var(--dx)*6px),
                            calc(var(--y) + var(--dy)*6px)) scale(1.1);
      }
      100%{
        opacity:0;
        transform:translate(calc(var(--x) + var(--dx)*22px),
                            calc(var(--y) + var(--dy)*22px)) scale(.2);
      }
    }

    /* 🔹 찜 / 벤 pill */
    .action-row{
      display:flex;
      gap:8px;
      margin-top:8px;
    }
    .action-pill{
      flex:1;
      border-radius:999px;
      border:1px solid var(--border);
      background:#fff;
      padding:7px 10px;
      font-size:13px;
      font-weight:700;
      cursor:pointer;
      display:flex;
      align-items:center;
      justify-content:center;
      gap:6px;
    }
    .action-pill span.emoji{
      font-size:16px;
    }
    .action-pill.active{
      border-color:var(--brand);
      background:var(--brand-light);
      color:#4c1d95;
    }
    .action-pill:disabled{
      opacity:.65;
      cursor:default;
    }

    /* 🔹 토스트 */
    .toast{
      position:fixed;
      bottom:24px;
      left:50%;
      transform:translateX(-50%) translateY(20px);
      background:#111827;
      color:#f9fafb;
      padding:9px 14px;
      border-radius:999px;
      font-size:13px;
      font-weight:500;
      box-shadow:0 10px 24px rgba(15,23,42,.55);
      opacity:0;
      pointer-events:none;
      transition:opacity .2s ease, transform .2s ease;
      z-index:1200;
    }
    .toast.show{
      opacity:1;
      transform:translateX(-50%) translateY(0);
    }

    /* 🔹 “더 이상 추천할 메뉴 없음” 안내 모달 */
    .info-modal-backdrop{
      position:fixed;
      inset:0;
      background:rgba(15,23,42,.55);
      display:none;
      align-items:center;
      justify-content:center;
      z-index:1100;
      padding:20px;
    }
    .info-modal-backdrop.show{
      display:flex;
    }
    .info-modal{
      background:var(--panel);
      border-radius:24px;
      border:1px solid var(--border);
      box-shadow:0 24px 60px rgba(15,23,42,.55);
      width:min(420px, 90vw);
      padding:22px 22px 18px;
      text-align:center;
    }
    .info-modal-title{
      font-size:20px;
      font-weight:800;
      margin-bottom:8px;
      letter-spacing:-0.3px;
    }
    .info-modal-desc{
      font-size:13px;
      color:var(--muted);
      line-height:1.5;
      margin-bottom:18px;
    }
    .info-modal-btn-row{
      display:flex;
      justify-content:flex-end;
      gap:8px;
    }
    .info-btn{
      padding:8px 14px;
      border-radius:999px;
      font-size:13px;
      font-weight:600;
      border:1px solid transparent;
      cursor:pointer;
    }
    .info-btn-outline{
      background:#fff;
      color:#111827;
      border-color:var(--border);
    }
    .info-btn-outline:hover{
      background:#f9fafb;
    }
    .info-btn-primary{
      background:var(--brand);
      color:#fff;
      border-color:var(--brand);
    }
    .info-btn-primary:hover{
      filter:brightness(0.97);
    }

    /* ====== 반응형 ====== */
    @media (max-width:560px){
      .panel{
        padding:50px 20px 60px;
        min-height:190px;
      }
      .hub{
        font-size: clamp(24px, 8vw, 30px);
      }
      .roulette-modal{
        width:92vw;
        padding:12px 14px 10px;
      }
      .roulette-modal-title{
        font-size:22px;
      }
      .info-modal{
        width:92vw;
      }
    }
  </style>
</head>
<body>
<header class="nav">
  <div class="nav-inner">
    <div class="nav-brand">오늘 뭐먹게</div>
    <a href="<c:url value='/logout'/>" class="logout-btn" aria-label="로그아웃">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false">
        <path d="M15 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h8"></path>
        <path d="M10 17l5-5-5-5"></path>
        <path d="M15 12H3"></path>
      </svg> 로그아웃
    </a>
  </div>
</header>

<main class="wrap">
  <div class="quick-nav-wrap">
    <nav class="quick-nav" aria-label="주요 메뉴">
      <a class="qitem" href="<c:url value='/home'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 10.5L12 3l9 7.5"></path>
          <path d="M5 10.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9.5"></path>
        </svg>
        <span class="label">홈</span>
      </a>
      <a class="qitem active" href="<c:url value='/roulette'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M12 6v6l4 2"></path>
          <circle cx="12" cy="12" r="2"></circle>
        </svg>
        <span class="label">룰렛 돌리기</span>
      </a>
      <a class="qitem" href="<c:url value='/charts'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 20h18"></path>
          <path d="M7 20V9"></path>
          <path d="M12 20V4"></path>
          <path d="M17 20v-6"></path>
        </svg>
        <span class="label">인기차트</span>
      </a>
      <a class="qitem" href="<c:url value='/mypage'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="8" r="4"></circle>
          <path d="M4 21a8 8 0 0 1 16 0"></path>
        </svg>
        <span class="label">마이페이지</span>
      </a>
    </nav>
  </div>
  <br>

  <h1 class="title">메뉴 룰렛</h1>
  <p class="subtitle">카테고리를 랜덤으로 선택하여 메뉴를 추천해드려요!</p>

  <section class="panel">
    <div class="roulette" id="roulette">
      <div class="pointer" aria-hidden="true"></div>
      <div class="wheel" id="wheel" role="img" aria-label="메뉴 룰렛"></div>
      <button class="hub" id="hub" type="button" aria-label="룰렛 돌리기"></button>
    </div>
  </section>
</main>

<!-- 🔹 결과 모달 -->
<div class="roulette-modal-backdrop" id="resultModal" aria-hidden="true">
  <div class="roulette-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="roulette-modal-header">
      <div>
        <h3 class="roulette-modal-title" id="modalTitle">
          <span id="dishName">추천 메뉴</span>
        </h3>
      </div>
      <button type="button" class="roulette-modal-close" id="btnClose" aria-label="닫기">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M6 6l12 12"></path>
          <path d="M18 6L6 18"></path>
        </svg>
      </button>
    </div>

    <div class="roulette-modal-image-wrap" id="imageWrap">
      <img id="dishImage" src="" alt="추천 메뉴 이미지" />
    </div>

    <!-- 🔹 별점 -->
    <div class="rating-box" aria-live="polite">
      <div class="rating-title">
        이 추천, 어떠셨나요?
        <span style="color:var(--muted);font-weight:600">별점을 주세요!</span>
      </div>
      <div class="rating-stars" id="ratingStars" role="radiogroup" aria-label="별점 주기">
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
        <span class="rating-hint" id="ratingHint">0/5</span>
      </div>
    </div>

    <!-- 🔹 찜 / 벤 -->
    <c:if test="${not empty sessionScope.loginMember}">
      <div class="action-row">
        <button type="button" class="action-pill wish-pill">
          <span class="emoji">♥</span>
          <span>찜하기</span>
        </button>
        <button type="button" class="action-pill ban-pill">
          <span class="emoji">✖</span>
          <span>벤하기</span>
        </button>
      </div>
    </c:if>

    <!-- 지도 / 배달 버튼 (기존 구조 유지) -->
    <div class="section-label" style="margin-top:10px;">지도에서 찾기</div>
    <div class="btn-row">
      <a class="btn btn-naver" id="modalNaverMap" target="_blank" href="#">Naver Map</a>
      <a class="btn btn-kakao" id="modalKakaoMap" target="_blank" href="#">Kakao Map</a>
    </div>

    <div class="section-label">배달 주문</div>
    <div class="btn-row">
      <a class="btn btn-baemin" id="modalBaemin" target="_blank" href="#">Baemin</a>
      <a class="btn btn-yogiyo" id="modalYogiyo" target="_blank" href="#">Yogiyo</a>
      <!-- 🔥 배민/요기요 아래에 한 줄 꽉 차게 + JS로 menuName 넘김 -->
      <a class="btn btn-mukke" href="#" id="modalMukke">
        먹게배달로 주문하기
      </a>
    </div>

    <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:6px;">
      <button type="button" class="btn btn-outline" id="btnRetry">다시 돌리기</button>
    </div>
  </div>
</div>

<!-- 🔹 “더 이상 추천할 메뉴 없음” 안내 모달 -->
<div class="info-modal-backdrop" id="emptyModal" aria-hidden="true">
  <div class="info-modal" role="dialog" aria-modal="true" aria-labelledby="emptyModalTitle">
    <h3 class="info-modal-title" id="emptyModalTitle">
      더 이상 추천할 메뉴가 없습니다
    </h3>
    <p class="info-modal-desc">
      설정하신 벤 / 알레르기 조건에 따라 <br>
      더 이상 추천할 수 있는 메뉴가 없습니다.
    </p>
    <div class="info-modal-btn-row">
      <button type="button" class="info-btn info-btn-outline" id="emptyBtnClose">확인</button>
      <button type="button" class="info-btn info-btn-primary" id="emptyBtnMypage">마이페이지로</button>
    </div>
  </div>
</div>

<div class="toast" id="toast">결과 표시</div>

<script>
  /* 홈과 동일한 active 처리(경로 기반) */
  (function setActive(){
    const items = document.querySelectorAll('.quick-nav .qitem');
    const currentPath = location.pathname;
    items.forEach(item => {
      const href = item.getAttribute('href');
      if (href === currentPath || (currentPath === '/' && href === '/home')) {
        item.classList.add('active');
      }
      item.addEventListener('click', () => {
        items.forEach(x => x.classList.remove('active'));
        item.classList.add('active');
      });
    });
  })();

  const SEGMENTS = [
    { name:"한식" }, { name:"중식" }, { name:"일식" }, { name:"양식" },
    { name:"한식" }, { name:"중식" }, { name:"일식" }, { name:"양식" }
  ];

  const wheel = document.getElementById("wheel");
  const hub = document.getElementById("hub");
  const modal = document.getElementById("resultModal");
  const dishImage = document.getElementById("dishImage");
  const dishName  = document.getElementById("dishName");
  const btnClose  = document.getElementById("btnClose");
  const btnRetry  = document.getElementById("btnRetry");
  const toast     = document.getElementById("toast");

  const modalNaverMap = document.getElementById("modalNaverMap");
  const modalKakaoMap = document.getElementById("modalKakaoMap");
  const modalBaemin   = document.getElementById("modalBaemin");
  const modalYogiyo   = document.getElementById("modalYogiyo");
  const modalMukke    = document.getElementById("modalMukke"); // 🔹 먹게배달 버튼

  const ratingStarsWrap = document.getElementById("ratingStars");
  const ratingHint = document.getElementById("ratingHint");
  const ratingStars = ratingStarsWrap ? Array.from(ratingStarsWrap.querySelectorAll(".star")) : [];
  let ratingLocked = 0;
  let currentRotation = 0;

  // ⭐ 이번 추천 메뉴에 대해 이미 별점 제출했는지
  let ratingSubmitted = false;

  // 🔹 “더 이상 추천할 메뉴 없음” 모달 요소
  const emptyModal = document.getElementById("emptyModal");
  const emptyBtnClose = document.getElementById("emptyBtnClose");
  const emptyBtnMypage = document.getElementById("emptyBtnMypage");

  // 🔹 현재 추천된 메뉴 이름(별점/찜/벤/먹게배달 공통 사용)
  function getCurrentMenuName(){
    return (dishName.textContent || "").trim();
  }

  // 🔹 이미지 기본 경로 (음식 / 음료)
  const FOOD_IMG_BASE = "<c:url value='/images/food/'/>";
  const BEV_IMG_BASE  = "<c:url value='/images/beverage/'/>";

  // 🔹 찜/벤 pill 버튼 (로그인 안됐으면 null)
  const wishPill = document.querySelector(".wish-pill");
  const banPill  = document.querySelector(".ban-pill");

  function showToast(msg){
    toast.textContent = msg;
    toast.classList.add("show");
    setTimeout(()=>toast.classList.remove("show"), 1500);
  }

  function indexFromAngle(deg){
    const step = 360 / SEGMENTS.length;
    const normalized = (360 - (deg % 360) + 360) % 360;
    let idx = Math.floor(normalized / step);
    if (idx === SEGMENTS.length) idx = 0;
    return idx;
  }

  function fillStars(value){
    ratingStars.forEach(s => s.classList.toggle("filled", Number(s.dataset.value) <= value));
    if (ratingHint) ratingHint.textContent = (value||0) + "/5";
  }

  function spawnSparkles(container, x, y){
    const N = 10 + Math.floor(Math.random()*6);
    for(let i=0;i<N;i++){
      const sp = document.createElement("span");
      sp.className = "sparkle";
      const angle = (Math.PI * 2) * (i/N);
      const jitter = (Math.random()*0.6 - 0.3);
      sp.style.setProperty('--x', x + 'px');
      sp.style.setProperty('--y', y + 'px');
      sp.style.setProperty('--dx', Math.cos(angle + jitter));
      sp.style.setProperty('--dy', Math.sin(angle + jitter));
      container.appendChild(sp);
      setTimeout(()=> sp.remove(), 620);
    }
  }

  // 🔹 룰렛 음식 별점 서버 전송
  function sendRouletteRating(score){
    const name = getCurrentMenuName();
    if (!name) return;

    fetch("<c:url value='/rating/food'/>", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
      },
      body: "foodName=" + encodeURIComponent(name) +
            "&score=" + encodeURIComponent(score)
    })
    .then(res => res.text())
    .then(text => {
      console.log("[ROULETTE-RATING]", text);
      if (text === "NOT_LOGIN") {
        alert("별점을 남기려면 먼저 로그인 해주세요.");
        window.location.href = "<c:url value='/login'/>";
      } else if (text === "OK") {
        console.log("룰렛 별점 저장 완료");
      } else if (text === "INVALID_SCORE") {
        console.warn("잘못된 점수:", score);
      } else {
        alert("별점 저장 중 오류가 발생했습니다.");
      }
    })
    .catch(err => {
      console.error("[ROULETTE-RATING-ERROR]", err);
      alert("서버 통신 중 오류가 발생했습니다.");
    });
  }

  // ⭐ 별점: 한 번만 제출 가능
  ratingStars.forEach(star=>{
    star.addEventListener('mouseenter', ()=> fillStars(Number(star.dataset.value)));
    star.addEventListener('mouseleave', ()=> fillStars(ratingLocked));
    star.addEventListener('click', (e)=>{
      if (ratingSubmitted) {
        showToast("이미 이 메뉴에 별점을 남기셨어요.");
        return;
      }
      ratingSubmitted = true;

      ratingLocked = Number(star.dataset.value);
      fillStars(ratingLocked);
      const rect = ratingStarsWrap.getBoundingClientRect();
      spawnSparkles(ratingStarsWrap, e.clientX-rect.left, e.clientY-rect.top);
      const svg = star.querySelector('svg');
      svg.style.transition='transform .18s cubic-bezier(.2,1.5,.4,1), filter .18s';
      svg.style.transform='scale(1.35)';
      svg.style.filter='drop-shadow(0 6px 16px rgba(255,179,0,.55))';
      setTimeout(()=>{ svg.style.transform=''; svg.style.filter=''; },200);

      console.log('[별점 제출]', {menuName: getCurrentMenuName(), score: ratingLocked});
      sendRouletteRating(ratingLocked);
    });
  });
  fillStars(0);

  // 🔹 찜/벤 버튼 상태 초기화
  function resetActionPills(){
    if (wishPill){
      wishPill.disabled = false;
      wishPill.classList.remove("active");
    }
    if (banPill){
      banPill.disabled = false;
      banPill.classList.remove("active");
    }
  }
  function disableActionPills(){
    if (wishPill) wishPill.disabled = true;
    if (banPill)  banPill.disabled  = true;
  }

  // 🔹 찜/벤 AJAX 호출
  function sendWish(foodName){
    if (!wishPill || !foodName) return;
    fetch("<c:url value='/wish/add'/>", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
      body: "foodName=" + encodeURIComponent(foodName)
    })
    .then(res => res.text())
    .then(text => {
      console.log("[WISH-ADD]", text);
      if (text === "OK"){
        wishPill.classList.add("active");
        disableActionPills();
        showToast("이 메뉴를 찜했어요.");
      }else if (text === "NOT_LOGIN"){
        showToast("로그인이 필요합니다.");
        window.location.href = "<c:url value='/login'/>";
      }else{
        showToast("찜 처리 중 오류가 발생했습니다.");
      }
    })
    .catch(err => {
      console.error(err);
      showToast("서버 통신 오류가 발생했습니다.");
    });
  }

  function sendDislike(foodName){
    if (!banPill || !foodName) return;
    fetch("<c:url value='/dislike/add'/>", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
      body: "foodName=" + encodeURIComponent(foodName)
    })
    .then(res => res.text())
    .then(text => {
      console.log("[DISLIKE-ADD]", text);
      if (text === "OK"){
        banPill.classList.add("active");
        disableActionPills();
        showToast("이 메뉴를 벤 리스트에 추가했어요.");
      }else if (text === "NOT_LOGIN"){
        showToast("로그인이 필요합니다.");
        window.location.href = "<c:url value='/login'/>";
      }else{
        showToast("벤 처리 중 오류가 발생했습니다.");
      }
    })
    .catch(err => {
      console.error(err);
      showToast("서버 통신 오류가 발생했습니다.");
    });
  }

  if (wishPill){
    wishPill.addEventListener("click", () => {
      if (wishPill.disabled) return;
      const name = getCurrentMenuName();
      if (!name) return;
      sendWish(name);
    });
  }

  if (banPill){
    banPill.addEventListener("click", () => {
      if (banPill.disabled) return;
      const name = getCurrentMenuName();
      if (!name) return;
      sendDislike(name);
    });
  }

  // 🔹 음식/음료 구분해서 이미지 src 만들기 (파일명 사용)
  function getImageSrc(row){
    const file =
      row.foodmenuImage || row.foodmenu_image ||
      row.beveragemenuImage || row.beveragemenu_image || "";

    if (!file || file.trim() === "") return "";

    const isBeverage =
      !!(row.beveragemenuName || row.beveragemenu_name ||
         row.style || row.temperature || row.sweetness ||
         row.milk_base || row.fruit_yn);

    const base = isBeverage ? BEV_IMG_BASE : FOOD_IMG_BASE;
    return base + file.trim();
  }

  function openModal(row){
    const name =
      row.foodmenuName || row.foodmenu_name ||
      row.beveragemenuName || row.beveragemenu_name ||
      "추천 메뉴";
    dishName.textContent = name;

    const src = getImageSrc(row);
    if (src){
      dishImage.src = src;
      dishImage.style.display = "block";
    } else {
      dishImage.removeAttribute("src");
      dishImage.style.display = "none";
    }

    // 지도 / 배달 링크 업데이트
    if (modalNaverMap) modalNaverMap.href = "https://map.naver.com/v5/search/" + encodeURIComponent(name);
    if (modalKakaoMap) modalKakaoMap.href = "https://map.kakao.com/?q=" + encodeURIComponent(name);
    if (modalBaemin)   modalBaemin.href   = "https://www.baemin.com/search?keyword=" + encodeURIComponent(name);
    if (modalYogiyo)   modalYogiyo.href   = "https://www.yogiyo.co.kr/search/?keyword=" + encodeURIComponent(name);
    // 🔹 먹게배달은 JS에서 메뉴이름을 쿼리로 넘김 (이 아래에서 이벤트로 처리)

    ratingLocked = 0;
    ratingSubmitted = false;
    fillStars(0);

    resetActionPills();
    modal.classList.add("show");
    modal.setAttribute("aria-hidden","false");
  }

  function closeModal(){
    modal.classList.remove("show");
    modal.setAttribute("aria-hidden","true");
  }

  btnClose.onclick = closeModal;
  modal.addEventListener("click", e=>{
    if(e.target===modal) closeModal();
  });
  btnRetry.addEventListener('click', ()=>{
    closeModal();
    setTimeout(()=>{ if(!hub.disabled) hub.click(); }, 120);
  });

  // 🔹 “더 이상 추천할 메뉴 없음” 모달 제어
  function openEmptyModal(){
    emptyModal.classList.add("show");
    emptyModal.setAttribute("aria-hidden","false");
  }
  function closeEmptyModal(){
    emptyModal.classList.remove("show");
    emptyModal.setAttribute("aria-hidden","true");
  }

  if (emptyBtnClose){
    emptyBtnClose.addEventListener("click", closeEmptyModal);
  }
  if (emptyBtnMypage){
    emptyBtnMypage.addEventListener("click", ()=>{
      window.location.href = "<c:url value='/mypage'/>";
    });
  }
  if (emptyModal){
    emptyModal.addEventListener("click", (e)=>{
      if (e.target === emptyModal){
        closeEmptyModal();
      }
    });
  }

  // 🔹 먹게배달 버튼 → 현재 메뉴 이름을 들고 /delivery 로 이동
  if (modalMukke){
    modalMukke.addEventListener("click", function(e){
      e.preventDefault();
      const name = getCurrentMenuName();
      if (!name || name === "추천 메뉴"){
        showToast("먼저 룰렛을 돌려서 메뉴를 선택해 주세요.");
        return;
      }
      const url = "<c:url value='/delivery'/>" + "?menuName=" + encodeURIComponent(name);
      window.location.href = url;
    });
  }

  hub.addEventListener("click", () => {
    if (hub.disabled) return;
    hub.disabled = true;
    wheel.classList.add("ringing");

    const spinRounds = 5 + Math.floor(Math.random()*3);
    const step = 360 / SEGMENTS.length;
    const targetIndex = Math.floor(Math.random()*SEGMENTS.length);
    const targetAngle = targetIndex * step + step/2;
    const to = currentRotation + spinRounds*360 + targetAngle;
    const from = currentRotation;
    const duration = (2.8 + Math.random()*0.8).toFixed(2) + "s";

    wheel.style.setProperty("--from", from + "deg");
    wheel.style.setProperty("--to",   to   + "deg");
    wheel.style.setProperty("--dur",  duration);
    wheel.classList.remove("spinning");
    void wheel.offsetWidth;
    wheel.classList.add("spinning");

    const onEnd = () => {
      wheel.removeEventListener("animationend", onEnd);
      currentRotation = to % 360;
      wheel.classList.remove("spinning");
      wheel.classList.remove("ringing");
      hub.disabled = false;

      const idx = indexFromAngle(currentRotation);
      const cate = SEGMENTS[idx].name;

      fetch("<c:url value='/api/roulette/spin'/>?category=" + encodeURIComponent(cate), {
        headers: { "Accept": "application/json" }
      })
        .then(r => r.json())
        .then(data => {
          // 🔹 벤/알레르기 필터링 결과, 추천할 메뉴가 없을 때 → 안내 모달
          if (!data.ok) {
            openEmptyModal();
            return;
          }
          if (!data.menu) {
            showToast("추천 결과가 없습니다.");
            return;
          }
          openModal(data.menu);
        })
        .catch(e => {
          console.error(e);
          showToast("네트워크 오류");
        });
    };
    wheel.addEventListener("animationend", onEnd);
  });

  hub.addEventListener("keydown", e=>{
    if(e.key==="Enter"||e.key===" "){
      e.preventDefault();
      hub.click();
    }
  });
</script>
</body>
</html>
