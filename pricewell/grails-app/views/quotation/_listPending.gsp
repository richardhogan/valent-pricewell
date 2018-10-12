
<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>

<style>

	   #grps .ui-jqgrid-title { height:0px; }
	
</style>
    	<script>

    		jQuery(document).ready(function() {

    			call();
	                 
           });

           function call()
           {
               jQuery("#grps").jqGrid("GridUnload")
               
        	   jQuery("#grps").jqGrid({url: '${baseurl}/quotation/listPendingJSON',
					colNames: ['ID','Quote Status', 'Days Pending', 'Customer Name', 'Customer Type', 'Created Date', 'Geo', 'Total Quoted Price'],
                    colModel:
                              	[{name:'id',editable: false}, {name:'status',editable: false},                                     
                                 {name:'daysPending',editable: false, sorttype: 'int',align: 'right'}, {name:'account',editable: false},                                     
                                 {name:'customerType',editable: false},{name:'createdDate',editable: false, sorttype:'date', datefmt:'Y-m-d'}, 	
                                 {name:'geo',editable: false}, {name:'total',editable: false, sorttype: 'float',align: 'right'}],
	                                sortname: 'daysPending',
	                                sortorder: 'desc',
	                                caption:'Quote status with days pending',
	                                height: 300,
	                                autowidth: true,
	                                scrollOffset: 0,
	                                rowList:[10,20,30],
	                                pager: '#pgrps',
	                                viewrecords: true,
	                                loadonce: true,datatype: 'json'});

        	   jQuery("#grps").jqGrid('navGrid','#pgrps',
           			{edit:false,add:false,del:false},
           			{},
           			{},
           			{multipleSearch:true, multipleGroup:true}
           			);

        	   jQuery('#grps .ui-jqgrid-title').css('height', 0);
           }

           
		
    	</script>
    <body>
         <table id="grps"></table>
			<div id="pgrps"></div>        
    </body>
</html>
