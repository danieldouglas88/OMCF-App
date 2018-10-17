<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
    
    <%@ Assembly Name="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    
    protected void Button1_Click(object sender, EventArgs e)
{

    var button = sender as Button;
    var code = button.CommandName;
    
    		//Javascript function being called
            ClientScript.RegisterStartupScript(this.GetType(), "CompletedRequest", "ShowPopUp();", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ScriptTest", " function ShowPopUp(){ alert('You have removed this record');}", true);

     using ( System.Data.SqlClient.SqlConnection sqlConnection1 =  new System.Data.SqlClient.SqlConnection("Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes")) 
        using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand("StatusUpdate", sqlConnection1))
        {
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@requestid", SqlDbType.VarChar).Value = code;
            cmd.Connection.Open();
            
            try {
	cmd.ExecuteNonQuery();
                
        } catch (Exception ex) {
                Response.Write("ERROR: " + ex.Message);
        }
        }
    
            //email objects et al
        System.Net.Mail.MailAddress emailVar = new System.Net.Mail.MailAddress("POSRequests@r-u-i.com");
        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
        System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("mail.r-u-i.com");
        DateTime now = DateTime.Now;
    
    var userName = code;
	userName = userName.Substring(0, userName.IndexOf("_"));
    
        message.To.Add(userName + "@r-u-i.com");
        message.Subject = "Your holiday meal period request has been approved on "  + now.ToShortDateString() + " at " + now.ToString("h:mm tt");
        message.From = emailVar;
       message.Body = "On " + now.ToShortDateString() + " at " + now.ToString("h:mm tt") + ", your holiday meal period request with ID of " + code + " was approved.";
            smtp.Send(message);
    
    System.Threading.Thread.Sleep(1000);


Page.Response.Redirect(Page.Request.Url.ToString(), true);
}

    </script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

<meta http-equiv="X-UA-Compatible" content="IE=edge">

    <style type="text/css">
       html{
            background-color: #E8ECEF;
        }
    </style>
    <!-- Bootstrap core CSS -->
    <link href="../bootstrap/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="../bootstrap/vendor/jquery/jquery.js"></script>

    <!-- Custom styles for this template -->
    <link href="../bootstrap/css/half-slider.css" rel="stylesheet">

</head>
<body>
<table class="table table-hover">
  <thead>
    <tr class="table-info">
      <th scope="col">User:</th>
      <th scope="col">Rest #:</th>
      <th scope="col">Submitted on:</th>    	
      <th scope="col">Goes live:</th>      
	<th scope="col">Ends:</th>
	<th scope="col">Meal Period:</th>
	<th scope="col">Permanent?:</th>
  <th scope="col"></th>
</tr>
</thead>

   <form runat="server" id="form1">
<asp:Repeater runat="server" id="Repeater1" DataSourceID="dsRequests">
   <ItemTemplate>
             <tr class="table-success">
              <td><%# Eval("username") %></td>
              <td><%# Eval("restNum") %></td>
              <td><%# Eval("dateInfo") %> @ <%# Eval("dateTime") %></td>         
              <td><%# Eval("golivedate") %></td>        
	          <td><%# Eval("enddate") %></td>
              <td><%# Eval("commentText") %></td> 
	          <td><%# Eval("permPeriod") %></td>     
<td><button onclick="alert('<%# Eval("comment") %>')" class="btn btn-info btn-sm">Comment</button>    
<asp:button CommandName='<%# Eval("ID") %>' runat="server" OnClick="Button1_Click" Text="Close"  class="btn btn-danger btn-sm"/>
     

  </td>
                 </tr></ItemTemplate>
</asp:Repeater> 
</form>
</table>

<asp:SqlDataSource runat="server" id="dsRequests" SelectCommand="PeriodRequestGet" 
  ConnectionString="Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes">
</asp:SqlDataSource> 

</body>
</html>
