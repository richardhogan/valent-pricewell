package com.valent.pricewell

import groovy.xml.StreamingMarkupBuilder
import java.util.Random;

class CommonFunctionsUtil {
	
	public def generatePswd(int minLen, int maxLen, int noOfCAPSAlpha,int noOfDigits, int noOfSplChars) 
	{
			
				String ALPHA_CAPS  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				String ALPHA   = "abcdefghijklmnopqrstuvwxyz";
				String NUM     = "0123456789";
				String SPL_CHARS   = "!@#%^&*_=+-/";
			 
			if(minLen > maxLen)
				throw new IllegalArgumentException("Min. Length > Max. Length!");
			if( (noOfCAPSAlpha + noOfDigits + noOfSplChars) > minLen )
				throw new IllegalArgumentException
				("Min. Length should be atleast sum of (CAPS, DIGITS, SPL CHARS) Length!");
			Random rnd = new Random();
			int len = rnd.nextInt(maxLen - minLen + 1) + minLen;
			char[] pswd = new char[len];
			int index = 0;
			for (int i = 0; i < noOfCAPSAlpha; i++) {
				index = getNextIndex(rnd, len, pswd);
				pswd[index] = ALPHA_CAPS.charAt(rnd.nextInt(ALPHA_CAPS.length()));
			}
			for (int i = 0; i < noOfDigits; i++) {
				index = getNextIndex(rnd, len, pswd);
				pswd[index] = NUM.charAt(rnd.nextInt(NUM.length()));
			}
			for (int i = 0; i < noOfSplChars; i++) {
				index = getNextIndex(rnd, len, pswd);
				pswd[index] = SPL_CHARS.charAt(rnd.nextInt(SPL_CHARS.length()));
			}
			for(int i = 0; i < len; i++) {
				if(pswd[i] == 0) {
					pswd[i] = ALPHA.charAt(rnd.nextInt(ALPHA.length()));
				}
			}
			return pswd;
		}
		
		public def getNextIndex(Random rnd, int len, char[] pswd) 
		{
			int index = rnd.nextInt(len);
			while(pswd[index = rnd.nextInt(len)] != 0);
			return index;
		}

		public def writeFile(fileName, closure) 
		{
			def xmlFile = new File(fileName)
		   
			def writer = xmlFile.newWriter()
			def builder = new StreamingMarkupBuilder()
			def Writable writable = builder.bind(closure)
			writable.writeTo(writer)
		   
		}
}
