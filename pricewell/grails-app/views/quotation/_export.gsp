<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ page import="com.valent.pricewell.CompanyInformation" %>
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page {
    size: 8.5in 11in;  /* width height */
    margin: 0.25in;
} %>

<%
	def companiesList = CompanyInformation.findAll("FROM CompanyInformation ci");	
	def companyInfo = null;
	if(companiesList != null && companiesList.size() > 0){
		companyInfo = companiesList.get(0);
	}

%>

<html>
	<head>
		 <style>
    
	#page-wrap table { border-collapse: collapse; font: 14px/1.4 Georgia, serif;}
	#page-wrap table td,#page-wrap table th { border: 1px solid black; padding: 0 5px; }
	
	#companyInfo {
		float: left;
		width: 50%
        }
	#invoiceHeader {
		float: right;
		text-align: right;
		vertical-align: top;
	}
	#invoiceHeader h1 {letter-spacing: 2px; font-size: 200%}
	#customerAddress {
		clear: both;
		float: left;
		width: 50%;
	}
	#invoiceInfo {
		float: right;
	}
	#page-wrap { }
	
	#meta { margin-top: 1px; float: right}
	#meta td { text-align: right;  }
	#meta td.meta-head { text-align: left; background: #eee; }
	#meta td div { height: 20px; text-align: right; }
	#meta td div.contacts { height: 60px; text-align: right; }
	
	#mainTable {
		clear: both;
		padding: 1px 0px;
	}
	
	#items { clear: both; width: 100%; margin: 30px 0 0 0; border: 1px solid black; }
	#items th { background: #eee; }
	#items textarea { width: 80px; height: 50px; }
	#items tr.item-row td { border: 0; vertical-align: top; }
	#items td.description { width: 300px; }
	#items td.item-name { width: 175px; }
	#items td.description textarea, #items td.item-name textarea { width: 100%; }
	#items td.total-line { border-right: 0; text-align: right; }
	#items td.total-value { border-left: 0; padding: 10px; }
	#items td.total-value textarea { height: 20px; background: none; }
	#items td.balance { background: #eee; }
	#items td.blank { border: 0; }
	
	#terms { text-align: center; margin: 20px 0 0 0; }
	#terms h5 { text-transform: uppercase; font: 13px Helvetica, Sans-Serif; letter-spacing: 10px; border-bottom: 1px solid black; padding: 0 0 8px 0; margin: 0 0 8px 0; }
	#terms p { width: 100%; text-align: center;}
	
  </style>
