<%@ page import="com.valent.pricewell.EncriptAndDecript" %>

<script>

		 jQuery(document).ready(function()
		 {
		
				jQuery('a[tooltip]').each(function()
						   {
						      jQuery(this).qtip({
						         content: jQuery(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
						         style: 'dark', // Give it a crea mstyle to make it stand out
						        	 
						               position: {
						                  corner: {
						                      // Use the corner...
						                     target: 'bottomLeft' // ...and opposite corner
						                  }
						               }
						      });
				
				});
		 });
</script>


<div id="emailSetting${i}" class="emailSetting-div" <g:if test="${hidden}">style="display:none;"</g:if>>
    <g:hiddenField name='emailSettingList[${i}].id' value='${emailSettingInstance?.id}'/>
    <g:hiddenField name='emailSettingList[${i}].deleted' value='false'/>
	<g:hiddenField name='emailSettingList[${i}].new' value="${emailSettingInstance?.id == null?'true':'false'}"/>
    
    
    <td>
    	<g:textField name="name" value="${emailSettingInstance.name}" readonly="true"/>
    </td>
    
    <td>&nbsp;&nbsp;</td>
    <td>
		<g:if test="${emailSettingInstance?.secret=='true'}">
			<%
				def secretValue = EncriptAndDecript.decrypt(emailSettingInstance.value);
			%>
			
			<g:passwordField name="val" value="${secretValue}" readonly="true"/>
			
		</g:if>
		<g:else>
			<g:textField name="val" value="${emailSettingInstance.value}" readonly="true"/>
		</g:else>
		    	
    </td>
    
    <td>&nbsp;&nbsp;</td>
    <td></td>
      
    <td>&nbsp;&nbsp;</td>  
	<td>
		<g:remoteLink action="edit" controller="emailSetting" update="emailSettingEdit" class="hyperlink"
			id="${emailSettingInstance?.id}" onLoading="jQuery('#emailSettingEdit').dialog('open');" tooltip="Edit">
			<r:img dir="images/skin" file="database_edit.png"/>
			</g:remoteLink>
	</td>
   
    <td>&nbsp;&nbsp;</td>  
	<td>
		<g:remoteLink action="delete" controller="emailSetting" update="success" class="hyperlink"
			id="${emailSettingInstance?.id}" onLoading="doRefresh();" tooltip="Delete"
			onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
			<r:img dir="images/skin" file="database_delete.png"/>
			</g:remoteLink>
	</td>
</div>
