document.addEventListener('DOMContentLoaded', function() {
    selectGender('male'); // 페이지 로드 시 기본 남자 버튼 선택
});

function selectGender(selectedGender) {
    var maleBtn = document.getElementById('maleBtn');
    var femaleBtn = document.getElementById('femaleBtn');

    // Get the data-gender attribute values
    var maleGender = maleBtn.getAttribute('data-gender');
    var femaleGender = femaleBtn.getAttribute('data-gender');

    // Set the selectedGender based on the gender parameter
    var selectedGender;
    if (gender === maleGender) {
        selectedGender = maleGender;
        maleBtn.classList.add('selected');
        femaleBtn.classList.remove('selected');
    } else if (gender === femaleGender) {
        selectedGender = femaleGender;
        maleBtn.classList.remove('selected');
        femaleBtn.classList.add('selected');
	}	else {
	        alert('잘못된 접근입니다.');
	        window.location.href = 'main.jsp';
	        return; // 이후 코드를 실행하지 않도록 함수 종료
    }

    console.log("Selected Gender: " + selectedGender); // For debugging
}