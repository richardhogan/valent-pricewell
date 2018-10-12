<%@ page import="com.valent.pricewell.ServiceStageFlow"%>

<%
	def baseurl = request.siteUrl
%>
<script type="text/javascript">
   
    jQuery(document).ready(function(){
    		
			jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showStage?source=design&id=' + <%=serviceProfileInstance?.id%> ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=serviceProfileInstance?.currentStep - 1%>, labelFinish:'Send Request', onFinish:onFinishCallback });

			jQuery('.swMain ul.anchor li a').height(30);
  		
    	/*function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }*/

		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

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
            	
            	if(step_num == 2)
            	{	
            		jQuery.ajax({
	                    url: '${baseurl}/service/hasActivityRoleDefine?id=' + <%=serviceProfileInstance?.id%>,
	                    type: 'POST', async: false, cache: false, timeout: 30000,
	                    error: function(){
	                        return false;
	                    },
	                    success: function(msg)
	                    { 
	                       if(msg == 'false')
		                   {
                        		jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
                        		//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
		                   }
			                    
	                    }
	                });
                
            	}

            	/*if(step_num == 3)
            	{	
            		jQuery.ajax({
	                    url: '${baseurl}/service/hasServiceProductItem?id=' + <%=serviceProfileInstance?.id%>,
	                    type: 'POST', async: false, cache: false, timeout: 30000,
	                    error: function(){
	                        return false;
	                    },
	                    success: function(msg)
	                    { 
	                       if(msg == 'false')
		                   {
                        		jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
                        		//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
		                   }
			                    
	                    }
	                });
                
            	}*/
        		
            }

    	function validateSteps(stepnumber, toStepIdx)
    	{
    		if(toStepIdx < stepnumber)
            {
                return true;
            }
            var isStepValid = true;

        		if(stepnumber == 2)
                {
                	var val = true;
                	if(toStepIdx > stepnumber)
                    {
                		jQuery.ajax({
    	                    url: '${baseurl}/service/hasActivityRoleDefine?id=' + <%=serviceProfileInstance?.id%>,
    	                    type: 'GET',
    	                    async: false,
    	                    cache: false,
    	                    timeout: 30000,
    	                    error: function(){
    	                        return false;
    	                    },
    	                    success: function(msg){ 
    		                    if(msg == 'false')
    			                   {
    	                        		val = false;
    	                        		jQuery('#step-2 div:first').prepend("<div class='errors'> Service Activity or Activity Role can not be empty </div>");
    	                        		
    			                   }
    			                    
    	                    }
    	                });
                    }
	            	return val;
                }

            	/*if(stepnumber == 3)
                {
                	var val = true;
	            	jQuery.ajax({
	                    url: '${baseurl}/service/hasServiceProductItem?id=' + <%=serviceProfileInstance?.id%>,
	                    type: 'GET',
	                    async: false,
	                    cache: false,
	                    timeout: 30000,
	                    error: function(){
	                        return false;
	                    },
	                    success: function(msg){ 
		                    if(msg == 'false')
			                   {
	                        		val = false;
	                        		jQuery('#step-2 div:first').prepend("<div class='errors'> Service Product Item can not be empty </div>");
	                        		
			                   }
			                    
	                    }
	                });

	                return val;
                }*/

            	return true;
            	 
            }

    	function onFinishCallback(){
    	       if(jQuery('#changeStage').validate().form()){
    	    	   jQuery("#changeStage").submit();
    	       }
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
				<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['design']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['design']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

