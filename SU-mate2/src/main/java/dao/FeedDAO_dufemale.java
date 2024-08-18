package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import util.ConnectionPool;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.NamingException;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class FeedDAO_dufemale {
    public boolean insert(String jsonstr) throws NamingException, SQLException, ParseException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try { 
            conn = ConnectionPool.get();
            synchronized(this) {
            	// JSON 문자열 유효성 검사
                if (jsonstr == null || jsonstr.trim().isEmpty()) {
                    System.err.println("Error: jsonstr is null or empty");
                    return false; // 오류 발생 시 false 반환
                }
            	
                // Phase 1: Add "no" property
                String sql = "SELECT no FROM fmfeed ORDER BY no DESC LIMIT 1";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                int max = (!rs.next()) ? 0 : rs.getInt("no");

                JSONParser parser = new JSONParser();
                JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
                jsonobj.put("no", max + 1);

                stmt.close(); rs.close();

                // Phase 2: Add "user" property
                String uid = jsonobj.get("id").toString();
                
                sql = "SELECT jsonstr FROM user WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, uid);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String usrstr = rs.getString("jsonstr");
                    JSONObject usrobj = (JSONObject) parser.parse(usrstr);
                    usrobj.remove("password");
                    usrobj.remove("ts");
                    jsonobj.put("user", usrobj);
                }

                stmt.close(); rs.close();
                
                // Log the JSON object
                System.out.println("Final JSON Object: " + jsonobj.toJSONString());

                // Phase 3: Insert jsonobj to the table
                sql = "INSERT INTO fmfeed(no, id, jsonstr) VALUES(?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, max + 1);
                stmt.setString(2, uid);
                stmt.setString(3, jsonobj.toJSONString());

                // Log the query and parameters
                System.out.println("Executing query: " + stmt.toString());

                int count = stmt.executeUpdate();

                // Log the result
                System.out.println("Rows affected: " + count);

                return count == 1;
            }
        } catch (SQLException e) {
            // SQL 예외 로그 출력
            System.err.println("SQLException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (NamingException e) {
            // Naming 예외 로그 출력
            System.err.println("NamingException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (ParseException e) {
            // JSON 파싱 예외 로그 출력
            System.err.println("ParseException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

public String getList() throws NamingException, SQLException {
	Connection conn = ConnectionPool.get();
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		String sql = "SELECT jsonstr FROM fmfeed ORDER BY no DESC";
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();
	 
		String str = "[";
		int cnt = 0;
		while(rs.next()) {
		if (cnt++ > 0) str += ", ";
		str += rs.getString("jsonstr");
		}
		return str + "]";
		
	} finally {
		if (rs != null) rs.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
}

public String getGroup(int maxNo) throws NamingException, SQLException {
	Connection conn = ConnectionPool.get();
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		String sql = "SELECT jsonstr FROM fmfeed";
		if (maxNo > 0) {
			sql += " WHERE no < " + maxNo;
		}
		sql += " ORDER BY no DESC LIMIT 6";
		
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();

        String str = "[";
        int cnt = 0;
        while (rs.next()) {
            if (cnt++ > 0) str += ", ";
            str += rs.getString("jsonstr");
        }
        return str + "]";

    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
  }
}
