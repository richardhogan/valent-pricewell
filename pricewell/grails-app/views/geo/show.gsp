
<%@ page import="com.valent.pricewell.Geo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geo.label', default: 'Geo')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script>
		 (function($) {
			  $(document).ready(function()
			  {				 
				  $('td.expandp span1').expander({
					    slicePoint:       200,  // default is 100
					    expandPrefix:     ' ', // default is '... '
					    expandText:       '[...]', // default is 'read more'
					    collapseTimer:    100000, // re-collapses after 100 seconds; default is 0, so no re-collapsing
					    userCollapseText: '[^]'  // default is 'read less'
					  });
			  });
			  
		 })(jQuery);
		</script>
    </head>
    <body>
        <div class="nav">
        	<g:if test="${createPermission}">
            	<span><g:link class="buttons.button button" title="Create Territory" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
            <span><g:link class="buttons.button button" title="List Of Territories" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <!-- <span><g:link class="buttons.button button" action="list" controller="deliveryRole">List of Delivery Roles</g:link></span>
        	<span><g:link class="buttons.button button" action="list" controller="geoGroup">List of Geos</g:link></span>-->
        </div>
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>${entityName} ${geoInstance.name }</div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.id.label" default="Id : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "id")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.name.label" default="Name : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "name")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.description.label" default="Description : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "description")}</td>
		                            
		                        </tr>
		                    
		                    	<tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.salesManager.label" default="Assigned Sales Manager : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "salesManager")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.salesPerson.label" default="Assigned Sales Persons : " /></label></td>
		                            
		                            <td valign="top" class="value">
		                            	<g:each in="${geoInstance.salesPersons}" var="g">
		                                    ${g?.encodeAsHTML()}</br>
		                                </g:each>
		                            </td>
		                            
		                        </tr>
		                        
		                        <tr class="prop">
		                    		<td valign="top" class="name"><label><g:message code="geo.dateFormat.label" default="Date Format : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "dateFormat")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.country.label" default="Country : " /></label></td>
		                            
		                            <td valign="top" class="value">
		                            	<g:if test="${geoInstance?.country?.size() == 3 }">
                        					<g:country code="${geoInstance?.country}"/>
                        				</g:if>
                       				</td>
		                    	</tr>
		                        
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.currency.label" default="Currency : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "currency")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.currencySymbol.label" default="CurrencySymbol : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "currencySymbol")}</td>
		                            
		                        </tr>
		                        
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.taxPercent.label" default="Tax (%) : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "taxPercent")}%</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <g:if test="${baseCurrency}">
		                               	<td valign="top" class="name" >
		                               		<label>Convert rate: 1 ${baseCurrency} = </label>
		                               	</td>
		                               	<td valign="top" class="value">
		                               		${geoInstance?.convert_rate} ${geoInstance?.currencySymbol}
		                               	</td>
		                             </g:if>
		                            
		                        </tr>
		                    	
		                    	<tr> 
					    			<td> 
					    				<label> SOW Label : </label>
					    			</td>
					    			
					    			<td> 
					    				${geoInstance?.sowLabel}
				    				</td>
					    		</tr>
					    		
		                    	<!--<tr> 
					    			<td> 
					    				<label> SOW Template : </label>
					    			</td>
					    			
					    			<td> 
					    				${geoInstance?.sowTemplate}
				    				</td>
					    		</tr>-->
		                    </tbody>
		                </table>
		                
		                <h1>SOW Template</h1>
		                <hr>
		                <p>
		                	${geoInstance?.sowTemplate}
		                </p>
		                
		                <h1>SOW Template Tags</h1>
		                <hr>
					    	<table>
					    		<tr>
					    			<td class="expandp">
					    				<label>[@@terms@@] : </label>
				    				</td>
				    				<td class="expandp">
				    					<span> ${geoInstance?.terms} </span> 
				    				</td>
					    		</tr>
					    		<tr>
					    			<td class="expandp">
					    				<label>[@@billing_terms@@] : </label>
				    				</td>
				    				<td class="expandp">
				    					<span> ${geoInstance?.billing_terms} </span> 
				    				</td>
					    		</tr>
					    		<tr>
					    			<td class="expandp">
					    				<label>[@@signature_block@@] : </label>
				    				</td>
				    				<td class="expandp">
				    					<span> ${geoInstance?.signature_block} </span> 
				    				</td>
					    		</tr>
					    	</table>
		            </div>
		            <div class="buttons">
		                <g:form>
		                    <g:hiddenField name="id" value="${geoInstance?.id}" />
		                    <g:if test="${updatePermission}">
		                    	<span class="button"><g:actionSubmit title="Edit Territory" class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
		                    </g:if>
		                    <g:if test="${createPermission}">
		                    	<span class="button"><g:actionSubmit title="Delete Territory" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
		                    </g:if>
		                </g:form>
		            </div>
				
				</div>
				
			</div>
            
            
        </div>
    </body>
</html>
