# CampaignMembershipByEmail
Sends an email with all CampaignMember details in a CSV

I wrote this for a non-profit that manages Chapters as Salesforce Campaigns. A Chapter has leaders (denoted by a special MemberStatus value) who want to receive an email with a CSV file containing all Chapter members' details.

This project consists of:
1. The back-end logic to create a CSV and email it out to the Chapters' leaders
2. Two Visualforce pages to associate with a Button (one for Record Detail, the other for List View)

Installation instructions:
1. Deploy this project's metadata.
2. Go to Setup->Customize->Campaign->Buttons
3. Create two new buttons
3a. One for Detail View. Associate with SendMemberListPage.
3b. One for List View (allow for multi-select). Associate with SendMemberListMultiSelect
4. Go to Page Layout for Campaign. Add the button you created in step 3a.
5. Go to List View Layout and Search Layout for Campaign. Add the button you created in step 3b.
