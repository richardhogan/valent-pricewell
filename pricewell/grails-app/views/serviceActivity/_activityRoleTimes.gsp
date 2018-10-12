<style>
	 .w-fixed {
	 	  display: inline-block;
			width: 15em;
	}
</style>

<g:setProvider library="prototype"/>
<script type="text/javascript">
    var childCount = ${serviceActivityInstance?.rolesEstimatedTime?.size()} + 0;

    function addRole()
    {
      var roleDefined = jQuery('#roleDefined').val(); roleDefined++;
      jQuery('#roleDefined').val(roleDefined); 
      //alert(jQuery('#roleDefined').val());
      var clone = jQuery("#activityRoleTime_clone").clone()
      var htmlId = 'rolesEstimatedTimeList['+childCount+'].';     
		
      clone.find("input[id$=id]")
             .attr('id',htmlId + 'id')
             .attr('name',htmlId + 'id');

      
      clone.find("input[id$=deleted]")
              .attr('id',htmlId + 'deleted')
              .attr('name',htmlId + 'deleted');
      clone.find("input[id$=new]")
              .attr('id',htmlId + 'new')
              .attr('name',htmlId + 'new')
              .attr('value', 'true');

      var roleSel = clone.find("select[id$=role\\.id]")
      		roleSel.attr('id',htmlId + 'role.id')
            roleSel.attr('name',htmlId + 'role.id');
           
      clone.find("input[id$=estimatedTimeInHoursFlat]")
              .attr('id',htmlId + 'estimatedTimeInHoursFlat')
              .attr('name',htmlId + 'estimatedTimeInHoursFlat');
      

      clone.find("input[id$=estimatedTimeInHoursPerBaseUnits]")
		      .attr('id',htmlId + 'estimatedTimeInHoursPerBaseUnits')
		      .attr('name',htmlId + 'estimatedTimeInHoursPerBaseUnits');

      clone.attr('id', 'activityRoleTime'+childCount);
      jQuery("#childList").append(clone);
      clone.show();
      roleSel.focus();
      if(childCount == 0){
          jQuery('#childList div:first').show();
       }

      jQuery('#childList div span').addClass('w-fixed');
      
      childCount++;
    }

    jQuery(function() {
    	jQuery('#btnrole').bind('click', addRole);
    	jQuery('#childList div span').addClass('w-fixed');

    	//bind click event on delete buttons using jquery live
        jQuery('.del-activityRoleTime').live('click', function() 
        //{
       	//jQuery(".del-activityRoleTime").click(function()
    	{
    		var roleDefined = jQuery('#roleDefined').val(); roleDefined--;
            jQuery('#roleDefined').val(roleDefined);
            alert(jQuery('#roleDefined').val());
            //find the parent div
            var prnt = jQuery(this).parents(".activityRoleTime-div");
            //find the deleted hidden input
            var delInput = prnt.find("input[id$=deleted]");
            //check if this is still not persisted
            var newValue = prnt.find("input[id$=new]").attr('value');
            //if it is new then i can safely remove from dom
            if(newValue == 'true'){
                prnt.remove();
            }else{
                //set the deletedFlag to true
                delInput.attr('value','true');
                //hide the div
                prnt.hide();
            }
        });
	});


</script>

<div id="childList" class="childList" style="width: 100%">
	<div <g:if test="${!serviceActivityInstance || !serviceActivityInstance.rolesEstimatedTime || serviceActivityInstance?.rolesEstimatedTime?.size() == 0}">style="display:none;"</g:if>>
		
		<span> Delivery Role* </span>
		<span> Est Hrs (Flat)* </span>
		<span> Extra Hrs per Unit* </span>
		
	</div>
    <g:each var="activityRoleTime" in="${serviceActivityInstance?.rolesEstimatedTime}" status="i">
        
        
        <!-- Render the activityRoleTime template (_activityRoleTime.gsp) here -->
        <g:render template='activityRoleTime' model="['activityRoleTimeInstance':activityRoleTime,'i':i,'hidden':false]"/>
        
        
        
    </g:each>
   
</div>
<input id="btnrole" type="button" title="Add Role" value="Add Role" />
