<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <link type="text/css" href="${baseurl}/css/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" />	
		<script type="text/javascript" src="${baseurl}/js/jquery-1.6.2.min.js"></script>
		<script type="text/javascript" src="${baseurl}/js/jquery-ui-1.8.16.custom.min.js"></script>
		 <script type="text/javascript" src="${baseurl}/js/tiny_mce/tiny_mce.js"></script>
		
		<script language="JavaScript" type="text/javascript"> 
        	jQuery.noConflict();

        	tinyMCE.init({
        		// General options
        		mode : "textareas",
        		theme : "advanced",
        		skin : "o2k7",
        		plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,inlinepopups,autosave",

        		// Theme options
        		theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
        		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
        		theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
        		theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak,restoredraft",
        		theme_advanced_toolbar_location : "top",
        		theme_advanced_toolbar_align : "left",
        		theme_advanced_statusbar_location : "bottom",
        		theme_advanced_resizing : true,

        		// Example word content CSS (should be your site CSS) this one removes paragraph margins
        		content_css : "css/word.css",

        		// Replace values for the template plugin
        		template_replace_values : {
        			username : "Some User",
        			staffid : "991234"
        		}
        	});
        	
		</script>  
		<script type="text/javascript">
    
	    (function($) { 
		    		$(function() {
							$( "#statusChangeDate" ).datepicker();
					}); })(jQuery);
    	</script>
        <g:set var="entityName" value="${message(code: 'quotation.label', default: 'Quotation')}" />  
        
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <g:javascript library="jquery" plugin="jquery"/>
		 <script src="${baseurl}/js/jquery.validate.js"></script>
		<script>
		 (function($) {
			  $(document).ready(function()
			  {				 
			    $("#quotationEdit").validate();
			  });
			  
			  
		 })(jQuery);
  		</script>
    </head>
    <body>
    	
        <div class="nav">
            <span class="menuButton"><g:link title="List Of Quotes" class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link title="Create Quote" class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${quotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${quotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="quotationEdit" >
                <g:hiddenField name="id" value="${quotationInstance?.id}" />
                <g:hiddenField name="version" value="${quotationInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="account"><g:message code="quotation.account.label" default="Account" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'account', 'errors')}">
									<g:select name="account.id" from="${accountsList}" optionKey="id" value="${quotationInstance?.account?.id}"  />
                                	<% def fields =  ["accountName":"Account Name", "website": "Website", "dateCreated": "Date Created"]; %>
									<g:popupSelect id="accounts" title="Select Account" list="${accountsList}" fields="${fields}" returnObject="account.id"></g:popupSelect>                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="customerType"><g:message code="quotation.customerType.label" default="Customer Type" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'customerType', 'errors')}">
                                    <g:textField name="customerType" value="${quotationInstance?.customerType}" class="required"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="geo"><g:message code="quotation.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${quotationInstance?.geo?.id}" noSelection="['': 'Select any one']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="status"><g:message code="quotation.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'status', 'errors')}">
                                    <g:select name="status" from="${com.valent.pricewell.Quotation$Status?.values()}" keys="${com.valent.pricewell.Quotation$Status?.values()*.name()}" value="${quotationInstance?.status?.name()}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name" colspan="2">
                                  	<label for="templateText"><g:message code="quotation.templateText.label" default="Template Text" /></label>
                                	<br/>
                                	<g:textArea name="templateText" value="${quotationInstance?.templateText}" rows="15" cols="80" style="width: 90%"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit title="Save Quote" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" before="if(!jQuery('#quotationEdit').validate().form()) {return false;}"/></span>
                    <span class="button"><g:actionSubmit title="Delete Quote" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
