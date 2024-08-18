<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="util.FileUtil" %>
<%@ page import="dao.FeedDAO_dufemale" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.io.File" %>

<%
try {
    request.setCharacterEncoding("utf-8");
    String jsonstr = null, ufname = null;
    byte[] ufile = null;

    ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
    List<FileItem> items = sfu.parseRequest(request);
    for (FileItem item : items) {
        if (item.isFormField()) {
            if (item.getFieldName().equals("jsonstr")) {
                jsonstr = item.getString("utf-8");
            }
        } else {
        	if (item.getFieldName().equals("image") && !item.getName().isEmpty()) {
        	    ufname = item.getName();
        	    ufile = item.get();
        	    String root = application.getRealPath("/images");
                System.out.println("Image save path: " + root); // 로그에 경로 출력
                File saveDir = new File(root);
                if (!saveDir.exists()) {
                    saveDir.mkdirs(); // 디렉토리가 없으면 생성
                }
                FileUtil.saveImage(root, ufname, ufile);
        	}
        }
    }

    if (jsonstr == null || jsonstr.trim().isEmpty()) {
        throw new Exception("Invalid data: jsonstr is null or empty");
    }

    JSONParser parser = new JSONParser();
    JSONObject jsonObj = (JSONObject) parser.parse(jsonstr);
    
    Object tsValue = jsonObj.get("ts");
    if (tsValue instanceof Long) {
        // 밀리초 단위의 타임스탬프를 날짜 문자열로 변환
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDate = sdf.format(new Date((Long) tsValue));
        jsonObj.put("ts", formattedDate);
    } else if (!(tsValue instanceof String)) {
        throw new Exception("Invalid timestamp format");
    }
    
    // 이미지 정보 추가
    jsonObj.put("images", ufname);
    
    // 이미지 URL 생성 및 추가
    String imageUrl = request.getContextPath() + "/images/" + ufname;
    jsonObj.put("imageUrl", imageUrl);
    
    // 세션에서 사용자 ID 가져와서 추가
    String userId = (String) session.getAttribute("id");
    if (userId == null || userId.trim().isEmpty()) {
        throw new Exception("User is not logged in");
    }
    jsonObj.put("id", userId);

    // 데이터베이스에 저장
    FeedDAO_dufemale dao = new FeedDAO_dufemale();
    boolean insertResult = dao.insert(jsonObj.toJSONString());

    if (insertResult) {
        out.print("OK");
    } else {
        out.print("ER: Insert failed");
    }

} catch (Exception e) {
    response.setStatus(500);
    out.println("Error: " + e.getMessage());
    e.printStackTrace(new java.io.PrintWriter(out));
    e.printStackTrace(); // 서버 로그에 스택 트레이스 출력
}
%>