<%@ page import="com.valent.pricewell.Service"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<script type="text/javascript">
  jQuery(document).ready(function() {
      // Initialize Smart Wizard
        jQuery('#wizard').smartWizard({
        		enableAllSteps: true,
            });
  }); 
</script>
</head>

<body>
	<div id="wizard" class="swMain">
  <ul>
    <li><a href="#step-1">
          <label class="stepNumber">1</label>
          <span class="stepDesc">
             Add Company Info
          </span>
      </a></li>
    <li><a href="#step-2">
          <label class="stepNumber">2</label>
          <span class="stepDesc">
             Define GEOs and Territories
             
          </span>
      </a></li>
    <li><a href="#step-3">
          <label class="stepNumber">3</label>
          <span class="stepDesc">
             Add more delivery roles
          </span>                   
       </a></li>
    <li><a href="#step-4">
          <label class="stepNumber">4</label>
          <span class="stepDesc">
             Define Portfolios
          </span>                   
      </a></li>
      <li><a href="#step-5">
          <label class="stepNumber">5</label>
          <span class="stepDesc">
             Define Users
          </span>                   
      </a></li>
  </ul>
  <div id="step-1">   
      <h2 class="StepTitle">Step 1 Content</h2>
       <!-- step content -->
  </div>
  <div id="step-2">
      <h2 class="StepTitle">Step 2 Content</h2> 
       <!-- step content -->
  </div>                      
  <div id="step-3">
      <h2 class="StepTitle">Step 3 Title</h2>   
       <!-- step content -->
  </div>
  <div id="step-4">
      <h2 class="StepTitle">Step 4 Title</h2>   
       <!-- step content -->                         
  </div>
  <div id="step-5">
      <h2 class="StepTitle">Step 5 Title</h2>   
       <!-- step content -->                         
  </div>
</div>
</body>
</html>
