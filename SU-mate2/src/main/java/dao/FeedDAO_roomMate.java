package dao;

import java.sql.*;
import javax.naming.NamingException;
import util.ConnectionPool;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class FeedDAO_roomMate {

    // 게시물 삽입 메서드
	public boolean insert(String jsonstr) throws NamingException, SQLException, ParseException {
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;

	    try {
	        conn = ConnectionPool.get();
	        synchronized (this) {
	            if (jsonstr == null || jsonstr.trim().isEmpty()) {
	                System.err.println("Error: jsonstr is null or empty");
	                return false;
	            }

	            JSONParser parser = new JSONParser();
	            JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);

	            // JSON 객체에서 각 필드 추출
	            String title = (String) jsonobj.get("title"); // 안전하게 캐스팅
	            // 다른 필드들도 같은 방식으로 추출
	            String dormitory = (String) jsonobj.get("dormitory");
	            //...

	            // 필드가 null이거나 빈 문자열인지 확인
	            if (title == null || title.trim().isEmpty()) {
	                System.err.println("Error: title is null or empty");
	                return false;
	            }

	            String sql = "INSERT INTO posts (title, dormitory, bedTime, wakeTime, showerTime, showerPeriod, sleepHabit, cleaning, snack, alarmSound, studyStyle, studyTime, description) " +
	                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, title);
	            stmt.setString(2, dormitory);
	            // 나머지 필드도 같은 방식으로 세팅
	            //...

	            int count = stmt.executeUpdate();
	            return (count == 1);
	        }
	    } finally {
	        if (rs != null) rs.close();
	        if (stmt != null) stmt.close();
	        if (conn != null) conn.close();
	    }
	}


    // 모든 게시물 리스트를 가져오는 메서드
    public String getList() throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM posts ORDER BY created_at DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            StringBuilder str = new StringBuilder("[");
            int cnt = 0;
            while (rs.next()) {
                if (cnt++ > 0) str.append(", ");
                
                JSONObject jsonobj = new JSONObject();
                jsonobj.put("id", rs.getInt("id"));
                jsonobj.put("title", rs.getString("title"));
                jsonobj.put("dormitory", rs.getString("dormitory"));
                jsonobj.put("bedTime", rs.getString("bedTime"));
                jsonobj.put("wakeTime", rs.getString("wakeTime"));
                jsonobj.put("showerTime", rs.getString("showerTime"));
                jsonobj.put("showerPeriod", rs.getString("showerPeriod"));
                jsonobj.put("sleepHabit", rs.getString("sleepHabit"));
                jsonobj.put("cleaning", rs.getString("cleaning"));
                jsonobj.put("snack", rs.getString("snack"));
                jsonobj.put("alarmSound", rs.getString("alarmSound"));
                jsonobj.put("studyStyle", rs.getString("studyStyle"));
                jsonobj.put("studyTime", rs.getString("studyTime"));
                jsonobj.put("description", rs.getString("description"));
                jsonobj.put("created_at", rs.getTimestamp("created_at").toString());
                
                str.append(jsonobj.toJSONString());
            }
            return str.append("]").toString();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 최대 ID 기준으로 특정 그룹의 게시물을 가져오는 메서드
    public String getGroup(String maxNo) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM posts";
            if (maxNo != null) {
                sql += " WHERE id < ? ";
            }
            sql += " ORDER BY id DESC LIMIT 3";

            stmt = conn.prepareStatement(sql);
            if (maxNo != null) {
                stmt.setInt(1, Integer.parseInt(maxNo));
            }
            rs = stmt.executeQuery();

            StringBuilder str = new StringBuilder("[");
            int cnt = 0;
            while (rs.next()) {
                if (cnt++ > 0) str.append(", ");
                
                JSONObject jsonobj = new JSONObject();
                jsonobj.put("id", rs.getInt("id"));
                jsonobj.put("title", rs.getString("title"));
                jsonobj.put("dormitory", rs.getString("dormitory"));
                jsonobj.put("bedTime", rs.getString("bedTime"));
                jsonobj.put("wakeTime", rs.getString("wakeTime"));
                jsonobj.put("showerTime", rs.getString("showerTime"));
                jsonobj.put("showerPeriod", rs.getString("showerPeriod"));
                jsonobj.put("sleepHabit", rs.getString("sleepHabit"));
                jsonobj.put("cleaning", rs.getString("cleaning"));
                jsonobj.put("snack", rs.getString("snack"));
                jsonobj.put("alarmSound", rs.getString("alarmSound"));
                jsonobj.put("studyStyle", rs.getString("studyStyle"));
                jsonobj.put("studyTime", rs.getString("studyTime"));
                jsonobj.put("description", rs.getString("description"));
                jsonobj.put("created_at", rs.getTimestamp("created_at").toString());
                
                str.append(jsonobj.toJSONString());
            }
            return str.append("]").toString();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 게시물 삭제 메서드
    public boolean deleteFeed(int feedNo, String userID) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();

            String SQL = "DELETE FROM posts WHERE id = ? AND user_id = ?";
            stmt = conn.prepareStatement(SQL);
            stmt.setInt(1, feedNo);
            stmt.setString(2, userID);

            int result = stmt.executeUpdate();
            return result > 0; // 삭제 성공 시 true 반환

        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}
