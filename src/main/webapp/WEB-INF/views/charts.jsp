<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 인기차트</title>

  <!-- 공통 폰트 + home.css -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/home.css'/>">

  <style>
    /* ✅ 이 페이지에서만 쓰는 추가 스타일만 정의 (nav/quick-nav 등은 home.css 공통 사용) */

    .chart-title{
      text-align:center; margin:18px 0 10px;
      font-weight:900; font-size:32px; letter-spacing:-.3px;
    }
    .chart-subtitle{
      text-align:center; color:var(--muted);
      margin-bottom:26px; font-weight:500;
    }

    /* 카드 래퍼 */
    .chart-card{
      background:var(--panel);
      border-radius:22px;
      box-shadow:var(--shadow);
      padding:20px;
      border:1px solid var(--border);
      margin-bottom:24px;
    }

    /* TOP3 레이아웃 */
    .top3{
      display:grid;
      grid-template-columns:2fr 1fr 1fr;
      gap:16px;
    }
    @media (max-width:900px){
      .top3{ grid-template-columns:1fr; }
    }

    .rank-card{
      position:relative;
      overflow:hidden;
      border-radius:18px;
      height:300px;
      display:flex;
      flex-direction:column;
      justify-content:flex-end;
      border:3px solid transparent;
      background:#ddd;
    }
    .rank-card.rank-1{ height:340px; }

    /* TOP3 이미지 */
    .rank-image{
      position:absolute;
      inset:0;
      width:100%;
      height:100%;
      object-fit:cover;
    }

    /* 어둡게 그라데이션 깔아서 글자 잘 보이게 */
    .rank-card::after{
      content:"";
      position:absolute;
      inset:0;
      background:linear-gradient(to top,
        rgba(0,0,0,.45),
        rgba(0,0,0,.1),
        rgba(0,0,0,0));
      z-index:1;
    }

    .rank-badge{
      position:absolute;
      top:12px; left:12px;
      padding:6px 10px;
      border-radius:999px;
      font-weight:900; font-size:13px;
      background:rgba(255,255,255,.9);
      border:1px solid var(--border);
      z-index:2;
    }

    .rank-info{
      position:relative;
      z-index:2;
      backdrop-filter:blur(6px);
      background:rgba(255,255,255,.9);
      padding:14px;
      display:flex;
      align-items:center;
      justify-content:space-between;
    }
    .rank-name{
      font-weight:900; font-size:18px;
    }
    .rank-meta{
      color:#555; font-size:12px;
    }

    /* 순위별 테두리 색 */
    .rank-card.rank-1{
      border-color:#ffc83a;
      box-shadow:0 0 0 4px rgba(255,200,58,.16) inset;
    }
    .rank-card.rank-2{
      border-color:#cfd8dc;
      box-shadow:0 0 0 4px rgba(207,216,220,.16) inset;
    }
    .rank-card.rank-3{
      border-color:#e7a26a;
      box-shadow:0 0 0 4px rgba(231,162,106,.16) inset;
    }

    /* 4~10위 리스트 */
    .section-title{
      font-weight:900; font-size:20px;
      margin:0 0 12px;
    }
    .chart-list{
      display:grid;
      gap:8px;
    }
    .list-item{
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding:12px 14px;
      border:1px solid var(--border);
      border-radius:12px;
      background:#fff;
    }
    .list-left{
      display:flex;
      align-items:center;
      gap:10px;
    }
    .rank-num{
      width:28px; height:28px;
      border-radius:8px;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      background:#f4f6fb;
      font-weight:800;
      color:#4a4f57;
      border:1px solid #e6e9f0;
    }
    .list-name{ font-weight:700; }
    .list-meta{ color:#666; font-size:12px; }

    @media (max-width:560px){
      .chart-title{ font-size:26px; }
    }
  </style>
</head>
<body>

<!-- ✅ 상단 네비: home.css 공통 구조 그대로 -->
<header class="nav">
  <div class="nav-inner">
    <div class="nav-brand">오늘 뭐먹게</div>
    <a href="<c:url value='/logout'/>" class="logout-btn">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h8"></path>
        <path d="M10 17l5-5-5-5"></path>
        <path d="M15 12H3"></path>
      </svg>
      로그아웃
    </a>
  </div>
</header>

<main class="wrap">

  <!-- ✅ 퀵 네비: home.jsp / recommand.jsp / mypage.jsp와 동일 마크업 -->
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
      <a class="qitem active" href="<c:url value='/charts'/>">
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
  <br>

  <!-- 타이틀 -->
  <h1 class="chart-title">인기차트</h1>
  <p class="chart-subtitle">1~3위는 이미지로 크게, 4~10위는 텍스트로 간결하게 보여줍니다.</p>

  <!-- TOP 3 -->
  <section class="chart-card" aria-labelledby="top3-title">
    <h2 id="top3-title" style="position:absolute;left:-9999px">상위 3위</h2>
    <div class="top3">
      <!-- 1위: 치킨 -->
      <div class="rank-card rank-1">
        <img class="rank-image"
             src="https://drive.google.com/thumbnail?id=1nut1CYNvGAiCoyiN9clPTKjMNjOyDJQK&sz=w800"
             alt="치킨 이미지">
        <div class="rank-badge">🥇 1위</div>
        <div class="rank-info">
          <div>
            <div class="rank-name">치킨</div>
            <div class="rank-meta">추천 320회 · ★ 4.6</div>
          </div>
          <div style="padding:6px 10px;border-radius:999px;background:#f5f0ff;color:#4f3ad6;border:1px solid #ebe6ff">
            금 랭킹
          </div>
        </div>
      </div>

      <!-- 2위: 떡볶이 -->
      <div class="rank-card rank-2">
        <img class="rank-image"
             src="https://drive.google.com/thumbnail?id=1XYbRb770rnsTG7pIQLzgf24GoHN1FNA-&sz=w800"
             alt="떡볶이 이미지">
        <div class="rank-badge">🥈 2위</div>
        <div class="rank-info">
          <div>
            <div class="rank-name">떡볶이</div>
            <div class="rank-meta">추천 270회 · ★ 4.5</div>
          </div>
          <div style="padding:6px 10px;border-radius:999px;background:#f7f7f8;color:#444;border:1px solid #eee">
            은 랭킹
          </div>
        </div>
      </div>

      <!-- 3위: 마라탕 -->
      <div class="rank-card rank-3">
        <img class="rank-image"
             src="https://drive.google.com/thumbnail?id=1G5rXgjWi9KjcxnjiKnk-zo61WVSv67jt&sz=w800"
             alt="마라탕 이미지">
        <div class="rank-badge">🥉 3위</div>
        <div class="rank-info">
          <div>
            <div class="rank-name">마라탕</div>
            <div class="rank-meta">추천 210회 · ★ 4.4</div>
          </div>
          <div style="padding:6px 10px;border-radius:999px;background:#fff4ec;color:#8a4d2a;border:1px solid #ffe3cc">
            동 랭킹
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 4~10위 -->
  <section class="chart-card" aria-labelledby="list-title">
    <div class="section-title" id="list-title">4~10위 목록</div>
    <div class="chart-list">
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">4</span>
          <span class="list-name">돈까스</span>
        </div>
        <span class="list-meta">추천 180 · ★ 4.3</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">5</span>
          <span class="list-name">초밥</span>
        </div>
        <span class="list-meta">추천 172 · ★ 4.5</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">6</span>
          <span class="list-name">피자</span>
        </div>
        <span class="list-meta">추천 165 · ★ 4.2</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">7</span>
          <span class="list-name">냉면</span>
        </div>
        <span class="list-meta">추천 151 · ★ 4.1</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">8</span>
          <span class="list-name">햄버거</span>
        </div>
        <span class="list-meta">추천 140 · ★ 4.0</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">9</span>
          <span class="list-name">우동</span>
        </div>
        <span class="list-meta">추천 132 · ★ 4.2</span>
      </div>
      <div class="list-item">
        <div class="list-left">
          <span class="rank-num">10</span>
          <span class="list-name">비빔밥</span>
        </div>
        <span class="list-meta">추천 120 · ★ 4.3</span>
      </div>
    </div>
  </section>

</main>
</body>
</html>
