<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="util.FileUtil" %>
<%@ page import="dao.FeedDAO_dumale" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.io.File" %>

<%
try {
    request.setCharacterEncoding("utf-8");
    String jsonstr = null, ufname = null;
    byte[] ufile = null;

    // 파일 업로드 핸들러 설정
    ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
    List<FileItem> items = sfu.parseRequest(request);

    for (FileItem item : items) {
        if (item.isFormField()) {
            if (item.getFieldName().equals("jsonstr")) {
                jsonstr = item.getString("utf-8");
            }
        } else {
            // 이미지 파일 처리
            if (item.getFieldName().equals("image") && !item.getName().isEmpty()) {
                ufname = item.getName(); // 업로드된 파일 이름
                ufile = item.get();
            }
        }
    }

    // jsonstr 데이터 확인
    if (jsonstr == null || jsonstr.trim().isEmpty()) {
        throw new Exception("Invalid data: jsonstr is null or empty");
    }

    // jsonstr 파싱
    JSONParser parser = new JSONParser();
    JSONObject jsonObj = (JSONObject) parser.parse(jsonstr);

    // 타임스탬프 처리
    Object tsValue = jsonObj.get("ts");
    if (tsValue instanceof Long) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDate = sdf.format(new Date((Long) tsValue));
        jsonObj.put("ts", formattedDate);
    } else if (!(tsValue instanceof String)) {
        throw new Exception("Invalid timestamp format");
    }

    // 세션에서 사용자 ID 가져오기
    String userId = (String) session.getAttribute("id");
    if (userId == null || userId.trim().isEmpty()) {
        throw new Exception("User is not logged in");
    }
    jsonObj.put("id", userId);

    // 이미지 처리
    if (ufname != null && ufile != null) {
        // 서버에 저장할 경로 설정
        String root = application.getRealPath(java.io.File.separator);
        File saveDir = new File(root);
        if (!saveDir.exists()) {
            saveDir.mkdirs();
        }

        // 파일명을 안전한 형식으로 변환
        String safeFileName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + "_" + userId + "_" + ufname.replaceAll("[^a-zA-Z0-9.-]", "_");
        String imageUrl = request.getContextPath() + "/images/" + safeFileName;
        System.out.println("imgurl:" + imageUrl); // 로그로 이미지 URL 출력
        jsonObj.put("imageUrl", imageUrl); // 안전한 URL을 DB에 저장

        // 이미지를 새 파일명으로 저장
        FileUtil.saveImage(root, safeFileName, ufile);
    }
    
    // 데이터베이스에 저장
    FeedDAO_dumale dao = new FeedDAO_dumale();
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
}
%>