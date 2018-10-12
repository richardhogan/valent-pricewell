package com.valent.pricewell

import net.sf.ehcache.*
import net.sf.ehcache.store.*
import org.apache.commons.logging.LogFactory
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.xhtmlrenderer.pdf.*

class MyPDFService {

    boolean transactional = false

/*  A Simple fetcher to turn a specific URL into a PDF.  */

  byte[] buildPdf(url) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ITextRenderer renderer = new ITextRenderer();
    try {
      renderer.setDocument(url);
      renderer.layout();
      renderer.createPDF(baos);
	  println baos
      byte[] b = baos.toByteArray();
      return b
    }
    catch (Throwable e) {
      log.error e
    }
  }

/*  
  A Simple fetcher to turn a well formated XHTML string into a PDF
  The baseUri is included to allow for relative URL's in the XHTML string
*/

  byte[] buildPdfFromString(content, baseUri) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ITextRenderer renderer = new ITextRenderer();
    try {
      renderer.setDocumentFromString(content)
      renderer.layout();
      renderer.createPDF(baos);
      byte[] b = baos.toByteArray();
      return b
    }
    catch (Throwable e) {
      log.error e
    }
  }
}
