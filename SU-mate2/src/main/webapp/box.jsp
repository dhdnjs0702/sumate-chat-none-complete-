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
	function chatBoxFunction(){
		var userID = '<%= userID %>'
		$.ajax({
			type: "POST",
			url: "./chatBox",
			data: {
				userID :encodeURIComponent(userID),
			},
			success: function(data){
				 console.log("data="+data); // 응답 데이터 확인
				if(data == "" ) return;
				$('#boxTable').html('');
				var parsed = JSON.parse(data);
				var result = parsed.result;
				for(var i = 0; i < result.length; i++){
	                var toID = (result[i][0].value == userID) ? result[i][1].value : result[i][0].value;
	                var lastID = (result[i][0].value == userID) ? result[i][1].value : result[i][0].value;
	                var chatContent = result[i][2].value;
	                var chatTime = result[i][3].value;
	                var unread = result[i][4].value;
					addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value);
				}
			}
		});
	}
	function addBox(lastID, toID, chatContent, chatTime){
	    $.ajax({
	        type: "GET",
	        url: "getChatNickname.jsp",  // 닉네임을 가져오는 JSP
	        data: { toID: toID },
	        success: function(response){
	            var nickname = JSON.parse(response).nickname;
	            console.log("Adding box for toID:", toID);
	            $('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID='+ encodeURIComponent(toID) + '\'">' +
	                '<td style="width: 150px;"><h5>' + nickname + '</h5></td>' +  // 닉네임 표시
	                '<td>' +
	                '<h5>' + chatContent + '</h5>' +
	                '<div class="pull-right">' + chatTime + '</div>' +
	                '</td>' + 
	                '</tr>');
	        },
	        error: function(){
	            console.log("Error retrieving nickname for toID:", toID);
	        }
	    });
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
			String messageContent = null;
			if(session.getAttribute("messageContent") != null){
				messageContent = (String) session.getAttribute("messageContent");
			}
			String messageType = null;
			if(session.getAttribute("messageType") != null){
				messageType = (String) session.getAttribute("messageType");
			}
			if (messageContent != null){
		%>
		<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="vertical-alignment-helper">
				<div class="modal-dialog vertical-align-center">
					<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title">
								<%= messageType %>
							</h4>
						</div>
						<div class="modal-body">
							<%= messageContent %>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script>
			$('#messageModal').modal("show");
		</script>
		<%
			session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
			}
		%>
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