<%@ page import="com.valent.pricewell.ServiceStageFlow"%>

<%
	def baseurl = request.siteUrl
%>
<r:script>
   
    jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showStage?source=salesreview&id=' + <%=serviceProfileInstance?.id%> ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=serviceProfileInstance?.currentStep - 1%>, approveEnabled: true, onApprove: onApprove, onReject: onReject });
  		
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
    		//jQuery('#approveForm').submit();
    		
    		jQuery( "#rewiewCommentCreate" ).dialog( "open" );
			return false;
    	}
          
     
		});
</r:script>

	<g:if test="${serviceProfileInstance?.id != null}">
		<g:each in="${stagingInstanceList}" status="i" var="stage">
			<g:if test="${serviceProfileInstance?.stagingStatus?.id == stage.id}">
				<g:set var="currentIndex" value="${i+1}"/>
			</g:if>
		</g:each>
	</g:if>
	
<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['salesreview']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['salesreview']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

