<% 
	def SelBtnId = map['id'] + "_SelBtn";
	def dialogDivId = map['id'] + "_dialog";
	def fields = map["fields"];
	def list = map["list"];
	def width = map["width"]; if(!width) {width = 500};
	def height = map["height"]; if(!height) {height = 500};
	def returnObject = map["returnObject"];
%>

<script>
	var selectedId = null;
	var selectedValue = null;
	
	jQuery(function() {

		var div = jQuery("#<%=dialogDivId%>");
		div.dialog({ autoOpen: false, width: <%=width%>, height: <%=height%>, 
						beforeClose: function(event,ui) {
								if(selectedId != null) {
									var obj = document.getElementById('<%=returnObject%>')
										if(obj){
											obj.value = selectedId;
										}
									}
							}});
		
		jQuery("#<%=SelBtnId%>").bind('click', function() {
				jQuery("#<%=dialogDivId%>").dialog('open');
			});

		
		
	});

	function select(id, val){
		selectedId = id;
		selectedValue = val;
		jQuery("#<%=dialogDivId%>").dialog('close');
	}

	
</script>

<input type="button" value="Select" id="${SelBtnId}"/>

<div id="${dialogDivId}" title="${map['title']}" width="100%">
		<div id="tablewrapper">
		<div id="tableheader">
        	<div class="search">
                <select id="columns" onchange="sorter.search(&#39;query&#39;)"></select>
                <input type="text" id="query" onkeyup="sorter.search(&#39;query&#39;)">
            </div>
            <span class="details">
				<div>Records <span id="startrecord">1</span>-<span id="endrecord">20</span> of <span id="totalrecords">49</span></div>
        		<div><a href="javascript:sorter.reset()">reset</a></div>
        	</span>
        </div>
        
        <table cellpadding="0" cellspacing="0" border="0" id="table" class="tinytable">
            <thead>
                <tr>
                    <th class="nosort" width="5em"><h3></h3></th>
                    <g:each in="${fields?.keySet()}" status="i" var="field">
                    	<g:if test="i==0">
                    		<th class="asc"><h3>${fields[field]}</h3></th>
                    	</g:if>
                    	<g:else>
                    		<th class="head"><h3>${fields[field]}</h3></th>
                    	</g:else>
                    </g:each>  
                </tr>
            </thead>
            <tbody>
            	<g:each in="${list}" status="i" var="item">
            		<tr class="<%=i%2==0?'evenrow':'oddrow' %>" onmouseover="sorter.hover('${i}',1)" onmouseout="sorter.hover('${i}',0)" id="selectedrow" style="">
            			<g:each in="${fields?.keySet()}" status="j" var="field">
            				<% def value = fieldValue(bean: item, field: field) %>
            				<g:if test="${j==0}">
            					<% def idValue = fieldValue(bean: item, field: 'id') %>
            					<td class=""> <a href='javascript: select("${idValue}","${value}")'> Select </a> </td>
            				</g:if>
            				<td class="">${value}</td>
            			</g:each>		
            		</tr>
            	</g:each>
              </tbody>
        </table>
        <div id="tablefooter">
          <div id="tablenav" style="display: block; ">
            	<div>
                    <img src="../images/first.gif" width="16" height="16" alt="First Page" onclick="sorter.move(-1,true)">
                    <img src="../images/previous.gif" width="16" height="16" alt="First Page" onclick="sorter.move(-1)">
                    <img src="../images/next.gif" width="16" height="16" alt="First Page" onclick="sorter.move(1)">
                    <img src="../images/last.gif" width="16" height="16" alt="Last Page" onclick="sorter.move(1,true)">
                </div>
                <div>
                	<select id="pagedropdown" onchange="sorter.goto(this.value)"><option value="1">1</option><option value="2">2</option><option value="3">3</option></select>
				</div>
                <div>
                	<a href="javascript:sorter.showall()">view all</a>
                </div>
            </div>
			<div id="tablelocation">
            	<div>
                    <select onchange="sorter.size(this.value)">
                    <option value="5">5</option>
                        <option value="10" selected="selected">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                    <span>Entries Per Page</span>
                </div>
                <div class="page">Page <span id="currentpage">1</span> of <span id="totalpages">3</span></div>
            </div>
        </div>
    </div>
    
	<script type="text/javascript">
	var sorter = new TINY.table.sorter('sorter','table',{
		headclass:'head',
		ascclass:'asc',
		descclass:'desc',
		evenclass:'evenrow',
		oddclass:'oddrow',
		evenselclass:'evenselected',
		oddselclass:'oddselected',
		paginate:true,
		size:10,
		colddid:'columns',
		currentid:'currentpage',
		totalid:'totalpages',
		startingrecid:'startrecord',
		endingrecid:'endrecord',
		totalrecid:'totalrecords',
		hoverid:'selectedrow',
		pageddid:'pagedropdown',
		navid:'tablenav',
		sortcolumn:1,
		sortdir:1,
		init:true
	});
  </script>
  
    </div>
            
	 
</div>