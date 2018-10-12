<!doctype html>
<html>
<head>
	<style type="text/css">
		#page-wrap table { border-collapse: collapse; font: 14px/1.4 Georgia, serif;}
		#page-wrap table td,#page-wrap table th { border: 1px solid black; padding: 0 5px; }
	</style>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>

<body>

	<div>
		<table>
			<tr>
				<td style="height: 5px; background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;Warning</td>
			</tr>
		</table>
	</div>
	<div id="page-wrap">
		<div class="divCustomer" id="divCustomer">
 	 		<h1><b>Customer Information Tags</b></h1>
	
			<table width="900" border-color="black" border="1" cellspacing="1" cellpadding="1">
  				<tr>
		    		<td width="200">&#36;{customer}</td>
		   		  	<td width="200">Customer Name</td>
		    		<td width="500">This customer is account for which SOW of opportunity has been generated.</td>
		  		</tr>
		  		<tr>
  		  			<td>&#36;{customer_logo}</td>
  		  			<td>Customer Logo</td>
  		  			<td>&nbsp;</td>
	  			</tr>
  				<tr>
  		  			<td>&#36;{customer_phone}</td>
  		  			<td>Customer Phone</td>
  		  			<td>&nbsp;</td>
	  			</tr>
		  		<tr>
		  		  	<td>&#36;{customer_fax}</td>
		  		  	<td>Customer Fax</td>
		  		  	<td>&nbsp;</td>
			  	</tr>
		  		<tr>
		  		  	<td>&#36;{customer_email}</td>
		  		  	<td>Customer E-mail</td>
		  		  	<td>&nbsp;</td>
			  	</tr>
  				<tr>
    				<td>&#36;{customer_address}</td>
	 	  			<td>Customer Address</td>
    				<td>This combines Address Line 1 and Address Line 2 of account.</td>
  				</tr>
  				<tr>
    				<td>&#36;{customer_city}</td>
   		  			<td>Customer City</td>
    				<td>&nbsp;</td>
  				</tr>
  				<tr>
    				<td>&#36;{customer_state}</td>
   		  			<td>Customer State</td>
    				<td>&nbsp;</td>
  				</tr>
  				<tr>
  		  			<td>&#36;{customer_country}</td>
  		  			<td>Customer Country</td>
  		  			<td>&nbsp;</td>
	  			</tr>
  				<tr>
    				<td>&#36;{customer_zip}</td>
   		  			<td>Customer Zip-code</td>
    				<td>&nbsp;</td>
  				</tr>
			</table>
		</div>

		<div class="divContactInformation" id="divContactInformation">
			<h1><b>Contact Information Tags</b></h1>

			<table  width="900" border="1"cellspacing="0" cellpadding="0">
	  			<tr>
	    			<td width="200">&#36;{contact_name}</td>
	    			<td width="200">Contact Name</td>
	    			<td width="500">This is a primary contact of opportunity for which SOW generated. This will combines first name and last name of contact.</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_phone}</td>
	    			<td>Contact Phone</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_fax}</td>
	    			<td>Contact fax</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_email}</td>
	    			<td>Contact E-mail</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_address}</td>
	    			<td>Contact Address</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_city}</td>
	    			<td>Contact City</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_state}</td>
	    			<td>Contact State</td>
	    			<td>&nbsp;</td>
	  			</tr>
	  			<tr>
	    			<td>&#36;{contact_country}</td>
	    			<td>Contact Country</td>
	    			<td>&nbsp;</td>
				</tr>
	  			<tr>
	    			<td>&#36;{contact_zip}</td>
	    			<td>Contact Zip</td>
	    			<td>&nbsp;</td>
	  			</tr>
			</table>
	
		</div>

		<div class="divSowInformation" id="divSowInformation">
  			<h1><b>SOW Information Tags</b></h1>
  
  			<table width="900" border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td width="200">&#36;{opportunity_name}</td>
    				<td width="200">Opportunity Name</td>
    				<td width="500">Name of SOW's opportunity.</td>
  				</tr>
  				<tr>
    				<td>&#36;{sow_id}</td>
    				<td>SOW Id</td>
    				<td>Same as quotation #</td>
			  	</tr>
  				<tr>
    				<td>&#36;{contract_date}</td>
    				<td>SOW Contract Date</td>
    				<td>This is a date on which SOW generated.</td>
  				</tr>
  				
  				<tr>
    				<td width="200">&#36;{sales_rep_name}</td>
    				<td width="200">Sales Representative Name</td>
    				<td width="500">Sales representative of company who is currently dealing with SOW.</td>
  				</tr>
  				
  				<tr>
    				<td width="200">&#36;{sales_rep_email}</td>
    				<td width="200">Sales Representative Email</td>
    				<td width="500">Email of sales representative of company who is currently dealing with SOW.</td>
  				</tr>
  				
  				<tr>
    				<td width="200">&#36;{sales_rep_phone}</td>
    				<td width="200">Sales Representative Phone</td>
    				<td width="500">Phone number of sales representative of company who is currently dealing with SOW.</td>
  				</tr>
  				
  				<tr>
    				<td>&#36;{sow_introduction}</td>
    				<td>SOW Introduction</td>
    				<td>This is an introduction of SOW added while generating it.</td>
  				</tr>
  				
  				<tr>
    				<td>&#36;{sow_project_parameters}</td>
    				<td>SOW Project Parameters</td>
    				<td>These are project parameters of SOW added while generating it.</td>
  				</tr>
  				
  				<tr>
    				<td>&#36;{expense_amount}</td>
    				<td>SOW Expense Amount</td>
    				<td>This is an expense amount of SOW.</td>
  				</tr>
  				
  				<tr>
    				<td>&#36;{expense_description}</td>
    				<td>SOW Expense Description</td>
    				<td>Detailed description of expense amount.</td>
  				</tr>
  				
  				<tr>
    				<td>&#36;{billingMilestone}</td>
    				<td>Billing Milestones</td>
    				<td><p>This tag will be replaced by table which consist of different milestones for payment of amount.</p>
      					<div>
	      					<p style="background-color: yellow;">This tag must be alone and not in between any sentence.</p>
      					</div>
      				</td>
  				</tr>
  				<!--  #583 - Snehal - 04092015 - Start -->
  				<tr>
    				<td>&#36;{sow_validfor}</td>
    				<td>SOW Valid For</td>
    				<td>This is will dynamically print how long the quote or SOW is valid. It would be driven as per the selection during quote creation</td>
  				</tr>
  				<!-- #583 - Snehal - 04092015 - END   -->
			</table>
	
		</div>

		<div class="divServiceInformation" id="divServiceInformation">
			<h1><b>Service Information Tags</b></h1>
			
			<table width="900" border="1" cellspacing="0" cellpadding="0">
  				<tr>
    				<td width="200">&#36;{quotationOfferingServices}</td>
    				<td width="700"><p>This tag will be replaced by table/simple-text which consist of portfolio related services added in SOW including deliverables with activities and tasks as separated section defined in services.</p>
      					<div>
	      					<p style="background-color: yellow;">This tag must be alone and not in between any sentence.</p>
      					</div>
      				</td>
  				</tr>
  				
  				<tr>
    				<td width="200">&#36;{quotationOfferingServicesGrouping}</td>
    				<td width="700"><p>This tag will be replaced by simple-text which consist of portfolio related services added in SOW including deliverables grouping with activities and tasks under it defined in services.</p>
      					<div>
	      					<p style="background-color: yellow;">This tag must be alone and not in between any sentence.</p>
      					</div>
      				</td>
  				</tr>
  				
  				<tr>
    				<td width="200">&#36;{quotedServicesPrice}</td>
    				<td width="700"><p>This tag will be replaced by table which consist of all services those are added into the quotation including its units and prices.</p>
      					<div>
	      					<p style="background-color: yellow;">This tag must be alone and not in between any sentence.</p>
      					</div>
      				</td>
  				</tr>
			</table>
	
		</div>
	</div>	
</body>
</html>
