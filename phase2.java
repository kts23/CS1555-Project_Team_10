import java.sql.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class phase2 {
    static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";
    private Connection dbcon; 
    static final String username = "kts23";
    static final String password = "3960791";
    static private String cur_user = "hwp59";
    
    public static void main(String [] args){
        DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
        Connection dbcon = DriverManager.getConnection(url, username, password);
        displayMessages(dbcon);
    }

    private void createUser(Connection dbcon)
    {

    }

    private void login(Connection dbcon)
    {

    }

    private void initiateFriendship(Connection dbcon)
    {

    }

    private void confirmFriendship(Connection dbcon)
    {

    }

    private void displayFriends(Connection dbcon)
    {

    }

    private void createGroup(Connection dbcon)
    {

    }

    private void initiateAddingGroup(Connection dbcon)
    {

    }

    private void sendMessageToUser(Connection dbcon)
    {

    }

    private void sendMessageToGroup(Connection dbcon) throws IOException, SQLException
    {
        int id = 0;
        String msg = "";
        String line = "";
        String group;
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        String sql = "SELECT max(msgID) as id FROM Messages";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");


        System.out.println("Which group would you like to send the message to?");
        group = buff.readLine();

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
            pstmt.setString(4, null);
            pstmt.setString(5, group);
            pstmt.setDate(6, sqlDate);

            dbcon.commit();

        }
        catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    JDBCTutorialUtilities.printSQLException(excep);
                }
            }
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
    }

    static private void displayMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

        System.out.println("IN function");

        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                System.out.println("From: " + rs.getString("fromID"));
                System.out.println("Msg: " + rs.getString("message"));
                System.out.println("Date Sent: " + df.format(rs.getDate("dateSent")));
                System.out.println();
            }
            rs.close();

        }
        catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
        
    }

    private void displayNewMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        String sql2 = "SELECT lastlogin FROM Profile WHERE userID = '" + cur_user + "')";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

        try{
            ResultSet rs = stmt.executeQuery(sql);
            ResultSet rs2 = stmt.executeQuery(sql2);

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
            //Handle errors for JDBC
            se.printStackTrace();
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
    }

    private void searchForUser(Connection dbcon) throws IOException, SQLException
    {
        String sql = " ";
        String search_input;
        String [] inputs;
        Statement stmt = dbcon.createStatement();
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter string to seach users by");
        search_input = buff.readLine();
        inputs = search_input.split(" ");

        for(int i = 0; i < inputs.length; i++){
            if(i == 0){
                sql = "SELECT * FROM Profiles WHERE userID = '" + inputs[i] + "' OR name = '" + inputs[i] + "' OR email = '" + inputs[i] + "'"; 
            }
            else{
                sql = sql + "\nUNION\n";
                sql = sql + "SELECT * FROM Profiles WHERE userID = '" + inputs[i] + "' OR name = '" + inputs[i] + "' OR email = '" + inputs[i] + "'";
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
            //Handle errors for JDBC
            se.printStackTrace();
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
    }

    private void threeDegrees(Connection dbcon, String userA, String userB) throws IOException, SQLException
    {
        String sql = " ";
        Statement stmt = dbcon.createStatement();
        
    }

    private void topMessages(Connection dbcon, int k, int x) throws IOException, SQLException
    {
        String sql = "SELECT prof.userID, count(*) as totSent FROM Profiles as prof INNER JOIN Messages as msg ON prof.userID = msg.fromID ";
        Statement stmt = dbcon.createStatement();
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
            //Handle errors for JDBC
            se.printStackTrace();
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
    }

    private void dropUser(Connection dbcon, String user) throws IOException, SQLException
    {
        String sql = "SELECT max(msgID) as id FROM Messages";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");
        
        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                id = Integer.parseInt(rs.getString("id"));
            }
            rs.close();

            dbcon.setAutoCommit(false);

            pstmt.setString(1, Integer.toString(id+1));
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);
            pstmt.setString(4, null);
            pstmt.setString(5, group);
            pstmt.setDate(6, sqlDate);

            dbcon.commit();

        }
        catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
            if(dbcon != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    JDBCTutorialUtilities.printSQLException(excep);
                }
            }
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
    }

    private void logOut(Connection dbcon) throws IOException, SQLException
    {
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        String sql = "UPDATE Profiles "+
                        "SET lastlogin = '" + cur_time +"' WHERE userID = '" + cur_user +"'";
        Statement stmt = dbcon.createStatement();
        try{
            dbcon.setAutoCommit(false);
            stmt.executeUpdate(sql);
            dbcon.commit();
        }
        catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
            if (con != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    con.rollback();
                } catch(SQLException excep) {
                    JDBCTutorialUtilities.printSQLException(excep);
                }
            }
        }
        catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    dbcon.close();
            }catch(SQLException se){
            }// do nothing
            try{
                if(dbcon!=null)
                    dbcon.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
        System.exit(0);
    }
}
