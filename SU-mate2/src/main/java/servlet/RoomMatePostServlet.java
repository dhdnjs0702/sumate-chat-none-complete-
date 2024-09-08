package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chat.ChatDAO;

@WebServlet("/RoomMatePostServlet")
public class RoomMatePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // GET 요청을 POST와 동일하게 처리
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // 세션에서 userID 가져오기
        String userID = (String) request.getSession().getAttribute("id");
        // 요청 파라미터에서 toID 가져오기
        String toID = request.getParameter("toID");

        // 디버깅: userID와 toID 값 확인
        System.out.println("userID: " + userID);
        System.out.println("toID: " + toID);

        // userID와 toID 값이 유효한지 확인
        if (userID == null || userID.equals("") || toID == null || toID.equals("")) {
            response.getWriter().write("<script>alert('로그인 후 이용 가능한 기능입니다.'); history.back();</script>");
            return;
        }

        try {
            // ChatDAO에서 두 사용자 간의 채팅방이 존재하는지 확인 또는 새로 생성
            ChatDAO chatDAO = new ChatDAO();
            int chatRoomID = chatDAO.findOrCreateChatRoom(userID, toID);

            // 디버깅: 생성된 채팅방 ID 확인
            System.out.println("chatRoomID: " + chatRoomID);

            // 채팅방이 생성되었으면 해당 채팅방으로 리다이렉트
            if (chatRoomID > 0) {
                response.sendRedirect("chat.jsp?chatRoomID=" + chatRoomID);
            } else {
                response.getWriter().write("<script>alert('채팅방 생성에 실패했습니다.'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<script>alert('서버 오류가 발생했습니다. 다시 시도해주세요.'); history.back();</script>");
        }
    }
}
