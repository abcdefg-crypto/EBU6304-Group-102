// ==================== fx/LoginController.java ====================
package dev.fx;

import javafx.fxml.FXML;
import javafx.scene.control.*;

public class LoginController {
    @FXML private TextField usernameField;
    @FXML private PasswordField passwordField;
    @FXML private Button loginButton;

    public void onLoginClicked() {
        // TODO: 使用 HttpClient 调用 AuthServlet，异步处理结果
    }
}

