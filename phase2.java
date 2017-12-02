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
	
    }

    private void displayFriends(Connection dbcon) throws IOException, SQLException
    {
       String sql = "SELECT userID, name1, userID2 as FuserID, name as Fname FROM FRIENDS f join (SELECT userID, name as name1 FROM PROFILE WHERE userID IN (SELECT userID1 FROM FRIENDS WHERE userID2 = '" + cur_user + "') OR userID IN (SELECT userID2 FROM FRIENDS WHERE userID1= '" + cur_user + "')) s ON f.userID1 = s.userID 
	               SELECT userID, name1, userID1 as FuserID, name as Fname FROM FRIENDS f join (SELECT userID, name as name1 FROM PROFILE WHERE userID IN (SELECT userID1 FROM FRIENDS WHERE userID2 = '" + cur_user + "') OR userID IN (SELECT userID2 FROM FRIENDS WHERE userID1= '" + cur_user + "')) s ON f.userID2 = s.userID "; 
        Statement stmt = dbcon.createStatement();

        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
               System.out.println("ID: " + rs.getString("userID"));
                System.out.println("Name: " + rs.getString("name1"));		         System.out.println("FriendID: " + rs1.getString("FuserID"));
                System.out.println("FriendName: " + rs1.getString("Fname"));
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
    }

    private void createGroup(Connection dbcon)throws IOException, SQLException
    {
	  string id = "";
	  string name = "";
	  int limit = 0;
 	  string dct = "";
	  string line = "";
	  string role = "maneger"

	string sql = "SELECT max(gID) as id FROM GROUPS"
	Statement stmt = dbcon.createStatement();
        Statement pstmt= dbcon.prepareStatement("INSERT INTO GROUPS values(?,?,?,?)");
	PrepStatement = dbcon.prepStatement("INSERT INTO GROUPMEMBERSHIP values(?,?,?)");
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

	    dacon.commit();
	
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
	PrepStatement = dbcon.prepStatement("INSERT INTO MESSAGERECIPIENT values(?,?)");


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
      
    }
}
