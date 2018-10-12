package com.salesforce.integration

/**
* Created by snehal.mistry on 10/20/14.
*/

import com.sforce.soap.partner.PartnerConnection;
import com.sforce.soap.partner.QueryResult;
import com.sforce.soap.partner.sobject.*;
import com.sforce.soap.partner.*;
import com.sforce.ws.ConnectorConfig;
import com.sforce.ws.ConnectionException;
import com.sforce.soap.partner.Error;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;




public class SalesforceTest {
   PartnerConnection partnerConnection = null;
   
   private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

   public static void main(String[] args) {
	   SalesforceTest samples = new SalesforceTest();
	   if (samples.login()) {
		   // Add calls to the methods in this class.
		   // For example:
		   //samples.querySample();
		   //samples.querySampleAccount();
		   samples.querySampleOpportunity();
	   }
   }

   private String getUserInput(String prompt) {
	   String result = "";
	   try {
		   System.out.print(prompt);
		   result = reader.readLine();
	   } catch (IOException ioe) {
		   ioe.printStackTrace();
	   }
	   return result;
   }

    private boolean login() {
        boolean success = false;
        String username = "ratan@valent-software.com";//"check39@gmail.com";
        String password = "Valent2010meSSchNimmBVGR6WPQ10sr0G";//"Valent2010!";

        String instanceUri  = "ap1.salesforce.com";
        String authEndPoint = "https://" + instanceUri + "/services/Soap/u/23.0";

        try {
            ConnectorConfig config = new ConnectorConfig();
            config.setUsername(username);
            config.setPassword(password);

            config.setAuthEndpoint(authEndPoint);
            config.setTraceFile("traceLogs.txt");
            config.setTraceMessage(true);
            config.setPrettyPrintXml(true);

            partnerConnection = new PartnerConnection(config);


            success = true;
        } catch (ConnectionException ce) {
            ce.printStackTrace();
        } catch (FileNotFoundException fnfe) {
            fnfe.printStackTrace();
        }

        return success;
    }

    public void querySample() {
        try {
            // Set query batch size
            partnerConnection.setQueryOptions(250);

            // SOQL query to use
            String soqlQuery = "SELECT FirstName, LastName, AssistantName FROM Contact WHERE AssistantName != null";
            // Make the query call and get the query results
            QueryResult qr = partnerConnection.query(soqlQuery);

            boolean done = false;
            int loopCount = 0;
            // Loop through the batches of returned results
            while (!done) {
                System.out.println("Records in results set " + loopCount++
                        + " - ");
                SObject[] records = qr.getRecords();
                // Process the query results
                for (int i = 0; i < records.length; i++) {
                    SObject contact = records[i];
                    Object accountId = contact.getField("AssistantName");
                    Object firstName = contact.getField("FirstName");
                    Object lastName = contact.getField("LastName");
                    if (firstName == null) {
                        System.out.println("Contact " + (i + 1) +
                                        ": " + accountId + " = " + lastName
                        );
                    } else {
                        System.out.println("Contact " + (i + 1) + ": " + accountId + " = " +
                                firstName + " " + lastName);
                    }
                }
                if (qr.isDone()) {
                    done = true;
                } else {
                    qr = partnerConnection.queryMore(qr.getQueryLocator());
                }
            }
        } catch(ConnectionException ce) {
            ce.printStackTrace();
        }
        System.out.println("\nQuery execution completed.");
    }
    
    public void querySampleContacts(String id) {
        try {
            // Set query batch size
            partnerConnection.setQueryOptions(250);
            String accountId = id;//"001900000135g2QAAQ";
            // SOQL query to use
            //String soqlQuery = "SELECT Name, AccountNumber, AccountId FROM Account";// WHERE AccountNumber = 001900000135g2TAAQ";
            String soqlQuery = "SELECT Id, FirstName, LastName, Email, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, MobilePhone FROM Contact WHERE AccountId = '"+accountId+"'";
            // Make the query call and get the query results
            QueryResult qr = partnerConnection.query(soqlQuery);

            boolean done = false;
            int loopCount = 0;
            // Loop through the batches of returned results
            while (!done) {
                System.out.println("Records in results set " + loopCount++
                        + " - ");
                SObject[] records = qr.getRecords();
                // Process the query results
                
                for (int i = 0; i < records.length; i++) {
                    SObject contact = records[i];
                    
                    //Object accountName = account.getField("Name");
                    //Object lastName = contact.getField("LastName");
                   // if (accountName != null) {
                   System.out.printf("%n");
                        
                   System.out.println("Contact " + (i + 1) + "  Account ID" + id +
                                         " Contact Id : "+ contact.getField("Id") + " FirstName : " + contact.getField("FirstName") + " LastName : " + contact.getField("LastName") + "Email : " +
                                         contact.getField("Email") + " MailingStreet : " + contact.getField("MailingStreet") + " MailingCity : " + contact.getField("MailingCity") + " MailingState : " 
                                        + contact.getField("MailingState") + " MailingCountry : " + contact.getField("MailingCountry") + " MailingPostalCode : " + contact.getField("MailingPostalCode")
                                        + " MobilePhone : " + contact.getField("MobilePhone")
                        );
                       
                   System.out.printf("%n");
                   // } /*else {
                       // System.out.println("Contact " + (i + 1) + ": " +
                        		//accountName + " " + accountName);
                 //   }*/
                }
                if (qr.isDone()) {
                    done = true;
                } else {
                    qr = partnerConnection.queryMore(qr.getQueryLocator());
                }
            }
        } catch(ConnectionException ce) {
            ce.printStackTrace();
        }
        System.out.println("\nQuery execution completed Contacts.");
    }
    
