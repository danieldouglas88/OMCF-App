<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
    
    <%@ Assembly Name="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style type="text/css">
        html{
            background-color: #E8ECEF;
        }
    </style>
<script runat="server">

protected void onClickUser(object sender, EventArgs e)
{
	SearchResultsRest.SelectParameters["idd"].DefaultValue = "50";
    SqlDataSourceSearchResults.SelectParameters["idd"].DefaultValue = DropDownListRequestorID.SelectedValue;
}
    
    protected void onClickRestaurant(object sender, EventArgs e)
{
SqlDataSourceSearchResults.SelectParameters["idd"].DefaultValue = "clear";
    SearchResultsRest.SelectParameters["idd"].DefaultValue = RestNum.SelectedValue;
}

</script>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
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
      <th scope="col">Record #</th>     
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
    
    <form id="form1" runat="server">
       
        <asp:SqlDataSource ID="SqlDataSourceSearchResults" runat="server" ConnectionString="Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes"
        SelectCommand="SELECT * FROM [PeriodChangeRequest] WHERE ([RequestedBy] = @idd) ORDER BY RequestID DESC">
   <SelectParameters>
       <asp:Parameter Name="idd" Type="String" />
   </SelectParameters>
</asp:SqlDataSource>
        
                <asp:SqlDataSource ID="SearchResultsRest" runat="server" ConnectionString="Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes"
        SelectCommand="SELECT * FROM [PeriodChangeRequest] WHERE ([RestaurantNum] = @idd) ORDER BY RequestID DESC">
   <SelectParameters>
       <asp:Parameter Name="idd" Type="String" />
   </SelectParameters>
</asp:SqlDataSource>
        
    <br />
    <center>
        <h3>Restaurant number: <%= RestNum.SelectedValue%>     </h3>
    
                <asp:DropDownList ID="DropDownListRequestorID" runat="server" DataSourceID="SqlDataSource1"
                    DataTextField="RequestorID" DataValueField="RequestorID" Enabled="True" Width="200px">
                </asp:DropDownList><asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=SEA2wnsql01;Initial Catalog=MenuChangeRequest;Integrated Security=True;Trusted_Connection=yes"
                    SelectCommand="SELECT [RequestorID] FROM [viewRequestorIDs]"></asp:SqlDataSource>

            
            <asp:DropDownList ID="RestNum" runat="server">
                <asp:ListItem Enabled="true" Text="Select Restaurant Number" Value=""></asp:ListItem>
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
            </asp:DropDownList> <br /><br />
            
     <asp:Button ID="Button1"
                Text="Search by User"
                OnClick="onClickUser"
                class="btn btn-primary btn-lg"
                runat="server" />  
            
                 <asp:Button ID="Button2"
                Text="Search by Restaurant"
                OnClick="onClickRestaurant"
                class="btn btn-primary btn-lg"
                runat="server" />  
            
            </center>
       <hr>
<asp:Repeater runat="server" id="Repeater1" DataSourceID="SqlDataSourceSearchResults">
   <ItemTemplate>
             <tr class="table-success">
	      <td><%# Repeater1.Items.Count + 1 %></td>
              <td><%# Eval("username")%></td>
              <td><%# Eval("restNum") %></td>
              <td><%# Eval("dateInfo") %></td>         
              <td><%# Eval("golivedate") %></td>        
	          <td><%# Eval("enddate") %></td>
              <td><%# Eval("commentText") %></td> 
	          <td><%# Eval("permPeriod") %></td> 

<td><button onclick="alert('<%# Eval("comment") %>')" class="btn btn-info btn-sm">Comment</button>
<button onclick="alert('<%# Eval("ID") %>')" class="btn btn-info btn-sm">Request ID</button> </td> 
</tr>
       
    </ItemTemplate>
</asp:Repeater> 

        
        <asp:Repeater runat="server" id="Repeater2" DataSourceID="SearchResultsRest">
   <ItemTemplate>
             <tr class="table-success">
<td><%# Repeater2.Items.Count + 1%> </td>
              <td><%# Eval("username")%></td>
              <td><%# Eval("restNum") %></td>
              <td><%# Eval("dateInfo") %></td>         
              <td><%# Eval("golivedate") %></td>        
	          <td><%# Eval("enddate") %></td>
              <td><%# Eval("commentText") %></td> 
	          <td><%# Eval("permPeriod") %></td>        
<td><button onclick="alert('<%# Eval("comment") %>')" class="btn btn-info btn-sm">Comment</button>
<button onclick="alert('<%# Eval("ID") %>')" class="btn btn-info btn-sm">Request ID</button> </td> 
</tr>
       
    </ItemTemplate>
</asp:Repeater> 
</form>
</table>

<asp:SqlDataSource runat="server" id="dsRequests" SelectCommand="RequestResults" 
  ConnectionString="Data Source=SEA2wnsql01;Initial Catalog=MealPeriod;Integrated Security=True;Trusted_Connection=yes">
</asp:SqlDataSource> 

</body>
</html>
