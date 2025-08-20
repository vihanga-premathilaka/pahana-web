# Pahana Edu – Web Billing System

A lightweight web app for a Colombo city bookshop to manage **customers, items, billing, and printed invoices**.  
Built with **Java 17, JSP/Servlets, JDBC (MySQL), Maven, Tomcat 9**.

---

## ✨ Features

- 🔐 **Admin login** with session-based access
- 👥 **Customer Management** – add, edit, delete, view
- 📦 **Item Management** – name, price, current stock (CRUD)
- 🧾 **Billing** – multi‑item bill, quantity, line totals, subtotal; **stock decremented** on confirm
- 🔎 **Customer Details** – search by account no./name + full billing history
- 📘 **Help & User Guide** page for end users
- 🎨 **Professional, responsive JSP UI**

---

## 🧱 Architecture

- **Presentation**: JSP + CSS
- **Web**: HttpServlets (`/login`, `/items`, `/editCustomer`, `/billing`, `/customerDetails`, `/help`)
- **Service/DAO**: transaction-safe JDBC
- **DB**: MySQL 8 (XAMPP compatible), InnoDB + FK constraints

## 📂 Project Structure

## 📂 Project Structure

```text
config/
 └─ DBConnection.java
dao/
 ├─ AdminDAO.java
 ├─ CustomerDAO.java
 ├─ ItemDAO.java
 └─ BillingDAO.java
model/
 ├─ Admin.java
 ├─ Customer.java
 ├─ Item.java
 ├─ Bill.java
 └─ BillItem.java
service/
 └─ AuthService.java (and other service classes)
web/
 ├─ LoginServlet.java
 ├─ ItemServlet.java
 ├─ EditCustomerServlet.java
 ├─ BillingServlet.java
 ├─ CustomerDetailsServlet.java
 └─ HelpServlet.java

src/main/webapp/
 ├─ WEB-INF/
 │   └─ web.xml
 ├─ login.jsp
 ├─ dashboard.jsp
 ├─ addCustomer.jsp
 ├─ editCustomer.jsp
 ├─ items.jsp
 ├─ billing.jsp
 ├─ printBill.jsp
 ├─ customer_details.jsp
 └─ help.jsp
``` 


## 🛠 Prerequisites

- **Java 17**
- **Tomcat 9** (or IntelliJ Tomcat runner)
- **MySQL 8** (XAMPP ok)
- **Maven 3.9+**
- **MySQL Connector/J 8.x** (already added via Maven)

---

## 🗄 Database

Create schema **`pahana_edu`** and tables:

- `admin (admin_id, username, password, full_name, email, …)`
- `customers (account_no, name, address, telephone, …)`
- `items (id, name, price, current_stock, …)`
- `bills (bill_id, customer_ac_no, bill_date, subtotal, total, note, …)`
- `bill_items (id, bill_id, item_id, item_name, unit_price, qty, line_total)`

> FKs: `bills.customer_ac_no → customers.account_no`,  
> `bill_items.bill_id → bills.bill_id`, `bill_items.item_id → items.id`.

**Default admin (for first login):**

---

## ▶️ Run (IntelliJ / Tomcat – no terminal)

1. Start **XAMPP MySQL**.
2. Import the schema (phpMyAdmin or MySQL Workbench).
3. Open the project in **IntelliJ**.
4. Add a **Tomcat 9** run configuration:
    - Artifact: `pahana-web:war exploded`
    - Application context: `/pahana-web` (or `/`)
5. Run ▶️ and open:

- Stage on `staging`, perform **regression testing**, then PR to `main`.
- Create **GitHub Release** with tag (e.g., `v1.0.0`).

---

## 🩹 Troubleshooting

- **Cannot connect to DB**: check `DBConnection.java` + MySQL running.
- **JSP EL errors**: ensure IntelliJ uses Tomcat 9 + Servlet API 4.0+.
- **Session not clearing**: verify logout page invalidates session and sets no‑cache headers.

---

## 📄 License

Academic / coursework use. Adapt as required by your institute.
