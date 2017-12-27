@isTest
public class TestSendMemberListController {
    
    static testmethod void test1() {
        Campaign c = new Campaign();
        c.Name = 'Test';
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'Test';
        c1.LastName = 'Contact';
        c1.Email = 'a@b.com';
        insert c1;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = c.Id;
        cm.ContactId = c1.Id;
        cm.Status = 'Co-Leader';
        insert cm;
        
        PageReference pageRef = Page.SendMemberListPage;
        pageRef.getParameters().put('recordId', c.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        SendMemberListController controller = new SendMemberListController(stdController);
        controller.SendEmailToLeaders();
        
        List<Campaign> lst = new List<Campaign>();
        lst.add(c);
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(lst);
        SendMemberListController controller2 = new SendMemberListController(setController);
    }
}