<%@  Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Assembly Name="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">


    //next two functions are for converting the selected calendar dates to a corresponding string
    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {
        TextBox1.Text = Calendar1.SelectedDate.ToString();
    }
    protected void Calendar2_SelectionChanged(object sender, EventArgs e)
    {
        TextBox2.Text = Calendar2.SelectedDate.ToString();
    }
     void Page_Load(Object sender, EventArgs e)
    {
        //Manually register the event-handling method for the Click event of the Button control.
        Button1.Click += new EventHandler(this.GreetingBtn_Click);
    }


  void GreetingBtn_Click(Object sender, EventArgs e)
    {

       if (MealPeriod.SelectedValue == "NONE SELECTED" || RestNum.SelectedValue == "NONE SELECTED")
        {
            //Javascript function being called
            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('You must choose both a restaurant number and a meal period.');}", true);
        }
        else
        {
            //When the button is clicked.
            Button clickedButton = (Button)sender;
            clickedButton.Enabled = false;

            //Javascript function being called
            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('You have successfully completed your request. An email has been sent out with your request details.');}", true);
        }
    }


    protected void onClickFunction(object sender, EventArgs e)
    {

String permanentPeriod;
        String idString;
        String goLiveDate;
        String endDate;
        string userName = string.Empty;
        int restNum = -1;

  
int i = 8; userName = ""; 
while (i < User.Identity.Name.Length) { userName = userName + User.Identity.Name[i]; i++; }

try{
userName = userName.Substring(0, userName.IndexOf("-"));

if (userName == "-1"){
i = 8; userName = ""; 
while (i < User.Identity.Name.Length) { userName = userName + User.Identity.Name[i]; i++; }
} 
}catch (Exception) {
//
}
        
        GreetingBtn_Click(sender, e);

        if (MealPeriod.SelectedValue == "NONE SELECTED" || RestNum.SelectedValue == "NONE SELECTED")
        {
            //Javascript function being called
            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('You must choose both a restaurant number and a meal period.');}", true);
        }
        else
        {
        
            Random random = new Random();
            //here we are creating our idString with random numbers, current date, username and restaurant number
            idString = userName + "_" + random.Next(0, 1000000000) + random.Next(0, 1000000000) + "_" + RestNum.SelectedValue;

            //date and period instance variables
            permanentPeriod = PermanentPeriodChange.SelectedValue;
            goLiveDate = Calendar1.SelectedDate.ToString();
            endDate = Calendar2.SelectedDate.ToString();

            //if period equals 'Permanent', then the radio button was checked. otherwise, the radio button was not checked
            if (permanentPeriod == "Permanent")
                permanentPeriod = "is";
            else
                permanentPeriod = "is not";

            //if date equals "1/1/0001 12:00:00 AM", then no date was selected. This logic just changes the default date to a string with the text "NO DATE SELECTED"
            if (goLiveDate == "1/1/0001 12:00:00 AM" && endDate == "1/1/0001 12:00:00 AM")
            {
                goLiveDate = "NO DATE SELECTED";
                endDate = "NO DATE SELECTED";
            }
            else
            {
                if (goLiveDate == "1/1/0001 12:00:00 AM")
                    goLiveDate = "NO DATE SELECTED";
                if (endDate == "1/1/0001 12:00:00 AM")
                    endDate = "NO DATE SELECTED";
            }


            //save data to DB, and catch any errors
    
                 try
            {

              if (int.TryParse(RestNum.SelectedValue, out restNum))
                  if (SaveToDataBase(0, idString, restNum, userName, goLiveDate, endDate, textBoxOne.Text))
                    //send out email with request details to requestee 
                    SendEmail(userName, goLiveDate, endDate, permanentPeriod, idString);
                else 
                  if (SaveToDataBase(0, idString, -1, userName, goLiveDate, endDate, textBoxOne.Text)) 
                    //send out email with request details to requestee 
                    SendEmail(userName, goLiveDate, endDate, permanentPeriod, idString);
        }
            catch (Exception ex)
            {
                Response.Write(string.Format("Error in SaveToDatabase {0}", ex.Message));
            }

        }
    }

    void SendEmail(string userName, string goLiveDate, string endDate, string permanentPeriod, string requestID)
   {
        //email objects et al
        System.Net.Mail.MailAddress emailVar = new System.Net.Mail.MailAddress("POSRequests@r-u-i.com");
        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
        System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("mail.r-u-i.com");
        DateTime now = DateTime.Now;

        message.To.Add(userName + "@r-u-i.com");
        message.Subject = "You have successfully submitted a meal period request on "  + now.ToShortDateString() + " at " + now.ToString("h:mm tt");
        message.From = emailVar;
       message.Body = "On " + now.ToShortDateString() + " at " + now.ToString("h:mm tt") + ", " + userName + " made a meal period request that goes live on " + goLiveDate
          + " and ends on " + endDate + ". The change " + permanentPeriod + " permanent. The meal period is " + MealPeriod.SelectedValue + " and the restaurant number is " + RestNum.SelectedValue
          + ". \n\n Your comment is: \n" + textBoxOne.Text + "\n\n Your RequestID is: " + requestID + "\n\n [This is an automated message.]";
        smtp.Send(message);

        Response.Write("Thanks. An email has been sent to " + userName + "@r-u-i.com | Your request ID is <b>" + requestID + "</b>");
    }

    bool SaveToDataBase(int requestID, string idString, int restaurantNum, string userName, string goLiveDate, string endDate, string comment)
    {
      DateTime liveDate;
      DateTime end;
    DateTime now = DateTime.Now;

        var permanentPeriod = PermanentPeriodChange.SelectedValue;
            //if period equals 'Permanent', then the radio button was checked. otherwise, the radio button was not checked
            if (permanentPeriod == "Permanent")
                permanentPeriod = "Yes";
            else
                permanentPeriod = "No";
      
        bool returnval = false;
      
       using ( System.Data.SqlClient.SqlConnection sqlConnection1 =  new System.Data.SqlClient.SqlConnection("Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes")) 
        using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand("MyInfoSaveProcedure", sqlConnection1))
        {

            cmd.CommandType = System.Data.CommandType.StoredProcedure;
           cmd.Parameters.Add("@requestID", SqlDbType.Int).Value = requestID;
            cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = idString;
            cmd.Parameters.Add("@dateInfo", SqlDbType.VarChar).Value = DateTime.Now.ToString("yyyy-MM-dd");
            cmd.Parameters.Add("@dateTime", SqlDbType.VarChar).Value = now.ToString("h:mm tt");
            cmd.Parameters.Add("@userName", SqlDbType.VarChar).Value = userName;
            cmd.Parameters.Add("@RequestedBy", SqlDbType.VarChar).Value = userName;
            cmd.Parameters.Add("@permPeriod", SqlDbType.VarChar).Value = permanentPeriod;
            cmd.Parameters.Add("@RestaurantNum", SqlDbType.VarChar).Value = restaurantNum;
    
              cmd.Parameters.Add("@goLiveDate", SqlDbType.Date).Value = Calendar1.SelectedDate.ToString(); 
              cmd.Parameters.Add("@endDate", SqlDbType.Date).Value = Calendar2.SelectedDate.ToString();
              cmd.Parameters.Add("@comment", SqlDbType.VarChar).Value = comment;
              cmd.Parameters.Add("@mealperiod", SqlDbType.VarChar).Value = MealPeriod.SelectedValue;
            cmd.Connection.Open();
            try {
              cmd.ExecuteNonQuery();
              returnval = true;
           }
            catch (Exception ex) {
              Response.Write("Error Occurred in SaveToDataBaseDateTime.TryParse");
              Response.Write(string.Format("Error Message: {0}", ex.Message));

            }
        }
        return returnval;
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <style type="text/css">
        form {
            background-color: #E8ECEF;
        }
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
            <div style="float: right; margin-left: auto;">
                <h3>Go Live Date:</h3>
               <asp:Calendar ID="Calendar1" runat="server" OnSelectionChanged="Calendar1_SelectionChanged"></asp:Calendar>
                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>

                 <h3>End date:</h3>
                <asp:Calendar ID="Calendar2" runat="server" OnSelectionChanged="Calendar2_SelectionChanged"></asp:Calendar>
                <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox> 
            </div>
            <h1>Meal Period Change</h1>

            <h3>Your restaurant number:</h3>
            <asp:DropDownList ID="RestNum" runat="server">
                <asp:ListItem Enabled="true" Text="Select Restaurant Number" Value="NONE SELECTED"></asp:ListItem>
                <asp:ListItem Text="03 - Scott's" Value="03"></asp:ListItem>
                <asp:ListItem Text="05 - Clinkerdagger" Value="05"></asp:ListItem>
                <asp:ListItem Text="10 - Simon & Seaforts" Value="10"></asp:ListItem>
                <asp:ListItem Text="12 - Horatio's" Value="12"></asp:ListItem>
                <asp:ListItem Text="14 - Maggie Bluff's" Value="14"></asp:ListItem>
                <asp:ListItem Text="16 - Stanley & Seaforts" Value="16"></asp:ListItem>
                <asp:ListItem Text="18 - Cutter's Crabhouse" Value="18"></asp:ListItem>
                <asp:ListItem Text="20 - Skates on the Bay" Value="20"></asp:ListItem>
                <asp:ListItem Text="23 - Kincaid's Bloomington" Value="23"></asp:ListItem>
                <asp:ListItem Text="26 - Kincaid's Burlingame" Value="26"></asp:ListItem>
                <asp:ListItem Text="29 - Palomino Seattle" Value="29"></asp:ListItem>
                <asp:ListItem Text="31 - Kincaid's Oakland" Value="31"></asp:ListItem>
                <asp:ListItem Text="34 - Palisade" Value="34"></asp:ListItem>
                <asp:ListItem Text="35 - Palomino San Francisco" Value="35"></asp:ListItem>
                <asp:ListItem Text="40 - Palomino Indi" Value="40"></asp:ListItem>
                <asp:ListItem Text="44 - Kincaid's Redondo" Value="44"></asp:ListItem>
                <asp:ListItem Text="48 - Palomino Cinci" Value="48"></asp:ListItem>
                <asp:ListItem Text="52 - Kincaid's St Paul" Value="52"></asp:ListItem>
                <asp:ListItem Text="57 - PSC WA Square" Value="57"></asp:ListItem>
                <asp:ListItem Text="64 - Stanford's Lake Oswego" Value="64"></asp:ListItem>
                <asp:ListItem Text="65 - PSC Mall 205" Value="65"></asp:ListItem>
                <asp:ListItem Text="66 - Stanford's Lloyd Center" Value="66"></asp:ListItem>
                <asp:ListItem Text="69 - Stanford's Tanasbourne" Value="69"></asp:ListItem>
                <asp:ListItem Text="71 - Stanford's Jantzen Beach" Value="71"></asp:ListItem>
                <asp:ListItem Text="72 - Stanford's Walnut Creek" Value="72"></asp:ListItem>
                <asp:ListItem Text="73 - Newport Seafood Grill" Value="73"></asp:ListItem>
                <asp:ListItem Text="75 - Stanford's Southcenter" Value="75"></asp:ListItem>
                <asp:ListItem Text="77 - Portland City Grill" Value="77"></asp:ListItem>
                <asp:ListItem Text="79 - Stanford's Clackamas" Value="79"></asp:ListItem>
                <asp:ListItem Text="80 - Manzana" Value="80"></asp:ListItem>
                <asp:ListItem Text="81 - Henry's Portland" Value="81"></asp:ListItem>
                <asp:ListItem Text="82 - Stanford's PDX" Value="82"></asp:ListItem>
                <asp:ListItem Text="83 - PRCC" Value="83"></asp:ListItem>
                <asp:ListItem Text="84 - Palomino Bellevue" Value="84"></asp:ListItem>
                <asp:ListItem Text="85 - Stanford's Northgate" Value="85"></asp:ListItem>
                <asp:ListItem Text="86 - Henry's SODO" Value="86"></asp:ListItem>
                <asp:ListItem Text="87 - Henry's Plano" Value="87"></asp:ListItem>
                <asp:ListItem Text="88 - Henry's Denver" Value="88"></asp:ListItem>
                <asp:ListItem Text="89 - Henry's PDX" Value="89"></asp:ListItem>
                <asp:ListItem Text="90 - Henry's Bellevue" Value="90"></asp:ListItem>
                <asp:ListItem Text="91 - Henry's SLU" Value="91"></asp:ListItem>
                <asp:ListItem Text="303 - Fondi" Value="303"></asp:ListItem>
                <asp:ListItem Text="OTHER" Value="0"></asp:ListItem>

            </asp:DropDownList>
            <br />

            <h3>Select Meal Period:</h3>
            <asp:DropDownList ID="MealPeriod" runat="server">
                <asp:ListItem Enabled="true" Text="Select Meal Period" Value="NONE SELECTED"></asp:ListItem>
                <asp:ListItem Text="Happy Hour" Value="Happy Hour"></asp:ListItem>
                <asp:ListItem Text="Dinner" Value="Dinner"></asp:ListItem>
                <asp:ListItem Text="Lunch" Value="Lunch"></asp:ListItem>
                <asp:ListItem Text="Brunch" Value="Brunch"></asp:ListItem>
                <asp:ListItem Text="Early Dinner" Value="Early Dinner"></asp:ListItem>
                <asp:ListItem Text="Late Dinner" Value="Late Dinner"></asp:ListItem>
                <asp:ListItem Text="HH Early Dinner" Value="HH Early Dinner"></asp:ListItem>
                <asp:ListItem Text="HH Late Dinner" Value="HH Late Dinner"></asp:ListItem>
                <asp:ListItem Text="Other - Leave comment" Value="Other"></asp:ListItem>
            </asp:DropDownList>

            <br />
            <br />

            <asp:RadioButtonList ID="PermanentPeriodChange" runat="server">
                <asp:ListItem Text=" - Change is permanent." Value="Permanent" CssClass="rbl" /> 
            </asp:RadioButtonList>

            <h3>Additional information:</h3>
            <asp:TextBox ID="textBoxOne" Rows="11" Style="width: 400px" TextMode="multiline" runat="server" />
            <br>
            <hr />

            <asp:Button ID="Button1"
                Text="Submit Request"
                OnClick="onClickFunction"
                class="btn btn-primary"
                runat="server" /> 
            <br>
            <br>
            <br>
            <br>
        
    </form>


</body>
</html>
