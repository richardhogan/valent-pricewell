<%@ page import="com.valent.pricewell.ObjectType" %>

<%
	def baseurl = request.siteUrl
%>

<html>
    <head>
        <script type="text/javascript">
        		jQuery(function() 
    			{
        			jQuery("#objectTypeCreateFrm").validate();

        			jQuery("#objectTypeCreateFrm input:text")[0].focus();

        			jQuery("#btnCancel").click(function()
  	  				{
  	  					
  	  					jQuery.ajax({
  	  						type: "POST",
  	  						url: "${baseurl}/objectType/listsetup",
  	  						data: {type: 'serviceDeliverable', source: 'firstSetup'},
  	  						success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
  	  						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
  	  					});
  	  					
  	  					return false;
  	  				});

        			jQuery('#name').keyup(function(){
					    this.value = this.value.toUpperCase();
					});
					 
  	        		jQuery("#btnCreateObjectType").click(function()
  	   				{
  	   					if(jQuery('#objectTypeCreateFrm').validate().form())
  	   					{
  	   						showLoadingBox();
  	   						
	  	   					jQuery.ajax({
		  	  					type: "POST", 
		  	  					url: "${baseurl}/objectType/checkForTypeAvailability", 
		  	  					data: jQuery("#objectTypeCreateFrm").serialize(),
		  	  					success: function(data)
		  	  					{
			  	  					if(data == "name_not_available")
				  	  				{
			  	  						jQuery.ajax(
			   	   						{
			   	   							type: "POST",
			   	   							url: "${baseurl}/objectType/saveType",
			   	   							data: jQuery("#objectTypeCreateFrm").serialize(),
			   	   							success: function(data)
			   	   							{
			   	   	   							hideLoadingBox();
			   	   								jQuery('#mainServicePropertiesTypesTab').html(data);
			
			   	   								refreshNavigation();
			   	   							}, 
			   	   							error:function(XMLHttpRequest,textStatus,errorThrown){
			
			   	   								hideLoadingBox();
			   	   								alert("Error while saving");
			   	   							}
			   	   						});
					  	  			}
				  	  				else
		  	  	   					{
		  	   							hideLoadingBox();
		  	   							jAlert('${message(code:'newDefaultEntityNameAvailable.message.alert')}', 'Create Default Entity Alert');
		  	  	  	   				}
			  	  				}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									return false;
								}
			   				});
  	   						
  	   					}
  	   					return false
  	   				});
        	        			
    			});

        	function isNameOfSelectedTypeAvailable()
        	{
        		
						return data;
					
   				//return false;
            }
		</script>
    </head>
    <body>
        
        <div class="body">
            <h1>Create Default Entity</h1>
            
            <g:form action="save" name="objectTypeCreateFrm">
            	<g:hiddenField name="createdFrom" value="setup"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="type"><g:message code="objectType.type.label" default="Type" /><em>*</em></label>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value ${hasErrors(bean: objectTypeInstance, field: 'type', 'errors')}">
                                    <g:select name="type" from="${objectTypeList}" keys="${objectTypeList}" value="${objectTypeInstance?.type?.name()}" noSelection="['':'-Select Any One-']" class="required"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="objectType.name.label" default="Name" /><em>*</em></label>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value ${hasErrors(bean: objectTypeInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${objectTypeInstance?.name}" class="required"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="objectType.description.label" default="Description" /><em>*</em></label>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value ${hasErrors(bean: objectTypeInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" value="${objectTypeInstance?.description}" rows="5" cols="40"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
	            
		            <span class="button">
	                  	<button id="btnCreateObjectType" class="btnCreateObjectType" title="Save">Save</button>
	                </span>
	                   	
		            <span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
		            
		        </div>
		        
            </g:form>
        </div>
    </body>
</html>