    public void querySampleAccount(String id) {
        try {
            // Set query batch size
            partnerConnection.setQueryOptions(250);
            String accountId = id;//"001900000135g2QAAQ";
            // SOQL query to use
            //String soqlQuery = "SELECT Name, AccountNumber, AccountId FROM Account";// WHERE AccountNumber = 001900000135g2TAAQ";
            String soqlQuery = "SELECT Fax, Id, Name, Phone, Site, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode FROM Account WHERE Id = '"+accountId+"'";
            // Make the query call and get the query results
            QueryResult qr = partnerConnection.query(soqlQuery);

            boolean done = false;
            int loopCount = 0;
            // Loop through the batches of returned results
            while (!done) {
                System.out.println("Records in results set " + loopCount++
                        + " - ");
                SObject[] records = qr.getRecords();
                // Process the query results
                for (int i = 0; i < records.length; i++) {
                    SObject account = records[i];
                    Object accountName = account.getField("Name");
                    //Object lastName = contact.getField("LastName");
                    System.out.printf("%n");
                    
                    if (accountName != null) {
                        System.out.println("Account " + (i + 1) +
                                        ": " + accountName + " Account Id : "+ account.getField("Id") + " Fax : " + account.getField("Fax") + " Phone : " + account.getField("Phone") + " Site : " +
                                        account.getField("Site") + " BillingCity : " + account.getField("BillingCity") + " BillingCountry : " + account.getField("BillingCountry") + " BillingState : " 
                                        + account.getField("BillingState") + " BillingStreet : " + account.getField("BillingStreet") + " BillingPostalCode : " + account.getField("BillingPostalCode")
                        );
                        
                    System.out.printf("%n");
                    } /*else {
                        System.out.println("Contact " + (i + 1) + ": " +
                        		accountName + " " + accountName);
                    }*/
                }
                System.out.println("==================Start Contacts Of Account id:"+ id +"========================");
				  querySampleContacts(id);
				 System.out.println("=================End Contact==========================");
                if (qr.isDone()) {
                    done = true;
                } else {
                    qr = partnerConnection.queryMore(qr.getQueryLocator());
                }
            }
        } catch(ConnectionException ce) {
            ce.printStackTrace();
        }
        System.out.println("\nQuery execution completed Accounts.");
    }

    public void querySampleOpportunity() {
 	   try {
 		   // Set query batch size
 		   partnerConnection.setQueryOptions(250);

 		   // SOQL query to use
 		   String soqlQuery = "SELECT  Id, Name, AccountId, Amount, CloseDate, Description, ExpectedRevenue, Type, StageName, Probability, LastModifiedDate, CreatedDate FROM Opportunity";
 		   // Make the query call and get the query results
 		   QueryResult qr = partnerConnection.query(soqlQuery);

 		   boolean done = false;
 		   int loopCount = 0;
 		   Set<String> a1 = new HashSet<String>();
 		   // Loop through the batches of returned results
 		   while (!done) 
 		   {
 			   System.out.println("Records in results set " + loopCount++ + " - ");
 			   SObject[] records = qr.getRecords();
 			   // Process the query results
 			   for (int i = 0; i < records.length; i++) 
 			   {
 				   SObject opportunity = records[i];
 				   Object opportunityName = opportunity.getField("Name");
 				   Object AccountId = opportunity.getField("AccountId");
 				 
 				   a1.add(AccountId.toString());
 				 
 				   //Object lastName = contact.getField("LastName");
 				   //if (opportunityName != null) {
 				   	   System.out.printf("%n");
 				   	   
 					   System.out.println("Opportunity " + (i + 1) + ": " + "++" + opportunity.getField("LastModifiedDate") + opportunity.getField("CreatedDate") + opportunity.getField("Name") + "++" + opportunity.getField("Id") + " : Account Id : " + AccountId + " CloseDate" + opportunity.getField("CloseDate") + " Description:" + opportunity.getField("Description")
 							 + " ExpectedRevenue:" + opportunity.getField("ExpectedRevenue") + " Type:" + opportunity.getField("Type") + " StageName:" + opportunity.getField("StageName") + " Probability :" + opportunity.getField("Probability")
 					   );
 					   
 					   System.out.printf("%n");
 				  // }
 					   /*else {
 					   System.out.println("Contact " + (i + 1) + ": " +
 							   accountName + " " + accountName);
 				   }*/
 			   }
 			   int i = 0;
 			   for(String id : a1)
 			   {
 				   i++;
 				  System.out.println("================Start Account"+ i + "========================");
 				  querySampleAccount(id);
 				 System.out.println("=================End Account==========================");
 				/*System.out.println("==================Start Contacts Of Account " + i + "========================");
 				  querySampleContacts(id);
 				 System.out.println("=================End Contact==========================");*/
 			   }
 			   	//System.out.print(a1);
 			   if (qr.isDone()) {
 				   done = true;
 			   } else {
 				   qr = partnerConnection.queryMore(qr.getQueryLocator());
 			   }
 		   }
 	   } catch(ConnectionException ce) {
 		   ce.printStackTrace();
 	   }
 	  
 	   System.out.println("\nQuery execution completed Opportunities.");
    }
   //
   // Add your methods here.
   //
}
