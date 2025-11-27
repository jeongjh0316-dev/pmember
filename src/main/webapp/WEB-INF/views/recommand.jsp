<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 메뉴 추천 설문</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <!-- ✅ home.jsp와 동일한 공통 CSS -->
  <link rel="stylesheet" href="<c:url value='/home.css'/>">
  <style>
    /* ✅ home.css 기반 + 이 페이지에서만 쓰는 추가 토큰 */
    :root{
      --ring:#ede9fe;
      --ring-strong:0 0 0 4px var(--ring);
    }

    /* ✅ 로그아웃 버튼: home.css 스타일 유지 + 줄바꿈 방지 */
    .logout-btn{
      white-space: nowrap;
    }

    /* ====== 이 페이지 전용 컴포넌트 ====== */
    .progress{
      width:100%;
      height:10px;
      background:#eee;
      border-radius:999px;
      overflow:hidden;
    }
    .bar{
      height:100%;
      width:0%;
      background:linear-gradient(90deg,var(--brand),#9a7bff);
      transition:width .25s;
    }

    .backline{
      display:flex;
      align-items:center;
      gap:12px;
      margin:10px 0 6px;
      color:#555;
    }

    .card{
      background:var(--panel);
      border:1px solid var(--border);
      border-radius:22px;
      box-shadow:var(--shadow);
      margin-top:18px;
      padding:28px;
    }
    .q-title{
      text-align:center;
      font-size:22px;
      font-weight:800;
      margin:10px 0 22px;
    }

    .opt{
      display:flex;
      align-items:center;
      gap:14px;
      width:100%;
      padding:18px 20px;
      margin:12px 0;
      border:1px solid var(--border);
      border-radius:16px;
      background:#fff;
      cursor:pointer;
      transition:.15s;
      font-size:18px;
      font-weight:600;
    }
    .opt:hover{
      transform:translateY(-1px);
      box-shadow:0 6px 16px rgba(0,0,0,.06);
    }
    .opt.selected{
      border-color:var(--brand);
      box-shadow:var(--ring-strong);
    }

    .actions{
      display:flex;
      justify-content:space-between;
      margin-top:22px;
    }
    .btn{
      border:0;
      border-radius:12px;
      padding:12px 16px;
      font-weight:700;
      cursor:pointer;
    }
    .btn-primary{
      background:var(--brand);
      color:#fff;
    }
    .btn-primary:disabled{
      opacity:.5;
      cursor:not-allowed;
    }
    .btn-prev{
      background:#fff;
      border:1px solid var(--border);
      box-shadow:var(--shadow);
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
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M3 10.5L12 3l9 7.5"></path>
          <path d="M5 10.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9.5"></path>
        </svg>
        <span class="label">홈</span>
      </a>
      <a class="qitem" href="<c:url value='/roulette'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M12 6v6l4 2"></path>
          <circle cx="12" cy="12" r="2"></circle>
        </svg>
        <span class="label">룰렛 돌리기</span>
      </a>
      <a class="qitem" href="<c:url value='/charts'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M3 20h18"></path>
          <path d="M7 20V9"></path>
          <path d="M12 20V4"></path>
          <path d="M17 20v-6"></path>
        </svg>
        <span class="label">인기차트</span>
      </a>
      <a class="qitem" href="<c:url value='/mypage'/>">
        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="8" r="4"></circle>
          <path d="M4 21a8 8 0 0 1 16 0"></path>
        </svg>
        <span class="label">마이페이지</span>
      </a>
    </nav>
  </div>

  <br>

  <div class="backline">
    <div id="goBack" style="cursor:pointer;">← 뒤로</div>
    <!-- 🔥 질문 1 / 6 칩 제거 -->
    <div style="margin-left:auto;font-weight:700;"><span id="percent">0</span>%</div>
  </div>
  <div class="progress"><div class="bar" id="bar"></div></div>

  <section class="card">
    <h2 class="q-title" id="qTitle"></h2>
    <div id="options"></div>

    <div class="actions">
      <button class="btn btn-prev" id="prevBtn">이전</button>
      <button class="btn btn-primary" id="submitBtn" style="display:none" disabled>추천받기</button>
    </div>
  </section>
</main>

<script>
  const QUESTIONS = [
    { key:"cuisine",         title:"오늘 땡기는 요리는?",            options:["한식","일식","중식","양식"] },
    { key:"staple",          title:"주식은 어떤게 좋으세요?",        options:["밥","빵","면","기타"] },
    { key:"main_ingredient", title:"반찬 메뉴는 어떤게 좋으세요?",    options:["육류","해산물","채소","상관없음"] },
    { key:"temp",            title:"온도는 어느정도가 좋으세요?",    options:["차가운","따뜻한"] },
    { key:"cook",            title:"지금은 어떤 느낌이 더 땡기세요?", options:["튀김","구이볶음","국탕찌개","찜","상관없음"] },
    { key:"spicy",           title:"맵기는 어느정도가 좋으세요?",    options:["매운","안매운"] }
  ];

  let step = 0;
  let skippedCook = false; // '차가운' 선택 시 cook 문항 스킵 여부
  const answers = {};

  const qTitle = document.getElementById("qTitle");
  const optsWrap = document.getElementById("options");
  const percent = document.getElementById("percent");
  const bar = document.getElementById("bar");
  const prevBtn = document.getElementById("prevBtn");
  const submitBtn = document.getElementById("submitBtn");
  const goBack = document.getElementById("goBack");

  const idxOf = key => QUESTIONS.findIndex(q=>q.key===key);
  const lastIndex = () => QUESTIONS.length - 1;

  function render(){
    const q = QUESTIONS[step];

    // 🔥 질문 N / 전체 표시 제거 (percent만 유지)
    const pct = Math.round(((step + 1) / QUESTIONS.length) * 100);
    percent.textContent = pct;
    bar.style.width = pct + "%";

    qTitle.textContent = q.title;
    optsWrap.innerHTML = "";

    q.options.forEach(opt=>{
      const btn=document.createElement("button");
      btn.type="button";
      btn.className="opt";
      btn.textContent = opt;
      btn.onclick=()=>selectOption(q.key,opt);
      if(answers[q.key]===opt) btn.classList.add("selected");
      optsWrap.appendChild(btn);
    });

    prevBtn.disabled = (step===0);
    submitBtn.style.display = (step===lastIndex())?"inline-block":"none";
    submitBtn.disabled = !answers[q.key];
  }

  function jumpToSpicyFromCold(){
    step = idxOf("spicy");
    skippedCook = true;
  }

  function selectOption(key,value){
    answers[key]=value;

    if(key==="temp"){
      if(value==="차가운"){
        jumpToSpicyFromCold();
        render();
        return;
      } else {
        skippedCook = false;
      }
    }

    if(step<lastIndex()) step++;
    render();
  }

  prevBtn.onclick=()=>{
    if(step===idxOf("spicy") && skippedCook){
      step = idxOf("temp");
      render();
      return;
    }
    if(step>0){ step--; render(); }
  };

  submitBtn.onclick=()=>{
    percent.textContent = "100";
    bar.style.width = "100%";

    localStorage.setItem("omg_survey", JSON.stringify(answers));

    const mapping = {
      category:         answers["cuisine"],
      main_yn:          answers["staple"],
      side_ingredients: answers["main_ingredient"],
      temp:             answers["temp"],
      recipe:           answers["cook"],
      hot_level:        answers["spicy"]
    };

    const form = document.createElement("form");
    form.method = "post";
    form.action = "<c:url value='/recommend'/>";

    Object.keys(mapping).forEach(key => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = key;
      input.value = mapping[key];
      form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
  };

  goBack.onclick=()=>{
    history.length>1 ? history.back() : location.href="<c:url value='/home'/>";
  };

  render();
</script>

</body>
</html>
