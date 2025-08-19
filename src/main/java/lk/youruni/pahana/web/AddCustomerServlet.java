package lk.youruni.pahana.web;

import lk.youruni.pahana.dao.CustomerDAO;
import lk.youruni.pahana.model.Customer;
import lk.youruni.pahana.config.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class AddCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // read inputs
        String accountNoStr = req.getParameter("accountNo");
        String name        = req.getParameter("name");
        String address     = req.getParameter("address");
        String telephone   = req.getParameter("telephone");

        int accountNo;
        try {
            accountNo = Integer.parseInt(accountNoStr);
        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Account No must be a number.");
            req.getRequestDispatcher("/addCustomer.jsp").forward(req, resp);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            CustomerDAO dao = new CustomerDAO(con);
            dao.addCustomer(new Customer(accountNo, name, address, telephone));
            // redirect to your list page (use your context path!)
            resp.sendRedirect(req.getContextPath() + "/customers.jsp");
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/addCustomer.jsp").forward(req, resp);
        }
    }
}
