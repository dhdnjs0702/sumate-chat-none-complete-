package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    String fromID = request.getParameter("fromID");
	    String toID = request.getParameter("toID");    
	    String chatContent = request.getParameter("chatContent");
	    
	    System.out.println("Received: fromID=" + fromID + ", toID=" + toID + ", content=" + chatContent);

	    if(fromID == null || fromID.equals("") || toID == null || toID.equals("")
	            || chatContent == null || chatContent.equals("")) {
	        response.getWriter().write("0");
	    } else if(fromID.equals(toID)) {
	        response.getWriter().write("-1");
	    } else {
	        try {
	            fromID = URLDecoder.decode(fromID, "UTF-8");
	            toID = URLDecoder.decode(toID, "UTF-8");
	            chatContent = URLDecoder.decode(chatContent, "UTF-8");
	            ChatDAO chatDAO = new ChatDAO();
	            int result = chatDAO.submit(fromID, toID, chatContent);
	            System.out.println("ChatDAO submit result: " + result);
	            response.getWriter().write(result + "");
	        } catch (Exception e) {
	            System.out.println("Error in ChatSubmitServlet: " + e.getMessage());
	            e.printStackTrace();
	            response.getWriter().write("Error: " + e.getMessage());
	        }
	    }
	}

}
