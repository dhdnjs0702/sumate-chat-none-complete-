package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/ChatBoxServlet")
public class ChatBoxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String userID = request.getParameter("id");
		if (userID == null || userID.equals("")) {
			response.getWriter().write("");
		} else {
			try {
				userID = URLDecoder.decode(userID, "UTF-8");
				response.getWriter().write(getBox(userID));
			}catch(Exception e) {
				response.getWriter().write("");
			}
			
		}
	}	
	
	public String getBox(String userID) {
        StringBuffer result = new StringBuffer("");
        result.append("{\"result\":[");
        ChatDAO chatDAO = new ChatDAO();
        ArrayList<ChatDTO> chatList = chatDAO.getBox(userID);
        if(chatList == null || chatList.size() == 0) return "";
        for(int i = chatList.size() - 1; i >= 0; i--) {
            String unread = "";
            String otherID = userID.equals(chatList.get(i).getToID()) ? 
                             chatList.get(i).getFromID() : chatList.get(i).getToID();
            
            if(userID.equals(chatList.get(i).getToID())) {
                unread = chatDAO.getUnreadChat(chatList.get(i).getFromID(), userID) + "";
                if(unread.equals("0")) unread = "";
            }
            
            result.append("[{\"value\":\"" + otherID + "\"},"); // 상대방 ID
            result.append("{\"value\":\"" + otherID + "\"},"); // toID로 사용될 값
            result.append("{\"value\":\"" + chatList.get(i).getChatContent() + "\"},");
            result.append("{\"value\":\"" + chatList.get(i).getChatTime() + "\"},");
            result.append("{\"value\":\"" + unread + "\"}]");
            if(i != 0) result.append(",");
        }
        result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
        return result.toString();
    }
}

