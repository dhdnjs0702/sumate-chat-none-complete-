package dao;

import java.sql.*;
import javax.naming.NamingException;
import java.util.ArrayList;
import util.*;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


public class FeedDAO {/*레퍼런스해야할 객체입니다.*/
	public boolean insert(String jsonstr) throws NamingException, SQLException, ParseException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try { 
        synchronized(this) {
        	// phase 1. add "no" property -----------------------------
        	String sql ="SELECT no FROM feed ORDER BY no DESC LIMIT 1";
        	stmt = conn.prepareStatement(sql);
        	rs = stmt.executeQuery();
        	
        	int max = (!rs.next()) ? 0 : rs.getInt("no");
              	
        	JSONParser parser = new JSONParser();
        	JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
        	jsonobj.put("no", max + 1);
        	
        	stmt.close();
        	

        	// phase 2. add "user" property ------------------------------
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
        		
    		// phase 3. insert jsonobj to the table ------------------------
    		sql = "INSERT INTO feed(no, id, jsonstr) VALUES(?, ?, ?)";
    		stmt = conn.prepareStatement(sql);
    		stmt.setInt(1, max+1);
    		stmt.setString(2, uid);
    		stmt.setString(3, jsonobj.toJSONString());
    		
    		int count = stmt.executeUpdate();
    		return (count == 1) ? true : false;
           }
        } finally {
        	  if (stmt != null) stmt.close();
  			  if (conn != null) conn.close();
  			  if (rs != null) rs.close();
          }
        }
        	
            
    /*public boolean insert(String uid, String jsonstr) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionPool.get();
            String sql = "INSERT INTO feed(id, jsonstr) VALUES(?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            stmt.setString(2, jsonstr);
            //stmt.setString(2, ucon);
            //stmt.setString(3, uimages);

            // 입력 데이터 확인
            System.out.println("uid: " + uid);
            System.out.println("ucon&uimages: " + jsonstr);
           

            // SQL 쿼리 실행 전
            System.out.println("Executing query: " + stmt.toString());
            int count = stmt.executeUpdate();

            // SQL 쿼리 실행 후 (1 or false)
            System.out.println("Rows affected: " + count);
            return count == 1;
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
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing Connection: " + e.getMessage());
                }
            }
        }
    }
	*/
	public String getList() throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT jsonstr FROM feed ORDER BY no DESC";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
		 
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
			if (cnt++ > 0) str += ", ";
			str += rs.getString("jsonstr");
			}
			return str + "]";
			/*
			ArrayList<FeedObj> feeds = new ArrayList<FeedObj>();
			while(rs.next()) {
				feeds.add(new FeedObj(rs.getString("id"), rs.getString("content"), rs.getString("ts"), rs.getString("images")));
		}
			return feeds;
			*/
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public String getGroup(String maxNo) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT jsonstr FROM feed";
			if (maxNo != null) {
			sql += " WHERE no < " + maxNo;
			}
			sql += " ORDER BY no DESC LIMIT 3";
			
			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
			if (cnt++ > 0) str += ", ";
			str += rs.getString("jsonstr");
			}
			return str + "]";
			/*
			ArrayList<FeedObj> feeds = new ArrayList<FeedObj>();
			while(rs.next()) {
				feeds.add(new FeedObj(rs.getString("id"), rs.getString("content"), rs.getString("ts"), rs.getString("images")));
		}
			return feeds;
			*/
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
}
		