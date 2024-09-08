package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/sumate?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String password = "1234"; // 실제 비밀번호로 변경하세요
        return DriverManager.getConnection(url, user, password);
    }
}