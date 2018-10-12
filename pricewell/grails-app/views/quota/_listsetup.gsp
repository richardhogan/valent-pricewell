<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Quota" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.SalesController" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
%>
<html>
	<style>
		h1, button, #successDialogInfo
		{
			font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
		}
		button{
			cursor:pointer;
		}
	</style>
	<script>
	
		function refreshGeoGroupList(source){
			refreshNavigation();
			jQuery.ajax({
				type: "GET",
				url: "${baseurl}/quota/listsetup",
				data: {source: 'firstsetup'},
				success: function(data){
					jQuery('#contents').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
		var ajaxList = new AjaxPricewellList("Quota", "Quota", "${baseurl}", "setup", 700, 800, "${allowCreate}", "${allowEdit}", "${allowDelete}", "${allowShow}");
		
		jQuery(document).ready(function()
		{
			ajaxList.init();

			jQuery("#editDialog").dialog({
	            autoOpen: false,
	            position: [400,200],
	            modal: true,
				close: function( event, ui ) {
					jQuery(this).html('');
				}
	        });

			jQuery(".resultDialog").dialog({
	            autoOpen: false,
	            resizable: false,
	            modal: true,
				close: function( event, ui ) {
					jQuery(this).html('');
				},
				buttons: 
				{
					OK: function() 
					{
						jQuery( ".resultDialog" ).dialog( "close" );
					}
				}
	        });
	        
			jQuery(".quotaEdit").click(function(){
				jQuery("#contents").html('Loading, please wait.....');
				/*jQuery("#editDialog").dialog( "open" );
				jQuery("#editDialog").dialog( "option", "title", "Edit Quota" );
				jQuery("#editDialog").dialog( "option", "width", 400);
				jQuery("#editDialog").dialog( "option", "maxHeight", 300);*/
				jQuery.ajax({
					type: "GET",
					url: "${baseurl}/quota/editsetup",
					data: {id: this.id, source: '${source}'},
					success: function(data){
						jQuery("#contents").html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});

			jQuery("#range").change(function () 
	    	{
		    	//alert(this.value);
	    		jQuery.ajax({type:'POST',data: {range: this.value, source: 'firstsetup'},
					 url:'${baseurl}/quota/listsetup',
					 success:function(data,textStatus){jQuery('#contents').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 return false;
	    	});
		});
	</script>
    <body>
        <div class="body">
            <h1> ${quotaInstanceTotal} Quota<g:if test="${quotaInstanceTotal > 1}">s</g:if> Defined In 
            								<g:select name="range" from="['First to this quarter', 'Previous to this quarter',
                           								 'First quarter', 'Previous quarter', 'This quarter',
                           								 'Next quarter', 'Last quarter', 'This to next quarter',
                           								 'This to last quarter', 'Previous year', 'This year', 'Next year']"  value='${range}' noSelection="['': 'Select Any One...']" />
                           								 
                           								 &nbsp; &nbsp;
            	<g:if test="${allowCreate == true}">
            		<span><button id="createQuota"> Add Quota </button></span>
           		</g:if>
			</h1><hr />
			
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            
            <div>
            	<!-- <tr class="prop">
                    <td valign="top" class="name">
                        <label for="timespan"><g:message code="quota.timespan.label" default="Quota In Quarter" /></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'timespan', 'errors')}">
                        <g:select name="timespan" from="['First and this quarter', 'Previous and this quarter',
                           								 'First quarter', 'Previous quarter', 'This quarter',
                           								 'Next quarter', 'Last quarter', 'This and next quarter',
                           								 'This and last quarter', 'Previous year', 'This year', 'Next year']"  value='This quarter' noSelection="['': 'Select Any One...']" />
                    </td>
                </tr>-->
            </div>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="quotasList">
                    <thead>
                        <tr>
                        	<th><g:message code="quota.person.label" default="Assigned To" /></th>
                        	
                        	<th><g:message code="${message(code: 'quota.amount.label', default: 'Amount')}" /></th>
                        
                            <th><g:message code="${message(code: 'quota.timespan.label', default: 'Time Duration')}" /></th>
                            
                            <th>Status</th>
							
							<g:if test="${allowEdit == true}"><th></th></g:if>
                            
                            <g:if test="${allowDelete == true}"><th></th></g:if>
							
                        	
                        </tr>
                    </thead>
                    <tbody>
	                    <g:each in="${quotaInstanceList}" status="i" var="quotaInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        	
	                        	<td>${fieldValue(bean: quotaInstance, field: "person")}</td>
								
								<g:if test="${new SalesController().isSalesPerson(quotaInstance?.person?.id) && quotaInstance?.currency != quotaInstance?.person?.territory?.currency}">
									<td>${fieldValue(bean: quotaInstance, field: "amount")} ${fieldValue(bean: quotaInstance, field: "currency")} = ${new SalesController().convertAmountToUserCurrency(quotaInstance?.person?.id, quotaInstance?.amount)} ${quotaInstance?.person?.territory?.currency}</td>
								</g:if>
								<g:else>
									<td>${fieldValue(bean: quotaInstance, field: "amount")} ${fieldValue(bean: quotaInstance, field: "currency")}</td>
								</g:else>
                        
                            	<td><g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.fromDate}" /> To <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.toDate}" /></td>
                        
                        		<td>
                        			<g:if test="${quotaInstance?.person?.id == loginUser?.id}">
                        				My Assigned
                        			</g:if>
                        			<g:elseif test="${quotaInstance?.createdBy?.id == loginUser?.id}">
                        				My Submitted
                        			</g:elseif>
                        		</td>
                        		
                            	<g:if test="${allowEdit == true}">
									<td> <a id="${quotaInstance.id}" href="#" class="quotaEdit hyperlink" title="Edit Quota"> Edit </a></td>
								</g:if>
								<g:if test="${allowDelete == true}">
									<td> <a id="${quotaInstance.id}" href="#" class="deleteQuota hyperlink" title="Delete Quota"> Delete </a></td>
								</g:if>
									
								
								
	                        
	                        </tr>
	                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
		<div id="quotaDialog" title="">
			
		</div>
		
		<div id="editDialog" title="">
			
		</div>
		<div id="resultDialog" class="resultDialog" title="">
			
		</div>
    </body>
</html>
