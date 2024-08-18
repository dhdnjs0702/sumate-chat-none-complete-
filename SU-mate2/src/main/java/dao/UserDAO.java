package dao;
import java.sql.*;
import javax.naming.NamingException;
import util.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class UserDAO {
	 public boolean insert(String uid, String jsonstr) throws NamingException, SQLException {
	        Connection conn = ConnectionPool.get();
	        PreparedStatement stmt = null;
	        try {
	            String sql = "INSERT INTO user(id, jsonstr) VALUES(?, ?)";    
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, uid);
	            stmt.setString(2, jsonstr);

	            int count = stmt.executeUpdate();
	            return (count == 1) ? true : false;

	        } finally {
	            if (stmt != null) stmt.close();
	            if (conn != null) conn.close();
	        }
	    }
public boolean exists(String uid) throws NamingException, SQLException {
	Connection conn = ConnectionPool.get();
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		String sql = "SELECT id FROM user WHERE id = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, uid);

		rs = stmt.executeQuery();
		return rs.next();

	} finally {
		if (rs != null) rs.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
}

public boolean delete(String uid) throws NamingException, SQLException {
    Connection conn = ConnectionPool.get();
    PreparedStatement stmt1 = null;
    PreparedStatement stmt2 = null;
    PreparedStatement stmt3 = null;

    try {
        conn.setAutoCommit(false); // 트랜잭션 시작

        String sql1 = "DELETE FROM user WHERE id = ?";
        String sql2 = "DELETE FROM mfeed WHERE id = ?";
        String sql3 = "DELETE FROM fmfeed WHERE id = ?";

        stmt1 = conn.prepareStatement(sql1);
        stmt1.setString(1, uid);
        int count1 = stmt1.executeUpdate();

        stmt2 = conn.prepareStatement(sql2);
        stmt2.setString(1, uid);
        int count2 = stmt2.executeUpdate();

        stmt3 = conn.prepareStatement(sql3);
        stmt3.setString(1, uid);
        int count3 = stmt3.executeUpdate();

        conn.commit(); // 모든 삭제가 성공하면 커밋
        return (count1 > 0 || count2 > 0 || count3 > 0); // 세 테이블 중 한 곳이라도 삭제되면 true 반환

    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback(); // 오류 발생 시 롤백
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
        return false;
    } finally {
        if (stmt1 != null) stmt1.close();
        if (stmt2 != null) stmt2.close();
        if (stmt3 != null) stmt3.close();
        if (conn != null) conn.close();
    }
}

public int login(String uid, String upass) throws NamingException, SQLException, ParseException {
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        String sql = "SELECT jsonstr FROM user WHERE id = ?";
        conn = ConnectionPool.get();
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, uid);
        rs = stmt.executeQuery();

        if (!rs.next()) {
            System.out.println("ID가 존재하지 않음: " + uid); // 디버깅 로그 추가
            return 1; // ID가 존재하지 않음
        }

        String jsonstr = rs.getString("jsonstr");
        JSONObject obj = (JSONObject) (new JSONParser()).parse(jsonstr);
        String pass = (String) obj.get("password"); // JSON에서 비밀번호 가져오기

        if (!upass.equals(pass)) {
            System.out.println("비밀번호가 일치하지 않음: " + uid); // 디버깅 로그 추가
            return 2; // 비밀번호가 일치하지 않음
        }

        return 0; // 로그인 성공

    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("SQL 에러: " + e.getMessage()); // 디버깅 로그 추가
        return -1; // SQL 에러
    } catch (ParseException e) {
        e.printStackTrace();
        System.out.println("JSON 파싱 에러: " + e.getMessage()); // 디버깅 로그 추가
        return -2; // JSON 파싱 에러
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}

public String getNickname(String uid) throws NamingException, SQLException, ParseException {
    Connection conn = ConnectionPool.get();
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        String sql = "SELECT jsonstr FROM user WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, uid);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String jsonstr = rs.getString("jsonstr");
            JSONObject obj = (JSONObject) (new JSONParser()).parse(jsonstr);
            return (String) obj.get("nickname");
        }

        return null;
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
}

public JSONObject getUserInfo(String uid) throws NamingException, SQLException, ParseException {
    Connection conn = ConnectionPool.get();
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        String sql = "SELECT jsonstr FROM user WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, uid);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String jsonstr = rs.getString("jsonstr");
            return (JSONObject) (new JSONParser()).parse(jsonstr);
        }

        return null;
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
}
}