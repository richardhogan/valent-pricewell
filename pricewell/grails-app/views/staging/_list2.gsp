
<%@ page import="com.valent.pricewell.Staging" %>

		
		<g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    
    <div class="body">
        
	        
	        <div class="leftNavSmall">      		
	    		<g:render template="../staging/nevigationsetup"/>
	    	</div>
	        
	        <div class="body rightContent column">
	            
	            <h1>${title}<!-- &nbsp; &nbsp;<span><button id="createStaging"> Add Staging </button></span>--></h1><hr />
	            
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="stagingsList">
	                    <thead>
	                        <tr>
	                        
	                            <th>Order</th>
	                            
	                            <th>Display Name</th>
	                        	
	                            <th>Description</th>
	                        
	                        	<!-- <th></th>
	                        	<th></th>-->
	                        </tr>
	                    </thead>
	                    <tbody>
		                    <g:each in="${stagingInstanceList}" status="i" var="stagingInstance">
		                        <tr>
		                        
		                            <td>${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
		                            <td><!-- <a id="${stagingInstance.id}" href="#" class="showStaging">--> ${fieldValue(bean: stagingInstance, field: "displayName")}<!-- </a>--></td> 
		                            
		                            <td>${fieldValue(bean: stagingInstance, field: "description")}</td>
		                        
		                        	<!-- <td> <a id="${stagingInstance.id}" href="#" class="editStaging"> edit </a></td>-->
									<!-- <td> <a id="${stagingInstance.id}" href="#" class="deleteStaging"> delete </a></td>-->
		                        </tr>
		                    </g:each>
	                    </tbody>
	                </table>
	            </div>
	            
	        </div>
	    
	    <div id="stagingDialog" title="">
			
		</div>
    </div>

