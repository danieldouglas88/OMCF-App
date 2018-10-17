<%@  Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Assembly Name="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    
void SendEmail(Object sender, EventArgs e) {
         Button clickedButton = (Button)sender;
     SqlConnection SQLCON = new SqlConnection("Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes");
        SQLCON.Open();
        SqlCommand SQLCommand = new SqlCommand("SELECT commentBox FROM NotePad WHERE userName = @username",SQLCON);
        SQLCommand.Parameters.AddWithValue("@username", User.Identity.Name);
    
    try {
        String comment = (String) SQLCommand.ExecuteScalar();
        SQLCON.Close();

int i = 8; string userNames = ""; 
while (i < User.Identity.Name.Length) { userNames = userNames + User.Identity.Name[i]; i++; }

try{
userNames = userNames.Substring(0, userNames.IndexOf("-"));

if (userNames == "-1"){
i = 8; userNames = ""; 
while (i < User.Identity.Name.Length) { userNames = userNames + User.Identity.Name[i]; i++; }
} 
}catch (Exception) {
//
}
                String shortDate = DateTime.Now.ToShortDateString();
            String timeDate = DateTime.Now.ToString("h:mm tt");
            System.Net.Mail.MailAddress emailVar = new System.Net.Mail.MailAddress("POSRequests@r-u-i.com");
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("mail.r-u-i.com");
            message.To.Add(userNames + "@r-u-i.com");
            message.Subject = "Your OMCF notes requested on "  + shortDate + " at " + timeDate;
            message.From = emailVar;
            message.Body = "Your NotePad notes: \n" + comment;
            smtp.Send(message);


            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('Your notes have been emailed to you.');}", true);
    } catch (Exception ex) {
                Response.Write(string.Format("Error in SaveToDatabase {0}", ex.Message));
            }
    }

    void LoadData(Object sender, EventArgs e) {
         Button clickedButton = (Button)sender;
     SqlConnection SQLCON = new SqlConnection("Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes");
        SQLCON.Open();
        SqlCommand SQLCommand = new SqlCommand("SELECT commentBox FROM NotePad WHERE userName = @username",SQLCON);
        SQLCommand.Parameters.AddWithValue("@username", User.Identity.Name);
        
        try {
        String comment = (String) SQLCommand.ExecuteScalar();
        SQLCON.Close();
        textBoxOne.Text = comment;
        }   catch (Exception ex) {
                Response.Write(string.Format("Error in SaveToDatabase {0}", ex.Message));
            }
    }

        void ClearData(Object sender, EventArgs e)
    {
        Button clickedButton = (Button)sender;
        ClearNote();
        textBoxOne.Text = "";
    }
    
    
    void GreetingBtn_Click(Object sender, EventArgs e)
    {
	Button clickedButton = (Button)sender;
	SaveToDataBase(); 
    }

    void SaveToDataBase()
    {
    string connectionString = "Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes";
        
    string query = @"IF EXISTS(SELECT * FROM NotePad WHERE userName = @username)UPDATE NotePad SET commentBox = @commentBox Where userName = @username ELSE INSERT INTO NotePad(userName, commentBox) VALUES(@username, @commentBox);";

    // create connection and command in "using" blocks
    using (SqlConnection conn = new SqlConnection(connectionString))
    using (SqlCommand cmd = new SqlCommand(query, conn))
    {
        try {
        cmd.Parameters.AddWithValue("@username", User.Identity.Name);
        cmd.Parameters.AddWithValue("@commentBox", textBoxOne.Text);

        // open connection, execute query, close connection
        conn.Open();
        
        int rowsAffected = cmd.ExecuteNonQuery();
        conn.Close();
        
        ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('Your note has been saved.');}", true); 
        }  catch (Exception ex) {
                Response.Write(string.Format("Error in SaveToDatabase {0}", ex.Message));
            } 
    }
    }
    
        void ClearNote()
    {
            System.Data.SqlClient.SqlConnection sqlConnection1 = 
            new System.Data.SqlClient.SqlConnection("Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes");

            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = "UPDATE NotePad SET commentBox = @commentBox Where userName = @requestID";

            cmd.Parameters.AddWithValue("@requestID", User.Identity.Name);
            cmd.Parameters.AddWithValue("@commentBox", "");

            cmd.Connection = sqlConnection1;

            sqlConnection1.Open();
        
        try {
            cmd.ExecuteNonQuery();
            sqlConnection1.Close();
        
            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('Your note has been cleared.');}", true);
        }  catch (Exception ex) {
                Response.Write(string.Format("Error in SaveToDatabase {0}", ex.Message));
            } 
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>OMCF NotePad</title>

    <style type="text/css">
        form {
            background-color: #E8ECEF;
        }

footer{border-style: dotted;
color:dimgrey;}

    </style>
    <!-- Bootstrap core CSS -->
    <link href="../bootstrap/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="../bootstrap/vendor/jquery/jquery.js"></script>

    <!-- Custom styles for this template -->
    <link href="../bootstrap/css/half-slider.css" rel="stylesheet">

    <!-- Bootstrap core JavaScript -->
    <script src="../bootstrap/vendor/jquery/jquery.min.js"></script>
    <script src="../bootstrap/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">

       <center>


<button type="button" class="btn btn-primary btn-lg btn-block">OMCF NOTEPAD:  <br><%=User.Identity.Name%></button>

<br>
                      <asp:Button ID="Button3"
                Text="Load Saved Notes"
                OnClick="LoadData"
                class="btn btn-info"
                runat="server" />    
<br>    

            <asp:TextBox ID="textBoxOne" Rows="15" Style="width: 600px" TextMode="multiline" runat="server" />
	</center>
            <hr />

<center>
            <asp:Button ID="Button1"
                Text="Save Notes"
                OnClick="GreetingBtn_Click"
                class="btn btn-primary btn-lg"
                runat="server" />  
    
           <asp:Button ID="Button2"
                Text="Delete Notes"
                OnClick="ClearData"
                class="btn btn-danger btn-lg"
                runat="server" />
    <br><br>
        <asp:Button ID="Button4"
                Text="Email me my Notes"
                OnClick="SendEmail"
                class="btn btn-info"
                runat="server" />
 <hr>
<footer>OMCF: Restaurants Unlimited</footer>

</center>
</form>


</body>
</html>
