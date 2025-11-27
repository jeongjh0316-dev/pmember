// 탭 전환
document.querySelectorAll('#tabs .tab').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('#tabs .tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const target = btn.getAttribute('data-target');
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    document.getElementById(target).classList.add('active');
  });
});

// 생년월일 자동 생성 (회원가입용)
const yearSelect  = document.getElementById('birthYear');
const monthSelect = document.getElementById('birthMonth');
const daySelect   = document.getElementById('birthDay');

if (yearSelect && monthSelect && daySelect) {
  const currentYear = new Date().getFullYear();

  for (let y = currentYear; y >= 1950; y--) {
    yearSelect.add(new Option(y, y));
  }
  for (let m = 1; m <= 12; m++) {
    monthSelect.add(new Option(m, m));
  }

  function fillDays() {
    const year = yearSelect.value;
    const month = monthSelect.value;
    daySelect.innerHTML = '<option value="" disabled selected>일</option>';
    if (!year || !month) return;
    const lastDay = new Date(year, month, 0).getDate();
    for (let d = 1; d <= lastDay; d++) {
      daySelect.add(new Option(d, d));
    }
  }
  yearSelect.addEventListener('change', fillDays);
  monthSelect.addEventListener('change', fillDays);

  // ▼ 서버가 준 data-default로 기존 입력값 복원
  (function applyBirthDefaults(){
    const setSelected = (sel, val) => {
      if (!val) return;
      const opt = Array.from(sel.options).find(o => String(o.value) === String(val));
      if (opt) opt.selected = true;
    };
    setSelected(yearSelect,  yearSelect?.dataset?.default);
    setSelected(monthSelect, monthSelect?.dataset?.default);
    fillDays(); // 월/연에 맞춰 일수 생성 후
    setSelected(daySelect,   daySelect?.dataset?.default);
  })();
}

// 🔹 아이디 찾기 탭용 생년월일 자동 생성
const findYearSelect  = document.getElementById('findBirthYear');
const findMonthSelect = document.getElementById('findBirthMonth');
const findDaySelect   = document.getElementById('findBirthDay');

if (findYearSelect && findMonthSelect && findDaySelect) {
  const currentYear = new Date().getFullYear();

  for (let y = currentYear; y >= 1950; y--) {
    findYearSelect.add(new Option(y, y));
  }
  for (let m = 1; m <= 12; m++) {
    findMonthSelect.add(new Option(m, m));
  }

  function fillFindDays() {
    const year = findYearSelect.value;
    const month = findMonthSelect.value;
    findDaySelect.innerHTML = '<option value="" disabled selected>일</option>';
    if (!year || !month) return;
    const lastDay = new Date(year, month, 0).getDate();
    for (let d = 1; d <= lastDay; d++) {
      findDaySelect.add(new Option(d, d));
    }
  }
  findYearSelect.addEventListener('change', fillFindDays);
  findMonthSelect.addEventListener('change', fillFindDays);
}

// 성별: 체크박스 단일 선택 강제
(function enforceSingleGender() {
  const boxes = document.querySelectorAll('.gender-wrap input[type="checkbox"]');
  if (!boxes.length) return;

  boxes.forEach(box => {
    box.addEventListener('change', (e) => {
      if (e.target.checked) {
        boxes.forEach(other => { if (other !== e.target) other.checked = false; });
      }
    });
  });

  // 로딩 시 중복 체크가 있었다면 하나만 남기기
  const checked = Array.from(boxes).filter(b => b.checked);
  if (checked.length > 1) checked.slice(1).forEach(b => b.checked = false);
})();

// 아이디 중복확인 (아이콘 + 테두리만 변경)
(function setupIdDuplicateCheck(){
  const btn  = document.getElementById('checkIdBtn');
  const input = document.getElementById('joinId');

  if(!btn || !input) return;

  const clearState = () => {
    input.classList.remove('state-valid','state-invalid');
  };

  input.addEventListener('input', clearState);

  btn.addEventListener('click', async () => {
    const id = input.value.trim();
    clearState();
    if(!id) { input.focus(); return; }

    try{
      const res = await fetch(`/check-id?id=${encodeURIComponent(id)}`);
      const txt = await res.text();
      if(txt === 'ok'){
        input.classList.add('state-valid');
      }else{
        input.classList.add('state-invalid');
      }
    }catch(e){
      // 실패 시 표시 없음
    }
  });
})();
