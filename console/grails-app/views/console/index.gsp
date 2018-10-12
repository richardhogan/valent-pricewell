<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title>Grails Console</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <link rel="stylesheet" href="${resource(dir: pluginPath11 + 'js/CodeMirror-2.2/lib', file: 'codemirror.css', plugin: 'console')}"/>
  <link rel="stylesheet" href="${resource(dir: pluginPath11 + 'css', file: 'jquery.layout.css', plugin: 'console')}"/>
  <link rel="stylesheet" href="${resource(dir: pluginPath11 + 'css', file: 'grails-console.css', plugin: 'console')}"/>
</head>

<body>

<div id="header">
  <h1>Grails Debug Console</h1>

  <div class="buttons">
    <div class="buttonset">
      <button class="first selected horizontal button" title="Horizontal">
        <img src="${resource(dir: pluginPath11 + 'images', file: 'h.png', plugin: 'console')}" alt="Vertical"/>
      </button>
      <button class="last vertical button" title="Vertical">
        <img src="${resource(dir: pluginPath11 + 'images', file: 'v.png', plugin: 'console')}" alt="Horizontal"/>
      </button>
    </div>
  </div>
</div>

<div id="editor" style="display: none">
  <div class="buttons">
    <button class="submit button" title="(Ctrl + Enter)">Execute</button>
  </div>

  <div id="code-wrapper">
    <g:textArea name="code" value="${code}" rows="25" cols="100"/>
  </div>

</div>

<div class="east results" style="display: none">
  <div class="buttons">
    <button class="clear button" title="(Esc)">Clear</button>
    <label class="wrap"><input type="checkbox" /> <span>Wrap text</span></label>
  </div>

  <div id="result"><div class="inner"></div></div>
</div>

<div class="south" style="display: none"></div>

<g:javascript src='jquery-1.7.1.min.js' plugin='console'/>
<g:javascript src='jquery-ui-1.8.17.custom.min.js' plugin='console'/>
<g:javascript src='jquery.layout.js' plugin='console'/>
<g:javascript src='jquery.Storage.js' plugin='console'/>
<g:javascript src='jquery.hotkeys.js' plugin='console'/>
<g:javascript src='CodeMirror-2.2/lib/codemirror.js' plugin='console'/>
<g:javascript src='CodeMirror-2.2/mode/groovy/groovy.js' plugin='console'/>
<g:javascript src='grails-console/console.js' plugin='console'/>
<script type="text/javascript" charset="utf-8">
  window.gconsole = {
    pluginContext: "${pluginContext}",
    executeLink: "${executeLink}"
  }
</script>

</body>
</html>
