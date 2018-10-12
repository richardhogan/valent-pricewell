<%@ page import="com.valent.pricewell.ObjectType" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			.ui-autocomplete {
    			max-height: 100px;
    			overflow-y: auto;
    			/* prevent horizontal scrollbar */
    			overflow-x: hidden;
  			}
			
			/* IE 6 doesn't support max-height
   			* we use height instead, but this forces the menu to always be this tall
   			*/
   
			* html .ui-autocomplete {
    			height: 100px;
  			}
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			jQuery(function() 
			{
				jQuery("#editActivity").validate();
				jQuery("#editActivity input:text")[0].focus();

				var availableServiceActivityCategories = ${serviceActivityCategories as JSON};

		 		jQuery("#category").autocomplete({
			    	source: availableServiceActivityCategories
			    });
		 		
		 		jQuery("#category").keyup(function(){
				    this.value = this.value.toUpperCase();
				});
			});
  		</script>
</head>

<div class="body">
	<g:form method="post" name="editActivity">
       <g:hiddenField name="id" value="${serviceActivityInstance?.id}" />
       <g:hiddenField name="version" value="${serviceActivityInstance?.version}" />
       
	   <div class="dialog">
		    <table>
		        <tbody>
		        	<tr class="prop">
		                 <td valign="top" class="name">
		                     <label for="name"><g:message code="serviceActivity.name.label" default="Name" /></label>
		                      <em>*</em>
		                 </td>
		                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'name', 'errors')}">
		                     <g:textField name="name" value="${serviceActivityInstance?.name}" size="133" class="required"/>
		                 </td>
		            </tr>
		            <tr class="prop"> 
		                 <td valign="top" class="name">
		                     <label for="category"><g:message code="serviceActivity.category.label" default="Category" /></label>
		                      <em>*</em>
		                 </td>
		                 
		                 <%--<g:set var="activityTypes" value="${ObjectType.getActivityTypes()}" />--%>
		                 
		                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'category', 'errors')}">
		                     
		                     <%--<g:if test="${activityTypes?.size() > 0 }">
		                   		<g:select name="category" from="${activityTypes}" value="${serviceActivityInstance?.category}" noSelection="['':'-Select Default One-']" class="required"/>
		                   	 </g:if> 
		                   	 --%>
                   	 		<g:textField name="category" value="${serviceActivityInstance?.category}" class="required"/>
		                 </td>
		            </tr>
		            <tr class="prop"> 
		                 <td valign="top" class="name">
		                     <label for="description"><g:message code="serviceActivity.description.label" default="Description" /></label>
		                 </td>
		                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'description', 'errors')}">
		                     <g:textArea name="description" value="${serviceActivityInstance?.description}" rows="5" cols="100" style="margin-left: 0px; margin-right: 0px; width: 100%;"/>
		                 </td>
		             </tr>
		        </tbody>
		    </table>  	   
		</div>  	   

    </g:form>
</div>