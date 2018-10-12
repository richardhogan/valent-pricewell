package pricewell
import org.apache.commons.logging.LogFactory
import org.apache.commons.logging.Log


class SendMailJob {
	private static final Log log = LogFactory.getLog(this)
	private static int counter= 0;
	def sendMailService
    /*static triggers = {
      simple startDelay: 60000, repeatInterval: 30000 // execute job once in 10 seconds
    }*/

    def execute() 
	{
		
		//log.error("Send mail started.. counter:" + counter++);
		//sendMailService.getPendingMail()	
			
        // execute job
    }
}
