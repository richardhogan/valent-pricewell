/**
 * 
 */
//var result = "success";
function isEditorContentSupported(content) 
{
	//var result = "success";
	var html, parser, htmlDoc, txt;
	txt = "";
	parser = new DOMParser();
	  
	htmlDoc = parser.parseFromString(content ,"text/html");
	html = htmlDoc.documentElement;
	
	var result = loopThroughContent(html);
	
	return result;
}

function loopThroughContent(x)
{
	var result = "success";
	var i, y, xLen, txt, j;
	txt = "";
	x = x.childNodes;
	xLen = x.length;
	//alert(xLen);
  	for (i = 0; i < xLen ;i++) 
  	{
  		y = x[i];
  		if (y.nodeName != "#text") 
	  	{
			//alert(y.nodeName);
  			if(y.nodeName.localeCompare("LI") == 0 && isListContainsList(y) == "yes") 
            {
            	jAlert('Text editor contains list inside list which is not supported by this system yet. Please change it.', 'Text Editor Validation Message');
            	
            	result = "fail";
            	//return false; 
            	//break;
            }
            //alert(result);
            if(result != "fail" && y.hasChildNodes())
            {
            	result = loopThroughContent(y);
                //txt += ": " + y.childNodes[0].nodeValue + myLoop(y) //+ "<br>";
            }
            
      	}
	    
  	}
  	return result;
}

function isListContainsList(x)
{
	var isThere = "no"
    x = x.childNodes;
    var xLen = x.length;
    for (i = 0; i < xLen ;i++) 
    {
        if(x[i].nodeName == "UL")
        {
            //return true;
        	isThere = "yes";
            break;
        }
    }
    return isThere;
}