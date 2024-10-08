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

public class FeedDAO_dumale {
    public boolean insert(String jsonstr) throws NamingException, SQLException, ParseException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try { 
            conn = ConnectionPool.get();
            synchronized(this) {
            	if (jsonstr == null || jsonstr.trim().isEmpty()) {
                    System.err.println("Error: jsonstr is null or empty");
                    return false;
                }
            	
                // Phase 1: Add "no" property
                String sql = "SELECT no FROM mfeed ORDER BY no DESC LIMIT 1";
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
                

                // Phase 3: Insert jsonobj to the table
                sql = "INSERT INTO mfeed(no, id, jsonstr) VALUES(?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, max + 1);
                stmt.setString(2, uid);
                stmt.setString(3, jsonobj.toJSONString());
                
                int count = stmt.executeUpdate();
               return (count == 1)?true:false;
            	}
                
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
		String sql = "SELECT jsonstr FROM mfeed ORDER BY no DESC";
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
		String sql = "SELECT jsonstr FROM mfeed";
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
public boolean deleteFeed(int feedNo, String userID) throws NamingException, SQLException {
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        conn = ConnectionPool.get();  // ConnectionPool을 통해 커넥션을 가져옴

        String SQL = "DELETE FROM mfeed WHERE no = ? AND id = ?";
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


	