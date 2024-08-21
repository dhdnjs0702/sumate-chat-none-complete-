package chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ChatDAO {
DataSource dataSource;
	
	public ChatDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/sumate");
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public ArrayList<ChatDTO> getChatListByID(String fromID, String toID, String chatID){
		ArrayList<ChatDTO> chatList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM chat WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatID > ? ORDER BY chatTime";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatID));
			
			rs = pstmt.executeQuery();
			chatList = new ArrayList<ChatDTO>();
			while (rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
				String timeType = "오전";
				if (chatTime > 12) {
					timeType = "오후";
					chatTime -= 12; 
				}
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + "" + timeType + "" + chatTime + ":" + rs.getString("chatTime").substring(14, 16)+"");
				chatList.add(chat);
				
				System.out.println("Chat found: " + chat.getFromID() + " -> " + chat.getToID() + ": " + chat.getChatContent()); //디버깅
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) rs.close();
				if(conn != null) conn.close();
				if(pstmt != null) pstmt.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		System.out.println("Total chats found: " + (chatList != null ? chatList.size() : 0)); //디버깅
		return chatList;
	}
	
	public ArrayList<ChatDTO> getChatListByRecent(String fromID, String toID, int number){
		ArrayList<ChatDTO> chatList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatID > (SELECT MAX(chatID) - ? FROM chat WHERE (fromID = ? AND toID = ?) OR (fromID = ? AND toID)) ORDER BY chatTime";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			pstmt.setString(6, fromID);
			pstmt.setString(7, toID);
			pstmt.setString(8, toID);
			pstmt.setString(9, fromID);
			rs = pstmt.executeQuery();
			chatList = new ArrayList<ChatDTO>();
			while (rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll("","&nbsp;").replaceAll("<", "&lt").replaceAll(">","&nbsp;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
				String timeType = "오전";
				if (chatTime > 12) {
					timeType = "오후";
					chatTime -= 12; 
				}
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + "" + timeType + "" + chatTime + ":" + rs.getString("chatTime").substring(14, 16)+"");
				chatList.add(chat);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) rs.close();
				if(conn != null) conn.close();
				if(pstmt != null) pstmt.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		return chatList;
	}
	
	public int submit(String fromID, String toID, String chatContent) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String SQL = "INSERT INTO CHAT (fromID, toID, chatContent, chatTime, chatRead) VALUES (?, ?, ?, NOW(), 0)";
	    try {
	        conn = dataSource.getConnection();
	        if (conn == null) {
	            System.out.println("Database connection failed");
	            return -1;
	        }
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, fromID);
	        pstmt.setString(2, toID);
	        pstmt.setString(3, chatContent);
	        System.out.println("Executing SQL: " + SQL);
	        System.out.println("Parameters: " + fromID + ", " + toID + ", " + chatContent);
	        int result = pstmt.executeUpdate();
	        System.out.println("SQL result: " + result);
	        return result;
	    } catch (SQLException e) {
	        System.out.println("SQL Error in submit method: " + e.getMessage());
	        System.out.println("SQL State: " + e.getSQLState());
	        System.out.println("Error Code: " + e.getErrorCode());
	        e.printStackTrace();
	        return -1;
	    } catch (Exception e) {
	        System.out.println("General Error in submit method: " + e.getMessage());
	        e.printStackTrace();
	        return -1;
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	
	public int readChat(String fromID, String toID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE CHAT SET chatRead = 1 WHERE (fromID = ? AND toID = ?)";
		try {
			conn =dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, toID);
			pstmt.setString(2, fromID);
			return pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				if(conn != null) conn.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	public int getAllUnreadChat(String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT COUNT(chatID) FROM CHAT WHERE toID = ? AND chatRead = 0";
		try {
			conn =dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0;
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) rs.close();
				if(conn != null) conn.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	public ArrayList<ChatDTO> getBox(String userID) {
	    ArrayList<ChatDTO> chatList = new ArrayList<ChatDTO>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    // 각 사용자 간의 마지막 메시지만 가져오는 SQL 쿼리
	    String SQL = "SELECT * FROM CHAT c1 WHERE c1.chatID = ("
	               + "SELECT MAX(c2.chatID) FROM CHAT c2 "
	               + "WHERE (c2.fromID = c1.fromID AND c2.toID = c1.toID) "
	               + "OR (c2.fromID = c1.toID AND c2.toID = c1.fromID)) "
	               + "AND ((c1.toID = ? AND c1.isDeletedByToID = 0) "
	               + "OR (c1.fromID = ? AND c1.isDeletedByFromID = 0)) "
	               + "ORDER BY c1.chatTime DESC";

	    try {
	        conn = dataSource.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, userID);
	        pstmt.setString(2, userID);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            ChatDTO chat = new ChatDTO();
	            chat.setChatID(rs.getInt("chatID"));
	            chat.setFromID(rs.getString("fromID").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            chat.setToID(rs.getString("toID").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            chat.setChatContent(rs.getString("chatContent").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            
	            int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
	            String timeType = "오전";
	            if (chatTime > 12) {
	                timeType = "오후";
	                chatTime -= 12;
	            }
	            chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16));
	            chatList.add(chat);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (conn != null) conn.close();
	            if (pstmt != null) pstmt.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return chatList;
	}
	
	public int getUnreadChat(String fromID ,String toID ) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT COUNT(chatID) FROM CHAT WHERE fromID = ? AND toID = ? AND chatRead = 0";
		try {
			conn =dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);

			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0;
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) rs.close();
				if(conn != null) conn.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	public boolean deleteChat(String userID, String otherID) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String SQL;
	    try {
	        conn = dataSource.getConnection();

	        // userID가 fromID인지 toID인지 확인하여 적절한 플래그 업데이트
	        boolean isFrom = isFromUser(conn, userID, otherID);

	        if (isFrom) {
	            SQL = "UPDATE CHAT SET isDeletedByFromID = TRUE WHERE fromID = ? AND toID = ?";
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, userID); // fromID로서 userID 설정
	            pstmt.setString(2, otherID); // toID 설정
	        } else {
	            SQL = "UPDATE CHAT SET isDeletedByToID = TRUE WHERE fromID = ? AND toID = ?";
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, otherID); // fromID 설정
	            pstmt.setString(2, userID); // toID로서 userID 설정
	        }

	        int result = pstmt.executeUpdate();
	        return result > 0; // 업데이트 성공 시 true 반환
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	private boolean isFromUser(Connection conn, String userID, String otherID) throws SQLException {
	    String SQL = "SELECT COUNT(*) FROM CHAT WHERE fromID = ? AND toID = ?";
	    try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	        pstmt.setString(1, userID);
	        pstmt.setString(2, otherID);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                int count = rs.getInt(1);
	                System.out.println("isFromUser: userID = " + userID + ", otherID = " + otherID + ", count = " + count);
	                return count > 0;
	            }
	        }
	    }
	    return false;
	}
	
	public Map<String, Integer> getUnreadMessageCountByChat(String userID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Integer> unreadCounts = new HashMap<>();

        String SQL = "SELECT fromID, COUNT(chatID) AS unreadCount " +
                     "FROM CHAT WHERE toID = ? AND chatRead = 0 " +
                     "GROUP BY fromID";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String fromID = rs.getString("fromID");
                int count = rs.getInt("unreadCount");
                unreadCounts.put(fromID, count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (conn != null) conn.close();
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return unreadCounts;
    }
}
