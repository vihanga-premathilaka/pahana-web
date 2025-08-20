package lk.youruni.pahana.web;

import lk.youruni.pahana.config.DBConnection;
import lk.youruni.pahana.dao.BillingDAO;
import lk.youruni.pahana.dao.CustomerDAO;
import lk.youruni.pahana.dao.ItemDAO;
import lk.youruni.pahana.model.Bill;
import lk.youruni.pahana.model.BillItem;
import lk.youruni.pahana.model.Customer;
import lk.youruni.pahana.model.Item;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class BillingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // login guard
        HttpSession ses = req.getSession(false);
        if (ses == null || ses.getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String billIdStr = req.getParameter("billId");

        try (Connection con = DBConnection.getConnection()) {
            if ("print".equalsIgnoreCase(action) && billIdStr != null) {
                int billId = Integer.parseInt(billIdStr);
                BillingDAO bdao = new BillingDAO(con);
                Bill bill = bdao.getBillWithItems(billId);
                if (bill == null) {
                    resp.sendRedirect(req.getContextPath() + "/billing?err=Bill+not+found");
                    return;
                }
                req.setAttribute("bill", bill);
                req.getRequestDispatcher("/bill_print.jsp").forward(req, resp);
                return;
            }

            // load customers & items for the form
            CustomerDAO cdao = new CustomerDAO(con);
            ItemDAO idao = new ItemDAO(con);
            List<Customer> customers = cdao.getAllCustomers();
            List<Item> items = idao.listAll();

            req.setAttribute("customers", customers);
            req.setAttribute("items", items);

            req.getRequestDispatcher("/billing.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/billing.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ses = req.getSession(false);
        if (ses == null || ses.getAttribute("ADMIN") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if (!"confirm".equalsIgnoreCase(action)) {
            resp.sendRedirect(req.getContextPath() + "/billing");
            return;
        }

        String customerStr = req.getParameter("customerAccountNo");
        String note = req.getParameter("note");
        String[] itemIds = req.getParameterValues("itemId[]");
        String[] qtys    = req.getParameterValues("qty[]");

        if (customerStr == null || itemIds == null || qtys == null || itemIds.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/billing?err=Please+select+customer+and+at+least+one+item");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            int customerAc = Integer.parseInt(customerStr);

            // Build bill object (prices will be validated server-side)
            Bill bill = new Bill();
            bill.setCustomerAccountNo(customerAc);
            bill.setNote(note);

            List<BillItem> lines = new ArrayList<>();
            for (int i = 0; i < itemIds.length; i++) {
                int itemId = Integer.parseInt(itemIds[i]);
                int qty = Integer.parseInt(qtys[i]);
                if (qty <= 0) continue; // skip zero/negative
                BillItem bi = new BillItem();
                bi.setItemId(itemId);
                bi.setQty(qty);
                lines.add(bi);
            }
            if (lines.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/billing?err=Please+enter+valid+quantities");
                return;
            }
            bill.setItems(lines);

            // Transactional insert + stock update
            BillingDAO bdao = new BillingDAO(con);
            int newBillId = bdao.createBillAndUpdateStock(bill);

            // go to print
            resp.sendRedirect(req.getContextPath() + "/billing?action=print&billId=" + newBillId);

        } catch (Exception e) {
            // back to form with error
            req.setAttribute("error", "Could not confirm bill: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
