<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function()
	{
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showServiceImportStages?source=publish&id=' + ${serviceProfileInstance?.id}  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${serviceProfileInstance?.currentStep - 1}, labelFinish:'Publish Service', onFinish:onFinishCallback });
  		
		var stepNumber
		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

    	    //alert(fromStepIdx + " " + toStepIdx);
    	    //var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(fromStepIdx, toStepIdx); // return false to stay on step and true to continue navigation 
        }

        function showStepCallback(obj){
            
       		var elements = jQuery('.swMain ul.anchor li a:lt(' + ${serviceProfileInstance?.currentStep - 1} + ')')
       		var step_num= obj.attr('rel');
       		stepNumber = obj.attr('rel');
       		for(var i=0; i<elements.length; i++){
				if(jQuery(elements[i]).hasClass('disabled')){
						jQuery(elements[i]).removeClass("disabled").addClass("done")
							.attr("isDone",1);
					}	
           	}
            		
        }

		
		
    	function validateSteps(stepnumber, toStepIdx)
    	{
    	
            var isStepValid = true;
            /*if(stepnumber == 1)
            {
                if(toStepIdx > stepnumber)
                {
	            	if(jQuery('#serviceEditDef').validate().form())
	                {
	                    if(CKEDITOR.instances['definition'].getData())
	                    {
	                    	jQuery('<input />').attr('type', 'hidden')
	    	        		.attr('name', 'step_number')
	    	        		.attr('value', 3 + '')
	    	        		.appendTo('#serviceEditDef');
	
	    	        		jQuery('<input />').attr('type', 'hidden')
	                   		.attr('name', 'source')
	                   		.attr('value', 'concept')
	                   		.appendTo('#serviceEditDef');
	           		
	                    	jQuery('#serviceEditDef').submit();
	                    	//return true;
	                   	}
	                    else
	                    {
	                    	jAlert('Please add Scope Definition Language.', 'Alert Message');
							return false;
	                    }
	                    
	    	        }
                }
    		}*/
            return true;
			
        }

    	function onFinishCallback()
    	{
    		showLoadingBox();
			jQuery.post( '${baseurl}/service/publishImportService', 
				{id: ${serviceProfileInstance?.id}},
			      function( data ) 
			      {
			 		  hideLoadingBox();
			          if(data == 'success')
			          {		                   		                   		
	                   		jQuery( "#successDialog" ).dialog("open");
				      }
				      else
				      {
	                  		jQuery( "#failureDialog" ).dialog("open");
				      }
				      
			      });
        	
		    return false;
   	    }
          
    	jQuery( "#successDialog" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#successDialog" ).dialog( "close" );
					window.location.href = '${baseurl}/service/catalog';
					return false;
				}
			}
		});
		
		jQuery( "#failureDialog" ).dialog(
		{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#failureDialog" ).dialog( "close" );
					return false;
				}
			}
		});
	});
</script>

<div id="successDialog" title="Success">
	<p>Service published successfully.</p>
</div>

<div id="failureDialog" title="Failure">
	<p><g:message code="service.import.message.failure.dialog" default=""/></p>
</div>

<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['publish']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['publish']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>
