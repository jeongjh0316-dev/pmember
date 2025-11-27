<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정</title>
    <!--===============================-->
    <!-- CSS (login.css 기반 통합) -->
    <!--===============================-->
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');
        * { box-sizing: border-box; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: #fff8f2;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 60px 0;
            align-items: flex-start;
        }
        .container {
            text-align: center;
            position: relative;
            width: 100%;
        }
        .logo {
            font-size: 2rem;
            color: #e86c29;
            margin-bottom: 8px;
            font-weight: 700;
        }
        .subtitle {
            color: #555;
            font-size: 0.95rem;
            margin-bottom: 32px;
        }
        .login-box {
            background: #fff;
            width: 480px;
            padding: 32px 28px 36px;
            border-radius: 16px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-align: left;
            margin: 0 auto;
            border: 1px solid #eee;
        }
        h2 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0 0 6px;
        }
        .desc {
            font-size: 0.86rem;
            color: #777;
            margin-bottom: 22px;
        }
        .form label {
            font-size: 0.86rem;
            font-weight: 700;
            color: #222;
            display: block;
            margin-top: 18px;
        }
        .form input, .form select {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #e3e3e8;
            background: #ffffff;
            margin-top: 6px;
            font-size: 0.95rem;
        }
        .birth-wrap {
            display: flex;
            gap: 8px;
            margin-top: 6px;
        }
        .birth-wrap select {
            flex: 1;
        }
        .gender-wrap {
            display: flex;
            justify-content: space-between;
            padding: 0 4px;
            margin-top: 8px;
            gap: 8px;
        }
        .gender-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            color: #555;
            cursor: pointer;
        }
        .gender-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #050512;
        }

        /* 🔹 수정하기 버튼: 보라색 */
        .primary-btn {
            width: 100%;
            background: #6f46ff;
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 12px;
            margin-top: 22px;
            font-size: 0.98rem;
            cursor: pointer;
        }
        .secondary-btn {
            width: 100%;
            background: #fff;
            color: #222;
            border: 1px solid #e3e3e8;
            border-radius: 10px;
            padding: 11px;
            margin-top: 12px;
            font-weight: 600;
            cursor: pointer;
        }

        /* 아이디 + 중복확인 */
        .id-check-group {
            display: flex;
            align-items: center;
            gap: 8px;
            position: relative;
        }
        .id-check-group input {
            flex: 1;
        }
        .btn-check {
            background:#fff;
            color:#222;
            border:1px solid #e3e3e8;
            border-radius:10px;
            padding:10px 12px;
            cursor:pointer;
            font-weight:600;
            white-space:nowrap;
            box-shadow:0 2px 6px rgba(0,0,0,.06);
        }
        /* 중복확인 결과 아이콘 */
        .id-state {
            width:20px;
            height:20px;
            position:absolute;
            right:96px;
            pointer-events:none;
            opacity:0;
            transition:opacity .15s;
        }
        input.state-valid ~ .id-state {
            opacity:1;
            background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='20' height='20' fill='none' stroke='%2316a34a' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M20 6L9 17l-5-5'/></svg>") center/20px 20px no-repeat;
        }
        input.state-invalid ~ .id-state {
            opacity:1;
            background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='20' height='20' fill='none' stroke='%23e11d48' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'/><line x1='15' y1='9' x2='9' y2='15'/><line x1='9' y1='9' x2='15' y2='15'/></svg>") center/20px 20px no-repeat;
        }

        /* ================= 모달 스타일 ================= */
        .modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        .modal-box {
            background: #ffffff;
            width: 320px;
            max-width: 90%;
            border-radius: 18px;
            padding: 22px 20px 18px;
            box-shadow: 0 18px 45px rgba(15,23,42,.35);
            text-align: center;
        }
        .modal-title {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #111827;
        }
        .modal-text {
            font-size: 0.9rem;
            color: #6b7280;
            margin-bottom: 20px;
        }
        .modal-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }
        .modal-btn-secondary {
            flex: 1;
            padding: 9px 0;
            border-radius: 999px;
            border: 1px solid #e5e7eb;
            background: #ffffff;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
        }
        .modal-btn-primary {
            flex: 1;
            padding: 9px 0;
            border-radius: 999px;
            border: none;
            background: #6f46ff;
            color: #ffffff;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
        }

        /* 🔻 회원탈퇴 버튼: 박스 바깥, 오른쪽 아래 구석 + 흰색 스타일 */
        .delete-btn-wrap{
            width: 480px;
            margin: 12px auto 0;
            text-align: right;
        }

        .delete-btn{
            background: #ffffff;
            color: #d32f2f;
            border: 1px solid #f0bcbc;
            padding: 10px 18px;
            border-radius: 999px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
        }

        .delete-btn:hover{
            background: #fff5f5;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">오늘 뭐먹게?</div>
    <p class="subtitle">나의 취향 기반 추천을 위한 정보를 관리하세요</p>

    <!-- 메인 수정 박스 -->
    <div class="login-box join-section">
        <h2>회원 정보 수정</h2>
        <p class="desc">아래 정보를 수정할 수 있습니다.</p>

        <!-- 실패 메시지 -->
        <c:if test="${not empty updateError}">
            <p style="color:#e11d48; font-weight:600; margin-bottom:12px; text-align:center;">
                ${updateError}
            </p>
        </c:if>

        <!-- 수정 Form -->
        <form class="form" action="<c:url value='/mypage/update'/>" method="post">
            <!-- 기존 ID 보유 -->
            <input type="hidden" name="oldId" value="${member.id}">

            <!-- 아이디 + 중복확인 -->
            <label>아이디</label>
            <div class="id-check-group">
                <input type="text" id="editId" name="id" value="${member.id}">
                <button type="button" id="editCheckIdBtn" class="btn-check">중복확인</button>
                <span id="editIdStateIcon" class="id-state"></span>
            </div>

            <!-- 이메일 -->
            <label>Email</label>
            <input type="email" name="email" value="${member.email}">

            <!-- 비밀번호 -->
            <label>새 비밀번호</label>
            <input type="password" name="pw" placeholder="변경하지 않으면 비워두세요">
            <label>비밀번호 확인</label>
            <input type="password" name="pw2" placeholder="재입력">

            <!-- 생년월일 -->
            <label>생년월일</label>
            <div class="birth-wrap">
                <select id="birthYear" name="birthYear" data-default="${birthYear}">
                    <option disabled>년</option>
                </select>
                <select id="birthMonth" name="birthMonth" data-default="${birthMonth}">
                    <option disabled>월</option>
                </select>
                <select id="birthDay" name="birthDay" data-default="${birthDay}">
                    <option disabled>일</option>
                </select>
            </div>

            <!-- 성별 -->
            <label>성별</label>
            <div class="gender-wrap">
                <label class="gender-item">
                    <input type="checkbox" name="gender" value="male"
                           <c:if test="${member.gender eq 'male'}">checked</c:if>> 남자
                </label>
                <label class="gender-item">
                    <input type="checkbox" name="gender" value="female"
                           <c:if test="${member.gender eq 'female'}">checked</c:if>> 여자
                </label>
                <label class="gender-item">
                    <input type="checkbox" name="gender" value="private"
                           <c:if test="${member.gender eq 'private'}">checked</c:if>> 비공개
                </label>
            </div>

            <button type="submit" class="primary-btn">수정하기</button>
            <button type="button" class="secondary-btn" onclick="history.back()">취소</button>
        </form>
    </div>

    <!-- 🔻 회원 탈퇴 버튼 (박스 바깥, 오른쪽 아래) -->
    <div class="delete-btn-wrap">
        <form action="<c:url value='/member/delete'/>" method="post" id="deleteForm">
            <button type="submit" class="delete-btn">회원 탈퇴</button>
        </form>
    </div>
</div>

<!-- 수정 완료 모달 -->
<div id="updateModal" class="modal-backdrop">
    <div class="modal-box">
        <h3 class="modal-title">회원정보 수정이 완료되었습니다.</h3>
        <p class="modal-text">계속 마이페이지를 수정하거나, 홈으로 돌아갈 수 있어요.</p>
        <div class="modal-actions">
            <button type="button" id="modalStay" class="modal-btn-secondary">취소</button>
            <button type="button" id="modalGoHome" class="modal-btn-primary">홈으로</button>
        </div>
    </div>
</div>

<!-- 🔻 회원탈퇴 모달 1: 정말 탈퇴하시겠습니까? -->
<div id="deleteModal1" class="modal-backdrop">
    <div class="modal-box">
        <h3 class="modal-title">정말 탈퇴하시겠습니까?</h3>
        <p class="modal-text">회원 탈퇴 시 계정은 비활성화되며, 다시 로그인할 수 없습니다.</p>
        <div class="modal-actions">
            <button type="button" id="delete1Cancel" class="modal-btn-secondary">취소</button>
            <button type="button" id="delete1Ok" class="modal-btn-primary">확인</button>
        </div>
    </div>
</div>

<!-- 🔻 회원탈퇴 모달 2: 이 작업은 되돌릴 수 없습니다. -->
<div id="deleteModal2" class="modal-backdrop">
    <div class="modal-box">
        <h3 class="modal-title">이 작업은 되돌릴 수 없습니다.</h3>
        <p class="modal-text">정말로 회원 탈퇴를 진행하시겠습니까?</p>
        <div class="modal-actions">
            <!-- ✅ 여기만 순서 반대로: 확인(왼쪽) / 취소(오른쪽) -->
            <button type="button" id="delete2Ok" class="modal-btn-primary">확인</button>
            <button type="button" id="delete2Cancel" class="modal-btn-secondary">취소</button>
        </div>
    </div>
</div>

<!-- JS -->
<script>
    /*============================== 생년월일 자동 불러오기 ==============================*/
    const yearSelect = document.getElementById('birthYear');
    const monthSelect = document.getElementById('birthMonth');
    const daySelect = document.getElementById('birthDay');

    if (yearSelect && monthSelect && daySelect) {
        const currentYear = new Date().getFullYear();
        for (let y = currentYear; y >= 1950; y--) yearSelect.add(new Option(y, y));
        for (let m = 1; m <= 12; m++) monthSelect.add(new Option(m, m));

        function fillDays() {
            const y = yearSelect.value;
            const m = monthSelect.value;
            daySelect.innerHTML = '<option disabled selected>일</option>';
            if (!y || !m) return;
            const lastDay = new Date(y, m, 0).getDate();
            for (let d = 1; d <= lastDay; d++) {
                daySelect.add(new Option(d, d));
            }
        }

        yearSelect.addEventListener('change', fillDays);
        monthSelect.addEventListener('change', fillDays);

        // 자동 선택: data-default에 있는 값을 선택
        const setVal = (sel, val) => {
            if (!val) return;
            [...sel.options].forEach(o => {
                if (o.value == val) o.selected = true;
            });
        };

        setVal(yearSelect, yearSelect.dataset.default);
        setVal(monthSelect, monthSelect.dataset.default);
        fillDays();
        setVal(daySelect, daySelect.dataset.default);
    }

    /*============================== 성별 단일 체크 ==============================*/
    (function() {
        const boxes = document.querySelectorAll('.gender-wrap input[type="checkbox"]');
        boxes.forEach(b => {
            b.addEventListener('change', (e) => {
                if (e.target.checked) {
                    boxes.forEach(o => {
                        if (o !== e.target) o.checked = false;
                    });
                }
            });
        });
    })();

    /*============================== 아이디 중복확인 ==============================*/
    (function(){
        const btn = document.getElementById('editCheckIdBtn');
        const input = document.getElementById('editId');
        const icon = document.getElementById('editIdStateIcon');
        if (!btn || !input) return;

        const clearState = () => {
            input.classList.remove('state-valid', 'state-invalid');
        };

        input.addEventListener('input', clearState);

        btn.addEventListener('click', async () => {
            const id = input.value.trim();
            if (!id) return;
            clearState();
            try {
                const url = '/check-id?id=' + encodeURIComponent(id);
                const res = await fetch(url);
                const txt = await res.text();
                if (txt === 'ok') {
                    input.classList.add('state-valid');
                } else {
                    input.classList.add('state-invalid');
                }
            } catch(e) {
                console.log(e);
            }
        });
    })();
</script>

<!-- ✅ 수정 성공 시 모달 자동 오픈 + 버튼 동작 -->
<c:if test="${not empty updateSuccess}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const modal = document.getElementById('updateModal');
            const btnHome = document.getElementById('modalGoHome');
            const btnStay = document.getElementById('modalStay');

            if (modal) {
                modal.style.display = 'flex';
            }
            if (btnHome) {
                btnHome.addEventListener('click', function () {
                    window.location.href = '<c:url value="/home"/>';
                });
            }
            if (btnStay) {
                btnStay.addEventListener('click', function () {
                    if (modal) modal.style.display = 'none';
                });
            }
        });
    </script>
