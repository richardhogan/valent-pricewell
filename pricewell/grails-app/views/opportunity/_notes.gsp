<%@ page import="com.valent.pricewell.Quotation"%>
<%
	def baseurl = request.siteUrl
%>

<script>

    var previewBinded = false;
    var index = 999;




    function refreshNoteList()
    {
     	jQuery.ajax({type:'POST',data: {opportunityId: ${opportunityInstance.id}},
   			 url:'${baseurl}/opportunity/refreshNotes',
   			 success:function(data,textStatus){             
                 jQuery('#newNoteField').val('')
   	   			 jQuery('#dvNotesList').html(data);
   			 },
   			 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			 return false;
	}

    function deleteClick(noteId)
    {         

    	jQuery.ajax({type:'POST',data: {noteId : noteId },
			url:'${baseurl}/opportunity/deleteNote',
			success:function(data,textStatus){
				refreshNoteList();
			},
			error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;     
    }

    function editClick(noteId)
    {
      	var noteFieldName = "textArea"+noteId;
      	var noteField  = document.getElementById(noteFieldName);

      	if(noteField != null)
      	{

      		jQuery.ajax({type:'POST',data: {noteId : noteId , comment : noteField.value },
				url:'${baseurl}/opportunity/editNote',
				success:function(data,textStatus){				
					refreshNoteList();
				},
				error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;  
		}      
    }
    
	jQuery(document).ready(function()
	{
		jQuery('#addNote').button();	
	    
		jQuery('#addNote').click(function() 
		{
			var comment = jQuery('#newNoteField').val(); 	   

			jQuery.ajax({type:'POST',data: {opportunityId: ${opportunityInstance.id} , comment: comment },
				url:'${baseurl}/opportunity/createNote',
				success:function(data,textStatus){
					refreshNoteList();
				},
				error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});

	}); 

 	
</script>
<div class="body">

	<h4 style="padding: 0px 0px 0px 0px">Notes</h4>

	<div id="newNote">
		&nbsp;
		<textArea style="width:98%; border: 2px solid #cccccc;"
			placeholder="enter new note" name="newNoteField" rows="5" cols="60"
			id="newNoteField"></textArea>
			
		<br> &nbsp; <input id="addNote" type="button"	title="Create New Quote" style="font-size: 0.8em" value="Comment"	class="button" />
	</div>



	<div id="dvNotesList" class="list">
		<g:render template="notesList"	model="['opportunityInstance': opportunityInstance , 'loginUserId' : loginUserId]" />
	</div>
</div>