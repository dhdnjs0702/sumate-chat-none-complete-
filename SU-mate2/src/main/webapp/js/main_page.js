document.addEventListener('DOMContentLoaded', () => {
    // 1. 메뉴 항목에 활성화 상태 표시
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', () => {
            menuItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');
        });
    });

    // 2. '시작하기' 버튼 클릭 시 알림 창 + 로그인 화면으로 이동
    const startButton = document.querySelector('.get-started-button');
    startButton.addEventListener('click', () => {
        alert('회원가입 또는 로그인 후 이용하실 수 있습니다.');
        window.location.href = 'login.html'; // 페이지 이동
    });

    // 3. 이미지 로드 시 로딩 애니메이션
    const images = document.querySelectorAll('.responsive-image');
    images.forEach(img => {
        img.style.opacity = 0;
        img.addEventListener('load', () => {
            img.style.transition = 'opacity 0.5s';
            img.style.opacity = 1;
        });
    });

    // 4. 윈도우 스크롤 시 헤더 고정
    const header = document.querySelector('.header');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('sticky');
        } else {
            header.classList.remove('sticky');
        }
    });
	
	const title = document.querySelector('.title');
	   title.addEventListener('click', () => {
	       window.location.href = 'main_page.html'; // main_page.html로 이동
	   });
});

document.addEventListener('DOMContentLoaded', () => {
    // 각 서비스 항목을 클릭하면 해당 설명으로 이동
    document.getElementById('roommate-item').addEventListener('click', () => {
        document.getElementById('roommate-desc').scrollIntoView({ behavior: 'smooth' });
    });

    document.getElementById('dusata-item').addEventListener('click', () => {
        document.getElementById('dusata-desc').scrollIntoView({ behavior: 'smooth' });
    });

    document.getElementById('mealmate-item').addEventListener('click', () => {
        document.getElementById('mealmate-desc').scrollIntoView({ behavior: 'smooth' });
    });

    document.getElementById('carpool-item').addEventListener('click', () => {
        document.getElementById('carpool-desc').scrollIntoView({ behavior: 'smooth' });
    });
});