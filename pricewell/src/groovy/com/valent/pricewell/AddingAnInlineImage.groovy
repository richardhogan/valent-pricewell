package com.valent.pricewell

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;


import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.parts.WordprocessingML.BinaryPartAbstractImage;
import org.docx4j.wml.Drawing;
import org.docx4j.wml.ObjectFactory;
import org.docx4j.wml.P;
import org.docx4j.wml.R;

public class AddingAnInlineImage {
	
	private static WordprocessingMLPackage wordMLPackage;
	
	public AddingAnInlineImage(WordprocessingMLPackage wordMLPackage)
	{
		this.wordMLPackage = wordMLPackage;
	}
    /**
     *  As is usual, we create a package to contain the document.
     *  Then we create a file that contains the image we want to add to the document.
     *  In order to be able to do something with this image, we'll have to convert
     *  it to an array of bytes. Finally we add the image to the package
     *  and save the package.
     */
    public static void main (String[] args) throws Exception {
        //WordprocessingMLPackage  wordMLPackage = WordprocessingMLPackage.createPackage();
 
        File file = new File("C:/Users/user/Downloads/myEye.jpg");
        byte[] bytes = convertImageToByteArray(file);
        addImageToPackage(bytes);
 
        //wordMLPackage.save(new java.io.File("G:/my/x2.docx"));
    }
 
    /**
     *  Docx4j contains a utility method to create an image part from an array of
     *  bytes and then adds it to the given package. In order to be able to add this
     *  image to a paragraph, we have to convert it into an inline object. For this
     *  there is also a method, which takes a filename hint, an alt-text, two ids
     *  and an indication on whether it should be embedded or linked to.
     *  One id is for the drawing object non-visual properties of the document, and
     *  the second id is for the non visual drawing properties of the picture itself.
     *  Finally we add this inline object to the paragraph and the paragraph to the
     *  main document of the package.
     *
     *  @param wordMLPackage The package we want to add the image to
     *  @param bytes         The bytes of the image
     *  @throws Exception    Sadly the createImageInline method throws an Exception
     *                       (and not a more specific exception type)
     */
    private static void addImageToPackage(byte[] bytes) throws Exception {
        println bytes
    	BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, bytes);
 
        int docPrId = 1;
        int cNvPrId = 2;
        Inline inline = imagePart.createImageInline("Test", "Tst", docPrId, cNvPrId, false);
 
        //System.out.println( inline);
        P paragraph = addInlineImageToParagraph(inline);
 
        wordMLPackage.getMainDocumentPart().addObject(paragraph);
    }
	
	private static P getImageParagraph(String filePath) throws Exception
	{
		File file = new File(filePath);
		byte[] imageBytes = convertImageToByteArray(file);
		
		BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, imageBytes);
		//println "image bytes : " + imageBytes
		int docPrId = 1;
	   	int cNvPrId = 2;
		Inline inline = imagePart.createImageInline("Test", "Tst", docPrId, cNvPrId, false);

	    //System.out.println( inline);
	   	P paragraph = addInlineImageToParagraph(inline);
		   
		return paragraph;
	}
	
	private static Inline getImageInline(String filePath) throws Exception
	{
		File file = new File(filePath);
		byte[] imageBytes = convertImageToByteArray(file);
		
		BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wordMLPackage, imageBytes);
		//println "image bytes : " + imageBytes
		int docPrId = 1;
		   int cNvPrId = 2;
		Inline inline = imagePart.createImageInline("Test", "Tst", docPrId, cNvPrId, false);

		//System.out.println( inline);
		//P paragraph = addInlineImageToParagraph(inline);
		   
		return inline;
	}
 
    /**
     *  We create an object factory and use it to create a paragraph and a run.
     *  Then we add the run to the paragraph. Next we create a drawing and
     *  add it to the run. Finally we add the inline object to the drawing and
     *  return the paragraph.
     *
     * @param   inline The inline object containing the image.
     * @return  the paragraph containing the image
     */
    private static P addInlineImageToParagraph(Inline inline) {
        // Now add the in-line image to a paragraph
        ObjectFactory factory = new ObjectFactory();
        P paragraph = factory.createP();
        R run = factory.createR();
        paragraph.getContent().add(run);
        Drawing drawing = factory.createDrawing();
        run.getContent().add(drawing);
        drawing.getAnchorOrInline().add(inline);
        return paragraph;
    }
 
    /**
     * Convert the image from the file into an array of bytes.
     *
     * @param file  the image file to be converted
     * @return      the byte array containing the bytes from the image
     * @throws FileNotFoundException
     * @throws IOException
     */
    private static byte[] convertImageToByteArray(File file) throws FileNotFoundException, IOException 
    {
        InputStream is = new FileInputStream(file );
        long length = file.length();
        // You cannot create an array using a long, it needs to be an int.
        if (length > Integer.MAX_VALUE) {
            System.out.println("File too large!!");
        }
        byte[] bytes = new byte[(int)length];
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
            offset += numRead;
        }
        // Ensure all the bytes have been read
        if (offset < bytes.length) {
            System.out.println("Could not completely read file "+file.getName());
        }
        is.close();
        return bytes;
    }
}