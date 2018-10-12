package com.valent.pricewell

import java.io.File;
import java.io.IOException;
import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.exceptions.InvalidFormatException;
import org.docx4j.openpackaging.io.SaveToZipFile;
import org.docx4j.openpackaging.parts.PartName;
import org.docx4j.openpackaging.contenttype.ContentType;
import org.docx4j.openpackaging.contenttype.ContentTypes;
import org.docx4j.relationships.Relationship;
import org.docx4j.openpackaging.parts.WordprocessingML.BinaryPartAbstractImage;
import org.docx4j.openpackaging.parts.relationships.Namespaces;
/**
 * Creates a WordprocessingML document from scratch.
 *
 * @author Jason Harrop
 * @version 1.0
 */
public class AddImage {
	
        public static void main(String[] args) throws Exception 
		{               
            System.out.println( "Creating package..");
            WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.createPackage();
           
           
            File file = new File("G:/my/CPTLogo1.gif" );
            //File file = new File("C:\\Documents and Settings\\Jason Harrop\\My Documents\\LANL\\fig1.pdf" );
           
            // Our utility method wants that as a byte array
           
            java.io.InputStream is = new java.io.FileInputStream(file );
			
			long length = file.length();   
        // You cannot create an array using a long type.
        // It needs to be an int type.
	        if (length > Integer.MAX_VALUE) {
	                System.out.println("File too large!!");
	        }
	        byte[] bytes = new byte[(int)length];
	        int offset = 0;
	        int numRead = 0;
	        while (offset < bytes.length
	               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
	            offset += numRead;
	        }
        // Ensure all the bytes have been read in
	        if (offset < bytes.length) {
	            System.out.println("Could not completely read file "+file.getName());
	        }
	        is.close();
       
	        String filenameHint = null;
	        String altText = null;
	        int id1 = 0;
	        int id2 = 1;
                       
	        org.docx4j.wml.P p = newImage( wordMLPackage, bytes, 
	                        filenameHint, altText, 
	                        id1, id2 );
	       
            // Now add our p to the document
            wordMLPackage.getMainDocumentPart().addObject(p);
			
	        /*org.docx4j.wml.P p2 = newImage( wordMLPackage, bytes, 
	                        filenameHint, altText, 
	                        id1, id2, 3000 );
	       
            // Now add our p to the document
            wordMLPackage.getMainDocumentPart().addObject(p2);
			
	        org.docx4j.wml.P p3 = newImage( wordMLPackage, bytes, 
	                        filenameHint, altText, 
	                        id1, id2, 6000 );
       
            // Now add our p to the document
            wordMLPackage.getMainDocumentPart().addObject(p3);
               
               */
            // Now save it
            wordMLPackage.save(new java.io.File("G:/my/x2.docx") );
           
            System.out.println("Done.");
                               
        }
		
		/*public static void convertImageToJPEG(File inputFile)
		{
			//File inputFile = new File("/path/to/image.png");
			File outputFile = new File("Test.jpg");
			try (InputStream is = new FileInputStream(inputFile)) {
				BufferedImage image = ImageIO.read(is);
				try (OutputStream os = new FileOutputStream(outputFile)) {
					ImageIO.write(image, "jpg", os);
				} catch (Exception exp) {
					exp.printStackTrace();
				}
			} catch (Exception exp) {
				exp.printStackTrace();
			}
		}*/
		
        public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
                        byte[] bytes,
                        String filenameHint, String altText, 
                        int id1, int id2) throws Exception {
               
	        BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);
	               
	        Inline inline = imagePart.createImageInline( filenameHint, altText, 
	                        id1, id2);
       
			// Now add the inline in w:p/w:r/w:drawing
            org.docx4j.wml.ObjectFactory factory = new org.docx4j.wml.ObjectFactory();
            org.docx4j.wml.P  p = factory.createP();
            org.docx4j.wml.R  run = factory.createR();             
            p.getParagraphContent().add(run);       
            org.docx4j.wml.Drawing drawing = factory.createDrawing();               
            run.getRunContent().add(drawing);               
            drawing.getAnchorOrInline().add(inline);
           
            return p;
               
        }       
       
        public static org.docx4j.wml.P newImage( WordprocessingMLPackage wordMLPackage,
                        byte[] bytes,
                        String filenameHint, String altText, 
                        int id1, int id2, long cx) throws Exception {
               
	        BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);
	               
	        Inline inline = imagePart.createImageInline( filenameHint, altText, 
	                        id1, id2, cx);
	       
	        // Now add the inline in w:p/w:r/w:drawing
            org.docx4j.wml.ObjectFactory factory = new org.docx4j.wml.ObjectFactory();
            org.docx4j.wml.P  p = factory.createP();
            org.docx4j.wml.R  run = factory.createR();             
            p.getParagraphContent().add(run);       
            org.docx4j.wml.Drawing drawing = factory.createDrawing();               
            run.getRunContent().add(drawing);               
            drawing.getAnchorOrInline().add(inline);
           
            return p;
               
        }       
}