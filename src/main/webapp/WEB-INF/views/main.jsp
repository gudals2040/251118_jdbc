<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>JDBC</title>
</head>
<body>
<%
    Dotenv dotenv = Dotenv.load();
    String DB_URL = dotenv.get("DB_URL");
    String DB_USER = dotenv.get("DB_USER");
    String DB_PASS = dotenv.get("DB_PASS");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (Exception e) {
        throw new RuntimeException("클래스 로딩 불가");
    }
    try (Connection conn = DriverManager.getConnection(
            DB_URL, // DB URL
            DB_USER, // DB User
            DB_PASS // DB Password
    ); Statement stmt = conn.createStatement()) {
        System.out.println("정상 연결");
        // Query 전달하는 포맷
//            Statement stmt = conn.createStatement();
        System.out.println("테이블 존재 시 삭제");
        stmt.execute("DROP TABLE IF EXISTS jdbc_test;");
        System.out.println("테이블 생성");
        String query = "CREATE TABLE jdbc_test(test_id INT PRIMARY KEY, text VARCHAR(255))";
        stmt.execute(query);
        // 데이터를 INSERT
        int count = stmt.executeUpdate("INSERT INTO jdbc_test VALUES (1, 'Hello'), (2, 'Bye')");
        System.out.println(count + "행만큼 영향 받음");
        // SELECT
        ResultSet rs = stmt.executeQuery("SELECT * FROM jdbc_test");
        while (rs.next()) { // 다음 행을 선택하고, 더 이상 선택할 결과행이 없으면 false.
            System.out.println("ID : " + rs.getInt("test_id"));
            System.out.println("MSG : " + rs.getString("text"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<p>Hi JDBC!</p>
</body>
</html>