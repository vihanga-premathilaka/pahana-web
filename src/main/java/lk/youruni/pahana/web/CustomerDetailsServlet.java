package lk.youruni.pahana.web;

import lk.youruni.pahana.config.DBConnection;
import lk.youruni.pahana.dao.CustomerDetailsDAO;
import lk.youruni.pahana.model.Customer;
import lk.youruni.pahana.model.BillSummary;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class CustomerDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Optional session gate (like other pages)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String q = req.getParameter("q");               // free-text search (acc no or name)
        String accParam = req.getParameter("accountNo"); // direct open

        try (Connection con = DBConnection.getConnection()) {
            CustomerDetailsDAO dao = new CustomerDetailsDAO(con);

            if (accParam != null && !accParam.trim().isEmpty()) {
                // Open a specific customer's details
                int accountNo = Integer.parseInt(accParam);
                Customer c = dao.getCustomer(accountNo);
                if (c != null) {
                    List<BillSummary> bills = dao.getBillsForCustomer(accountNo);
                    req.setAttribute("customer", c);
                    req.setAttribute("bills", bills);
                } else {
                    req.setAttribute("error", "Customer not found for account: " + accountNo);
                }
            } else if (q != null && !q.trim().isEmpty()) {
                // Search list
                List<Customer> results = dao.search(q.trim());
                req.setAttribute("query", q.trim());
                req.setAttribute("results", results);
                if (results.size() == 1) {
                    // auto-open singleton
                    Customer c = results.get(0);
                    List<BillSummary> bills = dao.getBillsForCustomer(c.getAccountNo());
                    req.setAttribute("customer", c);
                    req.setAttribute("bills", bills);
                }
            }

            req.getRequestDispatcher("/customer_details.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading customer details: " + e.getMessage());
            req.getRequestDispatcher("/customer_details.jsp").forward(req, resp);
        }
    }
}
