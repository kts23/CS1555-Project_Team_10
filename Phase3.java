import java.sql.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class Phase3{
    
    static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";
    private Connection dbcon; 
    static final String username = "kts23";
    static final String password = "3960791";

    public static void main(String [] args) throws IOException, SQLException {
        DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
        Connection dbcon = DriverManager.getConnection(url, username, password);
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));
        Phase2 func = new Phase2();
        System.out.println("Successfully Connected...");
        System.out.println("Welcome to Social@Panther\nPlease choose a function by entering it's number:");
        System.out.println("1. Create User");
        System.out.println("2. Login");
        System.out.println("3. Send a Friend Request");
        System.out.println("4. Confirm Friend/Group Requests");
        System.out.println("5. Display Friends");
        System.out.println("6. Create a Group");
        System.out.println("7. Join a Group");
        System.out.println("8. Send a message to a user");
        System.out.println("9. Send a message to a group");
        System.out.println("10. Dispaly All Messages");
        System.out.println("11. Display New Messages");
        System.out.println("12. Search for User");
        System.out.println("13. Three Degrees");
        System.out.println("14. Top Messages");
        System.out.println("15. Drop User");
        System.out.println("16. Logout");
        String input = buff.readLine();

        if(input.equals("1"))
        {
            System.out.println("\nName: ");
            String name = buff.readLine();
            System.out.println("Email: ");
            String email = buff.readLine();
            System.out.println("Date of Birth(YYYY-MM-DD): ");
            String bday = buff.readLine();

            func.createUser(dbcon, name, email, bday);
        }
        if(input.equals("2")){
            System.out.println("\nUserID: ");
            String uid = buff.readLine();
            System.out.println("\nPassword: ");
            String pass = buff.readLine();

            func.login(dbcon, uid, pass);
        }
        if(input.equals("3")){
            System.out.println("\nUserID: ");
            String uid = buff.readLine();
            func.initiateFriendship(dbcon, uid);
        }
        if(input.equals("4")){
            func.confirmFriendship(dbcon);
        }
        if(input.equals("5")){
            func.displayFriends(dbcon);
        }
        if(input.equals("6")){
            System.out.println("\n Group Name: ");
            String gname = buff.readLine();
            System.out.println("\nDescription: ");
            String desc = buff.readLine();
            System.out.println("\nlimit: ");
            String limit = buff.readLine();
            func.createGroup(dbcon, gname, desc, Integer.parseInt(limit));
        }
        if(input.equals("7")){
            System.out.println("\nUserID: ");
            String uidg = buff.readLine();
            System.out.println("\ngID: ");
            String gid = buff.readLine();
            func.initiateAddingGroup(dbcon, uidg, Integer.parseInt(gid));
        }
        if(input.equals("8")){
            System.out.println("\nUserID: ");
            String uids = buff.readLine();
            func.sendMessageToUser(dbcon, uids);
        }
        if(input.equals("9")){
            System.out.println("\ngID: ");
            String gids = buff.readLine();
            System.out.println("\nMessage: ");
            String msgs = buff.readLine();
            func.sendMessageToGroup(dbcon, Integer.parseInt(gids), msgs);
        }
        if(input.equals("10")){
            func.displayMessages(dbcon);
        }
        if(input.equals("11")){
            func.displayNewMessages(dbcon);
        }
        if(input.equals("12")){
            System.out.println("\nSearch: ");
            String search = buff.readLine();
            func.searchForUser(dbcon, search);
        }
        if(input.equals("13")){
            System.out.println("\nUserID1: ");
            String uid1 = buff.readLine();
            System.out.println("\nUserID2: ");
            String uid2 = buff.readLine();
            func.threeDegrees(dbcon,uid1,uid2);
        }
        if(input.equals("14")){
            System.out.println("\nk: ");
            String k = buff.readLine();
            System.out.println("\nx: ");
            String x = buff.readLine();
            func.topMessages(dbcon, Integer.parseInt(k), Integer.parseInt(x));
        }
        if(input.equals("15")){
            System.out.println("\nUserID: ");
            String uidd = buff.readLine();
            func.dropUser(dbcon, uidd);
        }
        if(input.equals("16")){
            func.logOut(dbcon);
        }

        //sample input if the if statements don't work just comment them out and run only this
        func.createUser(dbcon, "Keith Sudo", "kts23@pitt.edu", "1996-10-02");
        func.login(dbcon, "hjh84", "pass");
        func.initiateFriendship(dbcon, "wux53");
        func.confirmFriendship(dbcon);
        func.displayFriends(dbcon);
        func.createGroup(dbcon, "test", "This is a test group", 20);
        func.initiateAddingGroup(dbcon, "hjh84", 3);
        func.sendMessageToUser(dbcon, "xwg21");
        func.sendMessageToGroup(dbcon, 1, "Hi");
        func.displayMessages(dbcon);
        func.displayNewMessages(dbcon);
        func.searchForUser(dbcon, "Edmond Micaela");
        func.threeDegrees(dbcon,"lko38","eyi68");
        func.topMessages(dbcon, 10, 24);
        func.dropUser(dbcon, "vbt41");
        func.logOut(dbcon);
        dbcon.close();
        System.out.println("...Closed Connection");
    }
}