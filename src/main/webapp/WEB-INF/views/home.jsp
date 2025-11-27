<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>오늘 뭐먹게 | 홈</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/home.css'/>">
    <style>
        /* ✅ 이모지 폰트 고정 (상위 폰트 영향 차단) */
        .emoji {
            font-family: "Apple Color Emoji","Segoe UI Emoji","Noto Color Emoji","Noto Emoji",
                         "Segoe UI Symbol","Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif !important;
            font-weight: 400 !important;
            font-size: 64px;
            line-height: 1;
            display: inline-block;
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
    <!-- 퀵네비 -->
    <div class="quick-nav-wrap">
        <nav class="quick-nav" aria-label="주요 메뉴">
            <a class="qitem active" href="<c:url value='/home'/>">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 10.5L12 3l9 7.5"></path>
                    <path d="M5 10.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9.5"></path>
                </svg>
                <span class="label">홈</span>
            </a>
            <a class="qitem" href="<c:url value='/roulette'/>">
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

    <h1 class="title">오늘 뭐먹게?</h1>
    <p class="subtitle">
        <c:choose>
            <c:when test="${not empty nickname}">
                ${nickname}님, 환영합니다! 당신의 취향을 분석하여 완벽한 메뉴를 추천해드립니다
            </c:when>
            <c:otherwise>
                게스트님, 환영합니다! 당신의 취향을 분석하여 완벽한 메뉴를 추천해드립니다
            </c:otherwise>
        </c:choose>
    </p>

    <!-- ✅ 실제 이모지 적용 -->
    <section class="category-grid">
        <a href="<c:url value='/main-food'/>" class="category-card">
            <div class="category-icon"><span class="emoji" role="img" aria-label="밥">🍚</span></div>
            <div class="category-title">메인요리</div>
            <div class="category-desc">5~6개의 질문으로 당신의 입맛을 찾습니다</div>
        </a>
        <a href="<c:url value='/beverage'/>" class="category-card">
            <!-- 🧋 가 안 보이면 🥤 로 교체 가능 -->
            <div class="category-icon"><span class="emoji" role="img" aria-label="음료">🧋</span></div>
            <div class="category-title">음료</div>
            <div class="category-desc">3~4개의 질문으로 완벽한 음료를 찾습니다</div>
        </a>
    </section>
</main>

<!-- ✅ Twemoji 폴백 (모든 OS에서 동일 렌더링) -->
<script src="https://twemoji.maxcdn.com/v/latest/twemoji.min.js" crossorigin="anonymous"></script>
<script>
  document.addEventListener('DOMContentLoaded', function(){
    twemoji.parse(document.body, { folder: 'svg', ext: '.svg' });
  });
</script>

<script src="<c:url value='/home.js'/>" defer></script>
</body>
</html>
