<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>

<r:script>
   
    jQuery(document).ready(function(){
        	
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showStage?source=requestforpublished&id=' + <%=serviceProfileInstance?.id%> ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=serviceProfileInstance?.currentStep - 1%>, labelApprove:'Publish', approveEnabled: true, onApprove: onApprove, onReject: onReject });
		
		function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj){
        		var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=serviceProfileInstance?.currentStep - 1%> + ')')
        		var step_num= obj.attr('rel');
        		
        		for(var i=0; i<elements.length; i++){
					if(jQuery(elements[i]).hasClass('disabled')){
							jQuery(elements[i]).removeClass("disabled").addClass("done")
								.attr("isDone",1);
						}	
            	}
        		
        		
            }

    	function validateSteps(stepnumber){
            	return true;
            	 
            }

		function onApprove()
        {
        	jQuery('#status').val('${com.valent.pricewell.ReviewRequest.Status.APPROVED}');
        	
        	jQuery( "#rewiewCommentCreate" ).dialog( "open" );
			return false;
        }
        
        function onReject()
        {
        	jQuery('#status').val('${com.valent.pricewell.ReviewRequest.Status.REJECTED}');
        	
        	jQuery( "#rewiewCommentCreate" ).dialog( "open" );
			return false;
        }
        
    	function onFinishCallback()
    	{
    		jQuery( "#rewiewCommentCreate" ).dialog( "open" );
			return false;
    			//jQuery('#approveForm').submit();
      	}
          
     
	});
</r:script>

<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['requestforpublished']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${i+1}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['requestforpublished']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

