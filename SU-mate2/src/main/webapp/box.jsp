<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<!DOCTYPE html>
<html>
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
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="css/main_styles.css">
<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	function getUnread(){
		$.ajax({
			type: "POST",
			url: "./chatUnread",
			data: {
				userID :encodeURIComponent('<%= userID%>'),
			},
			success: function(result){
				if(result >=1){
					showUnread(result);
				} else{
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
		$('#unread').html(result);
	}
	function chatBoxFunction() {
	    var userID = '<%= userID %>';
	    $.ajax({
	        type: "POST",
	        url: "./chatBox",
	        data: {
	            userID: encodeURIComponent(userID),
	        },
	        success: function(data) {
	            console.log("data=" + data); // 응답 데이터 확인
	            if (data == "") return;
	            $('#boxTable').html('');
	            var parsed = JSON.parse(data);
	            var result = parsed.result;

	            // 각 메시지에서 삭제 플래그를 확인하여 표시
	            for (var i = 0; i < result.length; i++) {
	                var fromID = result[i][0].value;
	                var toID = result[i][1].value;
	                var chatContent = result[i][2].value;
	                var chatTime = result[i][3].value;
	                var isDeletedByFromID = result[i][5] ? result[i][5].value : false;
	                var isDeletedByToID = result[i][6] ? result[i][6].value : false;

	                // 현재 사용자가 fromID인 경우 isDeletedByFromID 체크
	                // 현재 사용자가 toID인 경우 isDeletedByToID 체크
	                if ((userID === fromID && isDeletedByFromID === "true") || 
	                    (userID === toID && isDeletedByToID === "true")) {
	                    continue; // 삭제된 채팅방은 표시하지 않음
	                }
	                
	                // 적절하게 addBox 함수에 필요한 값을 전달
	                addBox(fromID, toID, chatContent, chatTime);
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error("Error during chatBoxFunction: " + error);
	        }
	    });
	}
	function addBox(lastID, toID, chatContent, chatTime){
	    $.ajax({
	        type: "GET",
	        url: "getChatNickname.jsp",
	        data: { toID: toID },
	        success: function(response){
	            var nickname = JSON.parse(response).nickname;
	            console.log("Adding box for toID:", toID);
	            $('#boxTable').append('<tr id="chat-' + toID + '">' +
	                '<td style="width: 150px;"><h5>' + nickname + '</h5></td>' +
	                '<td style="position: relative;">' +
	                    '<div style="position: absolute; top: 5px; right: 5px;">' +
	                        '<span class="delete-chat" onclick="deleteChat(\'' + toID + '\'); event.stopPropagation();">&times;</span>' +
	                    '</div>' +
	                    '<h5>' + chatContent + '</h5>' +
	                    '<div style="position: absolute; bottom: 5px; right: 5px;">' +
	                        '<span>' + chatTime + '</span>' +
	                    '</div>' +
	                '</td>' +
	                '</tr>');
	            
	            // 채팅방 클릭 이벤트
	            $('#chat-' + toID).click(function() {
	                location.href = 'chat.jsp?toID=' + encodeURIComponent(toID);
	            });
	        },
	        error: function(){
	            console.log("Error retrieving nickname for toID:", toID);
	        }
	    });
	}

	function deleteChat(toID) {
	    if (confirm("이 채팅방을 삭제하시겠습니까?")) {
	        $.ajax({
	            type: "POST",
	            url: "deleteChat.jsp", // 서버에서 채팅방 삭제를 처리할 JSP
	            data: { 
	                userID: '<%= userID %>',
	                toID: toID
	            },
	            success: function(response) {
	            	console.log("Server response: " + response); // 서버 응답 로그
	                if(response.trim() === "success") {
	                    $('#chat-' + toID).remove(); // 화면에서 채팅방 제거
	                   	alert("채팅방이 성공적으로 삭제되었습니다.");
	                } else {
	                    alert("채팅방 삭제에 실패했습니다.");
	                }
	            },
	            error: function() {
	                alert("채팅방 삭제 중 오류가 발생했습니다.");
	            }
	        });
	    }
	}

	// CSS 스타일 추가
	$(document).ready(function() {
	    $('<style>')
	        .text(
	            '.delete-chat { ' +
	            '    cursor: pointer;' +
	            '    color: #ff0000;' +
	            '    font-weight: bold;' +
	            '    font-size: 1.2em;' +
	            '    margin-right: 5px;' +
	            '}' +
	            '.delete-chat:hover {' +
	            '    color: #cc0000;' +
	            '}'
	        )
	        .appendTo('head');
	});
	
	function getInfiniteBox(){
		setInterval(function(){
			chatBoxFunction();
		}, 3000);
	}
</script>
<title>추가기능 채팅 구현</title>
</head>
<body>
		<%@ include file="header_login.jsp" %> 
		<div class="container">
			<table class="table" style="margin: 0 auto;">
				<thead>
					<tr>
						<th><h4>주고받은 메시지 목록</h4></th>
					</tr>
				</thead>
				<div style="overflow-y: quto; width: 100%; max-height: 450px;">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
						<tbody id="boxTable">
						</tbody>
					</table>
				</div>
			</table>
		</div>
		<%
			if(userID != null){
				
		%>
		 <script type="text/javascript">
		 	$(document).ready(function(){
				getUnread();
		 		getInfiniteUnread();
		 		chatBoxFunction();
		 		getInfiniteBox();
		 	});
		 </script>
		<%
			}
		%>
 <script src="js/main_page.js"></script>
   

<%@ include file="footer.jsp" %> <!-- 풋터 부분 -->

    <script>
        // JavaScript 코드: 'SU-mate' 제목 클릭 시 mainPage.jsp로 이동
        document.getElementById('title').addEventListener('click', () => {
            window.location.href = 'mainPage.jsp';
        });
    </script>
</body>
</html>