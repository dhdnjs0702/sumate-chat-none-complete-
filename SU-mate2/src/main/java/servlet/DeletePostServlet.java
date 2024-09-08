package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/DeletePostServlet")
public class DeletePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String postID = request.getParameter("postID");
        String sessionUserID = (String) request.getSession().getAttribute("id");  // 현재 로그인한 사용자의 ID

        if (postID == null || postID.equals("")) {
            response.sendRedirect("listPosts.jsp?error=invalidPostID");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection(); // DB 연결
            // 게시글 작성자가 현재 로그인한 사용자와 동일한지 확인
            String checkSql = "SELECT userID FROM posts WHERE id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, Integer.parseInt(postID));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String postUserID = rs.getString("userID");

                if (!sessionUserID.equals(postUserID)) {
                    response.sendRedirect("listPosts.jsp?error=notAuthorized");
                    return;
                }

                // 작성자가 맞으면 게시글 삭제
                String deleteSql = "DELETE FROM posts WHERE id = ?";
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, Integer.parseInt(postID));
                int result = pstmt.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("listPosts.jsp?success=deleted");
                } else {
                    response.sendRedirect("listPosts.jsp?error=notFound");
                }
            } else {
                response.sendRedirect("listPosts.jsp?error=notFound");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("listPosts.jsp?error=sqlError");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
