 <g:form action="testemail" >
 	<table>
        <tbody>
        
            <tr class="prop">
                <td>
                    <label for="name"><g:message code="setting.name.label" default="Name" /></label>
                </td>
                <td >
                    <g:textField name="email" value="check39@gmail.com" />
                </td>
            </tr>
          </tbody>
          
       <div class="buttons">
          <span class="button"><g:submitButton name="create" class="save" value="Test Email" /></span>
       </div>
    </table>
 </g:form>