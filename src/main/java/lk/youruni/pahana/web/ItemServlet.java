package lk.youruni.pahana.web;

import lk.youruni.pahana.dao.ItemDAO;
import lk.youruni.pahana.model.Item;
import lk.youruni.pahana.config.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class ItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String id = req.getParameter("id");

        try (Connection con = DBConnection.getConnection()) {
            ItemDAO dao = new ItemDAO(con);

            if ("edit".equals(action) && id != null) {
                Item selected = dao.getItem(Integer.parseInt(id));
                req.setAttribute("selectedItem", selected);
            } else if ("delete".equals(action) && id != null) {
                dao.deleteItem(Integer.parseInt(id));
                resp.sendRedirect(req.getContextPath() + "/items");
                return;
            }

            List<Item> items = dao.getAllItems();
            req.setAttribute("items", items);
            req.getRequestDispatcher("/items.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/items.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("itemId");
        String name = req.getParameter("itemName");
        String priceStr = req.getParameter("price");
        String stockStr = req.getParameter("stock");

        try (Connection con = DBConnection.getConnection()) {
            ItemDAO dao = new ItemDAO(con);

            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);

            if (idStr == null || idStr.isEmpty()) {
                dao.addItem(new Item(name, price, stock));
            } else {
                int id = Integer.parseInt(idStr);
                dao.updateItem(new Item(id, name, price, stock));
            }

            resp.sendRedirect(req.getContextPath() + "/items");

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
