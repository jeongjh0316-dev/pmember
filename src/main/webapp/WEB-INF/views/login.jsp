<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>오늘 뭐먹게?</title>
  <link rel="stylesheet" href="<c:url value='/login.css'/>">
  <style>
    .modal {
      display: none;
      position: fixed; top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;
    }
    .modal-content {
      background: white; padding: 30px; border-radius: 12px; text-align: center;
      width: 90%; max-width: 400px; box-shadow: 0 4px 20px rgba(0,0,0,0.2);
    }
    .modal-content h3 { margin: 0 0 15px; color: #16a34a; }
    .modal-content p { margin: 0 0 20px; color: #555; }
    .modal-content button {
      background: #16a34a; color: white; border: none; padding: 10px 20px;
      border-radius: 6px; cursor: pointer; font-weight: 600;
    }
    .modal.active { display: flex; }

    /* 🔹 공통 토스트 스타일 (까만 배경, 잠깐 떴다 사라지는 A방식) */
    .toast {
      position: fixed;
      left: 50%;
      bottom: 32px;
      transform: translateX(-50%) translateY(10px);
      background: rgba(0, 0, 0, 0.88);
      color: #fff;
      padding: 10px 18px;
      border-radius: 999px;
      font-size: 0.85rem;
      font-weight: 500;
      opacity: 0;
      pointer-events: none;
      transition: opacity .25s ease, transform .25s ease;
      z-index: 10000;
      white-space: nowrap;
    }
    .toast.show {
      opacity: 1;
      transform: translateX(-50%) translateY(0);
    }
  </style>
</head>
<body>

  <%-- 🔹 어떤 탭을 활성화할지 결정:
       1순위: 서버에서 넣어준 activeTab (join 오류 / find 오류 등)
       2순위: 쿼리스트링 tab (login?tab=find)
       기본값: login --%>
  <c:set var="tab" value="${not empty activeTab ? activeTab : (not empty param.tab ? param.tab : 'login')}"/>

  <div class="container">
    <div class="logo">오늘 뭐먹게?</div>
    <p class="subtitle">당신의 취향을 분석하여 완벽한 메뉴를 추천해드립니다</p>

    <div class="login-box">
      <h2>환영합니다!</h2>
      <p class="desc">당신의 취향을 분석하여 완벽한 메뉴를 추천해드립니다</p>

      <!-- 탭 버튼 -->
      <div class="tab-buttons" id="tabs">
        <button class="tab ${tab eq 'login' ? 'active' : ''}" data-target="tab-login">로그인</button>
        <button class="tab ${tab eq 'join' ? 'active' : ''}" data-target="tab-join">회원가입</button>
        <button class="tab ${tab eq 'find' ? 'active' : ''}" data-target="tab-find">아이디/비번 찾기</button>
      </div>

      <!-- 로그인 -->
      <div id="tab-login" class="tab-content ${tab eq 'login' ? 'active' : ''}">

        <c:if test="${not empty loginError}">
          <p style="color:#e11d48; margin:10px 0; text-align:center; font-weight:600;">
            ${loginError}
          </p>
        </c:if>

        <form class="form" action="<c:url value='/login'/>" method="post">
          <label for="loginId">아이디</label>
          <input type="text" id="loginId" name="id" placeholder="아이디" required>

          <label for="loginPw">비밀번호</label>
          <input type="password" id="loginPw" name="pw" placeholder="비밀번호" required>

          <button type="submit" class="primary-btn">로그인</button>

          <button type="button" class="secondary-btn"
                  onclick="location.href='<c:url value='/guest'/>'">
            비회원으로 시작
          </button>
        </form>
      </div>

      <!-- 회원가입 -->
      <div id="tab-join" class="tab-content join-section ${tab eq 'join' ? 'active' : ''}">

        <c:if test="${not empty joinError}">
          <p style="color:#e11d48; margin:10px 0; text-align:center; font-weight:600;">
            ${joinError}
          </p>
        </c:if>

        <form class="form" action="<c:url value='/join'/>" method="post">
          <label for="joinId">아이디</label>
          <div class="id-check-group">
            <input type="text" id="joinId" name="id" placeholder="아이디" required value="${param.id}">
            <button type="button" id="checkIdBtn" class="btn-check">중복확인</button>
            <span id="idStateIcon" class="id-state"></span>
          </div>

          <label for="joinEmail">Email</label>
          <input type="email" id="joinEmail" name="email" placeholder="email@example.com" required value="${param.email}">

          <label for="joinPw">비밀번호</label>
          <input type="password" id="joinPw" name="pw" placeholder="비밀번호" required>

          <label for="joinPw2">비밀번호 확인</label>
          <input type="password" id="joinPw2" name="pw2" placeholder="비밀번호 확인" required>

          <label>생년월일</label>
          <div class="birth-wrap">
            <select id="birthYear" name="birthYear" required data-default="${param.birthYear}">
              <option value="" disabled ${empty param.birthYear ? 'selected' : ''}>년</option>
            </select>
            <select id="birthMonth" name="birthMonth" required data-default="${param.birthMonth}">
              <option value="" disabled ${empty param.birthMonth ? 'selected' : ''}>월</option>
            </select>
            <select id="birthDay" name="birthDay" required data-default="${param.birthDay}">
              <option value="" disabled ${empty param.birthDay ? 'selected' : ''}>일</option>
            </select>
          </div>

          <label>성별</label>
          <div class="gender-wrap">
            <label class="gender-item">
              <input type="checkbox" name="gender" value="male"
                     ${param.gender == 'male' ? 'checked' : ''}> 남자
            </label>
            <label class="gender-item">
              <input type="checkbox" name="gender" value="female"
                     ${param.gender == 'female' ? 'checked' : ''}> 여자
            </label>
            <label class="gender-item">
              <input type="checkbox" name="gender" value="private"
                     ${param.gender == 'private' ? 'checked' : ''}> 비공개
            </label>
          </div>

          <button type="submit" class="primary-btn">가입하기</button>
        </form>
      </div>

      <!-- 아이디/비번 찾기 -->
      <div id="tab-find" class="tab-content ${tab eq 'find' ? 'active' : ''}">

        <!-- 아이디 찾기 -->
        <div class="find-section">
          <h3 class="find-title">아이디 찾기</h3>

          <form class="form" action="<c:url value='/find-id'/>" method="post">
            <label for="findIdEmail">Email</label>
            <input type="email" id="findIdEmail" name="email"
                   placeholder="가입 시 사용한 이메일" required>

            <label>생년월일</label>
            <div class="birth-wrap">
              <select id="findBirthYear" name="birthYear" required>
                <option value="" disabled selected>년</option>
              </select>
              <select id="findBirthMonth" name="birthMonth" required>
                <option value="" disabled selected>월</option>
              </select>
              <select id="findBirthDay" name="birthDay" required>
                <option value="" disabled selected>일</option>
              </select>
            </div>

            <button type="submit" class="secondary-btn">아이디 찾기</button>
          </form>
        </div>

        <hr class="find-divider">

        <!-- 비밀번호 찾기 -->
        <div class="find-section">
          <h3 class="find-title">비밀번호 찾기</h3>

          <form class="form" action="<c:url value='/find-pw'/>" method="post">
            <label for="findPwId">아이디</label>
            <input type="text" id="findPwId" name="id" placeholder="아이디 입력" required>

            <label for="findPwEmail">Email</label>
            <input type="email" id="findPwEmail" name="email"
                   placeholder="가입 시 사용한 이메일" required>

            <button type="submit" class="secondary-btn">비밀번호 찾기</button>
          </form>
        </div>

      </div>
    </div>
  </div>

  <!-- 회원가입 성공 모달 -->
  <div id="joinSuccessModal" class="modal">
    <div class="modal-content">
      <h3>회원가입이 완료되었습니다!</h3>
      <p>로그인을 하고 메뉴 추천을 받아보세요!</p>
      <button onclick="document.getElementById('joinSuccessModal').classList.remove('active')">확인</button>
    </div>
  </div>

  <!-- 🔹 토스트 DOM (메시지가 있을 때만 렌더링) -->
  <c:if test="${not empty toastMessage}">
    <div id="toast" class="toast">
      ${toastMessage}
    </div>
  </c:if>

  <script src="<c:url value='/login.js'/>" defer></script>

  <script>
    // 가입 성공 시 모달
    <c:if test="${showJoinSuccessModal}">
      document.addEventListener('DOMContentLoaded', () => {
        document.getElementById('joinSuccessModal').classList.add('active');
      });
    </c:if>

    // 🔹 /login?tab=find&focus=id|pw 에서 focus에 따라 해당 폼으로 커서 이동
    document.addEventListener('DOMContentLoaded', () => {
      const params = new URLSearchParams(window.location.search);
      const focus = params.get('focus');

      if (focus === 'id') {
        const el = document.getElementById('findIdEmail');
        if (el) el.focus();
      } else if (focus === 'pw') {
        const el = document.getElementById('findPwId');
        if (el) el.focus();
      }

      // 🔹 토스트 메시지가 있으면 잠깐 보여줬다가 자동으로 숨김
      const toast = document.getElementById('toast');
      if (toast) {
        // 조금 딜레이 주고 등장
        setTimeout(() => {
          toast.classList.add('show');
        }, 50);

        // 2.5초 뒤 자동으로 사라짐
        setTimeout(() => {
          toast.classList.remove('show');
        }, 2550);
      }
    });
  </script>

</body>
</html>
