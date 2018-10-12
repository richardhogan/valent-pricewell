<%@ page import="com.valent.pricewell.ServiceStageFlow"%>

<%
	def baseurl = request.siteUrl
%>
<script>
   
    jQuery(document).ready(function(){
    	
        	
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showStage?source=designreview&id=' + <%=serviceProfileInstance?.id%> ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=serviceProfileInstance?.currentStep - 1%>, approveEnabled: true, onApprove: onApprove, onReject: onReject});
  		
  		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

    	    //alert(fromStepIdx + " " + toStepIdx);
    	    //var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(fromStepIdx, toStepIdx); // return false to stay on step and true to continue navigation 
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
            	
            	if(step_num == 3)
            	{	
            		jQuery('.buttonFinish').removeClass("buttonDisabled");
            		jQuery('.buttonReject').removeClass("buttonDisabled");
            		
            	}
            	else
            	{
            		jQuery('.buttonFinish').addClass("buttonDisabled");
            		jQuery('.buttonReject').addClass("buttonDisabled");
            	}
        		
            }

    	function validateSteps(stepnumber, toStepIdx)
    	{
    		if(toStepIdx < stepnumber)
            {
                return true;
            }
            	/*if(stepnumber == 2)
                {
                    if(toStepIdx > stepnumber)
                    {
    	            	if(jQuery('#serviceEditDef').validate().form())
    	                {
    	                    if(CKEDITOR.instances['definition'].getData())
    	                    {
    	                    	jQuery('<input />').attr('type', 'hidden')
    	    	        		.attr('name', 'step_number')
    	    	        		.attr('value', 3+'')
    	    	        		.appendTo('#serviceEditDef');
    	
    	    	        		jQuery('<input />').attr('type', 'hidden')
    	                   		.attr('name', 'source')
    	                   		.attr('value', 'concept')
    	                   		.appendTo('#serviceEditDef');
    	           		
    	                    	jQuery('#serviceEditDef').submit();
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
</script>

	<g:if test="${serviceProfileInstance?.id != null}">
		<g:each in="${stagingInstanceList}" status="i" var="stage">
			<g:if test="${serviceProfileInstance?.stagingStatus?.id == stage.id}">
				<g:set var="currentIndex" value="${i+1}"/>
			</g:if>
		</g:each>
	</g:if>
	
<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['designreview']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['designreview']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

