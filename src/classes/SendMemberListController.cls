public class SendMemberListController {

    public Id campaignId;
    public String campaignName {get; set;}
    public String coLeaderNames {get; set;}
    ApexPages.StandardSetController setCon;
    public String emailBody {get; set;}
    
    public SendMemberListController(ApexPages.StandardController stdController) {
        campaignId = stdController.getId();
        campaignName = [SELECT Name from Campaign WHERE Id=:CampaignId].Name;
    }
    
    public SendMemberListController(ApexPages.StandardSetController controller) {
        campaignName = '';
        setCon = controller;
        for (Campaign c : (List<Campaign>) setCon.getSelected()) {
            campaignName += c.Name + ', ';
            campaignId = c.Id;
            SendEmailToLeaders();
        }
    }
    
   

    public PageReference SendEmailToLeaders() {
        List<CampaignMember> campaignMembers = [Select Status, Salutation, Name, FirstName, LastName, Email, Phone, MobilePhone, Street, City, State, PostalCode, Religion__c 
                                                From CampaignMember Where CampaignId=:CampaignId AND Status <> 'Former Member'];
        
        coLeaderNames = '';
        List<String> coLeaderEmails = new List<String>();
        
        String header = 'Salutation, FirstName, LastName, Email, Phone, MobilePhone, Street, City, State, PostalCode, Religion\n';
        String finalstr = header ;
        for (CampaignMember cm: campaignMembers) {
            if (cm.Status.equals('Co-Leader')) {
                String entry = cm.Name + ' <' + cm.Email + '>';
                if (!String.isEmpty(coLeaderNames)) {
			       coLeaderNames += ', ';
                }
                coLeaderNames += entry;
                coLeaderEmails.add(cm.Email);
            }
            
            string recordString = '"' +
                (cm.Salutation == null ? '' : cm.Salutation) + '","' +
                (cm.FirstName  == null ? '' : cm.FirstName)  + '","' +
                (cm.LastName   == null ? '' : cm.LastName)   + '","' +
                (cm.Email      == null ? '' : cm.Email)      + '","' +
                (cm.Phone      == null ? '' : cm.Phone)      + '","' +
                (cm.MobilePhone== null ? '' : cm.MobilePhone)+ '","' +
                (cm.Street     == null ? '' : cm.Street)     + '","' +
                (cm.City       == null ? '' : cm.City)       + '","' +
                (cm.State      == null ? '' : cm.State)      + '","' +
                (cm.PostalCode == null ? '' : cm.PostalCode) + '","' +
                (cm.Religion__c== null ? '' : cm.Religion__c)+ '"\n';
            System.debug(recordString);
            finalstr += recordString;
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Members.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String subject ='Chapter members for ' + campaignName;
        email.setSubject(subject);
        email.setToAddresses(coLeaderEmails);
        if (emailBody == null || emailBody.length() == 0)
            emailBody = subject;
        email.setPlainTextBody(emailBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        if(!Test.isRunningTest())
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return Page.SendMemberListConfirmationPage;
    }
}
