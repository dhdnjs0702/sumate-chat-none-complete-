<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="dao.FeedDAO_dumale" %>
<%@ page import="dao.FeedObj" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>

<%
    // 로그인 상태 확인
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
%>
        <script type="text/javascript">
            alert("로그인 후 이용가능한 컨텐츠입니다.");
            window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        </script>
<%
        return; // JSP 페이지 실행 종료
    }

    // 로그인 상태인 경우 세션에 사용자 ID를 다시 설정 (필요에 따라)
    session.setAttribute("id", uid);
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
        <button id="maleBtn" data-gender="male" class="gender-btn selected" onclick="window.location.href='dusata_m.jsp'">남</button>
        <button id="femaleBtn" data-gender="female" class="gender-btn" onclick="window.location.href='dusata_f.jsp'">여</button>
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
    AJAX.call("feedGetGroup_dum.jsp", {maxNo: 0}, function(data) {
        var feeds = JSON.parse(data.trim());
        if (feeds.length > 0) {
            minNo = feeds[feeds.length - 1].no;
        }
        show(feeds);
    });
}

$(document).ready(function() {
    start('<%=uid%>');
    
    // 이벤트 리스너 설정 (중복 방지)
    $('.feed-add-button').off('click').on('click', addFeed);
    $('#loadMoreButton').off('click').on('click', loadMoreFeeds);
});

function loadMoreFeeds() {
    if (isLoading) return; // 이미 로딩 중이면 새로운 요청을 막음
    isLoading = true; // 로딩 시작
    
    AJAX.call("feedGetGroup_dum.jsp", {maxNo: minNo}, function(data) {
        var feeds = JSON.parse(data.trim());
        if (feeds.length > 0) {
            minNo = feeds[feeds.length - 1].no;
            show(feeds);
        } else {
            $("#loadMoreButton").hide();
        }
        isLoading = false; // 로딩 끝
    });
}

function show(feeds) {
    var str = "<div class='postit-container'>";
    for (var i = 0; i < feeds.length; i++) {
        var img = feeds[i].images, imgstr = "";
        if (img && img.trim() !== "") {
            imgstr = "<img src='" + img + "' width='100%' onerror='this.style.display=\"none\"'>";
        }
        var nickname = feeds[i].user ? feeds[i].user.nickname : "Unknown";        
     
        str += "<div class='postit'>";
        str += "<div><small>" + nickname + "</small>&nbsp;<small>(" + feeds[i].ts + ")</small></div>";
        str += "<div>" + imgstr + "</div>";
        str += "<div class='postit-content'>" + feeds[i].content + "</div>";
        str += "</div>";
    }
    str += "</div>";
    $("#feedContainer").append(str);  // append를 사용하여 기존 내용에 추가
}

function addFeed() {
    window.location.href = "feedAdd_dumale.html";
}

document.querySelector('.feed-add-button').addEventListener('click', addFeed);
document.getElementById('loadMoreButton').addEventListener('click', loadMoreFeeds);
</script>
    
</body>
</html>