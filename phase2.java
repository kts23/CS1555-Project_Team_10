import java.sql.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class phase2 {
    static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";
    private Connection dbcon; 
    static final String username = "kts23";
    static final String password = "3960791";
    static private String cur_user = "xwg21";
    
    public static void main(String [] args) throws IOException, SQLException {
        DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
        Connection dbcon = DriverManager.getConnection(url, username, password);
        System.out.println("Successfully Connected...");
        sendMessageToGroup(dbcon, "1", "Hi");
        threeDegrees(dbcon,"lko38","eyi68");
        dbcon.close();
        System.out.println("...Closed Connection");
    }

    private void createUser(Connection dbcon) throws IOException, SQLException
    {
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());

        string id = "";
        string name = "";
        string email = "";
        string date = "";
        string password = "";
        date dob = null;
        Statement stmt = dbcon.createStatement();
        Statement pstmt= dbcon.prepareStatement("INSERT INTO PROFILE values(?,?,?,?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter string as your name");
        name = buff.readLine();
        System.out.println("Enter string as your email address");
        email = buff.readLine();
        System.out.println("Enter string as your date of brith, such as 2012-02-24");
        date = buff.readLine();
	    id = StringUtils.substringBefore(email, ¡°@¡±);
	    password = id;

        try{
            dob = dateFormat.parse(date);
            java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
                dbcon.setAutoCommit(false);

                pstmt.setString(1, id);
                pstmt.setString(2, name);
                pstmt.setString(3, email);
                pstmt.setString(4, password);
                pstmt.setString(5, dob);
                pstmt.setDate(6, cur_time);

                dbcon.commit();

        }
        catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }   
    }

    private void login(Connection dbcon) throws IOException, SQLException
    {
        string id = "";
        string pw = "";
        string sql = "SELECT password FROM PROFILE WHERE userID = '"+ id +"'";
        statement stmt = dbcon.createStatement();
        
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter your userID");
        id = buff.readLine();
        System.out.println("Enter your password");
        pw = buff.readLine();

        try{
                ResultSet rs = stmt.executeQuery(sql);
                dbcon.setAutoCommit(false);
            if(ps.equals(rs.getString("password"))){
                dacon.commit();
	        }
		}
	    catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{

            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void initiateFriendship(Connection dbcon) throws IOException, SQLException
    {
        string id = "";
        String msg = "";
        string sql = "SELECT userID, name FROM PROFILE WHERE userID = '"+ id +"'";
        statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO PENDINGFRIENDS values(?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter the userID which you want to initiate friendship");
        id = buff.readLine();
	    ResultSet rs = stmt.executeQuery(sql);
	
	    while(re.next()){
	        System.out.println("The userID is: " + rs.getString("userID") + ". The name is: " + rs.getString("name"));	
	    }
        System.out.println("Enter the message");
        msg = buff.readLine();
        while((line = buff.readLine()) != null){
            if(line.isEmpty()){
                break;
            }
            msg = msg + line + "\n";
        }

        try{
            dbcon.setAutoCommit(false);
            
            pstmt.setString(1, cur_user);
            pstmt.setString(2, id);
            pstmt.setString(3, msg);

            dacon.commit();
        
            }
	    catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void confirmFriendship(Connection dbcon) throws IOException, SQLException
    {
	    Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        int count = 0;
	    string id = "";
	    string my_group = "";


        String sel1 = "SELECT gID FROM GROUPMEMBERSHIP WHERE userID ='"+ cur_user +"' AND role = '"manager"'";
        String sel2 = "SELECT fromID, message FROM PENDINGFRIENDS WHERE toID ='"+ cur_user +"'";
        String sel3 = "SELECT fromID, message FROM PENDINGGROUPMEMBERS WHERE gID ='"+ my_group +"'";
        String sql = "DELETE FROM PENDINGFRIENDS WHERE fromID = '"+ id +"' AND toID = '"+ cur_user +"'";
        String query = "DELETE FROM PENDINGGROUPMEMBERS WHERE userID = '"+ id +"' AND gID = '"+ my_group +"'";
        Statement stmt = dbcon.createStatement();
        Statement pstmt= dbcon.prepareStatement("INSERT INTO FRIENDS values(?,?,?,?)");
	    PrepStatement = dbcon.prepStatement("INSERT INTO GROUPMEMBERSHIP values(?,?,?)");

        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
	
        ResultSet rs1 = stmt.executeQuery(sel1);
        if(rs1 != null){
            ResultSet rs2 = stmt.executeQuery(sel2);
            ResultSet rs3 = stmt.executeQuery(sel3);
            System.out.println(count + "rs2.getString("fromID")" + ":" + "rs2.getString("message")");
            count ++;
        }
        
        System.out.println("Enter string as your name");
        name = buff.readLine();
        System.out.println("Enter string as your email address");
        email = buff.readLine();
        System.out.println("Enter string as your date of brith, such as 2012-02-24");
        date = buff.readLine();
        id = StringUtils.substringBefore(email, ¡°@¡±);
        password = id;

	    try{
	  	    dob = dateFormat.parse(date);
		    java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
            dbcon.setAutoCommit(false);

            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            pstmt.setString(4, password);
            pstmt.setString(5, dob);
            pstmt.setDate(6, cur_time);

            dbcon.commit();

		}
	    catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void displayFriends(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT userID, name1, userID2 as FuserID, name as Fname FROM FRIENDS f join (SELECT userID, name as name1 FROM PROFILE WHERE userID IN (SELECT userID1 FROM FRIENDS WHERE userID2 = '" + cur_user + "') OR userID IN (SELECT userID2 FROM FRIENDS WHERE userID1= '" + cur_user + "')) s ON f.userID1 = s.userID " +
	               "SELECT userID, name1, userID1 as FuserID, name as Fname FROM FRIENDS f join (SELECT userID, name as name1 FROM PROFILE WHERE userID IN (SELECT userID1 FROM FRIENDS WHERE userID2 = '" + cur_user + "') OR userID IN (SELECT userID2 FROM FRIENDS WHERE userID1= '" + cur_user + "')) s ON f.userID2 = s.userID "; 
        Statement stmt = dbcon.createStatement();

        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                System.out.println("ID: " + rs.getString("userID"));
                System.out.println("Name: " + rs.getString("name1"));		         
                System.out.println("FriendID: " + rs1.getString("FuserID"));
                System.out.println("FriendName: " + rs1.getString("Fname"));
                System.out.println();
            }
            rs.close();

        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void createGroup(Connection dbcon)throws IOException, SQLException
    {
	  string id = "";
	  string name = "";
	  int limit = 0;
 	  string dct = "";
	  string line = "";
	  string role = "maneger";

	    string sql = "SELECT max(gID) as id FROM GROUPS";
	    Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt= dbcon.prepareStatement("INSERT INTO GROUPS values(?,?,?,?)");
	    PreparedStatement prepStatement = dbcon.prepareStatement("INSERT INTO GROUPMEMBERSHIP values(?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter string as group name");
        name = buff.readLine();
        System.out.println("Enter group description");
        dct = buff.readLine();
        System.out.println("Enter the number of member limitation");
        limit = buff.readLine();
	
	    while((line = buff.readLine()) != null){
            if(line.isEmpty()){
                break;
            }
            dct = dct + line + "\n";
        }

	    try{
	  	    ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                id = Integer.parseInt(rs.getString("id"));
            }
            rs.close();

            dbcon.setAutoCommit(false);

            pstmt.setString(1, Integer.toString(id+1));
            pstmt.setString(2, name);
            pstmt.setString(3, dct);
            pstmt.setString(4, limit);

            prepStatement.setString(1, Integer.toString(id+1)); 
            prepStatement.setString(2, cur_user);
            prepStatement.setString(3, role);

            pstmt.executeUpdate();
            prepStatement.executeUpdate();

            dbcon.commit();

		}
	    catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void initiateAddingGroup(Connection dbcon)throws IOException, SQLException
    {
        string id = "";
        String msg = "";
        string sql = "SELECT g.limit, SUM(m.userID) as cur_member FROM GROUPS g join GROUPMEMBERSHIP m on g.gID = m.gID WHERE gID = '"+ id +"'";
        statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO PENDINGGROUPMEMBERS values(?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter the gID which you want to join in");
        id = buff.readLine();
	    ResultSet rs = stmt.executeQuery(sql);
	
        while(re.next()){
            if(rs.getInt("limit")==re.getInt("cur_member")){
                System.out.println("This group is full");
                break;
            }	
        }
        System.out.println("Enter the message");
        msg = buff.readLine();
        while((line = buff.readLine()) != null){
            if(line.isEmpty()){
                break;
            }
            msg = msg + line + "\n";
        }

	    try{
            dbcon.setAutoCommit(false);
	    
            pstmt.setString(1, id);
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);

            pstmt.executeUpdate();

            dbcon.commit();
	
		}
	    catch(SQLException se){
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    private void sendMessageToUser(Connection dbcon)throws IOException, SQLException
    {
        int id = 0;
        String msg = "";
        String line = "";
	    String toId;
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        String sql = "SELECT max(msgID) as id FROM Messages";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");
	    PreparedStatement prepStatement = dbcon.prepareStatement("INSERT INTO MESSAGERECIPIENT values(?,?)");


        System.out.println("Which userID would you like to send the message to?");
        toId = buff.readLine();
        System.out.println("Enter the message");
        msg = buff.readLine();

        while((line = buff.readLine()) != null){
            if(line.isEmpty()){
                break;
            }
            msg = msg + line + "\n";
        }
        
        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                id = Integer.parseInt(rs.getString("id"));
            }
            rs.close();

            java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
            dbcon.setAutoCommit(false);

            pstmt.setString(1, Integer.toString(id+1));
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);
            pstmt.setString(4, toId);
            pstmt.setString(5, null);
            pstmt.setDate(6, sqlDate);

            prepStatement.setString(1, Integer.toString(id+1)); 
            prepStatement.setString(2, toId);

            pstmt.executeUpdate();
            prepStatement.executeUpdate();

            dbcon.commit();

        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }
        }
    }

    static private void sendMessageToGroup(Connection dbcon, String group, String msg) throws IOException, SQLException
    {
        int id = 0;
        String line = "";
        String sql = "SELECT max(msgID) as id FROM Messages";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");
        
        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                id = rs.getInt("id");
            }
            rs.close();

            java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
            dbcon.setAutoCommit(false);

            pstmt.setInt(1, id+1);
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);
            pstmt.setString(4, null);
            pstmt.setString(5, group);
            pstmt.setDate(6, sqlDate);
            pstmt.executeUpdate();

            dbcon.commit();

            System.out.println("Completed Insert");
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    static private void displayMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

        try{
            ResultSet rs = stmt.executeQuery(sql);
            if(!rs.next())
            {
                System.out.println("There are no messages");
            }
            while(rs.next()){
                System.out.println("From: " + rs.getString("fromID"));
                System.out.println("Msg: " + rs.getString("message"));
                System.out.println("Date Sent: " + df.format(rs.getDate("dateSent")));
                System.out.println();
            }
            rs.close();
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
    }

    static private void displayNewMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        String sql2 = "SELECT lastlogin FROM Profile WHERE userID = '" + cur_user + "'";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

        try{
            ResultSet rs = stmt.executeQuery(sql);
            ResultSet rs2 = stmt.executeQuery(sql2);

            if(!rs.next())
            {
                System.out.println("There are no new messages");
            }

            while(rs.next()){
                if(rs.getTimestamp("lastlogin").compareTo(rs.getDate("dateSent")) <= 0){
                    System.out.println("From: " + rs.getString("fromID"));
                    System.out.println("Msg: " + rs.getString("message"));
                    System.out.println("Date Sent: " + df.format(rs.getDate("dateSent")));
                    System.out.println();
                }
            }
            rs.close();
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    static private void searchForUser(Connection dbcon, String search_input) throws IOException, SQLException
    {
        String sql = " ";
        String [] inputs;
        Statement stmt = dbcon.createStatement();

        inputs = search_input.split(" ");

        for(int i = 0; i < inputs.length; i++){
            if(i == 0){
                sql = "SELECT * FROM Profile WHERE userID = '" + inputs[i] + "' OR name = '" + inputs[i] + "' OR email = '" + inputs[i] + "'"; 
            }
            else{
                sql = sql + "\nUNION\n";
                sql = sql + "SELECT * FROM Profile WHERE userID = '" + inputs[i] + "' OR name = '" + inputs[i] + "' OR email = '" + inputs[i] + "'";
            }
        }
        try{
            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()){
                System.out.println("Username: " + rs.getString("userID"));
                System.out.println("Name: " + rs.getString("name"));
                System.out.println("Email: " + rs.getString("email"));
                System.out.println();
            }
            rs.close();
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    static private void threeDegrees(Connection dbcon, String userA, String userB) throws IOException, SQLException
    {
        String sql = "SELECT v1.f1 as f1, v2.f1 as f2, v3.f1 as f3, v3.f2 as f4 " +
                     "FROM (SELECT * FROM td WHERE f1 = ?) v1 " +
                     "INNER JOIN td v2 ON v1.f2 = v2.f1 " +
                     "INNER JOIN td v3 ON v2.f2 = v3.f1 " + 
                     "WHERE v2.f1 = ? OR v3.f1 = ? OR v3.f2 = ?";
        PreparedStatement stmt = dbcon.prepareStatement(sql);

        try{
            stmt.setString(1, userA);
            stmt.setString(2, userB);
            stmt.setString(3, userB);
            stmt.setString(4, userB);
            ResultSet rs = stmt.executeQuery();

            
            if(!rs.next()){
                System.out.println("No path of 3 hops or less exists between users " + userA + " and " + userB);
            }
            else{
                String f1 = rs.getString("f1");
                String f2 = rs.getString("f2");
                String f3 = rs.getString("f3");
                String f4 = rs.getString("f4");
                System.out.println(f1+" -> "+f2);
                if(f2.compareTo(userB) != 0){
                    System.out.println(" -> " + f3);
                }
                if(f3.compareTo(userB) != 0 && f2.compareTo(userB) != 0){
                    System.out.println(" -> " + f4);
                }
            }
            System.out.println("Completed Insert");
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
    }

    //Can't get the select statement to work for this one. Any advice?
    static private void topMessages(Connection dbcon, int k, int x) throws IOException, SQLException
    {
        java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis() - 3);
        String sql = "SELECT s1.userID as userID, (s1.sent + s2.recv) as tot_msg " +
                     "FROM (SELECT fromID as userID, count(*) as sent FROM Messages WHERE dateSent >= add_months(SYSDATE, -"+ Integer.toString(x) +") GROUP BY fromID) as s1, " +
                     "(SELECT r.userID as userID, count(*) as recv FROM Messages m INNER JOIN MessageRecipient r ON m.msgID = r.msgID " +
                     "WHERE m.dateSent >= add_months(SYSDATE, -"+ Integer.toString(x) +") GROUP BY r.userID) as s2 " +
                     "WHERE s1.userID = s2.userID " +
                     "ORDER BY tot_msg desc" +
                     "FETCH FIRST "+ Integer.toString(k) +" ROWS ONLY";
        Statement stmt = dbcon.createStatement();
        int rank = 0;
        
        System.out.println(sql);

        try{
            ResultSet test = stmt.executeQuery(sqla);
            ResultSet testb = stmt.executeQuery(sqlb);
            ResultSet rs = stmt.executeQuery(sql);
            
            while(rs.next()){
                rank++;
                System.out.println(Integer.toString(rank) + ". " + rs.getString("userID"));
                System.out.print(" #msgs : " + rs.getInt("tot_msg"));
            }
            rs.close();
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    static private void dropUser(Connection dbcon, String user) throws IOException, SQLException
    {
        String newline = System.getProperty("line.separator");
        String sql = "DELETE FROM Profile WHERE userID = '" + user +"'";
        Statement stmt = dbcon.createStatement();
        
        if(user.contains(" ") || user.contains(newline))//prevents sql injection
        {
            System.out.println("Improper userID");
            return;
        }

        try{
            dbcon.setAutoCommit(false);
            stmt.executeUpdate(sql);
            dbcon.commit();
            System.out.println("Successfully Deleted Profile");
        }
        catch(SQLException se){
            se.printStackTrace();
            if(dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    static private void logOut(Connection dbcon) throws IOException, SQLException
    {
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        String sql = "UPDATE Profile "+
                        "SET lastlogin = SYSTIMESTAMP WHERE userID = '" + cur_user +"'";
        Statement stmt = dbcon.createStatement();
        try{
            dbcon.setAutoCommit(false);
            stmt.executeUpdate(sql);
            dbcon.commit();
            System.out.println("Logged Out");
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        System.exit(0);
    }
}
