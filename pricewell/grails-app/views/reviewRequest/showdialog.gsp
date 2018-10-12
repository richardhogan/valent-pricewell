
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceProfile" %>
<%@ page import="com.valent.pricewell.*" %>
<html>
        <div class="body"  style="width: 700px; height: 600px; overflow: auto">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
               <g:render template="show-info" model="['reviewRequestInstance': reviewRequestInstance]"/>
            </div>
            <div class="buttons">
            <g:if test="${submitterLoggedIn}">
                <g:form>
                    <g:hiddenField name="id" value="${reviewRequestInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                
                </g:form>
                   <br>
             </g:if>
             </div>
			 
			<div id="mainComment">				
				<table> 
					<g:hiddenField name="reviewRequestId" value="${reviewRequestInstance?.id}"/>
					
				    <tr>
				    <td>
				    						
					  <g:render template="/reviewComment/listComments" model="['reviewRequestInstance' : reviewRequestInstance, 'commentAllowed': commentAllowed, 'statusChangeAllowed': statusChangeAllowed, 'source': 'serviceProfile']"></g:render>	
									
						</td>		
					</tr>
					
				</table>				
    	</div>
			
       </div> 
    </body>
</html>