package lk.youruni.pahana.web;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class HelpServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Optional: protect with admin session (uncomment to require login)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/help.jsp").forward(req, resp);
    }
}
