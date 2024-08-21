<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userID=null;
	if(session.getAttribute("id") !=null){
		userID = (String) session.getAttribute("id");
	}
%>
<%
    // 로그인 상태 확인
    if (userID == null) {
%>
        <script type="text/javascript">
            alert("로그인 후 이용가능한 컨텐츠입니다.");
            window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        </script>
<%
        return; // JSP 페이지 실행 종료
    }

    // 로그인 상태인 경우 세션에 사용자 ID를 다시 설정 (필요에 따라)
    session.setAttribute("id", userID);
   
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지(로그인 후)</title>
<link rel="stylesheet" href="css/main_styles.css">
<script src="js/jquery-3.7.1.min.js"></script>
</head>
<body>
 <%@ include file="header_login.jsp" %> 
 <!-- 헤더 부분 -->
 <%
    String nickname = (String) session.getAttribute("nickname");
%>       
<div class="intro-section">
            <div class="divider"></div>
            <div class="intro-text">
                <div class="welcome">
                <% if (nickname != null) { %>
                어서오세요! <%= nickname %>님!
                <%= nickname %>님의 영원한 친구 SU-mate입니다!
            	<% } else { %>
                안녕하세요! 여러분들의 영원한 친구 SU-mate입니다!
           		 <% } %>
                </div>
                <div class="description">지금 바로 SU-mate와 함께 나에게 맞는 친구를 찾아보세요</div>
                
            </div>
  </div>

<!-- 헤더 부분 -->

<div class="roommate-list">
                <div class="roommate-item" id="roommate-item">
                    <div class="roommate-image"></div>
                    <div class="roommate-details">
                        <div class="roommate-name">기숙사 룸메이트 매칭</div>
                        <div class="roommate-bio">완벽한 룸메이트를 찾고 계신가요? 룸메이트에서 당신과 잘 맞는 친구를 찾아보세요!</div>
                    </div>
                </div>

                <div class="dusata-item" id="dusata-item">
                    <div class="dusata-image"></div>
                    <div class="dusata-details">
                        <div class="dusata-name">두유는 사랑을 타고(두사타)</div>
                        <div class="dusata-bio">캠퍼스에서 특별한 인연을 찾고 싶으신가요? 이젠 두사타도 온라인으로!</div>
                    </div>
                </div>

                <div class="carpool-item" id="carpool-item">
                    <div class="carpool-image"></div>
                    <div class="carpool-details">
                        <div class="carpool-name">카풀</div>
                        <div class="carpool-bio">같은 방향으로 가는 친구를 찾고 있나요? 카풀메이트에서 함께 이동할 친구를 구하세요!</div>
                    </div>
                </div>
            </div>
            <div class="divider"></div>
        <!--여기까지는 그림과 간단한 설명만 들어갑니다-->
               <div class="feature-content" id="roommate-desc">
            <div class="feature-image">
                <img src="your-image-path.jpg" alt="Feature Image" class="responsive-image">
            </div>
            <div class="feature-description">
                <h2>기숙사 룸메이트 매칭 소개</h2>
               	<p>한 학기를 같이 지내는데 아무나 구하시나요? 룸메이트에서 당신과 잘 맞는 친구를 찾아보세요. 편안하고 즐거운 기숙사 생활이 만족스러운 한 학기를 시작입니다.</p>
                <p>지금 바로 SU-mate와 함께 여러분의 룸 메이트를 찾아보세요!</p>
            </div>
        </div> 
        <div class="divider"></div>
        <div class="feature-content" id="dusata-desc">
            <div class="feature-image">
                <img src="your-image-path.jpg" alt="Feature Image" class="responsive-image">
            </div>
            <div class="feature-description">
                <h2>두유는 사랑을 타고(두사타) 소개</h2>
           	    <p>낭만적인 캠퍼스 생활을 이대로 보내실건가요? 러브메이트에서 당신의 이상형을 만나보세요. 대화를 통해 더 깊고 성공적인 두사타!</p>
                <p>지금 바로 SU-mate와 함께 여러분의 사랑을 찾아보세요!</p>
            </div>
        </div>
        <div class="divider"></div>
        <div class="feature-content" id="carpool-desc">
            <div class="feature-image">
                <img src="your-image-path.jpg" alt="Feature Image" class="responsive-image">
            </div>
            <div class="feature-description">
                <h2>카풀 매칭 소개</h2>
                <p>혼자 등교하기 비효율적이고 심심하신가요? 카풀메이트에서 함께 이동할 친구를 구하세요. 교통비도 절약하고, 환경도 보호하세요!</p>
                <p>지금 바로 SU-mate와 함께 여러분의 카풀 메이트를 찾아보세요!</p>
            </div>
        </div>
    </div>
    
    <%
			if(userID != null){
				
		%>
		 <script type="text/javascript">
		 	$(document).ready(function(){
				getUnread();
		 		getInfiniteUnread();
		 		chatBoxFunction();
		 	});
		 </script>
		<%
			}
		%>
    

    <script src="js/main_page.js"></script>
   

<%@ include file="footer.jsp" %> <!-- 풋터 부분 -->

    <script>
    function getUnread(){
    	var userID = '<%= userID %>';
        console.log("userID in getUnread: " + userID);
    	$.ajax({
    		type: "POST",
    		url: "./chatUnread",
    		data: {
    			userID :encodeURIComponent('<%= userID%>'),
    		},
    		success: function(result){
    			if(result >=1){
    				console.log("result(com)="+ result);
    				showUnread(result);
    			} else{
    				console.log("result(else)="+ result);
    				showUnread('');
    			}
    	       }
    	});
    }
    function getInfiniteUnread(){
    	setInterval(function(){
    		getUnread();
    	}, 4000)
    }
    function showUnread(result){
    	 var unreadElement = $('#unread');
    	    if(result && result.trim() !== "") {
    	        unreadElement.html(result);
    	        unreadElement.show(); 
    	    } else {
    	        unreadElement.hide(); 
    	    }
    }
    
     
        document.getElementById('title').addEventListener('click', () => {
            window.location.href = 'mainPage.jsp';
        });
    </script>
</body>
</body>
</html>