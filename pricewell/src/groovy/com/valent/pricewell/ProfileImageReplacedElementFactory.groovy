package com.valent.pricewell
import org.w3c.dom.Element
import org.xhtmlrenderer.extend.*
import org.xhtmlrenderer.layout.LayoutContext
import org.xhtmlrenderer.pdf.ITextFSImage
import org.xhtmlrenderer.pdf.ITextImageElement
import org.xhtmlrenderer.render.BlockBox
import org.xhtmlrenderer.simple.extend.FormSubmissionListener

import com.lowagie.text.BadElementException
import com.lowagie.text.Image


class ProfileImageReplacedElementFactory implements ReplacedElementFactory {

	private final ReplacedElementFactory superFactory;
	private final byte[] imageBytes;

	public ProfileImageReplacedElementFactory(ReplacedElementFactory superFactory, byte[] imageBytes) {
		this.superFactory = superFactory;
		this.imageBytes = imageBytes;
	}

	@Override
	public ReplacedElement createReplacedElement(LayoutContext layoutContext, BlockBox blockBox,
	UserAgentCallback userAgentCallback, int cssWidth, int cssHeight) {

		Element element = blockBox.getElement();
		if (element == null) {
			return null;
		}

		String nodeName = element.getNodeName();
		String className = element.getAttribute("class");
		if ("div".equals(nodeName) && className.contains("profile_picture")) {

			try {

				byte[] bytes = imageBytes;
				Image image = Image.getInstance(bytes);
				FSImage fsImage = new ITextFSImage(image);

				if (fsImage != null) {
					if ((cssWidth != -1) || (cssHeight != -1)) {
						fsImage.scale(cssWidth, cssHeight);
					}
					return new ITextImageElement(fsImage);
				}
			} catch (IOException e) {
				println(e);
			} catch (BadElementException e) {
				println(e)
			} finally {
			}
		}

		return superFactory.createReplacedElement(layoutContext, blockBox, userAgentCallback, cssWidth, cssHeight);
	}

	@Override
	public void reset() {
		superFactory.reset();
	}

	@Override
	public void remove(Element e) {
		superFactory.remove(e);
	}

	@Override
	public void setFormSubmissionListener(FormSubmissionListener listener) {
		superFactory.setFormSubmissionListener(listener);
	}
}