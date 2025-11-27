<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 마이페이지</title>

  <!-- 공통 폰트 -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <!-- ✅ home.css 공통 스타일 -->
  <link rel="stylesheet" href="<c:url value='/home.css'/>">

  <style>
    /* 🔹 이 페이지에서만 쓰는 추가 스타일들만 정의 (nav/quick-nav 등은 home.css 사용) */

    .page-title{
      text-align:center; margin:18px 0 10px;
      font-weight:900; font-size:32px; letter-spacing:-.3px;
    }
    .page-subtitle{
      text-align:center; color:var(--muted);
      margin-bottom:26px; font-weight:500;
    }

    /* 프로필 카드 */
    .profile-card{
      background:var(--panel); border-radius:22px; box-shadow:var(--shadow);
      padding:40px 24px 30px;
      text-align:center; margin-bottom:24px;
      border:1px solid var(--border); position:relative;
    }

    .profile-edit-btn{
      position:absolute;
      top:18px;
      right:20px;
      padding:8px 14px;
      border-radius:999px;
      background:#fff;
      border:1px solid var(--border);
      font-size:13px;
      font-weight:700;
      color:#555;
      text-decoration:none;
      box-shadow:0 2px 6px rgba(0,0,0,.04);
      display:inline-flex;
      align-items:center;
      gap:6px;
      cursor:pointer;
    }
    .profile-edit-btn:hover{
      background:#fff9f1;
    }

    .avatar{
      width:170px;
      height:170px;
      border-radius:50%;
      margin:0 auto 20px;
      background:conic-gradient(from 0deg, #ff6b6b, #feca57, #48dbfb, #ff9ff3);
      display:flex; align-items:center; justify-content:center;
      position:relative;
    }
    .avatar::after{
      content:"";
      position:absolute;
      inset:12px;
      background:#fff;
      border-radius:50%;
    }
    .avatar img{
      width:104px;
      height:104px;
      border-radius:50%;
      position:relative; z-index:1;
      object-fit:cover;
    }

    .edit-photo{
      position:absolute;
      bottom:-8px;
      right:-8px;
      background:#fff;
      width:52px;
      height:52px;
      border-radius:50%;
      display:flex; align-items:center; justify-content:center;
      box-shadow:0 2px 8px rgba(0,0,0,.18);
      cursor:pointer;
      z-index:2;
      border:3px solid(var(--panel));
    }
    .edit-photo svg{
      width:24px;
      height:24px;
      stroke:#555; stroke-width:2.2;
    }

    .username{
      font-weight:900; font-size:20px;
      margin:12px 0 4px;
    }
    .useremail{
      color:var(--muted); font-size:14px;
      margin-bottom:12px;
    }

    .settings-link{
      color:var(--brand); font-size:14px; text-decoration:none; font-weight:600;
      display:inline-flex; align-items:center; gap:4px;
    }
    .settings-link svg{width:14px;height:14px;stroke-width:2;}

    .tab-bar{
      display:flex; gap:8px; margin-bottom:20px;
    }
    .tab-btn{
      flex:1; padding:12px 8px; border-radius:14px;
      background:#fff; border:1px solid var(--border);
      font-weight:700; font-size:14px; color:#555;
      cursor:pointer; transition:all .2s;
      box-shadow:0 2px 6px rgba(0,0,0,.04);
    }
    .tab-btn.active{
      background:var(--brand); color:#fff; border-color:var(--brand);
      box-shadow:0 4px 10px rgba(111,70,255,.2);
    }

    .section-card{
      background:var(--panel); border-radius:18px; padding:20px;
      box-shadow:var(--shadow); border:1px solid var(--border);
      margin-bottom:28px;
    }
    .section-title{
      font-weight:700; font-size:16px; margin:0 0 16px; color:#222;
    }

    .avoid-grid{
      display:grid; grid-template-columns:repeat(3,1fr); gap:12px 16px;
      align-items:center;
    }
    .avoid-item{
      display:flex; align-items:center; gap:10px; font-size:15px;
    }
    .avoid-item input[type="checkbox"]{
      width:18px; height:18px; accent-color:var(--accent);
    }
    .avoid-text{ flex:1; font-weight:500; }

    .empty-state{
      text-align:center; color:#aaa; font-size:14px; padding:20px 0;
      line-height:1.5;
    }

    .tab-content{display:none;}
    .tab-content.active{display:block;}

    .pill-btn{
      padding:8px 12px; border-radius:12px; border:1px solid var(--border);
      background:#fff; font-weight:700; font-size:13px; cursor:pointer;
      box-shadow:0 2px 6px rgba(0,0,0,.04);
    }
    .pill-btn:hover{background:#fff9f1}

    .title-food,
    .title-drink{
      color:var(--brand);
    }

    .wish-name-btn{
      border:none;
      background:transparent;
      padding:4px 0;
      margin:0;
      font-size:15px;
      font-weight:500;
      color:#333;
      cursor:pointer;
      text-align:left;
      flex:1;
    }
    .wish-name-btn:hover{
      color:var(--brand);
      text-decoration:underline;
    }

    /* ───────── 지도/배달 버튼: 룰렛 모달과 동일 스타일 ───────── */
    .btn{
      flex:1;
      min-width:130px;
      padding:7px 10px;
      border-radius:10px;
      text-align:center;
      font-weight:800;
      font-size:12px;
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

    /* 🔥 먹게배달: 룰렛 모달과 동일한 풀컬러 버튼 */
    .btn-mukke{
      flex-basis:100%;
      margin-top:2px;
      background:#6c5ce7;
      color:#ffffff;
      border-color:#6c5ce7;
      font-weight:900;
      font-size:14px;
      box-shadow:0 4px 12px rgba(88,28,135,.35);
      text-shadow:1px 1px 0 rgba(0,0,0,0.5);
    }
    .btn-mukke:hover{
      background:#7560ff;
      box-shadow:0 6px 16px rgba(88,28,135,.45);
    }

    /* 🔹 찜/기록 모달: 룰렛 모달 디자인과 동일하게 적용 */

    .wish-modal-backdrop{
      position:fixed;
      inset:0;
      background:rgba(15,23,42,.55);
      display:none;
      align-items:center;
      justify-content:center;
      z-index:1000;
      padding:20px;
    }
    .wish-modal{
      background:var(--panel);
      border-radius:24px;
      border:2px solid var(--brand);
      box-shadow:0 24px 60px rgba(15,23,42,.55);
      width:min(520px, 92vw);
      padding:22px 22px 18px;
      position:relative;
    }
    .wish-modal-header{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:10px;
      margin-bottom:12px;
    }
    .wish-modal-title{
      font-size:28px;
      font-weight:900;
      letter-spacing:-.4px;
    }
    .wish-modal-close{
      border:none;
      background:transparent;
      cursor:pointer;
      padding:4px;
      margin:-4px -4px 0 0;
    }
    .wish-modal-close svg{
      width:20px;
      height:20px;
      stroke:#666;
      stroke-width:2;
    }

    /* ⭐ 모달 이미지 영역 (룰렛 모달과 비슷하게) */
    .wish-modal-image-wrap{
      width:100%;
      border-radius:16px;
      overflow:hidden;
      background:#f3f4f6;
      margin-bottom:8px;
      display:none; /* JS에서 이미지 있을 때만 block으로 변경 */
    }
    .wish-modal-image-wrap img{
      width:100%;
      display:block;
      max-height:210px;
      object-fit:cover;
    }

    .wish-modal-body{
      font-size:13px;
      color:var(--muted);
      margin-bottom:10px;
      line-height:1.5;
    }
    .wish-modal-section-label{
      margin-top:6px;
      margin-bottom:6px;
      font-size:12px;
      font-weight:800;
      color:#555;
      letter-spacing:-.2px;
      display:flex;
      align-items:center;
      gap:6px;
    }
    .wish-modal-section-label::before{
      content:"";
      width:7px; height:7px;
      border-radius:50%;
      background:var(--brand);
      display:inline-block;
    }
    .wish-modal-btn-row{
      display:flex;
      flex-wrap:wrap;
      gap:8px;
      margin-bottom:6px;
    }
    .wish-modal-btn-row .btn{
      flex:1;
      min-width:130px;
    }

    /* ⭐ 별점 박스 (룰렛 스타일과 맞춤) */
    .rating-box{
      margin:8px 0 4px;
      padding:12px;
      border:1px dashed var(--border);
      border-radius:14px;
      background:#fafafa;
      transform:scale(.9);
      transform-origin:center;
    }
    .rating-title{
      font-weight:800;
      margin-bottom:6px;
      display:flex;
      align-items:center;
      gap:8px;
      justify-content:center;
      font-size:13px;
    }
    .rating-stars{
      display:flex;
      gap:9px;
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
      transform:scale(1.15);
      filter:drop-shadow(0 2px 6px rgba(0,0,0,.15));
    }
    .rating-hint{
      font-weight:800;
      color:#8a8f98;
      min-width:44px;
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

    /* 🔹 찜 / 벤 pill (기록 모달에서만 사용) */
    .action-row{
      display:flex;
      gap:8px;
      margin-top:8px;
      margin-bottom:4px;
    }
    .action-pill{
      flex:1;
      border-radius:999px;
      border:1px solid var(--border);
      background:#fff;
      padding:8px 10px;
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

    @media (max-width:560px){
      .page-title{font-size:26px}
      .tab-btn{font-size:13px; padding:10px 6px;}
      .avoid-grid{grid-template-columns:1fr;}

      .avatar{
        width:110px;
        height:110px;
        margin-bottom:16px;
      }
      .avatar img{
        width:70px;
        height:70px;
      }
      .edit-photo{
        width:36px;
        bottom:-6px;
        right:-6px;
        height:36px;
      }

      .wish-modal{
        width:92vw;
        padding:18px 16px 16px;
      }
      .wish-modal-title{
        font-size:22px;
      }
      .btn{
        min-width:0;
      }
    }
  </style>
</head>
<body>

  <!-- 상단 네비게이션 -->
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

    <!-- 퀵 네비게이션 -->
    <div class="quick-nav-wrap">
      <nav class="quick-nav" aria-label="주요 메뉴">
        <a class="qitem" href="<c:url value='/home'/>">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 10.5L12 3l9 7.5"></path>
            <path d="M5 10.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9.5"></path>
          </svg>
          <span class="label">홈</span>
        </a>
        <a class="qitem" href="<c:url value='/roulette'/>">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 6v6l4 2"></path>
            <circle cx="12" cy="12" r="2"></circle>
          </svg>
          <span class="label">룰렛 돌리기</span>
        </a>
        <a class="qitem" href="<c:url value='/charts'/>">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 20h18"></path>
            <path d="M7 20V9"></path>
            <path d="M12 20V4"></path>
            <path d="M17 20v-6"></path>
          </svg>
          <span class="label">인기차트</span>
        </a>
        <a class="qitem active" href="<c:url value='/mypage'/>">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="8" r="4"></circle>
            <path d="M4 21a8 8 0 0 1 16 0"></path>
          </svg>
          <span class="label">마이페이지</span>
        </a>
      </nav>
    </div>

    <br>

    <!-- 페이지 타이틀 -->
    <h1 class="page-title">마이페이지</h1>
    <p class="page-subtitle">내가 찜한 메뉴와 활동을 한눈에 확인하세요</p>

    <!-- 프로필 카드 -->
    <section class="profile-card">
      <a href="<c:url value='/mypage/edit'/>" class="profile-edit-btn">
        회원 정보 수정
      </a>

      <form action="<c:url value='/mypage/profile-image'/>"
            method="post"
            enctype="multipart/form-data">

        <div class="avatar">
          <c:choose>
            <c:when test="${not empty profileImage}">
              <img src="${profileImage}" alt="프로필 사진">
            </c:when>
            <c:otherwise>
              <img src="https://via.placeholder.com/80" alt="기본 프로필">
            </c:otherwise>
          </c:choose>

          <label class="edit-photo" title="사진 변경">
            <input type="file" name="file" accept="image/*" style="display:none;"
                   onchange="this.form.submit();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 8v8"></path>
              <path d="M8 12h8"></path>
            </svg>
          </label>
        </div>

        <div class="username">
          ${nickname} 님 환영합니다.
        </div>
        <div class="useremail">
          ${email}
        </div>

      </form>
    </section>

    <!-- 탭 버튼: 설정 / 벤 메뉴 관리 / 기록 -->
    <div class="tab-bar">
      <button class="tab-btn active" data-tab="settings">설정</button>
      <button class="tab-btn" data-tab="ban">벤 메뉴 관리</button>
      <button class="tab-btn" data-tab="history">기록</button>
    </div>

    <!-- 설정 탭 -->
    <div id="settings" class="tab-content active">
      <!-- 🔹 찜 목록 관리 -->
      <section class="section-card">
        <h3 class="section-title" style="display:flex; align-items:center; justify-content:space-between;">
          <span>찜한 메뉴</span>
          <span style="display:flex; gap:8px;">
            <button type="button" class="pill-btn" id="wishSelectAllBtn">전체선택</button>
            <button type="button" class="pill-btn" id="wishClearSelectionBtn">선택해제</button>
            <button type="submit" class="pill-btn" id="wishDeleteSelectedBtn"
                    form="wishForm"
                    style="background: var(--brand); color:#fff; border-color: var(--brand);">
              삭제
            </button>
          </span>
        </h3>

        <c:if test="${empty wishlist}">
          <p class="empty-state" id="wishEmpty">
            아직 찜한 메뉴가 없습니다.<br>
            추천 결과에서 하트(♥) 버튼 눌러서 찜 해보세요!
          </p>
        </c:if>

        <c:if test="${not empty wishlist}">
          <form id="wishForm" method="post" action="<c:url value='/wish/remove'/>">
            <div class="avoid-grid" id="wishList">
              <c:forEach var="wish" items="${wishlist}">
                <div class="avoid-item">
                  <input type="checkbox" name="foodName" value="${wish.foodName}">
                  <!-- 찜 목록: 음식 타입 고정 -->
                  <button type="button"
                          class="wish-name-btn"
                          data-food-name="${wish.foodName}"
                          data-type="food"
                          data-image-url="<c:url value='/images/food/${wish.foodImage}'/>">
                    ${wish.foodName}
                  </button>
                </div>
              </c:forEach>
            </div>
          </form>
        </c:if>
      </section>

      <!-- 🔹 알레르기 정보 -->
      <section class="section-card" id="allergy-section">
        <form id="allergyForm" method="post" action="<c:url value='/mypage/allergy'/>">
          <h3 class="section-title" style="display:flex; align-items:center; justify-content:space-between;">
            <span>알레르기 정보 저장</span>
            <span style="display:flex; gap:8px;">
              <button type="button" class="pill-btn" id="allergySelectAllBtn">전체선택</button>
              <button type="button" class="pill-btn" id="allergyClearSelectionBtn">선택해제</button>
              <button type="submit" class="pill-btn"
                      style="background: var(--brand); color:#fff; border-color: var(--brand);">
                저장
              </button>
            </span>
          </h3>

          <div class="avoid-grid" id="allergyList">
            <c:forEach var="al" items="${alergyList}">
              <div class="avoid-item">
                <input type="checkbox"
                       name="alergyIds"
                       value="${al.al_idx}"
                       <c:if test="${userAlergyIdxList != null and userAlergyIdxList.contains(al.al_idx)}">
                         checked="checked"
                       </c:if>
                >
                <span class="avoid-text">${al.al_name}</span>
              </div>
            </c:forEach>
          </div>
        </form>
      </section>
    </div>

    <!-- 벤 메뉴 관리 탭 -->
    <div id="ban" class="tab-content">
      <section class="section-card" id="ban-section">
        <h3 class="section-title" style="display:flex; align-items:center; justify-content:space-between;">
          <span>벤 메뉴 관리</span>
          <span style="display:flex; gap:8px;">
            <button type="button" class="pill-btn" id="selectAllBtn">전체선택</button>
            <button type="button" class="pill-btn" id="clearSelectionBtn">선택해제</button>
            <button type="submit" form="banForm" class="pill-btn" id="deleteSelectedBtn"
                    style="background: var(--brand); color:#fff; border-color: var(--brand);">
              삭제
            </button>
          </span>
        </h3>

        <c:if test="${not empty dislikeList}">
          <form id="banForm" method="post" action="<c:url value='/dislike/removeSelected'/>">
            <div class="avoid-grid" id="banList">
              <c:forEach var="d" items="${dislikeList}">
                <div class="avoid-item">
                  <input type="checkbox" name="foodName" value="${d.foodName}">
                  <span class="avoid-text">${d.foodName}</span>
                </div>
              </c:forEach>
            </div>
          </form>
        </c:if>

        <c:if test="${empty dislikeList}">
          <p class="empty-state" id="banEmpty">
            벤한 메뉴가 없습니다.<br>
            추천 결과에서 ‘싫어요(X)’ 버튼을 누르면 여기로 모여요.
          </p>
        </c:if>

        <script>
          (function(){
            const list = document.getElementById('banList');
            const emptyMsg = document.getElementById('banEmpty');
            const selectAllBtn = document.getElementById('selectAllBtn');
            const clearSelectionBtn = document.getElementById('clearSelectionBtn');
            const deleteSelectedBtn = document.getElementById('deleteSelectedBtn');

            function hasItems(){
              return !!(list && list.querySelectorAll('.avoid-item').length > 0);
            }

            function refreshEmptyState(){
              if (!emptyMsg) return;
              emptyMsg.style.display = hasItems() ? 'none' : 'block';
            }

            if (selectAllBtn) {
              selectAllBtn.addEventListener('click', () => {
                if (!list) return;
                list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = true);
              });
            }

            if (clearSelectionBtn) {
              clearSelectionBtn.addEventListener('click', () => {
                if (!list) return;
                list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = false);
              });
            }

            if (deleteSelectedBtn) {
              deleteSelectedBtn.addEventListener('click', (e) => {
                if (!list) {
                  e.preventDefault();
                  alert('삭제할 메뉴를 선택해 주세요.');
                  return;
                }
                const selected = list.querySelectorAll('input[type="checkbox"]:checked');
                if(selected.length === 0){
                  e.preventDefault();
                  alert('삭제할 메뉴를 선택해 주세요.');
                }
              });
            }

            refreshEmptyState();
          })();
        </script>
      </section>
    </div>

    <!-- 기록 탭 -->
    <div id="history" class="tab-content">
      <!-- 음식 추천 기록 -->
      <section class="section-card">
        <h3 class="section-title" style="display:flex; align-items:center; justify-content:space-between;">
          <span>최근 <span class="title-food">음식</span> 추천 기록 (최대 21개)</span>
        </h3>

        <c:if test="${empty foodHistoryList}">
          <p class="empty-state" id="historyFoodEmpty">
            아직 음식 추천 기록이 없습니다.<br>
            메뉴 추천을 받아 보세요!
          </p>
        </c:if>

        <c:if test="${not empty foodHistoryList}">
          <div class="avoid-grid" id="historyFoodList">
            <c:forEach var="h" items="${foodHistoryList}">
              <div class="avoid-item">
                <div class="avoid-text">
                  <button type="button"
                          class="wish-name-btn"
                          data-food-name="${h.foodmenuName}"
                          data-type="food"
                          data-image-url="<c:url value='/images/food/${h.foodmenuImage}'/>">
                    ${h.foodmenuName}
                  </button>
                  <div style="font-size:12px; color:var(--muted);">
                    ${h.createdAt}
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:if>
      </section>

      <!-- 음료 추천 기록 -->
      <section class="section-card">
        <h3 class="section-title" style="display:flex; align-items:center; justify-content:space-between;">
          <span>최근 <span class="title-drink">음료</span> 추천 기록 (최대 21개)</span>
        </h3>

        <c:if test="${empty beverageHistoryList}">
          <p class="empty-state" id="historyDrinkEmpty">
            아직 음료 추천 기록이 없습니다.<br>
            음료 메뉴 추천을 받아 보세요!
          </p>
        </c:if>

        <c:if test="${not empty beverageHistoryList}">
          <div class="avoid-grid" id="historyDrinkList">
            <c:forEach var="h" items="${beverageHistoryList}">
              <div class="avoid-item">
                <div class="avoid-text">
                  <!-- ⭐ type="drink" → JS에서 찜/벤 버튼 숨김 -->
                  <button type="button"
                          class="wish-name-btn"
                          data-food-name="${h.beveragemenuName}"
                          data-type="drink"
                          data-image-url="<c:url value='/images/beverage/${h.beveragemenuImage}'/>">
                    ${h.beveragemenuName}
                  </button>
                  <div style="font-size:12px; color:var(--muted);">
                    ${h.createdAt}
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:if>
      </section>
    </div>

    <!-- 🔹 공통 모달 (룰렛 모달 스타일 + 먹게배달 버튼 포함) -->
    <div class="wish-modal-backdrop" id="wishModal">
      <div class="wish-modal" role="dialog" aria-modal="true" aria-labelledby="wishModalTitle">

        <div class="wish-modal-header">
          <h3 class="wish-modal-title" id="wishModalTitle">메뉴 이름</h3>
          <button type="button" class="wish-modal-close" id="wishModalClose" aria-label="닫기">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M6 6l12 12"></path>
              <path d="M18 6L6 18"></path>
            </svg>
          </button>
        </div>

        <!-- 이미지 영역 -->
        <div class="wish-modal-image-wrap" id="wishModalImageWrap">
          <img id="wishModalImage" src="" alt="메뉴 이미지">
        </div>

        <!-- 별점 -->
        <div class="rating-box" aria-live="polite" id="wishRatingBox">
          <div class="rating-title">
            이 메뉴, 어떠셨나요?
            <span style="color:var(--muted);font-weight:600">별점을 주세요!</span>
          </div>
          <div class="rating-stars" id="wishRatingStars" role="radiogroup" aria-label="별점 주기">
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
            <span class="rating-hint" id="wishRatingHint">0/5</span>
          </div>
        </div>

        <!-- 기록용 찜/벤 (음식 기록만 노출) -->
        <c:if test="${not empty sessionScope.loginMember}">
          <div class="action-row" id="actionRow">
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

        <div class="wish-modal-body">
          선택한 메뉴입니다. 지도로 주변 가게를 찾아보거나 배달로 주문해 보세요.
        </div>

        <!-- 지도/배달 버튼: 룰렛 모달과 동일 구조 + 먹게배달 -->
        <div class="wish-modal-section-label">지도에서 찾기</div>
        <div class="wish-modal-btn-row">
          <a class="btn btn-naver" id="modalNaverMap" target="_blank" href="#">
            Naver Map
          </a>
          <a class="btn btn-kakao" id="modalKakaoMap" target="_blank" href="#">
            Kakao Map
          </a>
        </div>

        <div class="wish-modal-section-label">배달 주문</div>
        <!-- 1줄: Baemin / Yogiyo -->
        <div class="wish-modal-btn-row">
          <a class="btn btn-baemin" id="modalBaemin" target="_blank" href="#">
            Baemin
          </a>
          <a class="btn btn-yogiyo" id="modalYogiyo" target="_blank" href="#">
            Yogiyo
          </a>
        </div>
        <!-- 2줄: 먹게배달 단독 -->
        <div class="wish-modal-btn-row">
          <a class="btn btn-mukke" id="modalMukke" href="#">
            먹게배달로 주문하기
          </a>
        </div>
      </div>
    </div>

    <br><br><br>
  </main>

  <!-- 토스트 -->
  <div class="toast" id="toast">결과 표시</div>

  <!-- 탭 전환 -->
  <script>
    (function(){
      const tabButtons = document.querySelectorAll('.tab-btn');
      const tabContents = document.querySelectorAll('.tab-content');

      function activateTab(tabId){
        tabButtons.forEach(btn => {
          const id = btn.getAttribute('data-tab');
          btn.classList.toggle('active', id === tabId);
        });
        tabContents.forEach(content => {
          content.classList.toggle('active', content.id === tabId);
        });
      }

      const params = new URLSearchParams(window.location.search);
      const initialTab = params.get('tab') || 'settings';

      activateTab(initialTab);

      tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
          const tabId = btn.getAttribute('data-tab');
          activateTab(tabId);
        });
      });
    })();
  </script>

  <!-- 찜 목록 + 기록 공통 모달 스크립트 -->
  <script>
    (function(){
      /* ====== 찜 목록: 전체선택/삭제 ====== */
      const list = document.getElementById('wishList');
      const emptyMsg = document.getElementById('wishEmpty');
      const selectAllBtn = document.getElementById('wishSelectAllBtn');
      const clearSelectionBtn = document.getElementById('wishClearSelectionBtn');
      const deleteSelectedBtn = document.getElementById('wishDeleteSelectedBtn');
      const form = document.getElementById('wishForm');

      function hasItems(){
        return !!(list && list.querySelectorAll('.avoid-item').length > 0);
      }
      function refreshButtons(){
        const disabled = !hasItems();
        if (selectAllBtn) selectAllBtn.disabled = disabled;
        if (clearSelectionBtn) clearSelectionBtn.disabled = disabled;
        if (deleteSelectedBtn) deleteSelectedBtn.disabled = disabled;
      }
      refreshButtons();

      if (selectAllBtn) {
        selectAllBtn.addEventListener('click', () => {
          if (!list) return;
          list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = true);
        });
      }
      if (clearSelectionBtn) {
        clearSelectionBtn.addEventListener('click', () => {
          if (!list) return;
          list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = false);
        });
      }

      if (deleteSelectedBtn) {
        deleteSelectedBtn.addEventListener('click', (e) => {
          if (!list || !form) return;
          const selected = Array.from(list.querySelectorAll('input[type="checkbox"]:checked'));
          if (selected.length === 0) {
            e.preventDefault();
            alert('삭제할 메뉴를 선택해 주세요.');
          }
        });
      }

      /* ====== 공통 모달 요소 ====== */
      const modal = document.getElementById('wishModal');
      const modalTitle = document.getElementById('wishModalTitle');
      const closeBtn = document.getElementById('wishModalClose');
      const linkNaver = document.getElementById('modalNaverMap');
      const linkKakao = document.getElementById('modalKakaoMap');
      const linkBaemin = document.getElementById('modalBaemin');
      const linkYogiyo = document.getElementById('modalYogiyo');
      const linkMukke = document.getElementById('modalMukke'); // ⭐ 먹게배달 버튼

      const modalImageWrap = document.getElementById('wishModalImageWrap');
      const modalImage = document.getElementById('wishModalImage');

      const toast = document.getElementById('toast');

      // ⭐ 먹게배달 기본 URL (룰렛과 동일하게 사용) ➜ /delivery 로 통일
      const mukkeBaseUrl = "<c:url value='/delivery'/>";

      // 별점
      const ratingStarsWrap = document.getElementById('wishRatingStars');
      const ratingHint = document.getElementById('wishRatingHint');
      const ratingStars = ratingStarsWrap ? Array.from(ratingStarsWrap.querySelectorAll('.star')) : [];
      let ratingLocked = 0;
      let ratingSubmitted = false;

      // 찜/벤 pill
      const actionRow = document.getElementById('actionRow');
      const wishPill = actionRow ? actionRow.querySelector('.wish-pill') : null;
      const banPill  = actionRow ? actionRow.querySelector('.ban-pill') : null;

      // 현재 메뉴 정보
      let currentMenuName = '';
      let currentMenuType = 'food'; // 'food' | 'drink'

      function showToast(msg){
        if (!toast) return;
        toast.textContent = msg;
        toast.classList.add('show');
        setTimeout(()=> toast.classList.remove('show'), 1500);
      }

      function fillStars(value){
        ratingStars.forEach(s => s.classList.toggle('filled', Number(s.dataset.value) <= value));
        if (ratingHint) ratingHint.textContent = (value||0) + '/5';
      }
      fillStars(0);

      function spawnSparkles(container, x, y){
        const N = 10 + Math.floor(Math.random()*6);
        for(let i=0;i<N;i++){
          const sp = document.createElement('span');
          sp.className = 'sparkle';
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

      function getCurrentMenuName(){
        return currentMenuName || (modalTitle.textContent || '').trim();
      }

      // ⭐ 별점 서버 전송 (음식/음료 구분해서 전송)
      function sendModalRating(score){
        const name = getCurrentMenuName();
        if (!name) return;

        let url = "<c:url value='/rating/food'/>";
        let paramName = "foodName";
        if (currentMenuType === 'drink') {
          url = "<c:url value='/rating/beverage'/>";
          paramName = "beverageName";
        }

        const body =
          encodeURIComponent(paramName) + "=" + encodeURIComponent(name) +
          "&score=" + encodeURIComponent(score);

        fetch(url, {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
          },
          body: body
        })
          .then(res => res.text())
          .then(text => {
            console.log("[MYPAGE-RATING]", text);
            if (text === "NOT_LOGIN") {
              alert("별점을 남기려면 먼저 로그인 해주세요.");
              window.location.href = "<c:url value='/login'/>";
            } else if (text === "OK") {
              console.log("마이페이지 별점 저장 완료");
            } else if (text === "INVALID_SCORE") {
              console.warn("잘못된 점수:", score);
            } else {
              alert("별점 저장 중 오류가 발생했습니다.");
            }
          })
          .catch(err => {
            console.error("[MYPAGE-RATING-ERROR]", err);
            alert("서버 통신 중 오류가 발생했습니다.");
          });
      }

      // 별점 이벤트
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

          console.log('[MYPAGE 별점 제출]', {
            menuName: getCurrentMenuName(),
            score: ratingLocked,
            type: currentMenuType
          });
          sendModalRating(ratingLocked);
        });
      });

      function resetRating(){
        ratingLocked = 0;
        ratingSubmitted = false;
        fillStars(0);
      }

      // 음식 기록만 찜/벤 노출, 음료 기록은 숨김
      function resetActionPills(show){
        if (actionRow){
          actionRow.style.display = show ? 'flex' : 'none';
        }
        if (!show) return;
        if (wishPill){
          wishPill.disabled = false;
          wishPill.classList.remove('active');
        }
        if (banPill){
          banPill.disabled = false;
          banPill.classList.remove('active');
        }
      }

      function disableActionPills(){
        if (wishPill) wishPill.disabled = true;
        if (banPill)  banPill.disabled  = true;
      }

      // 찜/벤 AJAX
      function sendWish(foodName){
        if (!wishPill || !foodName) return;
        fetch("<c:url value='/wish/add'/>", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
          body: "foodName=" + encodeURIComponent(foodName)
        })
          .then(res => res.text())
          .then(text => {
            console.log("[WISH-ADD-MYPAGE]", text);
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
            console.log("[DISLIKE-ADD-MYPAGE]", text);
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

      // 모달 열기
      function openWishModal(foodName, imageUrl, fromHistory, menuType){
        if (!modal) return;
        currentMenuName = foodName || '';
        currentMenuType = menuType || 'food';

        modalTitle.textContent = foodName;

        // 이미지 세팅
        if (modalImage && modalImageWrap){
          if (imageUrl && imageUrl.trim() !== ''){
            modalImage.src = imageUrl;
            modalImage.alt = foodName;
            modalImageWrap.style.display = 'block';
          } else {
            modalImage.src = '';
            modalImageWrap.style.display = 'none';
          }
        }

        const q = encodeURIComponent(foodName);
        if (linkNaver) linkNaver.href = "https://map.naver.com/v5/search/" + q;
        if (linkKakao) linkKakao.href = "https://map.kakao.com/?q=" + q;
        if (linkBaemin) linkBaemin.href = "https://www.baemin.com/search?keyword=" + q;
        if (linkYogiyo) linkYogiyo.href = "https://www.yogiyo.co.kr/search/?keyword=" + q;
        // 🔹 룰렛과 동일하게 /delivery?menuName= 으로 연결
        if (linkMukke) linkMukke.href = mukkeBaseUrl + "?menuName=" + q;

        resetRating();

        // 음식 + history일 때만 찜/벤 표시
        const showPills = fromHistory && currentMenuType === 'food';
        resetActionPills(showPills);

        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
      }

      function closeWishModal(){
        if (!modal) return;
        modal.style.display = 'none';
        document.body.style.overflow = '';
      }

      // 버튼들에 모달 연결
      document.querySelectorAll('.wish-name-btn').forEach(btn => {
        btn.addEventListener('click', () => {
          const name = btn.getAttribute('data-food-name') || btn.textContent.trim();
          const img = btn.getAttribute('data-image-url');
          const type = btn.getAttribute('data-type') || (btn.closest('#historyDrinkList') ? 'drink' : 'food');
          const fromHistory = !!btn.closest('#history');
          openWishModal(name, img, fromHistory, type);
        });
      });

      if (closeBtn) {
        closeBtn.addEventListener('click', closeWishModal);
      }
      if (modal) {
        modal.addEventListener('click', (e) => {
          if (e.target === modal) {
            closeWishModal();
          }
        });
      }
    })();
  </script>

  <!-- 알레르기 전체선택/선택해제 -->
  <script>
    (function(){
      const list = document.getElementById('allergyList');
      const selectAllBtn = document.getElementById('allergySelectAllBtn');
      const clearSelectionBtn = document.getElementById('allergyClearSelectionBtn');

      if (selectAllBtn) {
        selectAllBtn.addEventListener('click', () => {
          if (!list) return;
          list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = true);
        });
      }
      if (clearSelectionBtn) {
        clearSelectionBtn.addEventListener('click', () => {
          if (!list) return;
          list.querySelectorAll('input[type="checkbox"]').forEach(chk => chk.checked = false);
        });
      }
    })();
  </script>

</body>
</html>
