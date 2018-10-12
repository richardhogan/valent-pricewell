
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
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
				type: "POST",
				url: "${baseurl}/geo/listsetup",
				data: {source: 'firstsetup'},
				success: function(data){
					jQuery('#contents').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
		var ajaxList = new AjaxPricewellList("Territory", "Geo", "${baseurl}", "setup", 700, 800, "${allowCreate}", "${allowEdit}", "${allowDelete}", "${allowShow}");
		
		jQuery(document).ready(function()
		{
			ajaxList.init();
		});
	</script>
    <body>
        <div class="body">
            <h1> ${geoInstanceTotal} Territories defined &nbsp; &nbsp;
            	<g:if test="${allowCreate == true}">
            		<span><button id="createGeo"> Add Territory </button></span>
           		</g:if>
			</h1><hr />
			
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="geosList">
                    <thead>
                        <tr>
                            <th>${message(code: 'geo.name.label', default: 'Name')}</th>
                        
                            <th>${message(code: 'geo.description.label', default: 'Description')}</th>
                        
                        	<th>${message(code: 'geo.country.label', default: 'Country')}</th>
                        	
                            <th>${message(code: 'geo.currency.label', default: 'Currency')}</th>
                            
                        	<th>${message(code: 'geo.currencySymbol.label', default: 'CurrencySymbol')}</th>
                        	<th>Sales Manager</th>
                        	<th>Sales Persons</th>
							<th> GEO </th>
							
							<g:if test="${allowEdit == true}"><th></th></g:if>
                            
                            <g:if test="${allowDelete == true}"><th></th></g:if>
							
                        	
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${geoInstanceList}" status="i" var="geoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	
                        	<g:if test="${allowShow == true}">
                        		<td><a id="${geoInstance.id}" title="Show Details" href="#" class="showGeo hyperlink"> ${fieldValue(bean: geoInstance, field: "name")} </a></td>
                            </g:if>
                            <g:else>
                           		${fieldValue(bean: geoInstance, field: "name")}
                           	</g:else>
                        
                            <td>${fieldValue(bean: geoInstance, field: "description")}</td>
                        
                        	<td>
                        		<g:if test="${geoInstance?.country?.size() == 3 }">
                        			<g:country code="${geoInstance?.country}"/>
                        		</g:if>
                       		</td>
                        	
                            <td>${fieldValue(bean: geoInstance, field: "currency")}</td>
                            
                            <td>${fieldValue(bean: geoInstance, field: "currencySymbol")}</td>
							
							<td>${fieldValue(bean: geoInstance, field: "salesManager")}</td>
							
							<td>
								${geoInstance.salesPersons.join('</br>')}
								
							</td>
							
							<td> ${fieldValue(bean: geoInstance, field: "geoGroup")} </td>
	
							<g:if test="${allowEdit == true}">
								<td> <a id="${geoInstance.id}" href="#" class="editGeo hyperlink" title="Edit Territory"> Edit </a></td>
							</g:if>
							<g:if test="${allowDelete == true}">
								<td> <a id="${geoInstance.id}" href="#" class="deleteGeo hyperlink" title="Delete Territory"> Delete </a></td>
							</g:if>
								
							
							
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
		<div id="geoDialog" title="">
			
		</div>
    </body>
</html>
