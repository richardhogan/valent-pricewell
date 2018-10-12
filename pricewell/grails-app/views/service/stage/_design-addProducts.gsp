
<g:set var="tmpProductList" value="${serviceProfileInstance?.productsRequired}" />

<%
	def baseurl = request.siteUrl
%>
<script>
	function hideUnhideActionBtn()
	{
		jQuery.ajax({
            url: '${baseurl}/service/hasServiceProductItem?id=' + <%=serviceProfileInstance?.id%>,
            type: 'POST', async: false, cache: false, timeout: 30000,
            error: function(){
                return false;
            },
            success: function(msg)
            { 
               if(msg == 'true')
               {
               		if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
            			jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");
        				
        				
        			}
    				
               }
               else
               {
               		if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
            			jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
        			}
        			
               }
                  
               return false;  
            }
        });
	}
</script>


<div id="mainProductsRequiredTab">

	<g:if test="${tmpProductList && tmpProductList.size() > 0}">
		<g:render template="/serviceProductItem/listServiceProductItems" model="['serviceProfileInstance': serviceProfileInstance, productList: productList]"/>
		
	</g:if>
	<g:else>
		<g:render template="/serviceProductItem/createFromService" model="['serviceProfileId': serviceProfileInstance.id, productList: productList]"/>
		
	</g:else>
	

</div>