

<%@ page import="com.valent.pricewell.ReviewRequest" %>
<g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
<script>
		jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
					jQuery("#reviewRequestEdit").validate();
					
			  });
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

			jQuery( "#submitToUpdate" ).click(function() 
			{
				if(jQuery('#reviewRequestEdit').validate().form())
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/reviewRequest/update', 
			    		jQuery("#reviewRequestEdit").serialize(),
				      	function( data ) 
				      	{
							hideLoadingBox();
			  				jQuery("#mainReviewBoardTab").html(data);
				          	return false;
				          
				      	});

				}
	       		return false;
			});
		});	

		function createReviewRequest()
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/reviewRequest/create",
				data: {'category': '${category}', 'type': '${type}'},
				success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}
		
		function reviewRequestList(type)
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
    	<g:if test="${!hideUpperNav}">
    		<div class="nav">
	        	<span>
	        		<!--<g:remoteLink class="buttons.button button" controller="reviewRequest" action="list" params="[category: category, type: type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.list.label" args="[entityName]" /></g:remoteLink>-->
	        		<a id="idCreateReviewRequest" onclick="createReviewRequest();" class="buttons.button button" title="Create Review Request"><g:message code="default.new.label" args="[entityName]" /></a>
	        	</span>
	        		
	            <span>
	            	<!--<g:remoteLink class="buttons.button button" controller="reviewRequest" action="create" params="[category: category, type: type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.new.label" args="[entityName]" /></g:remoteLink>-->
	            	
	            	<a id="idReviewRequestList" onclick="reviewRequestList();" class="buttons.button button" title="List Of Review Request"><g:message code="default.list.label" args="[entityName]" /></a>
	            </span>
	        </div>
    	</g:if>
        
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${reviewRequestInstance}">
            <div class="errors">
                <g:renderErrors bean="${reviewRequestInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="reviewRequestEdit">
                <g:hiddenField name="id" value="${reviewRequestInstance?.id}" />
                <g:hiddenField name="version" value="${reviewRequestInstance?.version}" />
                <g:hiddenField name="category" value="${category}" />
                <g:hiddenField name="type" value="${type}" />
                <g:hiddenField name="sourceFrom" value="${sourceFrom}" />
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
                                    <g:select name="assignees" from="${usersList}" multiple="yes" optionKey="id" size="5" value="${reviewRequestInstance?.assignees*.id}" />
                                </td>
                            </tr>
                        
                          
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="status"><g:message code="reviewRequest.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'status', 'errors')}">
                                    <g:select name="status" from="${com.valent.pricewell.ReviewRequest$Status?.values()}" keys="${com.valent.pricewell.ReviewRequest$Status?.values()*.name()}" value="${reviewRequestInstance?.status?.name()}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
            		<span class="button">
            		
            			<button id="submitToUpdate">Update</button>
            		</span>
                </div>
            </g:form>
        </div>
    </body>

							