package com.valent.pricewell

/**
 * Grails 7 compatibility taglib that reimplements the removed g:remoteLink,
 * g:remoteForm, g:submitToRemote, and g:formRemote tags using jQuery AJAX.
 */
class RemoteTagsCompatTagLib {

    static namespace = "g"

    private String buildUrl(Map attrs) {
        def linkAttrs = [:]
        ['controller', 'action', 'id', 'params', 'fragment', 'mapping', 'absolute', 'base', 'url'].each { k ->
            if (attrs[k] != null) linkAttrs[k] = attrs[k]
        }
        return createLink(linkAttrs)
    }

    private String resolveUpdateIds(update) {
        if (update instanceof Map) return [update?.success, update?.failure ?: update?.success]
        return [update, update]
    }

    /**
     * g:remoteLink - renders an AJAX link that loads content into an update target.
     */
    def remoteLink = { attrs, body ->
        def url = buildUrl(attrs)
        def update = attrs.update
        def successId = (update instanceof Map) ? update?.success : update
        def method = attrs.method ?: 'GET'

        def sb = new StringBuilder("<a href=\"${url}\"")
        ['class', 'id', 'title', 'style', 'name'].each { attr ->
            if (attrs[attr] != null) sb << " ${attr}=\"${attrs[attr]}\""
        }

        if (successId) {
            sb << " onclick=\"jQuery.ajax({url:this.href,type:'${method}',success:function(d){jQuery('#${successId}').html(d);}});return false;\""
        } else if (attrs.onSuccess) {
            sb << " onclick=\"jQuery.ajax({url:this.href,type:'${method}',success:function(data){${attrs.onSuccess};}});return false;\""
        }

        sb << ">${body()}</a>"
        out << sb
    }

    /**
     * g:submitToRemote - renders a submit button that submits the form via AJAX.
     */
    def submitToRemote = { attrs, body ->
        def url = attrs.url ?: buildUrl(attrs)
        def update = attrs.update
        def successId = (update instanceof Map) ? update?.success : update

        def sb = new StringBuilder("<input type=\"submit\"")
        sb << " value=\"${(attrs.value ?: body()?.toString()?.trim() ?: 'Submit').encodeAsHTML()}\""
        ['class', 'id', 'name', 'style', 'title'].each { attr ->
            if (attrs[attr] != null) sb << " ${attr}=\"${attrs[attr].encodeAsHTML()}\""
        }

        def successHandler = successId ? "success:function(d){jQuery('#${successId}').html(d);}" : (attrs.onSuccess ? "success:function(data){${attrs.onSuccess};}" : "")
        sb << " onclick=\"var \$f=jQuery(this).closest('form');jQuery.ajax({url:'${url}',type:\$f.attr('method')||'post',data:\$f.serialize(),${successHandler}});return false;\""
        sb << " />"
        out << sb
    }

    /**
     * g:remoteForm / g:formRemote - renders a form that submits via AJAX.
     */
    def remoteForm = { attrs, body ->
        def url = buildUrl(attrs)
        def update = attrs.update
        def successId = (update instanceof Map) ? update?.success : update
        def formId = attrs.id ?: "rf_${System.nanoTime()}"

        def sb = new StringBuilder("<form")
        sb << " id=\"${formId}\""
        sb << " action=\"${url}\""
        sb << " method=\"${attrs.method ?: 'post'}\""
        ['class', 'name', 'style', 'enctype'].each { attr ->
            if (attrs[attr] != null) sb << " ${attr}=\"${attrs[attr]}\""
        }

        def successHandler = successId ? "success:function(d){jQuery('#${successId}').html(d);}" : (attrs.onSuccess ? "success:function(data){${attrs.onSuccess};}" : "")
        sb << " onsubmit=\"jQuery.ajax({url:jQuery('#${formId}').attr('action'),type:jQuery('#${formId}').attr('method')||'post',data:jQuery('#${formId}').serialize(),${successHandler}});return false;\""
        sb << ">"
        sb << body()
        sb << "</form>"
        out << sb
    }

    def formRemote = remoteForm
}
