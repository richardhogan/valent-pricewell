
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.Pricelist" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<meta name="layout" content="main" />
    	<export:resource />
    	
    	
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        
        <title>Service Catalog </title>
        
         <script type="text/javascript">

         var params = ""; 
         //?geoId=2&searchFields.portfolio.id=1
         
         var $j = jQuery.noConflict();
	        jQuery(document).ready(function() {

	    		call();
		        
                         
               });


            function call()
            {
                //alert('called');
            	params = "";
                params += "?geoId=" + jQuery('#geoId').val();
                params += "&searchFields.portfolio.id=" + jQuery('#searchFields\\.portfolio\\.id').val();

                jQuery("#grps").jqGrid("GridUnload")
                
            	jQuery("#grps").jqGrid({url: '${baseurl}/service/pricelistJSON' + params,
					colNames: ['Portfolio','Service', 'SKU', 'Unit of Sale',  
                                  'Base Units', 'Base Hrs','Add.Unit Hrs','Base Price',  'Additional Price per Unit','Premium','Currency', 'Published Date'],
                                  colModel:
                                           	[{name:'portfolio',editable: false}, {name:'serviceName',editable: false},                                     
                                              {name:'skuName',editable: false}, {name:'unitOfSale',editable: false},                                     
                                               {name:'baseUnits',editable: false,sorttype:'float', align: 'right'},{name:'baseHrs',editable: false,sorttype:'float', align: 'right'},
                                               {name:'addHrs',editable: false,sorttype:'float', align: 'right'},  
                                               {name:'basePrice',editable: false,sorttype:'float', align: 'right'},                                     
                                                {name:'additionalPrice',editable: false,sorttype:'float', align: 'right'}, {name:'premiumPercent',editable: false,sorttype:'float', align: 'right'},                                    
                                                 {name:'currency',editable: false}, {name: 'publishedDate', editable: false, sorttype:'date', datefmt:'Y-m-d'}],
                                                 sortname: 'serviceName',
                                                 caption:'Pricelist',
                                                  height: 300,
                                                  autowidth: true,
                                                  scrollOffset: 0,
                                                  rowList:[10,20,30],
                                                 pager: '#pgrps',
                                                  viewrecords: true,
                                                  loadonce: true,datatype: 'json'});
            	jQuery("#grps").jqGrid('navGrid','#pgrps',
            			{edit:false,add:false,del:false,excel: true},
            			{caption:"Export", 
            			       onClickButton : function () { 
            			           jQuery("#grps").excelExport();
            			       } },
            			{},
            			{},
            			{multipleSearch:true, multipleGroup:true}
            			);
            }
            
        </script>
        
    </head>
    <body>
    	<div class="nav">
            <span><g:link class="list" action="index" title="List Of Services" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        
        <div class="leftNav">				
    		<g:render template="serviceNavigation"/>
    	</div>
    		
        <div id="columnRight" class="body rightContent column">
        	
            <h1> Service Catalog </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
           
            <g:render template="pricelistSearchBar" model="['searchFields':searchFields, 'geoInstance': geoInstance]"/> 
            
            <export:formats formats="['csv', 'excel', 'pdf', 'xml']" />

             <table id="grps"></table>
			<div id="pgrps"></div>
           
            </div>
           
        </div>
    </body>
</html>
