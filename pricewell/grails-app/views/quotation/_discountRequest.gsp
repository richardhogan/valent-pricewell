<%
	def baseurl = request.siteUrl
%>

	<script>
		 jQuery(document).ready(function(){
			 	jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {

			 		jQuery("#discountRequest").validate();		 		
			 	});
					
				jQuery('#save').button();
				
				jQuery('#btnSaveDiscountRequest').click(function()
				{
					showLoadingBox();
					jQuery.ajax({type:'POST',data:jQuery('#discountRequest').serialize(),
						 url:'${baseurl}/quotation/sendDiscountNotification',
						 success:function(data,textStatus)
						 {
							 hideLoadingBox();
							 jQuery( "#dvQutationServices" ).dialog( "close" );
							 jQuery('#dvQuote').html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				});
			 });
		
		 
  </script>
    
            
    <g:form  name="discountRequest" url="[action:'sendDiscountNotification',controller:'quotation']">
        <g:hiddenField name="id" value="${quotationInstance?.id}" />
        
        <h1><g:message code="quotation.discountRequest.message" default=""/></h1>
        <div class="dialog">
            <table>
                <tbody>
                	<tr class="prop">
                        <td valign="top" class="name">
                          <label for="Message">Comment</label>
                        </td>
                        <td valign="top">
                            <g:textArea name="comment" value="" rows="5" cols="40"/>
                        </td>
                    </tr>                        
                  
                </tbody>
            </table>
        </div>
        <div class="buttons">
        	<input id="btnSaveDiscountRequest" class="save" title="Save" value="Save" type="button"/>
        	<!--g:submitButton id="save" name="save" class="save" value="Send Request" /-->
        </div>
    </g:form>
        
