package lk.youruni.pahana.web;

import lk.youruni.pahana.dao.CustomerDAO;
import lk.youruni.pahana.model.Customer;
import lk.youruni.pahana.config.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class EditCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null || req.getSession(false).getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String accountNoParam = req.getParameter("accountNo");
        String action = req.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {
            CustomerDAO dao = new CustomerDAO(con);

            // If delete requested
            if ("delete".equals(action) && accountNoParam != null) {
                try {
                    int acc = Integer.parseInt(accountNoParam);
                    dao.deleteByAccountNo(acc);
                    resp.sendRedirect(req.getContextPath() + "/editCustomer");
                    return;
                } catch (NumberFormatException nfe) {
                    req.setAttribute("error", "Invalid account number.");
                }
            }

            // Table data
            List<Customer> customers = dao.getAllCustomers();
            req.setAttribute("customers", customers);

            // If user clicked Edit
            if ("edit".equals(action) && accountNoParam != null && !accountNoParam.trim().isEmpty()) {
                try {
                    int acc = Integer.parseInt(accountNoParam);
                    Customer c = dao.getCustomer(acc);
                    if (c != null) {
                        req.setAttribute("selectedCustomer", c);
                    } else {
                        req.setAttribute("error", "Customer not found for account: " + acc);
                    }
                } catch (NumberFormatException ignore) {
                    req.setAttribute("error", "Invalid account number.");
                }
            }

            req.getRequestDispatcher("/editCustomer.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading customers: " + e.getMessage());
            req.getRequestDispatcher("/editCustomer.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null || req.getSession(false).getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String accountNoStr = req.getParameter("accountNo");
        String name = req.getParameter("name");
        String address = req.getParameter("address");
        String telephone = req.getParameter("telephone");

        int accountNo;
        try {
            accountNo = Integer.parseInt(accountNoStr);
        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Account No must be a number.");
            doGet(req, resp);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            CustomerDAO dao = new CustomerDAO(con);
            dao.updateCustomer(new Customer(accountNo, name, address, telephone));
            resp.sendRedirect(req.getContextPath() + "/editCustomer");
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
