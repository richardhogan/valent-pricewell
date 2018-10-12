<%@page import="com.valent.pricewell.ExtraUnitController"%>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ExtraUnit" %>
<%@ page import="com.valent.pricewell.ObjectType" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<g:setProvider library="prototype"/>
	
       <script>
       jQuery(document).ready(function()
 		   	{
    	   //jQuery('#removeExtraUnitBtn').hide();
    	   		var counter = 1;
    	   		
       			jQuery("#extraUnitOfSaleFrm").validate(
				    {
	  					rules: 
	  					{
	    					extraUnit: 
	    					{
	      						number: true	
	    					},
	  					}
					});
	       		
	       		
	       		jQuery(".removeExtraUnitSetup").click(function()
   				{
  					//alert("In remove link"+this.id)
   					var myid = this.id;
   					var btns = {};
   				
					jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/extraUnit/deleteExtraUnit",
						data: {id: myid},
						
						success: function(data)
						{
							
							if(data == "success")
							{
								
								jQuery("#extraUnitRow"+myid).remove();
								
							}
							else{
								
							}
						} 
					});
   				});
	       		
	       		jQuery("#saveExtraUnitBtn").click(function()
	    	    {
	       			if(jQuery('#extraUnitOfSaleFrm').validate().form())
		       		{
	       				if(jQuery("#extraUnit").val() == "")
		       			{
		       				jAlert('Please enter extra units');
		       				return false;
		       			}

		       			//jQuery("#unitOfSale").val(jQuery("#additionalUnitOfSale").val());

	       				showLoadingBox();

	       				jQuery.ajax(
   						{
   							type: "POST",
   							url: "${baseurl}/extraUnit/saveExtraUnit",
   							data:jQuery("#extraUnitOfSaleFrm").serialize(),
   							
   							success: function(data)
   							{
   								//alert(counter);
   								jQuery("#allData").empty();
   								for(var i=0;i<data.length;i++) 
   								{
   									
   									jQuery("#allData").append("<tr id='extraUnitRow"+data[i].id+"'><td>"+data[i].unitOfSale+"</td><td>"+data[i].extraUnit+"</td><td>ExtraUnit "+(i+1)+ "</td><td><a id="+data[i].id+" href='#' class='removeExtraUnitSetup hyperlink'> Remove </a></td></tr>");
   									jQuery("#extraUnitRow"+data[i].id)
   									.removeClass('even odd')
   									.addClass( (i%2)==0 ? 'odd' : 'even')
   								}
   								//counter = counter
   								jQuery("#extraUnit").val("");
   								jQuery(".removeExtraUnitSetup").click(function()
   			    				{
   			    					var myid = this.id;
   			    					var btns = {};
   			    				
   			    						jQuery.ajax(
   			    						{
   			    							type: "POST",
   			    							url: "${baseurl}/extraUnit/deleteExtraUnit",
   			    							data: {id: myid},
   			    							success: function(data)
   			    							{
   			    								if(data == "success")
   			    								{								    		         
   			    									jQuery("#extraUnitRow"+myid).remove();
   			    								}
   			    								else{
   			    									
   			    								}
   			    							} 
   			    						});
   			    				});
   								jQuery("#getAll").val(data);
   								
   								hideLoadingBox();							
   								return false;
   							}, 
   							error:function(XMLHttpRequest,textStatus,errorThrown){
   								//hideLoadingBox();
   								return false;
   							}
   		       			});
			       	}
	       			return false;				
 		   		});

	       		var availableExtraUnitOfSaleList = ${serviceExtraUnitOfSaleList as JSON};

		 		jQuery("#additionalUnitOfSale").autocomplete({
			    	source: availableExtraUnitOfSaleList
			    });
		 		
		 		jQuery("#additionalUnitOfSale").keyup(function(){
				    this.value = this.value.toUpperCase();
				});
 		   		
 		   	});
		       
	   	</script>
    <body>
    
		<div class="body" id="dvMainExtraUnitOfSale">
    		<g:form name="extraUnitOfSaleFrm" class="extraUnitOfSaleFrm" method="POST">
			 	<g:set var="defaultUnitOfSales" value="${ObjectType.getUnitOfSaleTypes()}" />
	            	
            	<g:hiddenField id="id" name="serviceProfileId" value="${serviceProfileInstance?.id}" />
            	<g:hiddenField id="shortName" name="shortName" value="ExtraUnit" />
            	<g:hiddenField id="temp" name="temp" value="${defaultUnitOfSales}" />
            	<g:hiddenField id="unitOfSale" name="unitOfSale" value=""/>
            	<%--<g:hiddenField id="counter" name="counter" value="0" />--%>
            	
            	<div class="dialog" id="dialog">
                       <table>
                       	<tbody id="maintbody">
                       		<tr id="maintr">
								<td>Unit Of Sale</td>
								<td>&nbsp;&nbsp;</td>
								
								<td>
									<g:textField name="additionalUnitOfSale" id="additionalUnitOfSale"  value="" class="required"></g:textField>
								</td>
								<td>&nbsp;&nbsp;</td>
								
								<td>Extra Unit</td>
								<td>&nbsp;&nbsp;</td>
								
								<td>
									<input type="text" id="extraUnit" name="extraUnit" class="required number" value=""/>
								</td>
								<td>&nbsp;&nbsp;</td>
								
								<td>
									<button id="saveExtraUnitBtn" class="saveExtraUnitBtn" title="Save and Add Extra Unit" > Save And Add New </button>
								</td>
							</tr>
                       	</tbody>
                       </table>
                </div>
	                
               	<div class="buttons">
               		<script>
                             
                          </script>
                </div><br/>
	                
                <div class="list">
	                <table>
	                	<thead>
	                        <tr>
	                            <th>Unit Of Sale</th>
	                        	<th>Extra Unit</th>
								<th>Short Name</th>
								<th>Action</th>
								<th></th>
	                        </tr>
	                    </thead>
	                    
	                    <tbody id="allData">
	                      	<g:each in="${extraUnitInstanceList}" status="i" var="extraUnitInstance">
	                      			
		                        <tr id="extraUnitRow${extraUnitInstance?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                            <td>${extraUnitInstance?.unitOfSale}</td>
		                            <td>${extraUnitInstance?.extraUnit}</td>
		                        	<td>ExtraUnit ${i+1}</td>
		                        	<td><a id="${extraUnitInstance.id}" href="#" class="removeExtraUnitSetup hyperlink"> Remove </a></td>
		                        </tr>
	                     
	                    	</g:each>
	                    </tbody>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
