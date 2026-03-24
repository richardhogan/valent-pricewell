package com.valent.pricewell

/**
 * Overrides g:layoutHead, g:layoutBody, g:layoutTitle and g:pageProperty to work
 * with the SiteMesh 3 decorator pipeline (sitemesh3 plugin 7.0.0-SNAPSHOT).
 *
 * Problem: Grails 7 ships both the 'layout' plugin (RenderGrailsLayoutTagLib) and
 * the 'sitemesh3' plugin (RenderSitemeshTagLib), with conflicting g:* tag definitions.
 * The 'layout' plugin wins the conflict but uses SiteMesh 2's REQUEST_PAGE attribute,
 * which SiteMesh 3 never sets.  The 'sitemesh3' plugin's approach — emitting
 * <sitemesh:write property="head"/> placeholders — works correctly.
 *
 * Application-level taglibaries override plugin taglibaries, so this class wins.
 */
class SiteMesh3LayoutTagLib {

    static namespace = "g"

    /** Emits a sitemesh:write placeholder for the original page's <head> section. */
    def layoutHead = { attrs ->
        def sb = new StringBuilder('<sitemesh:write property="head"')
        if (attrs.'class') {
            sb.append(' class="').append(attrs.'class'.encodeAsHTML()).append('"')
        }
        sb.append('/>')
        out << sb.toString()
    }

    /** Emits a sitemesh:write placeholder for the original page's <body> section. */
    def layoutBody = { attrs ->
        def sb = new StringBuilder('<sitemesh:write property="body"')
        if (attrs.'class') {
            sb.append(' class="').append(attrs.'class'.encodeAsHTML()).append('"')
        }
        sb.append('/>')
        out << sb.toString()
    }

    /** Emits a sitemesh:write placeholder for the original page's <title>. */
    def layoutTitle = { attrs ->
        def defaultTitle = attrs.default ?: ''
        out << '<sitemesh:write property="title" default="' << defaultTitle.encodeAsHTML() << '"/>'
    }

    /** Reads a named property from the SiteMesh 3 content for use in layouts. */
    def pageProperty = { attrs ->
        def propName = attrs.name ?: ''
        def sb = new StringBuilder('<sitemesh:write property="')
        sb.append(propName.encodeAsHTML())
        sb.append('"')
        if (attrs.default) {
            sb.append(' default="').append(attrs.default.encodeAsHTML()).append('"')
        }
        sb.append('/>')
        out << sb.toString()
    }
}
