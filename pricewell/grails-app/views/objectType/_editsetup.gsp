<%@ page import="com.valent.pricewell.ObjectType" %>

<%
	def baseurl = request.siteUrl
%>

<html>
    <head>
        <script type="text/javascript">
        		jQuery(function() 
    			{
        			jQuery("#objectTypeEditFrm").validate();

        			jQuery("#objectTypeEditFrm input:text")[0].focus();

        			jQuery('#name').keyup(function(){
					    this.value = this.value.toUpperCase();
					});
					
        			jQuery("#btnCancel").click(function()
  	  				{
  	  					
  	  					jQuery.ajax({
  	  						type: "POST",
  	  						url: "${baseurl}/objectType/listsetup",
  	  						data: {type: '${type}', source: 'firstSetup'},
  	  						success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
  	  						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
  	  					});
  	  					
  	  					return false;
  	  				});

  	        		jQuery("#btnEditObjectType").click(function()
  	   				{
  	   					if(jQuery('#objectTypeEditFrm').validate().form())
  	   					{
  	   						showLoadingBox();
  	   				    	jQuery.ajax(
  	   						{
  	   							type: "POST",
  	   							url: "${baseurl}/objectType/updateType",
  	   							data: jQuery("#objectTypeEditFrm").serialize(),
  	   							success: function(data)
  	   							{
  	   	   							hideLoadingBox();
  	   								jQuery('#mainServicePropertiesTypesTab').html(data);
  	   								
  	   							}, 
  	   							error:function(XMLHttpRequest,textStatus,errorThrown){

  	   								hideLoadingBox();
  	   								alert("Error while saving");
  	   							}
  	   						});
  	   					}
  	   					return false
  	   				});
        	        			
    			});

		</script>
    </head>
    <body>
        
        <div class="body">
            <h1>Edit Service Property Type</h1>
            
            <g:form action="save" name="objectTypeEditFrm">
            	<g:hiddenField name="id" value="${objectTypeInstance?.id}"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="type"><g:message code="objectType.type.label" default="Type" /><em>*</em></label>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value ${hasErrors(bean: objectTypeInstance, field: 'type', 'errors')}">
                                	<g:textField name="type" value="${objectTypeInstance?.type}" class="required" readOnly="true"/>
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
	                  	<button id="btnEditObjectType" class="btnEditObjectType" title="Update">Update</button>
	                </span>
	                   	
		            <span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
		            
		        </div>
		        
            </g:form>
        </div>
    </body>
</html>
