/**
 * CKEditor 4 → 5 Compatibility Layer
 *
 * Provides CKEDITOR.replace(), CKEDITOR.instances[name].getData/setData/destroy
 * so existing GSP code works unchanged with CKEditor 5 CDN.
 *
 * Load AFTER ckeditor5.umd.js:
 *   <script src="https://cdn.ckeditor.com/ckeditor5/44.3.0/ckeditor5.umd.js"></script>
 *   <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/44.3.0/ckeditor5.css" />
 *   <asset:javascript src="ckeditor5-compat.js"/>
 */
(function() {
    var CK5 = window.CKEDITOR;
    if (!CK5 || !CK5.ClassicEditor) {
        console.error('ckeditor5-compat: CKEditor 5 UMD not loaded');
        return;
    }

    var instances = {};

    // Map CKEditor 4 toolbar item names to CKEditor 5 equivalents
    var TOOLBAR_MAP = {
        'Bold': 'bold', 'Italic': 'italic', 'Underline': 'underline',
        'Strike': 'strikethrough',
        'BulletedList': 'bulletedList', 'NumberedList': 'numberedList',
        'Outdent': 'outdent', 'Indent': 'indent',
        'JustifyLeft': 'alignment:left', 'JustifyCenter': 'alignment:center',
        'JustifyRight': 'alignment:right', 'JustifyBlock': 'alignment:justify',
        'Styles': 'heading', 'Format': 'heading',
        'Link': 'link', 'Blockquote': 'blockQuote',
        'HorizontalRule': 'horizontalLine',
        'Undo': 'undo', 'Redo': 'redo',
        '-': '|'
    };

    function mapToolbar(ck4Toolbar) {
        if (ck4Toolbar === 'Basic') {
            return ['bold', 'italic', '|', 'link', '|', 'bulletedList', 'numberedList', '|', 'undo', 'redo'];
        }
        if (Array.isArray(ck4Toolbar) && ck4Toolbar.length === 0) {
            return [];
        }
        if (Array.isArray(ck4Toolbar)) {
            var items = [];
            ck4Toolbar.forEach(function(group) {
                if (group && group.items) {
                    if (items.length > 0) items.push('|');
                    group.items.forEach(function(item) {
                        var mapped = TOOLBAR_MAP[item];
                        if (mapped) items.push(mapped);
                    });
                }
            });
            return items.length > 0 ? items : undefined;
        }
        return undefined;
    }

    function collectPlugins(toolbarItems) {
        var plugins = [CK5.Essentials, CK5.Paragraph, CK5.Undo];
        var seen = {};
        function add(p) { if (p && !seen[p.pluginName]) { seen[p.pluginName] = true; plugins.push(p); } }

        if (!toolbarItems || toolbarItems.length === 0) {
            return plugins;
        }

        var str = toolbarItems.join(',');
        if (/bold/.test(str)) add(CK5.Bold);
        if (/italic/.test(str)) add(CK5.Italic);
        if (/underline/.test(str)) add(CK5.Underline);
        if (/strikethrough/.test(str)) add(CK5.Strikethrough);
        if (/link/.test(str)) add(CK5.Link);
        if (/bulletedList|numberedList/.test(str)) add(CK5.List);
        if (/indent|outdent/.test(str)) { add(CK5.Indent); add(CK5.IndentBlock); }
        if (/alignment/.test(str)) add(CK5.Alignment);
        if (/heading/.test(str)) add(CK5.Heading);
        if (/blockQuote/.test(str)) add(CK5.BlockQuote);
        if (/horizontalLine/.test(str)) add(CK5.HorizontalLine);

        return plugins.filter(Boolean);
    }

    window.CKEDITOR = {
        instances: instances,

        replace: function(nameOrElement, config) {
            config = config || {};
            var element, name;

            if (typeof nameOrElement === 'string') {
                name = nameOrElement;
                element = document.getElementById(name) ||
                          document.querySelector('[name="' + name + '"]');
            } else {
                element = nameOrElement;
                name = element.id || element.name;
            }

            if (!element) {
                console.warn('CKEditor compat: element not found:', nameOrElement);
                return;
            }

            // Destroy existing instance
            if (instances[name]) {
                try { instances[name].destroy(); } catch(e) {}
                delete instances[name];
            }

            var toolbarItems = mapToolbar(config.toolbar);
            var ck5Config = {
                plugins: collectPlugins(toolbarItems)
            };

            if (toolbarItems) {
                // Deduplicate (e.g. 'heading' may appear twice from Styles + Format)
                var unique = [];
                toolbarItems.forEach(function(t) {
                    if (unique.indexOf(t) === -1 || t === '|') unique.push(t);
                });
                ck5Config.toolbar = unique;
            }

            CK5.ClassicEditor.create(element, ck5Config)
                .then(function(editor) {
                    instances[name] = editor;
                    if (config.readOnly) {
                        editor.enableReadOnlyMode('compat-readonly');
                    }
                })
                .catch(function(err) {
                    console.error('CKEditor compat: failed to create editor for "' + name + '":', err);
                });
        }
    };
})();
