<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>오늘 뭐먹게 | 아이디 찾기 결과</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">

  <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{
      font-family:'Noto Sans KR',sans-serif;
      background:#fff8f2;
      color:#111827;
    }
    .shell{
      min-height:100vh;
      display:flex;
      flex-direction:column;
      align-items:center;
      padding:24px;
    }

    .global-header{
      text-align:center;
      margin-bottom:26px;
      margin-top:10px;
    }
    .global-title{
      font-size:2rem;
      color:#e86c29;
      font-weight:700;
      margin-bottom:8px;
      letter-spacing:-0.5px;
    }
    .global-sub{
      color:#555;
      font-size:0.95rem;
      margin-bottom:32px;
    }

    .card{
      width:100%;
      max-width:460px;
      background:#fff;
      border-radius:24px;
      padding:36px 30px 40px;
      box-shadow:0 18px 45px rgba(15,23,42,.12);
    }

    .title{
      font-size:26px;
      font-weight:900;
      margin-bottom:6px;
    }
    .sub{
      font-size:13px;
      color:#6b7280;
      margin-bottom:28px;
      line-height:1.5;
    }

    .result-box{
      background:#fff8df;
      border-radius:18px;
      padding:16px 18px;
      margin-bottom:16px;
    }

    .label{
      font-size:15px;
      font-weight:700;
      color:#ea580c;
      margin-bottom:20px;
    }

    .value{
      background:#fff;
      padding:10px 12px;
      border-radius:20px;
      font-size:18px;
      font-weight:700;
      display:flex;
      align-items:center;
      gap:6px;
      font-family:ui-monospace, Consolas, "Courier New", monospace;
    }

    .dot{
      width:7px;height:7px;border-radius:50%;
      background:#f97316;
    }

    .help{
      font-size:12px;
      color:#6b7280;
      line-height:1.5;
      margin-bottom:26px;
    }

    .btn-row{
      display:flex;
      gap:10px;
    }

    .btn{
      flex:1;
      border:none;
      border-radius:999px;
      padding:12px 0;
      font-size:14px;
      font-weight:600;
      cursor:pointer;
      transition:.18s ease;
    }

    .btn-white{
      background:#ffffff;
      color:#4b5563;
      border:1px solid #e5e7eb;
    }
    .btn-white:hover{
      background:#f3f4f6;
    }

    .btn-black{
      background:#111827;
      color:#fff;
      box-shadow:0 8px 18px rgba(17,24,39,.25);
    }
    .btn-black:hover{
      transform:translateY(-1px);
      box-shadow:0 12px 26px rgba(17,24,39,.35);
    }

  </style>
</head>
<body>

<div class="shell">

  <div class="global-header">
    <div class="global-title">오늘 뭐먹게?</div>
    <div class="global-sub">당신의 취향을 분석하여 완벽한 메뉴를 추천해드립니다</div>
  </div>

  <div class="card">

    <h1 class="title">아이디 찾기</h1>
    <p class="sub">회원가입 시 입력한 정보와 일치하는 계정의 아이디입니다.</p>

    <div class="result-box">
      <p class="label">조회된 아이디</p>
      <div class="value">
        <span class="dot"></span>
        ${foundId}
      </div>
    </div>

    <p class="help">
      보안을 위해 일부 문자는 마스킹 처리될 수 있으며,<br>
      필요 시 로그인 후 마이페이지에서 정보를 변경할 수 있습니다.
    </p>

    <div class="btn-row">
      <!-- 👉 비밀번호 찾기 탭으로 이동 -->
      <button class="btn btn-white"
              onclick="location.href='/login?tab=find&focus=pw'">
        비밀번호 찾기
      </button>

      <button class="btn btn-black"
              onclick="location.href='/login'">
        로그인하러 가기
      </button>
    </div>

  </div>
</div>

</body>
</html>
