package com.valent.pricewell

import com.opensymphony.module.sitemesh.HTMLPage

/**
 * Overrides g:layoutBody and g:layoutHead from the conflicting
 * RenderSitemeshTagLib (grails-plugin-sitemesh3) which emits literal
 * {@code <sitemesh:write property="body"/>} tags instead of actual content.
 *
 * This app-level taglib takes priority over plugin taglibs and delegates
 * to the HTMLPage stored in the request by SpringMVCViewDecorator.
 */
class LayoutOverrideTagLib {

    static String namespace = 'g'

    private static final String PAGE_ATTR = '__sitemesh__page'

    Closure layoutBody = { Map attrs ->
        HTMLPage page = (HTMLPage) request.getAttribute(PAGE_ATTR)
        if (page != null) {
            page.writeBody(out)
        }
    }

    Closure layoutHead = { Map attrs ->
        HTMLPage page = (HTMLPage) request.getAttribute(PAGE_ATTR)
        if (page != null) {
            page.writeHead(out)
        }
    }

    Closure layoutTitle = { Map attrs ->
        HTMLPage page = (HTMLPage) request.getAttribute(PAGE_ATTR)
        if (page != null) {
            out << page.getTitle()
        }
    }
}