</c:if>

<!-- 🔻 회원탈퇴 2단계 모달 로직 -->
<script>
    (function(){
        const deleteForm = document.getElementById("deleteForm");
        const modal1 = document.getElementById("deleteModal1");
        const modal2 = document.getElementById("deleteModal2");
        if (!deleteForm || !modal1 || !modal2) return;

        const open = (el) => { el.style.display = 'flex'; };
        const close = (el) => { el.style.display = 'none'; };

        const btn1Cancel = document.getElementById("delete1Cancel");
        const btn1Ok     = document.getElementById("delete1Ok");
        const btn2Cancel = document.getElementById("delete2Cancel");
        const btn2Ok     = document.getElementById("delete2Ok");

        deleteForm.addEventListener("submit", function(e){
            e.preventDefault();      // 기본 제출 막고
            open(modal1);           // 1번 모달 열기
        });

        if (btn1Cancel) {
            btn1Cancel.addEventListener("click", function(){
                close(modal1);
            });
        }
        if (btn1Ok) {
            btn1Ok.addEventListener("click", function(){
                close(modal1);
                open(modal2);       // 1 → 2번 모달로
            });
        }
        if (btn2Cancel) {
            btn2Cancel.addEventListener("click", function(){
                close(modal2);
            });
        }
        if (btn2Ok) {
            btn2Ok.addEventListener("click", function(){
                // 최종 확인 시 실제 폼 전송
                deleteForm.submit();
            });
        }
    })();
</script>

</body>
</html>
