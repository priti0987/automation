*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
Library             SeleniumLibrary
Resource            ../Global/Resource.robot
Test Setup         I Create Post Request For Login And Verify Response      Company Admin
*** Test Cases ***
DashBoardEditCompanyAdmin
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    Then I Create Get Request For Dashboard And Verify Response      Company Admin
    And I Create Get Request For Get User Id        Company Admin

Property Add Property
    And I Create Post Request For Add Property And Verify

Property listing
    And I Create Post Request To View Report Statuses And Verify Response
PropertyCompadmin Report Update
    And I Create Post Request To View Report Update features And Verify Response
PropertyCompadmin FilterByCompany
    And I Create Post Request Navigation on Dashboard    Company Admin    FilterByCompany
PropertyCompadmin SearchBuildings
    #validation for load factor
    And I Create Post Request Navigation on Dashboard    Company Admin    SearchBuildings
PropertyCompadmin SpecialCharacter
    And I Create Post Request Navigation on Dashboard    Company Admin    SpecialCharacter
PropertyCompadmin ReportView
    And I Create Post Request Navigation on Dashboard    Company Admin    ReportView
PropertyCompadmin ViewAllOrders
    And I Create Post Request Navigation on Dashboard    Company Admin    ViewAllOrders
PropertyCompadmin Property Summary
    And I Create Post Request Navigation on Dashboard    Company Admin    Property Summary
PropertyCompadmin Tenant Details
    And I Create Post Request Navigation on Dashboard    Company Admin    Tenant Details
PropertyCompadmin Stacking Plan
    And I Create Post Request Navigation on Dashboard    Company Admin    Stacking Plan
PropertyCompadmin Drawing vault
    And I Create Post Request Navigation on Dashboard    Company Admin    Drawing vault


Property Invite User
    And I Create Post Request For Invite User And Verify Response For Company Admin
    And I Create Post Request For Invalid email for invite user in company admin
    And I Create Post Request For Company admin can invite already existing member

Property Create Order
    And I Create Post Request For Create Order For Comapany Admin

Property Update Property Summary
    And I Create Post Request For Update Property Summary

Property View Property Details
    And I Create Post Request For View Property Details and verify Measurement Reports

Company Admin can Download Current Floor and Tenant Listing
    And I Create Post Request For AuditTrail To Navigate To Current Floor and Tenant Listing
    And I Create Post Request For floor-and-tenant-detail
    And I Create Post Request For GenerateExcelReport

Company Admin can share Measurement Report
    And I Create Post Request For share Measurement Report

Company Admin can view Report Updates
    And I Create Post Request For view Report Updates

Company Admin can redirect to Order details when clicking related order
    And I Create Post Request For redirect to Order details when clicking related order

