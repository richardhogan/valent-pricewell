<%@ page import="com.valent.pricewell.ObjectType" %>

  <div class="dialog">
    <table>
        <tbody>
        	<tr class="prop">
                 <td valign="top" class="name">
                     <label for="name"><g:message code="serviceActivity.name.label" default="Name" /></label>
                      <em>*</em>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'name', 'errors')}">
                     <g:textField name="name" value="${serviceActivityInstance?.name}" class="required" size="133"/>
                 </td>
             </tr>
             
              <tr class="prop">
                 <td valign="top" class="name">
                     <label for="category"><g:message code="serviceActivity.category.label" default="Category" /></label>
                      <em>*</em>
                 </td>
                 <%--<g:set var="activityTypes" value="${ObjectType.getActivityTypes()}" />--%>
                 
                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'category', 'errors')}">
                     <g:textField name="category" id="category" value="${serviceActivityInstance?.category}" class="required"/>
                     
                     <%--<g:if test="${activityTypes?.size() > 0 }">
                   		<g:select name="defaultCategory" from="${activityTypes}" value="${serviceActivityInstance?.category}" noSelection="['':'-Select Default One-']" class="required"/>
                   	 </g:if>    	--%>
                     
                 </td>
             </tr>
         
             <tr class="prop">
                 <td valign="top" class="name">
                     <label for="description"><g:message code="serviceActivity.description.label" default="Description" /></label>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'description', 'errors')}">
                     <g:textArea name="description" value="${serviceActivityInstance?.description}" rows="3" cols="100" style="margin-left: 0px; margin-right: 0px; width: 940px;" />
                 </td>
             </tr>
        </tbody>
    </table>  	   
</div>  	   
   
    
  		   

   
