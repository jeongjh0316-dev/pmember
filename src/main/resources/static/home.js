// src/main/resources/static/home.js
document.addEventListener('DOMContentLoaded', () => {
  const items = document.querySelectorAll('.quick-nav .qitem');
  const currentPath = location.pathname;

  // 현재 URL에 맞는 active 클래스 설정
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

  // 카드 호버 애니메이션
  const cards = document.querySelectorAll('.category-card');
  cards.forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.transform = 'translateY(-6px)';
      card.style.boxShadow = '0 12px 28px rgba(0, 0, 0, .12)';
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = '';
      card.style.boxShadow = '0 4px 12px rgba(0, 0, 0, .06)';
    });
  });
});