</head><body>
<div id="page-wrap">	
	<div id="companyInfo">
		<p> 
			<g:if test="${companyInfo != null}">
	        		<g:if test="${companyInfo?.logo?.id != null}">
	        			<g:if test="${pdfDisplay}">
	        				<div class="profile_picture" style="display:block;height:40px;"  />
	        			</g:if>
	        			<g:else>
							<img src="<g:createLink controller='logoImage' action='renderImage' id='${companyInfo?.logo?.id}' style='height: 40px'/>" />	        				
	        			</g:else>
	    			</g:if>
    			</g:if>
		 </p>
		<p style="font: 14px/1.4 Georgia, serif;"> <span style="font-size: 24px"> ${companyInfo.name} </span> <br/>
			<g:if test="${companyInfo.shippingAddress}">
				<g:if test="${companyInfo.shippingAddress?.shipAddressLine1}">
					${companyInfo.shippingAddress?.shipAddressLine1} <br/>
				</g:if>
				<g:if test="${companyInfo.shippingAddress?.shipAddressLine2}">
					${companyInfo.shippingAddress?.shipAddressLine2} <br/>
				</g:if>

				${companyInfo.shippingAddress?.shipCity}, ${companyInfo.shippingAddress?.shipState}, ${companyInfo.shippingAddress?.shipPostalcode} <br/> 
			</g:if>
			
		</p>
			
		<br/>
		<p style="font: 18px/1.4 Georgia, serif;"> To: </p> 
		<p  style="font: 14px/1.4 Georgia, serif;"> <span style="font-size: 24px"> ${quotationInstance?.account?.accountName?.encodeAsHTML()} </span> <br/>
	
		 	<g:if test="${quotationInstance?.account?.billingAddress}">
				${quotationInstance?.account?.billingAddress?.billAddressLine1} <br/>
				${quotationInstance?.account?.billingAddress?.billAddressLine2} <br/>
				${quotationInstance?.account?.billingAddress?.billCity}, ${quotationInstance?.account?.billingAddress?.billState}, ${quotationInstance?.account?.billingAddress?.billPostalcode}<br/> 
			</g:if>
			
		</p>
	</div>

	<div id="invoiceHeader">
		<p style="letter-spacing: 2px;"> <span style="font-size: 200%; font-weight: bold;"> QUOTE </span> 
			<span style="font-size: 175%;"> # ${quotationInstance?.id}</span>
		</p>
		<table id="meta">
		                
		                <tr>
		                    <td class="meta-head">Customer #</td>
		                    <td><div>${quotationInstance?.account?.id}</div></td>
		                </tr>
		                <tr>

		                    <td class="meta-head">Date</td>
		                    <td><div id="date"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.createdDate}" /></div></td>
		                </tr>
		               <tr>
		                    <td class="meta-head">Sales Representative</td>
		                    <td><div class="contacts">${quotationInstance?.opportunity?.assignTo?.profile?.fullName?.encodeAsHTML()} <br/>
		                    			${quotationInstance?.opportunity?.assignTo?.profile?.email?.encodeAsHTML()} 
		                    			</div></td>
		                </tr>
		                <tr>
		                    <td class="meta-head">Customer Contact</td>
		                    <td><div class="contacts">${quotationInstance?.opportunity?.primaryContact?.firstname} ${quotationInstance?.opportunity?.primaryContact?.lastname} <br/>
		                    					${quotationInstance?.opportunity?.primaryContact?.email}<br/>
		                    					${quotationInstance?.opportunity?.primaryContact?.phone}
		                    				</div></td>
		                </tr>
		                <tr>
		                    <td class="meta-head">Total Price</td>
		                    <td><div class="due">${quotationInstance?.geo?.currencySymbol}  ${fieldValue(bean: quotationInstance, field: "finalPrice")}</div></td>
		                </tr>
						<tr>
		                    <td class="meta-head">Valid Until</td>
		                    <td><div id="date"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance.createdDate + quotationInstance.validityInDays}" /></div></td>
		                </tr>
		            </table>
		
	</div>

	<div id="customerAddress">
		
		
			
			 </div>

	<div id="invoiceInfo"> 
			</div>
	<div id="mainTable">

		<table id="items">

				  <tr>
					 <th> Service Group</th>
				      <th>Service</th>
					  <th> Unit of Sale </th>
				      <th style="width: 6em"># of Units</th>
				      <th style="width: 12em">Price</th>
				  </tr>
				  
						<g:each in="${serviceQuotations?.sort{it?.sequenceOrder}}" status="i" var="serviceQuotationInstance">
							
								<g:if test="${serviceQuotationInstance?.stagingStatus?.name != 'delete'}">
									<tr class="item-row">
			  							<td class="item-name"><p>${serviceQuotationInstance?.service?.portfolio?.portfolioName?.encodeAsHTML()}</p></td>
		      							<td class="item-name"><p>${serviceQuotationInstance?.service?.serviceName?.encodeAsHTML()}</p></td>
			   							<td class="item-name"><p>${serviceQuotationInstance?.profile?.unitOfSale?.encodeAsHTML()} </p></td>
		      							<td><p class="qty">${fieldValue(bean: serviceQuotationInstance, field: "totalUnits")}</p></td>
		      							<td><p class="qty">${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: serviceQuotationInstance, field: "price")}</p></td>
		  							</tr>
								</g:if>											
							
							
						</g:each>
					
					

				  <tr>
				      <td  colspan="3" class="blank"> </td>
				      <td  class="total-line">Subtotal</td>
				      <td class="total-value"><div>${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</div></td>
				  </tr>
				  <g:if test="${quotationInstance.discountAmount > 0}">
		        			<tr>
		        				<td  colspan="3" class="blank"> </td>
		        				<td  class="total-line">Discount</td>
		        				<td class="total-value"><div>${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "discountAmount")}  ${(!quotationInstance.flatDiscount ? '(' + quotationInstance.discountPercent + '%)': '')}</div></td>
		        			</tr>
		        	</g:if>
				  <tr>

				      <td colspan="3" class="blank"> </td>
				      <td class="total-line">Tax</td>
				      <td class="total-value"><div>${quotationInstance?.geo?.currencySymbol}  ${fieldValue(bean: quotationInstance, field: "taxAmount")}</div></td>
				  </tr>
				  <tr>
				      <td colspan="3" class="blank"> </td>
				      <td class="total-line">Expenses</td>

				      <td class="total-value"><div>${quotationInstance?.geo?.currencySymbol}  ${fieldValue(bean: quotationInstance, field: "expenseAmount")}</div></td>
				  </tr>
				  <tr>
				      <td  colspan="3" class="blank"> </td>
				      <td  class="total-line balance">Total </td>
				      <td class="total-value balance"><div class="due">${quotationInstance?.geo?.currencySymbol}  ${fieldValue(bean: quotationInstance, field: "finalPrice")}</div></td>
				  </tr>

				</table>
	</div>
	
</div>
</body></html>