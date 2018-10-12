<table>
		<tbody>
			<tr class="prop">
					<td valign="top" class="name">
                    	<label for="subject"><g:message code="reviewRequest.subject.label" default="Subject : " /></label>
                    </td>
                    <td valign="top" class="value" colspan="3">
                        ${reviewRequestInstance.subject}
                    </td>
                            
			</tr>
			<tr class="prop">
                    <td valign="top" class="name">
                        <label for="description"><g:message code="reviewRequest.description.label" default="Description : " /></label>
                    </td>
                    <td valign="top" colspan="3" class="value ${hasErrors(bean: reviewRequestInstance, field: 'description', 'errors')}">
                        ${reviewRequestInstance.description}
                    </td>
             </tr>
             <tr class="prop">
                    <td valign="top" class="name"> <label> <g:message code="reviewRequest.submitter.label" default="Submitter : " /> </label></td>
                    
                    <td valign="top" class="value"><g:link controller="user" action="show" id="${reviewRequestInstance?.submitter?.id}">${reviewRequestInstance?.submitter?.encodeAsHTML()}</g:link></td>
                    
                    <td>&nbsp;&nbsp;</td>
                    
                    <td valign="top" class="name"><label><g:message code="reviewRequest.assignees.label" default="Assignees : " /></label></td>
                    
                    <td valign="top" style="text-align: left;" class="value">
                        
                        <g:each in="${reviewRequestInstance.assignees}" var="a" status="k">
                        	<g:if test="${k>0}">
                        		;
                        	</g:if>
                            <span> ${a?.encodeAsHTML()} </span>
                        </g:each>
                        
                    </td>
                            
              </tr>
              <tr class="prop">
                                       
                    <td valign="top" class="name"><label><g:message code="reviewRequest.status.label" default="Status : " /></label></td>
                    
                    <td valign="top" class="value">${reviewRequestInstance?.status?.encodeAsHTML()}</td>
                    
               </tr>
        </tbody>
   </table>