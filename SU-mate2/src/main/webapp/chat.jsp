<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
		<%
			String userID=null;
			if(session.getAttribute("id") !=null){
				userID = (String) session.getAttribute("id");
				System.out.println("userID1="+userID);
				
			}
			String toID = null;
            if (request.getParameter("toID") != null) {
                toID = request.getParameter("toID");
                toID = URLDecoder.decode(toID, "UTF-8");
				System.out.println("toID2="+toID);

            }
          
			if(userID == null){
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "현재 로그인이 되어 있지 않습니다.");
				response.sendRedirect("login.jsp");				
				System.out.println("userID3="+userID);

				return;
			}
			if(toID == null){
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "대화 상태가 지정되지 않았습니다.");
				response.sendRedirect("mainPage.jsp");
				System.out.println("toID4="+toID);
				return;
			}
			
			if (userID.equals(toID)) {
                session.setAttribute("messageType", "오류 메시지");
                session.setAttribute("messageContent", "자기 자신에게 쪽지를 보낼 수 없습니다.");
                response.sendRedirect("mainPage.jsp");
                return;
            }
		%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<title>추가기능 채팅 구현</title>
<script type="text/javascript">
	function autoClosingAlert(selector, delay){
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout(function() {alert.hide()}, delay);
	}
	function submitFunction(){
		var fromID = '<%= userID %>';
		console.log("fromID="+fromID);

		var toID = '<%= toID %>';
		console.log("toID="+toID);
		var chatContent = $('#chatContent').val();
		$.ajax({
			type: "POST",
			url: "./chatSubmitServlet",
			data: {
				fromID: fromID,
	            toID: toID,
	            chatContent: encodeURIComponent(chatContent),
			},
			success: function(result){
				if(result == 1){
					autoClosingAlert('#successMessage', 2000);
				} else if(result == 0){
					autoClosingAlert('#dangerMessage', 2000);
				}else{
					autoClosingAlert('#warningMessage', 2000);
				}
			}
		});
		$('#chatContent').val('');
	}
	var lastID = 0;

	function chatListFunction(type) {
	    var fromID = '<%= userID %>';
	    var toID = '<%= toID %>';
	    $.ajax({
	        type: "POST",
	        url: "./chatListServlet",
	        data: {
	            fromID: encodeURIComponent(fromID),
	            toID: encodeURIComponent(toID),
	            listType: type
	        },
	        success: function(data) {
	            console.log("AJAX response received:", data); // 디버깅
	            if (data == "") return;
	            var parsed = JSON.parse(data);
	            var result = parsed.result;

	            for (var i = 0; i < result.length; i++) {
	                var chatName = result[i][0].value;
	                var chatContent = result[i][2].value;
	                var chatTime = result[i][3].value;

	                // HTML 엔터티(&nbsp; 등)을 제거하고 공백을 제거
	                chatName = chatName.replace(/&nbsp;/g, '').trim();

	                // 메시지 발신자가 현재 사용자인 경우 '나'로 표시
	                if (chatName === fromID) {
	                    chatName = '나';
	                }

	                addChat(chatName, chatContent, chatTime);
	            }

	            lastID = Number(parsed.last);
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.error("AJAX error:", textStatus, errorThrown); // 디버깅
	        }
	    });
	}
	function addChat(chatName, chatContent, chatTime){
		console.log("Adding chat:", chatName, chatContent, chatTime); //디버깅
		$('#chatList').append('<div class="row">' +
				'<div class="col-lg-12">' +
				'<div class="media">' +
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width: 30px; height: 30px;" src="images/icon.png" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				chatName +
				'<span class="small pull-right">' +
				chatTime +
				'</span>' +
				'</h4>' +
				'<p>' +
				chatContent +
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>'
				);
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
	}
	function getInfiniteChat(){
		setInterval(function(){
			chatListFunction(lastID);
		}, 3000);
	}
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
		       },
		       error: function(xhr, status, error) {
		            console.error("Error occurred: " + error);
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
</script>
</head>
<body>
		<nav class= "navbar navbar-default">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
					aria-expanded="false">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index.jsp">실시간 채팅 기능 구현</a>
			</div>
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li><a href="index.jsp">메인</a></li>
					<li><a href="find.jsp">친구찾기</a></li>
					<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				</ul>
			</div>
		</nav>
		<div class="container bootstrap snippet">
			<div class="row">
				<div class="col-xs-12">
					<div class="portlet portlet-default">
						<div class="portlet-heading">
							<div class="portlet- title">
								<h4><i class="fa fa-circle text-green">실시간 채팅</i></h4>
							</div>
							<div class="clearfix"></div>
						</div>
						<div id="chat" class="pannel-collapse collapse in">
							<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:600px">
							</div>
							<div class="portlet-footer">
								<div class="row" style="height: 90px;">
									<div class="form-group col-xs-10">
										<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="메시지를 입력하세요." maxlength="100"></textarea>
									</div>
									<div class="form-group col-xs-2">
										<button type="button" class="btn btn-default pull right" onclick="submitFunction();">전송</button>
										<div class="clearfix"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="alert alert-success" id="successMessage" style="display: none;">
			<strong>메시지 전송에 성공했습니다.</strong>
		</div>
		<div class="alert alert-danger" id="dangerMessage" style="display: none;">
			<strong>이름과 내용을 모두 입력해주세요.</strong>
		</div>
		<div class="alert alert-warning" id="warningMessage" style="display: none;">
			<strong>데이터 베이스 오류가 발생했습니다.</strong>
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
		<script type="text/javascript">
		$(document).ready(function(){
			var toID = '<%= toID %>';
			getUnread();
			chatListFunction('0');
			getInfiniteChat();
			getInfiniteUnread();
		});
		</script>
</body>
</html>