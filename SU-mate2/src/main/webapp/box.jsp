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
	
	var lastUpdateTime = {};

	
	function chatBoxFunction() {
	    var userID = '<%= userID %>';
	    $.ajax({
	        type: "POST",
	        url: "./chatBox",
	        data: {
	            userID: encodeURIComponent(userID),
	        },
	        success: function(data) {
	            if (data == "") return;
	            var parsed = JSON.parse(data);
	            var result = parsed.result;

	            $.ajax({
	                type: "POST",
	                url: "getUnreadCounts.jsp",
	                data: { userID: userID },
	                dataType: 'json',
	                success: function(unreadCounts) {
	                    var chatList = [];

	                    for (var i = 0; i < result.length; i++) {
	                        var fromID = result[i][0].value;
	                        var toID = result[i][1].value;
	                        var chatContent = result[i][2].value;
	                        var chatTime = result[i][3].value;
	                        var isDeletedByFromID = result[i][5] ? result[i][5].value : false;
	                        var isDeletedByToID = result[i][6] ? result[i][6].value : false;

	                        if ((userID === fromID && isDeletedByFromID === "true") || 
	                            (userID === toID && isDeletedByToID === "true")) {
	                            continue;
	                        }

	                        var unreadCount = unreadCounts[fromID] || 0;
	                        var chatID = 'chat-' + toID;

	                        chatList.push({
	                            fromID: fromID,
	                            toID: toID,
	                            chatContent: chatContent,
	                            chatTime: chatTime,
	                            unreadCount: unreadCount
	                        });
	                    }
	                    
	                 // 디버깅용 콘솔 로그
	                    console.log("Before sorting:", chatList);

	                    // 최신 메시지 시간 기준으로 정렬
	                    chatList.sort(function(a, b) {
	                        return new Date(b.chatTime) - new Date(a.chatTime);
	                    });

	                 // 정렬 후 상태를 로그로 확인
	                    console.log("After sorting:", chatList);
	                    
	                    // 정렬된 채팅방을 UI에 추가 또는 업데이트
	                    $('#boxTable').empty(); // 기존 채팅방 리스트 초기화
	                    for (var i = 0; i < chatList.length; i++) {
	                        updateOrAddBox(chatList[i].fromID, chatList[i].toID, chatList[i].chatContent, chatList[i].chatTime, chatList[i].unreadCount);
	                    }
	                },
	                error: function(jqXHR, textStatus, errorThrown) {
	                    console.error("Error fetching unread counts:", textStatus, errorThrown);
	                }
	            });
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.error("Error fetching chat box:", textStatus, errorThrown);
	        }
	    });
	}

	function updateOrAddBox(fromID, toID, chatContent, chatTime, unreadCount) {
	    var chatID = 'chat-' + toID;
	    var $existingChat = $('#' + chatID);

	    if ($existingChat.length) {
	        // 기존 채팅방 업데이트
	        $existingChat.find('.chat-content').text(chatContent);
	        $existingChat.find('.chat-time').text(chatTime);
	        var $unreadBadge = $existingChat.find('.unread-badge');
	        if (unreadCount > 0) {
	            if ($unreadBadge.length) {
	                $unreadBadge.text(unreadCount);
	            } else {
	                $existingChat.find('h5').first().append('<span class="badge bg-danger unread-badge">' + unreadCount + '</span>');
	            }
	        } else {
	            $unreadBadge.remove();
	        }
	    } else {
	        // 새로운 채팅방 추가
	        addBox(fromID, toID, chatContent, chatTime, unreadCount);
	    }
	}
	function updateBox(fromID, toID, chatContent, chatTime, unreadCount) {
	    var chatID = 'chat-' + toID;
	    var $existingChat = $('#' + chatID);
	    
	    if ($existingChat.length) {
	        // 기존 채팅방 업데이트
	        if (new Date(chatTime) > new Date(lastUpdateTime[chatID] || 0)) {
	            $existingChat.find('.chat-content').text(chatContent);
	            $existingChat.find('.chat-time').text(chatTime);
	            $existingChat.find('.unread-badge').text(unreadCount > 0 ? unreadCount : '');
	            
	            // 새 메시지가 있으면 상단으로 이동
	            if (unreadCount > 0) {
	                $existingChat.prependTo('#boxTable');
	            }
	            
	            lastUpdateTime[chatID] = chatTime;
	        }
	    } else {
	        // 새로운 채팅방 추가
	        addBox(fromID, toID, chatContent, chatTime, unreadCount);
	    }
	}
	function addBox(lastID, toID, chatContent, chatTime, unreadCount){
	    $.ajax({
	        type: "GET",
	        url: "getChatNickname.jsp",
	        data: { toID: toID },
	        success: function(response){
	            var nickname = JSON.parse(response).nickname;
	            var unreadBadge = unreadCount > 0 ? '<span class="badge bg-danger unread-badge">' + unreadCount + '</span>' : '';
	            console.log("Adding box for toID:", toID);
	            $('#boxTable').append('<tr id="chat-' + toID + '">' +
	                    '<td style="width: 150px;"><h5>' + nickname + ' ' + unreadBadge + '</h5></td>' +
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
						<th>
						<h4>주고받은 메시지 목록</h4>
						<button id="updateButton" class="btn btn-primary">새로운 채팅 불러오기</button>
						</th>
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
			   
			    chatBoxFunction();
			    
			    
			    $('#updateButton').click(function() {
			        chatBoxFunction();
			    });
			    
			    getUnread();
			    getInfiniteUnread();
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