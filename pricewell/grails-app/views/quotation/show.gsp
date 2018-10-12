
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>
<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quotation.label', default: 'Quotation')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
              
		<style>
			td.name { font-weight: bold; font-size: 90%}
			#summary {
				font-size: 110%
			}
			
		</style>
        <script>
			var index = 999;
        </script>
    </head>
    <body>
        <div class="nav">
        <g:form>
        	<g:hiddenField name="id" value="${quotationInstance?.id}" />
        	
        	<!--  
        	 <span class="menuButton"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
	         <span class="menuButton"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
	         -->
	         
	        <!-- <span class="menuButton"><g:link class="edit" action="edit" id="${quotationInstance?.id}"> Edit </g:link> </span>
	         <span class="menuButton"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
	         
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            <g:if test="${requestDone}">
            	<span class="menuButton"><g:link action="exportPDF" id="${quotationInstance?.id}"> Generate Quote[PDF] </g:link>  </span>
            	<span class="menuButton"><g:link action="exportSOWInPDF" id="${quotationInstance?.id}"> Generate SOW[PDF] </g:link>  </span>
            </g:if>
            -->	
           <span class="menuButton"><g:link action="show" controller="opportunity" id="${quotationInstance?.opportunity?.id}"> Go To Opportunity </g:link>  </span>
        </g:form>
        </div>
        <div class="body yui-skin-sam">
        	 <h1> Quote Id: ${fieldValue(bean: quotationInstance, field: "id")} </h1>
        	 <h1> Quote for Customer: ${fieldValue(bean: quotationInstance, field: "account.accountName")} </h1>
        	  
	         <g:if test="${flash.message}">
            <!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                                    
                            <td valign="top" class="name"><g:message code="quotation.createdBy.label" default="Created By:" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${quotationInstance?.createdBy?.id}">${quotationInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><g:message code="quotation.geo.label" default="Geo:" /></td>
                            
                            <td valign="top" class="value"><g:link controller="geo" action="show" id="${quotationInstance?.geo?.id}">${quotationInstance?.geo?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><g:message code="quotation.status.label" default="Status:" /></td>
                            
                            <td valign="top" class="value">${quotationInstance?.status?.encodeAsHTML()}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><g:message code="quotation.createdDate.label" default="Created Date:" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.createdDate}" /></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><g:message code="quotation.modifiedDate.label" default="Modified Date:" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.modifiedDate}" /></td>
                           
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <!--  
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${quotationInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
            -->
        
			
       		<div id="dvQuotationMain">
       			<g:render template="/serviceQuotation/list" model="['quotationInstance': quotationInstance, 'canModifyServices': canModifyServices]"/>
       		</div>
       		<div style="float: right;width: 35%;">
	       		<table id="summary">
		        		<tbody>
		        			<tr class="prop">
		        				<td valign="top" id="totalPrice" class="name"> Subtotal Price: </td>
		                        <td valign="top" id="totalPriceValue" class="value">${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")} ${quotationInstance?.geo?.currencySymbol}</td>
		                        <td> </td>
		        			</tr>
		        			
		        			<tr class="prop">
		        				<td class="name"> Discount: </td>
		        				
		        				<td> ${fieldValue(bean: quotationInstance, field: "discountAmount")} ${quotationInstance?.geo?.currencySymbol}</td>
		        				<td> ${(!quotationInstance.flatDiscount ? '(' + quotationInstance.discountPercent + '%)': '')} </td>
		        			</tr>
		        			<tr class="prop">
		        				<td class="name"> Tax:   </td>
		        				
		        				<td> ${fieldValue(bean: quotationInstance, field: "taxAmount")} ${quotationInstance?.geo?.currencySymbol} </td>
		        				<td> (${fieldValue(bean: quotationInstance, field: "taxPercent")}%)</td>
		        			</tr>
		        			<tr class="prop">
		        				<td class="name"> Total Price:  </td>
		        				
		        				<td> ${fieldValue(bean: quotationInstance, field: "finalPrice")} ${quotationInstance?.geo?.currencySymbol} </td>
		        				<td> </td>
		        			</tr>
		        		</tbody>
		        </table>
	        </div>			        
        	
        </div>
        <br><br><br><br><br><br>
        
        <g:if test="${!requestDone}">
	        <div>
	        	<g:if test="${notificationList.size()>0}">
	        		<h1>Notification Request</h1><hr>
	        		<table><tbody>
			        	<g:each in="${notificationList}" status="i" var="notification" >
			                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="border-bottom-style:dotted;">
			                    <td class="bottom">
			                    	<p style="width:725px; font-size: 100%;">${notification.comment}</p>
			                    </td>    
			                    
			                    <td class="bottom">Submitted By:<br>
		                            <br>
		                           
		                            ${notification.createdBy}
		                            <br>
		                            <g:formatDate  format="MMMMM d, yyyy" date="${notification.dateCreated}" />
		                        </td>                 
			                </tr>
			                
			            </g:each>
		            <table><tbody>
		        </g:if>
	        </div>
        </g:if>
    </body>
</html>