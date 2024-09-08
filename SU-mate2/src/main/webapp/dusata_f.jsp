<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="dao.FeedDAO_dufemale" %>
<%@ page import="dao.FeedObj" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>

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
<title>Insert title here</title>
<link rel="stylesheet" href="css/main_styles.css">
<link rel="stylesheet" href="css/dusata.css">
<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/core.js"></script>
</head>
<body>
<div class="main-container">
<%@ include file="header_login.jsp" %> <!-- 헤더 부분 -->

   <div class="content-section">
    <div>
        <button class="feed-add-button">글 작성하기</button>
    </div>
    <div class="gender-selector">
        <button id="maleBtn" data-gender="male" class="gender-btn" onclick="window.location.href='dusata_m.jsp'">남</button>
        <button id="femaleBtn" data-gender="female" class="gender-btn selected" onclick="window.location.href='dusata_f.jsp'">여</button>
    </div>
    <div id="feedContainer">
        <!-- 여기에 JavaScript로 동적으로 게시물이 추가됩니다 -->
    </div>
    <div id="loadMoreContainer">
        <button id="loadMoreButton" onclick="loadMoreFeeds()">작성글 더 보기</button>
    </div>
</div>

<%@ include file="footer.jsp" %> <!-- 풋터 부분 -->
</div>

<script>
var minNo = -1;
var isLoading = false; // 중복 요청 방지를 위한 변수

function start(uid) {
    AJAX.call("feedGetGroup_dufm.jsp", {maxNo: 0}, function(data) {
        var feeds = JSON.parse(data.trim());
        if (feeds.length > 0) {
            minNo = feeds[feeds.length - 1].no;
        }
        show(feeds);
    });
}

$(document).ready(function() {
    start('<%=userID%>');
    
    $('.feed-add-button').off('click').on('click', addFeed);
    $('#loadMoreButton').off('click').on('click', loadMoreFeeds);
});

function loadMoreFeeds() {
    if (isLoading) return; 
    isLoading = true; 
    
    AJAX.call("feedGetGroup_dufm.jsp", {maxNo: minNo}, function(data) {
        var feeds = JSON.parse(data.trim());
        if (feeds.length > 0) {
            minNo = feeds[feeds.length - 1].no;
            show(feeds);
        } else {
            $("#loadMoreButton").hide();
        }
        isLoading = false; 
    });
}

function redirectToChat(toID, nickname) {
    var userID = '<%= userID %>'; // 현재 로그인한 사용자의 ID를 JSP에서 가져옴

    if (toID && toID.trim() !== "") {
        if (userID === toID) {
            alert("자기자신과는 채팅할 수 없습니다.");
        } else {
            var confirmMessage = nickname + "님과 채팅하시겠습니까?";
            if (confirm(confirmMessage)) { 
                window.location.href = "chat.jsp?toID=" + encodeURIComponent(toID);
            }
        }
    } else {
        alert("잘못된 유저 정보입니다.");
    }
}

function show(feeds) {
    var str = "<div class='postit-container'>";
    for (var i = 0; i < feeds.length; i++) {
        var img = feeds[i].imageUrl;
        var imgstr = "";
        if (img && img.trim() !== "") {
            // 상대 경로를 절대 경로로 변환, URL을 디코딩하여 사용
            var fullImageUrl = window.location.origin + decodeURIComponent(img);
            
            imgstr = "<img src='" + fullImageUrl + "' class='postit-image' onerror='this.onerror=null; this.src=\"/SU-mate2/images/default-image-svg.svg\"; this.alt=\"이미지 없음\"'>";
        }

        var nickname = feeds[i].user ? feeds[i].user.nickname : "Unknown";
        var userID = feeds[i].user ? feeds[i].user.id : ""; // 유저 ID 가져오기
        var timestamp = feeds[i].ts; // 작성 시간 가져오기
        
        // 글자 수 제한 (최대 25자 * 4줄)
        var content = feeds[i].content;
        var maxCharsPerLine = 25;
        var maxLines = 4;
        var formattedContent = '';

        for (var j = 0; j < maxLines; j++) {
            if (content.length > maxCharsPerLine) {
                formattedContent += content.substring(0, maxCharsPerLine) + '<br>';
                content = content.substring(maxCharsPerLine);
            } else {
                formattedContent += content;
                break;
            }
        }
        
        str += "<div class='postit'>";
        str += "<div class='postit-header'>";
        str += "<small class='postit-nickname'>" + nickname + " (" + timestamp + ")</small>";
        str += "<div class='postit-options' onclick='event.stopPropagation(); toggleOptions(" + feeds[i].no + ")'>...</div>";
        str += "<div id='options-" + feeds[i].no + "' class='options-dropdown'>";
        str += "<div onclick='redirectToChat(\"" + userID + "\", \"" + nickname + "\")'>채팅하기</div>";
        if (userID === '<%=userID%>') {
            str += "<div onclick='deletePost(" + feeds[i].no + ")'>글 삭제</div>";
        }
        str += "</div>";
        str += "</div>";
        str += "<div class='postit-body'>" + imgstr;
        str += "<div class='postit-content'>" + formattedContent + "</div>";
        str += "</div>";
        str += "</div>";
    }
    str += "</div>";
    $("#feedContainer").append(str);  
}

function addFeed() {
    window.location.href = "feedWrite_dufemlae.jsp";
}

function deletePost(feedNo) {
    if (confirm("이 글을 삭제하시겠습니까?")) {
        AJAX.call("feedDelete_dufm.jsp", { no: feedNo }, function(response) {
            if (response.trim() === "success") {
                alert("글이 삭제되었습니다.");
                location.reload(); // 페이지 새로고침으로 업데이트
            } else {
                alert("글 삭제에 실패했습니다.");
            }
        });
    }
}

function toggleOptions(feedNo) {
    var options = document.getElementById('options-' + feedNo);
    if (options.style.display === 'block') {
        options.style.display = 'none';
    } else {
        options.style.display = 'block';
    }
    
    document.addEventListener('click', function(event) {
        if (!options.contains(event.target) && event.target.className !== 'postit-options') {
            options.style.display = 'none';
        }
    }, { once: true });
}

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

document.querySelector('.feed-add-button').addEventListener('click', addFeed);
document.getElementById('loadMoreButton').addEventListener('click', loadMoreFeeds);
</script>
    
</body>
</html>