<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Report of Quotes</title>
          <link rel='stylesheet' type='text/css' href='${baseurl}/js/yui-cms/2.1/accordion/assets/accordion.css'/>
        <link rel='stylesheet' type='text/css' href='${baseurl}/css/customyui.css'/>    
        <link rel='stylesheet' type='text/css' href='${baseurl}/css/mySkin.css'/>        
       <script type="text/javascript" src="${baseurl}/js/yui-cms/2.1/bubbling/bubbling-min.js" ></script>  
		<script type="text/javascript" src="${baseurl}/js/yui-cms/2.1/accordion/accordion-min.js" ></script>
		<script type="text/javascript" src="http://www.google.com/jsapi"></script>
		
		<gui:resources components="tabView" mode="debug"/>
		
		
    </head>
    <body>
        <div class="body yui-skin-sam">
    		
    		<table> 
    			<thead>
    				<tr> 
    					<th> Portfolio </th>
    					<th> Service Name </th>
    					<th> SKU </th>
    					<th> totalUnits Sold </th>
    					<th> Estimated Avg. Profit </th>
    				</tr>
    			</thead>
    			<tbody>
    				 <g:each in="${servicesMap.keySet()}" status="j" var="sku">
                        <tr class="${(j % 2) == 0 ? 'odd' : 'even'}">
                        	<td>
                        		${servicesMap[sku]["service"]?.portfolio.name}
                        	</td>
                        	<td>
                        		${servicesMap[sku]["service"]?.serviceName}
                        	</td>
                        	<td>
                        		${servicesMap[sku]["totalUnits"]}
                        	</td>
							<td>
								${servicesMap[sku]["totalUnits"]}
							</td>
						</tr>
					</g:each>
                        
    			</tbody>
    		</table>
    		    
    	</div>
    </body>
    
    