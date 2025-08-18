package lk.youruni.pahana.service;

import lk.youruni.pahana.dao.AdminDAO;
import lk.youruni.pahana.model.Admin;

public class AuthService {
    private final AdminDAO adminDAO = new AdminDAO();

    public Admin login(String username, String password) throws Exception {
        return adminDAO.findByUsernameAndPassword(username, password);
    }
}
