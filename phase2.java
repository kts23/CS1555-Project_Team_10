import java.sql.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class Phase2{

    private String cur_user = "xwg21";
    
    public void createUser(Connection dbcon, String name, String email, String dob) throws IOException, SQLException
    {
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt= dbcon.prepareStatement("INSERT INTO PROFILE values(?,?,?,?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        String sql;
        String id;
        String pswd = " ";
        String beginning;
        int num = 0;
        int fail = 0;
        
        //This part Generates a unique userID
        if(name.length() < 3){
            beginning = name;
        }
        else{
            beginning = name.substring(0, 3);
        }
        id = beginning +  Integer.toString(num);
        sql = "SELECT * FROM PROFILE WHERE userId = '" + id + "'"; 

        while(fail == 0){
            try{
                fail = 0;
                ResultSet rs = stmt.executeQuery(sql);
                //This checks that the userID generated is unique and changes the ID if it's not
                if(rs != null){
                    while(rs.next())
                    {
                        num++;
                        id = beginning + num;
                        sql = "SELECT * FROM PROFILE WHERE userId = '" + id + "'"; 
                        rs = stmt.executeQuery(sql);
                    }
                }
                pswd = id;

                //Inserts the new user to the database
                java.util.Date java_dob = df.parse(dob);
                java.sql.Date sql_dob = new java.sql.Date(java_dob.getTime());
                dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                dbcon.setAutoCommit(false);

                pstmt.setString(1, id);
                pstmt.setString(2, name);
                pstmt.setString(3, email);
                pstmt.setString(4, pswd);
                pstmt.setDate(5, sql_dob);
                pstmt.setDate(6, null);
                pstmt.execute();

                dbcon.commit();

            }
            catch(SQLException se){
                if (dbcon != null) {
                    try {
                        System.err.println("Transaction is being rolled back");
                        dbcon.rollback();
                        fail = 1;
                    } catch(SQLException excep) {
                        excep.printStackTrace();
                    }
                }
                if(se.getErrorCode() == 1)
                {
                    System.out.println("There is already an account associated with the email address: " + email);
                    System.out.println("Please enter a different eamil: ");
                    email = buff.readLine();
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        if (fail == 0)
        {
            System.out.println("User has been successfully created with \nID: " + id);
            System.out.println("Password: " + pswd);
        }
    }

    public void login(Connection dbcon, String id, String pswd) throws IOException, SQLException
    {
        String sql = "SELECT * FROM PROFILE WHERE userID = '"+ id +"' AND password = '" + pswd +"'";
        Statement stmt = dbcon.createStatement();

        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next())
            {
                cur_user = id;
                System.out.println("Successfully Logged in...");
                System.out.println("Welcome " + rs.getString("name"));
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    public void initiateFriendship(Connection dbcon, String id) throws IOException, SQLException
    {
        String msg = "";
        String sql = "SELECT userID, name FROM PROFILE WHERE userID = '"+ id +"'";
        String sel = "SELECT * FROM Friends WHERE userID1 = '"+ cur_user +"' AND userID2 = '" + id +"' OR userID1 = '" + id + "' AND userID2 = '" + cur_user + "'";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO PENDINGFRIENDS values(?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        int exist = 0;
        String confirm;
        ResultSet rs = stmt.executeQuery(sql);
        String line = "";
        String name = "";
        int fail = 0;
    
        //if the user exists
        while(rs.next()){
            System.out.println("The userID is: " + rs.getString("userID") + "\nThe name is: " + rs.getString("name"));
            name = rs.getString("name");
            exist = 1;	
        }
        if(exist == 0){
            System.out.println("The user with id = " + id + " does not exist\nExiting Method...");
            return;
        }
        
        ResultSet rs2 = stmt.executeQuery(sel);
        while(rs2.next())
        {
            System.out.println("You are already friends with " + name);
            return;
        }

        System.out.println("Enter a message to send along with the request");
        msg = buff.readLine();
        while((line = buff.readLine()) != null){
            if(line.isEmpty()){
                break;
            }
            msg = msg + line + "\n";
        }
        //checks for confimation from the user that they want to send the request
        System.out.println("Would you like to send a friend request to " + name + "\n With message: " + msg);
        System.out.println("Please enter yes or no:");
        confirm = buff.readLine();

        //if they say no: exit the function
        if(confirm == "no")
        {
            System.out.println("Denial confirmed. Exiting method...");
            return;
        }

        try{
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); //makes it so that multiple inserts can be made at the same time
            dbcon.setAutoCommit(false);
            
            pstmt.setString(1, cur_user);
            pstmt.setString(2, id);
            pstmt.setString(3, msg);
            pstmt.execute();

            dbcon.commit();
        
        }
        catch(SQLException se){
            if(se.getErrorCode() == 1)
            {
                System.out.println("You have already sent a friend request to " + id);
            }
            fail = 1;
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        if(fail == 0)
        {
            System.out.println("Request Successfully Sent");
        }
    }

    public void confirmFriendship(Connection dbcon) throws IOException, SQLException
    {
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        int count = 0;
        String id = "";
        String my_group = "";


        String sel1 = "SELECT gID FROM GROUPMEMBERSHIP WHERE userID = '"+ cur_user +"' AND role = 'manager'";
        String sel2 = "SELECT fromID, message FROM PENDINGFRIENDS WHERE toID = '"+ cur_user +"'";
        String sel3;
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO FRIENDS values(?,?,?,?)");
        PreparedStatement prep = dbcon.prepareStatement("INSERT INTO GROUPMEMBERSHIP(gID, userID) values(?,?)");
        PreparedStatement del_pf = dbcon.prepareStatement("DELETE FROM PENDINGFRIENDS WHERE fromID = ? AND toID = ?");
        PreparedStatement del_pg = dbcon.prepareStatement("DELETE FROM PENDINGGROUPMEMBERS WHERE userID = ? AND gID = ?");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        int group;
        String [] friends;
        String [] members;
        ArrayList<String> new_friends = new ArrayList<String>();
        ArrayList<String> new_members = new ArrayList<String>();
    
        
        //gets all of the pending friend requests
        ResultSet rs2 = stmt.executeQuery(sel2);
        System.out.println("Friend Requests: ");
        if(rs2 != null)
        {
            while(rs2.next()){
                System.out.println(Integer.toString(count) +  ". " + rs2.getString("fromID") + ": " + rs2.getString("message"));
                new_friends.add(count,rs2.getString("fromID") + "|" + rs2.getString("message"));//stores pending friend requests in an array
                count++;
            }
        }
        if(count == 0){
            System.out.println("You do not currently have any Friend requests");
        }
        
        //if the current user is a manager of a group:
        //print out all the pending group requests for those groups
        ResultSet rs1 = stmt.executeQuery(sel1);
        group = count; //group variable keeps track of which index numbers refer to group requests
        if(rs1 != null){
            while(rs1.next()){
                if(group == count){
                    System.out.println("Group Requests: ");
                }
                sel3 = "SELECT userID, message FROM PENDINGGROUPMEMBERS WHERE gID = '"+ rs1.getInt("gID") +"'";
                ResultSet rs3 = stmt.executeQuery(sel3);
                while(rs3.next())
                {
                    System.out.println(Integer.toString(count) +  ". " + rs2.getString("userID") + ": " + rs2.getString("message"));
                    new_members.add(count-group, rs2.getString("userID")+":"+ Integer.toString(rs1.getInt("gID"))); //stores pending group requests in an array
                    count ++;
                }
            }
        }
        if(group == count){
            System.out.println("There are currently no group requests");
        }

        if(count == 0){
            return;
        }

        friends = new String[new_friends.size()];
        members = new String[new_members.size()];
        friends = new_friends.toArray(friends);
        members = new_members.toArray(members);

        //asks the users for the requests that they want to accept
        System.out.println("Enter the number of the requests you want to accept. Each number should be seperated by a comma (ex. 1,2,3,4,5...)");
        String accepted = buff.readLine();

        //stores the index numbers of the accepted requests in an array
        String[] parts = accepted.split(",");
        int[] nums_accepted = new int[parts.length];
        for(int i = 0; i < parts.length; i ++){
            nums_accepted[i] = Integer.parseInt(parts[i]);
        }

        try{

            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            dbcon.setAutoCommit(false);
            java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());

            for(int i = 0; i < nums_accepted.length; i++)
            {
                if(nums_accepted[i] < group)//inserts accepted friends into the firends table
                {
                    String[] parts2 = friends[nums_accepted[i]].split("|");
                    pstmt.setString(1, cur_user);
                    pstmt.setString(2, parts2[0]);
                    pstmt.setDate(3, sqlDate);
                    pstmt.setString(4, parts2[1]);
                    pstmt.execute();
                }
                if(nums_accepted[i] >= group){ //inserts accepted group members into the groupmembers table
                    String[] parts3 = members[nums_accepted[i]-group].split(":");
                    prep.setInt(1, Integer.parseInt(parts3[1]));
                    prep.setString(2, parts3[0]);
                    prep.execute();
                }
            }
            for(int i = 0; i < friends.length; i++) //deletes all pending friend requests for the user
            {
                String[] partsdf = friends[i].split("|");
                del_pf.setString(1, partsdf[0]);
                del_pf.setString(2, cur_user);
                del_pf.execute();
            }
            for(int i = 0; i < members.length; i++) //deletes all pending group requests for the group
            {
                String[] partsdg = members[i].split(":");
                del_pg.setString(1, partsdg[0]);
                del_pg.setInt(2, Integer.parseInt(partsdg[1]));
                del_pg.execute();
            }
            dbcon.commit();
        }
        catch(SQLException se){
            if(se.getErrorCode() == 1)
            {
                System.out.println("You are either already friends with one of these people or they are already part of the group");
            }
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
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


    public void displayFriends(Connection dbcon) throws IOException, SQLException
    {
        int exist = 0;
        String select = "0";
        String sql = "SELECT userID, name FROM PROFILE WHERE userID IN (SELECT userID1 FROM FRIENDS WHERE userID2 = '" + cur_user + "') OR userID IN (SELECT userID2 FROM FRIENDS WHERE userID1= '" + cur_user + "')"; 
        String sql2 = "SELECT userID, name, date_of_birth FROM PROFILE WHERE userID = '"+ select +"'";
        Statement stmt = dbcon.createStatement();
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("\nFriends: ");
        
        do{	
            if(select.equals("0")){
                //show the main menu
                ResultSet rs = stmt.executeQuery(sql);
                if(!rs.next())
                {
                    System.out.println("You do not have friends");
                }

                while(rs.next()){
                    System.out.println("ID: " + rs.getString("userID"));
                    System.out.println("Name: " + rs.getString("name"));
                    ResultSet rs1 = stmt.executeQuery(sql);
                    
                    if(!rs.next())
                    {
                        System.out.println("He/She does not have friends");
                    }

                    while(rs1.next()){	         
                        System.out.println("FriendID: " + rs1.getString("UserID"));
                        System.out.println("FriendName: " + rs1.getString("name"));
                        System.out.println();
                    }	
                    rs1.close();
                    System.out.println("\n");
                }
                rs.close();
            }

            System.out.println("Please enter the UserID you want to see or enter number 0 to return main menu:");
            select = buff.readLine();
            sql2 = "SELECT userID, name, date_of_birth FROM PROFILE WHERE userID = '"+ select +"'";
            ResultSet rs2 = stmt.executeQuery(sql2);
            
            //if the user exists
            while(rs2.next()){
                System.out.println("The userID is: " + rs2.getString("userID") + "\n The name is: " + rs2.getString("name") + "\n The date of birth is: " + rs2.getString("date_of_birth"));
                exist = 1;	
            }
            
            if(select.equals("0")){
                System.out.println("Return to the main menu...");
                return;
            }

            if(exist == 0){
                System.out.println("The user does not exist\nExiting Method...");
                return;
            }
        }while(true);
    }

    
    public void createGroup(Connection dbcon, String name, String dct, int limit)throws IOException, SQLException
    {
        int id = 0;
        String role = "manager";

        String sql = "SELECT max(gID) as id FROM GROUPS";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt= dbcon.prepareStatement("INSERT INTO GROUPS values(?,?,?,?)");
        PreparedStatement prepStatement = dbcon.prepareStatement("INSERT INTO GROUPMEMBERSHIP values(?,?,?)");
        int fail = 0;

        try{
            ResultSet rs = stmt.executeQuery(sql);
                while(rs.next()){
                id = rs.getInt("id");
            }
            rs.close();

            dbcon.setAutoCommit(false);
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            pstmt.setInt(1, id+1);
            pstmt.setString(2, name);
            pstmt.setString(3, dct);
            pstmt.setInt(4, limit);

            prepStatement.setInt(1, id+1); 
            prepStatement.setString(2, cur_user);
            prepStatement.setString(3, role);

            pstmt.executeUpdate();
            prepStatement.executeUpdate();

            dbcon.commit();

        }
        catch(SQLException se){
            se.printStackTrace();
            fail = 1;
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        if(fail == 0){
            System.out.println("Successfully created group " + name);
        }
    }

    
    public void initiateAddingGroup(Connection dbcon, String uid, int gid)throws IOException, SQLException
    {
        String msg = "";
        String line = "";
        String sql = "SELECT g.limit, SUM(m.userID) as cur_member FROM GROUPS g INNER JOIN GROUPMEMBERSHIP m ON g.gID = m.gID WHERE g.gID = "+ gid +" GROUP BY g.limit";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO PENDINGGROUPMEMBERS values(?,?,?)");
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        int fail = 0;
        ResultSet rs = stmt.executeQuery(sql);
    
        while(rs.next()){
            if(rs.getInt("limit")==rs.getInt("cur_member")){
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
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        
            pstmt.setInt(1, gid);
            pstmt.setString(2, uid);
            pstmt.setString(3, msg);

            pstmt.executeUpdate();

            dbcon.commit();
    
        }
        catch(SQLException se){
            fail = 1;
            if(se.getErrorCode() == 1){
                System.out.println("You have already requested to join this group");
            }
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        if (fail == 0)
        {
            System.out.println("You successfully requested to join the group");
        }
    }

    
    public void sendMessageToUser(Connection dbcon, String uId)throws IOException, SQLException
    {
        int id = 0;
        String msg = "";
        String line = "";
        int exist = 0;
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        String sql = "SELECT max(msgID) as id FROM Messages";
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");
        String sql2 = "SELECT userID, name FROM PROFILE WHERE userID = '"+ uId +"'";
        int fail = 0;

        ResultSet rs1 = stmt.executeQuery(sql2);
        //if the user exists
        while(rs1.next()){
            System.out.println("The userID is: " + rs1.getString("userID") + "\n The name is: " + rs1.getString("name"));
            exist = 1;	
        }
        if(exist == 0){
            System.out.println("The user with id = " + id + " does not exist\nExiting Method...");
            return;
        }

        System.out.println("Enter the message");
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
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            dbcon.setAutoCommit(false);
            

            pstmt.setInt(1, id+1);
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);
            pstmt.setString(4, uId);
            pstmt.setString(5, null);
            pstmt.setDate(6, sqlDate);
            

            pstmt.executeUpdate();

            dbcon.commit();

        }
        catch(SQLException se){
            fail = 1;
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        if(fail == 0)
        {
            System.out.println("Message Successfully Sent");
        }
    }    

    //Don't edit past this part. All these functions work correctly
    public void sendMessageToGroup(Connection dbcon, int gid, String msg) throws IOException, SQLException
    {
        int id = 0;
        String line = "";
        String sql = "SELECT max(msgID) as id FROM Messages";
        String sel = "SELECT userID FROM GROUPMEMBERSHIP WHERE gID = " + Integer.toString(gid);
        Statement stmt = dbcon.createStatement();
        PreparedStatement pstmt = dbcon.prepareStatement("INSERT INTO MESSAGES values(?,?,?,?,?,?)");
        int in_group = 0;
        
        try{
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()){
                id = rs.getInt("id");
            }
            rs.close();

            ResultSet rs1 = stmt.executeQuery(sel);
            if(rs1 != null)
            
            while(rs1.next())
            {
                if(cur_user.equals(rs1.getString("userID"))){
                    in_group = 1;
                }
            }
            rs1.close();

            if(in_group == 0){
                System.out.println("Sorry you can't send a message to this group since you are not a member");
                return;
            }

            java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            dbcon.setAutoCommit(false);

            pstmt.setInt(1, id+1);
            pstmt.setString(2, cur_user);
            pstmt.setString(3, msg);
            pstmt.setString(4, null);
            pstmt.setInt(5, gid);
            pstmt.setDate(6, sqlDate);
            pstmt.executeUpdate();

            dbcon.commit();

            System.out.println("Completed Insert");
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    dbcon.rollback();
                } catch(SQLException excep) {
                    excep.printStackTrace();
                }
            }
            System.out.println("Message Failed to Send");
        }
        catch(Exception e){
            e.printStackTrace();
        }
        System.out.println("Message was successfully sent");
    }

    public void displayMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        int count = 0;

        try{
            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()){
                System.out.println("From: " + rs.getString("fromID"));
                System.out.println("Msg: " + rs.getString("message"));
                System.out.println("Date Sent: " + df.format(rs.getDate("dateSent")));
                System.out.println();
                count ++;
            }
            rs.close();

            if(count == 0)
            {
                System.out.println("There are no messages");
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public void displayNewMessages(Connection dbcon) throws IOException, SQLException
    {
        String sql = "SELECT * FROM Messages WHERE msgID IN (SELECT msgID FROM MessageRecipient WHERE userID = '" + cur_user + "' )";
        String sql2 = "SELECT lastlogin FROM Profile WHERE userID = '" + cur_user + "'";
        Statement stmt = dbcon.createStatement();
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        int count = 0;

        try{
            ResultSet rs = stmt.executeQuery(sql);
            ResultSet rs2 = stmt.executeQuery(sql2);


            while(rs.next()){
                if(rs.getTimestamp("lastlogin").compareTo(rs.getDate("dateSent")) <= 0){
                    System.out.println("From: " + rs.getString("fromID"));
                    System.out.println("Msg: " + rs.getString("message"));
                    System.out.println("Date Sent: " + df.format(rs.getDate("dateSent")));
                    System.out.println();
                    count++;
                }
            }
            rs.close();

            if(count == 0)
            {
                System.out.println("There are no new messages");
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    public void searchForUser(Connection dbcon, String search_input) throws IOException, SQLException
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

    public void threeDegrees(Connection dbcon, String userA, String userB) throws IOException, SQLException
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
                System.out.print(f1+" -> "+f2);
                if(f2.compareTo(userB) != 0){
                    System.out.print(" -> " + f3);
                }
                if(f3.compareTo(userB) != 0 && f2.compareTo(userB) != 0){
                    System.out.print(" -> " + f4);
                }
            }
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
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

    public void topMessages(Connection dbcon, int k, int x) throws IOException, SQLException
    {
        java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis() - 3);
        String sql = "SELECT s1.userID as userID, (s1.sent + s2.recv) as tot_msg " +
                     "FROM (SELECT fromID as userID, count(*) as sent FROM Messages WHERE dateSent >= add_months(SYSDATE, -"+ Integer.toString(x) +") GROUP BY fromID) s1, " +
                     "(SELECT r.userID as userID, count(*) as recv FROM Messages m INNER JOIN MessageRecipient r ON m.msgID = r.msgID " +
                     "WHERE m.dateSent >= add_months(SYSDATE, -"+ Integer.toString(x) +") GROUP BY r.userID) s2 " +
                     "WHERE s1.userID = s2.userID " +
                     "ORDER BY tot_msg desc " +
                     "FETCH FIRST "+ Integer.toString(k) +" ROWS ONLY";
        Statement stmt = dbcon.createStatement();
        int rank = 0;

        try{
            ResultSet rs = stmt.executeQuery(sql);
            
            while(rs.next()){
                rank++;
                System.out.println();
                System.out.print(Integer.toString(rank) + ". " + rs.getString("userID"));
                System.out.println(" #msgs : " + rs.getInt("tot_msg"));
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

    public void dropUser(Connection dbcon, String user) throws IOException, SQLException
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
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            dbcon.setAutoCommit(false);
            stmt.executeUpdate(sql);
            dbcon.commit();
            System.out.println("\nSuccessfully Deleted Profile");
        }
        catch(SQLException se){
            se.printStackTrace();
            if(dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
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

    public void logOut(Connection dbcon) throws IOException, SQLException
    {
        Timestamp cur_time = new Timestamp(System.currentTimeMillis());
        String sql = "UPDATE Profile "+
                        "SET lastlogin = SYSTIMESTAMP WHERE userID = '" + cur_user +"'";
        Statement stmt = dbcon.createStatement();
        try{
            dbcon.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            dbcon.setAutoCommit(false);
            stmt.executeUpdate(sql);
            dbcon.commit();
            System.out.println("\nLogged Out");
        }
        catch(SQLException se){
            se.printStackTrace();
            if (dbcon != null) {
                try {
                    System.err.println("Transaction is being rolled back");
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