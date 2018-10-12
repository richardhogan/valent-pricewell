
<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>

<script>

    var previewBinded = false;
    var index = 999;
    
    function refreshList(){
    	jQuery.ajax({type:'POST',data: {opportunityId: <%=opportunityInstance.id %> },
			 url:'${baseurl}/quotation/listPart',
			 success:function(data,textStatus){jQuery('#dvListPart').html(data);},
			 error:function(XMLHttpRequest,textStatus,errorThrown){}});
       }

    function previewQuotation(id){
    	jQuery("#dvPreview").html("..Loading");
    	jQuery( "#dvPreview" ).dialog( "option", "title", 'Preview of Quotation ID:' + id );
    	jQuery( "#dvPreview" ).dialog( "option", "zIndex", 10000 );
    	//jQuery( "#dvPreview" ).dialog( "option", "width", 900 );
		index = index+1000;
		jQuery( "#dvPreview" ).dialog( "open" );
		
		bindCloseDialog(id);
		 
			
		jQuery.ajax({type:'POST',data: {id: id},
					 url:'${baseurl}/quotation/previewQuotation',
					 success:function(data,textStatus){jQuery('#dvPreview').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 return false
    	
       }

     function bindCloseDialog(id){
         if(previewBinded){
			return;
         }
         else{
        	 jQuery( "#dvPreview" ).bind( "dialogclose", function(event, ui) {
        		 refreshShowInfo(id); 
 			});
        	previewBinded = true;
         }
      }
         

    function previewSOW(id){
        jQuery("#dvPreview").html("..Loading");
    	jQuery( "#dvPreview" ).dialog( "option", "title", 'Preview of SOW ID:' + id );
    	jQuery( "#dvPreview" ).dialog( "option", "zIndex", 9000 );
		index = index+1000;
		jQuery( "#dvPreview" ).dialog( "open" );

		bindCloseDialog(id);

		jQuery.ajax({type:'POST',data: {id: id},
					 url:'${baseurl}/quotation/previewSOW',
					 success:function(data,textStatus){jQuery('#dvPreview').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 return false
	}
	
	jQuery(document).ready(function()
	{
	 	
		jQuery( "#dvNewQuote" ).dialog(
		{
			height: 230,
			width: 330,
			modal: true,
			autoOpen: false,
			buttons: {
				Create: function() 
				{
					//alert(jQuery("input[name=versionType]:checked").val());
					showLoadingBox();
					jQuery.ajax({type:'POST',data: jQuery('#quotationCreate').serialize(),
						 url:'${baseurl}/quotation/save',
						 success:function(data1,textStatus)
						 {		
							 jQuery( "#dvNewQuote" ).dialog("close");
							 if(data1['res'] == "success")
							 {
								 var id = data1['id'];
								 
								 jQuery.ajax(
								 {
									type:'POST',
									data: {id: id, source: "fromOpportunity"},
				   					url:'${baseurl}/quotation/show',
				   					success:function(data,textStatus)
				   					{
					   					jQuery( '#dvQuote' ).html(data);
								 	   	jQuery( "#dvQuote" ).dialog( "option", "title", 'New Quote' );

								 	    var options = {
							 			    buttons: {
							 			        'Save': function() 
							 			        {
							 			        	//refreshList();
							 			        	saveQuote(id);
													jQuery( "#successdialog" ).html('<p>'+data1['msg']+'</p>');jQuery( "#successdialog" ).dialog("open");
													var options_n1 =	{buttons: {}};
													jQuery("#dvQuote").dialog('option', options_n1);
													jQuery("#dvQuote").dialog("close");
													return false;
							 			        },
							 			        'Cancel': function()
							 			        {
							 			        	deleteQuote(id);
							 			        	var options_n2 =	{buttons: {}};
													jQuery("#dvQuote").dialog('option', options_n2);
													jQuery("#dvQuote").dialog("close");
												    return false;
								 			    }
							 			    }
							 			};

								 	    jQuery("#dvQuote").dialog('option', options);
								 	    jQuery("#dvQuote").dialog("open");
									},
				   					error:function(XMLHttpRequest,textStatus,errorThrown){}
			   					});
							 }
							 else
							 {
								 jQuery( "#failuredialog" ).html(data1['msg']);
								 jQuery( "#failuredialog" ).dialog( "open" );
							 }
							 hideLoadingBox();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
				}
			}
			
		});

		jQuery( "#successdialog" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#successdialog" ).dialog( "close" );
					return false;
				}
			}
		});
				
		jQuery( "#failuredialog" ).dialog(
		{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#failuredialog" ).dialog( "close" );
					return false;
				}
			}
		});

				
		jQuery( "#dvQuote" ).dialog(
		{
			height: jQuery(window).height()-70,
			width: jQuery(window).width()-50,
			modal: true,
			autoOpen: false,
			closeOnEscape: false,
			open: function() {                         // open event handler
		        jQuery(this)                           // the element being dialogged
		            .parent()                          // get the dialog widget element
		            .find(".ui-dialog-titlebar-close") // find the close button for this dialog
		            .hide();                           // hide it
		    },
	    	close: function() {
	    		refreshList();
			}
		});

		jQuery( "#dvPreview" ).dialog(
		{
			height: jQuery(window).height()-50,
			width: jQuery(window).width()-50,
			modal: true,
			autoOpen: false,
			position:[10, 10]
		});


	}); 

 	function deleteQuote(id)
 	{
 		jQuery.ajax(
		{
			type:'POST',
			data: {id: id},
			url:'${baseurl}/quotation/delete',
			success:function(data,textStatus){if(data=="success"){refreshList();}},
			error:function(XMLHttpRequest,textStatus,errorThrown){}
		});
				
 	}

 	function saveQuote(id)
 	{
 		jQuery.ajax(
		{
			type:'POST',
			data: {id: id},
			url:'${baseurl}/quotation/changeServiceQuotationStatus',
			success:function(data,textStatus){if(data=="success"){refreshList();}},
			error:function(XMLHttpRequest,textStatus,errorThrown){}
		});
				
 	}

 	function cancelQuote(id)
 	{
 		jQuery.ajax(
		{
			type:'POST',
			data: {id: id},
			url:'${baseurl}/quotation/cancelServiceQuotationStatus',
			success:function(data,textStatus){if(data=="success"){refreshList();}},
			error:function(XMLHttpRequest,textStatus,errorThrown){}
		});
				
 	}
</script>
    <div class="body">
    	<h4 style="padding: 0px 0px 0px 0px"> Quotations & Contracts  </h4>
    
           	<div id="dvListPart" class="list">
           		<g:render template="/quotation/listPart" mode="['filePath': filePath, 'quoteAvailable': quoteAvailable, 'quotationInstance': quotationInstance, 'opportunityInstance': opportunityInstance]"/>
           	</div>
           	
           	<div id="successdialog" title="Success Message">
				
			</div>
	
			<div id="failuredialog" title="Failure Message">
				
			</div>
             <div id="dvNewQuote"></div> 
             <div id="dvQuote"> </div>
             <div id="dvPreview"> </div>
    </div>

                        
            