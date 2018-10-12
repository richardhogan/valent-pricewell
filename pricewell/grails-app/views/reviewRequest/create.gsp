<%@ page import="com.valent.pricewell.ReviewRequest" %>
<g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
		/*jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
					jQuery("#reviewRequestCreate").validate();
					
			  });*/

		jQuery(document).ready(function()
		{			 
			tinyMCE.init({
        		// General options
        		mode : "textareas",
        		theme : "advanced",
        		skin : "o2k7",
        		plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advlink,iespell,insertdatetime,preview,searchreplace,print,directionality,fullscreen,noneditable,visualchars,nonbreaking,template,inlinepopups,autosave",

        		// Theme options
        		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect,fontselect,fontsizeselect",
        		theme_advanced_buttons2 : "bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,forecolor,backcolor,|,cite,abbr,acronym,del,ins,attribs,|,nonbreaking,pagebreak,|,fullscreen",
        	    theme_advanced_buttons3 : "",
        	
        		theme_advanced_toolbar_location : "top",
        		theme_advanced_toolbar_align : "left",
        		theme_advanced_statusbar_location : "bottom",
        		theme_advanced_resizing : true,
        		// Replace values for the template plugin
        		template_replace_values : {
        			username : "Some User",
        			staffid : "991234"
        		}
        	});
        	
		    jQuery( "#successDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#successDialog" ).dialog( "close" );
						
						jQuery.ajax({type:'POST',data: {category: '<%=category %>', type: '<%=type %>' },
							 url:'${baseurl}/reviewRequest/list',
							 success:function(data,textStatus){jQuery('#mainReviewBoardTab').html(data);},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
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

			jQuery( "#reviewRequest" ).click(function() 
			{
				if(jQuery('#reviewRequestCreate').validate().form())
				{
					showLoadingBox();
	   				jQuery.post( '${baseurl}/reviewRequest/save', 
        				  jQuery("#reviewRequestCreate").serialize(),
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
					          
					          return false;
					          
					      });
            		
        		}
				return false;
			});

		});

		  function reviewRequestList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/reviewRequest/list",
					data: {'category': '${category}', 'type': '${type}'},
					success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
</script>
<body>
        <div class="nav">
            <span>
            	<a id="idReviewRequestList" onclick="reviewRequestList();" class="buttons.button button" title="List Of Review Request">List of Review Request</a>
            	<!--<g:remoteLink class="buttons.button button" controller="reviewRequest" action="list" params="[category: category, type: type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.list.label" args="[entityName]" /></g:remoteLink>-->
            </span>
        </div>
        <div class="body">
        
        	<div id="successDialog" title="Success">
				<p><g:message code="reviewRequest.create.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureDialog" title="Failure">
				<p><g:message code="reviewRequest.create.message.failure.dialog" default=""/></p>
			</div>
			
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${reviewRequestInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${reviewRequestInstance}" as="list" />
	            </div>
            </g:hasErrors>
            <g:form action="save" name="reviewRequestCreate">
            
            <g:hiddenField name="userId" value="${userId}" />
            <g:hiddenField name="source" value="inbox" />
           
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="subject"><g:message code="reviewRequest.subject.label" default="Subject" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'subject', 'errors')}">
                                    <g:textField name="subject" value="${reviewRequestInstance?.subject}" class="required"/>
                                </td>
                            </tr>
                        	
                        	<tr class="prop">
                                <td valign="top" class="name">
                                  <label><g:message code="serviceProfile.label" default="Service" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'assignees', 'errors')}">
                                    <g:select name="serviceProfileId" from="${com.valent.pricewell.ServiceProfile.list()?.sort {it.service.serviceName}}" optionKey="id" value="${serviceProfileId}" />
                                </td>
                            </tr>
                        	
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="reviewRequest.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" value="${reviewRequestInstance?.description}" rows="5" cols="50"/>
                                </td>
                            </tr>
                        
                         <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="assignees"><g:message code="reviewRequest.assignees.label" default="Assignees" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'assignees', 'errors')}">
                                    <g:select name="assignees" from="${userList.sort {it.profile.fullName}}" multiple="yes" optionKey="id" size="5" value="${serviceProfileInstance?.reviewRequestInstance?.assignees*.id}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status"><g:message code="reviewRequest.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'status', 'errors')}">
                                            REVIEW
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button">	            		
	            		<button id="reviewRequest">Create</button></b>
	            	</span>
                </div>
            </g:form>
        </div>
</body>

