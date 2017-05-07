/* ex.9-2 更新SQL文(UPDATE)を発行してテーブルのデータを更新するJavaプログラム */
import java.sql.*;

public class ex_9_2 {
     public static void main(String[] args) throws Exception {

          /* 1) PostgreSQLへの接続情報 */
          Connection con;
          Statement st;

          String url = "jdbc:postgresql://localhost:5432/shop";
          String user = "postgres";
          String password = args[0];

          /* 2) JDBCドライバの定義 */
          Class.forName("org.postgresql.Driver");

          /* 3) PostgreSQLへの接続 */
          con = DriverManager.getConnection(url, user, password);
          st = con.createStatement();

          /* 4) UPDATE文の実行 */
          /* 5) 結果の画面表示 */
          int updcnt = st.executeUpdate("UPDATE Shohin SET shohin_mei =  'Yシャツ' WHERE shohin_id = '0001'");
          System.out.println(updcnt + "行更新されました");

          /* 6) PostgreSQLとの接続を切断 */
          st.close();
          con.close();
     }
}
