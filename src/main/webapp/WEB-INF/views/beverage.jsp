<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>오늘 뭐먹게 | 음료 추천 설문</title>
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
    <!-- 🔥 질문 1 / N 칩 제거 → 진행률만 표시 -->
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
  // FEATURES_TO_USE = ['sweetness', 'style', 'milk_base', 'fruit_yn', 'temperature']
  const QUESTIONS = [
    {
      key: "sweetness",
      title: "오늘은 어느 정도로 달게 마실까요?",
      options: [
        { label: "달게",   value: "SWEETENED" },
        { label: "안 달게", value: "UNSWEETENED" }
      ]
    },
    {
      key: "style",
      title: "어떤 종류의 음료가 가장 끌리나요?",
      options: [
        { label: "커피", value: "COFFEE" },
        { label: "차(TEA)", value: "TEA" },
        { label: "스무디", value: "SMOOTHIE" },
        { label: "밀크티·티라테", value: "NOCOFFEELATTE" },
        { label: "에이드", value: "ADE" },
        // 🔥 추가: 스타일 상관없음 → 머신러닝에 "None" 전달 (가중치 0)
        { label: "상관없음", value: "None" }
      ]
    },
    {
      key: "milk_base",
      title: "우유는 어떻게 드시고 싶나요?",
      options: [
        { label: "우유가 들어간 음료", value: "MILK" },
        { label: "우유가 안 들어간 음료", value: "NOMILK" }
      ]
    },
    {
      key: "fruit_yn",
      title: "과일이 들어가는 음료는 어떤가요?",
      options: [
        { label: "과일 들어간 게 좋아요", value: "fruitY" },
        { label: "과일 안 들어간 게 좋아요", value: "fruitN" }
      ]
    },
    {
      key: "temperature",
      title: "온도는 어떻게 마실까요?",
      options: [
        { label: "차갑게", value: "COLD" },
        { label: "따뜻하게", value: "HOT" }
      ]
    }
  ];

  let step = 0;          // 0~4
  const answers = {};    // { sweetness: "...", ... }

  const qTitle   = document.getElementById("qTitle");
  const optsWrap = document.getElementById("options");
  const percent  = document.getElementById("percent");
  const bar      = document.getElementById("bar");
  const prevBtn  = document.getElementById("prevBtn");
  const submitBtn= document.getElementById("submitBtn");
  const goBack   = document.getElementById("goBack");

  const lastIndex = () => QUESTIONS.length - 1; // 4

  function getStyleValue(){
    return answers["style"];
  }

  // 총 질문 수 (스타일에 따라 4 or 5)
  function getTotalSteps(){
    const styleVal = getStyleValue();
    if (styleVal === "COFFEE" || styleVal === "NOCOFFEELATTE") {
      return 4;
    }
    return 5;
  }

  // 현재 step 이 사용자에게 몇 번째 질문으로 보일지 계산
  function getDisplayStepNumber(){
    const styleVal = getStyleValue();

    if (styleVal === "COFFEE") {
      // 방문 순서: 0(당도)→1(스타일)→2(우유)→4(온도)
      if (step === 0) return 1;
      if (step === 1) return 2;
      if (step === 2) return 3;
      if (step === 4) return 4;
    } else if (styleVal === "NOCOFFEELATTE") {
      // 방문 순서: 0(당도)→1(스타일)→3(과일)→4(온도)
      if (step === 0) return 1;
      if (step === 1) return 2;
      if (step === 3) return 3;
      if (step === 4) return 4;
    }

    // 그 외 스타일 or 아직 스타일 선택 전 ("None" 포함)
    return step + 1;
  }

  // 다음 step 계산
  function getNextStep(current){
    const styleVal = getStyleValue();

    // 스타일에서 다음으로 이동
    if (current === 1) {
      if (styleVal === "NOCOFFEELATTE") {
        // 2(우유) 스킵 → 3(과일)
        return 3;
      }
      // 그 외: 2(우유)로 (COFFEE, ADE, TEA, SMOOTHIE, None 등)
      return 2;
    }

    // 우유에서 다음으로 이동
    if (current === 2) {
      if (styleVal === "COFFEE") {
        // 커피면 과일 질문 스킵 → 4(온도)
        if (!answers["fruit_yn"]) {
          answers["fruit_yn"] = "fruitN";
        }
        return 4;
      }
      // 그 외: 3(과일)로
      return 3;
    }

    // 나머지는 기본적으로 +1
    return Math.min(current + 1, lastIndex());
  }

  // 이전 step 계산
  function getPrevStep(current){
    const styleVal = getStyleValue();

    // 과일에서 이전으로
    if (current === 3 && styleVal === "NOCOFFEELATTE") {
      // 3(과일) ← 1(스타일)
      return 1;
    }

    // 온도에서 이전으로
    if (current === 4) {
      if (styleVal === "COFFEE") {
        // 4(온도) ← 2(우유)
        return 2;
      } else if (styleVal === "NOCOFFEELATTE") {
        // 4(온도) ← 3(과일)
        return 3;
      } else {
        // 일반: 4(온도) ← 3(과일)
        return 3;
      }
    }

    return Math.max(current - 1, 0);
  }

  function render(){
    const q = QUESTIONS[step];

    // 🔥 질문 N / 전체 텍스트는 제거, 진행률만 유지
    const displayStep = getDisplayStepNumber();
    const totalSteps  = getTotalSteps();
    const pct = Math.round((displayStep / totalSteps) * 100);
    percent.textContent = pct;
    bar.style.width = pct + "%";

    qTitle.textContent = q.title;
    optsWrap.innerHTML = "";

    q.options.forEach(opt => {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "opt";
      btn.textContent = opt.label;
      btn.onclick = () => selectOption(q.key, opt.value);
      if (answers[q.key] === opt.value) btn.classList.add("selected");
      optsWrap.appendChild(btn);
    });

    prevBtn.disabled = (step === 0);
    submitBtn.style.display = (step === lastIndex()) ? "inline-block" : "none";
    submitBtn.disabled = !answers[q.key];
  }

  function selectOption(key, value){
    const prevStyle = answers["style"];
    answers[key] = value;

    // 스타일 선택 로직
    if (key === "style") {
      const styleVal = value;

      // 1) 커피면 과일 질문 스킵 → 과일 없음으로 고정
      if (styleVal === "COFFEE") {
        answers["fruit_yn"] = "fruitN";
      } else if (prevStyle === "COFFEE" && styleVal !== "COFFEE") {
        // 커피였다가 다른 스타일로 바꾸면 과일은 다시 선택 받도록 초기화
        delete answers["fruit_yn"];
      }

      // 2) 밀크티·티라테면 우유는 무조건 MILK로 자동 세팅
      if (styleVal === "NOCOFFEELATTE") {
        answers["milk_base"] = "MILK";
      }
      // 3) 스타일을 "상관없음(None)"으로 바꾸는 경우:
      //    - 별도 예외 필요 없음. 일반 흐름(우유→과일→온도) 그대로 진행.
      //    - Flask 쪽에서는 style="None" → 가중치 0으로 처리됨.
    }

    if (step < lastIndex()) {
      step = getNextStep(step);
    }
    render();
  }

  prevBtn.onclick = () => {
    if (step > 0) {
      step = getPrevStep(step);
      render();
    }
  };

  submitBtn.onclick = () => {
    // 진행도 100%
    percent.textContent = "100";
    bar.style.width = "100%";

    localStorage.setItem("omg_beverage_survey", JSON.stringify(answers));

    const form = document.createElement("form");
    form.method = "post";
    form.action = "<c:url value='/beverage-result'/>";

    const KEYS = ["sweetness", "style", "milk_base", "fruit_yn", "temperature"];
    for (const key of KEYS) {
      if (!answers[key]) {
        alert("설문 값이 누락되었습니다. 다시 선택해 주세요.");
        return;
      }
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = key;
      input.value = answers[key];
      form.appendChild(input);
    }

    document.body.appendChild(form);
    form.submit();
  };

  goBack.onclick = () => {
    if (history.length > 1) {
      history.back();
    } else {
      location.href = "<c:url value='/home'/>";
    }
  };

  // 첫 렌더링
  render();
</script>

</body>
</html>
