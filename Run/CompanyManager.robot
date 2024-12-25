*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
Library             SeleniumLibrary
Resource            ../Global/Resource.robot
Test Setup         I Create Post Request For Login And Verify Response      Company Manager

*** Test Cases ***
DashBoardEditCompanyManager
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    #**********************
    And I Create Get Request For Get User Id        Company Manager
    And I Create Get Request For Dashboard And Verify Response      Company Manager
    #And I Create Post Request Arrange Widgets      Company Manager
    And I Create Get Request For Get User Widget For verification     Company Manager

Property listing
    And I Create Post Request To View Report Statuses And Verify Response
    And I Create Post Request To View Report Update features And Verify Response
    And I Create Post Request Navigation on Dashboard    Company Manager    Properties
    And I Create Post Request Navigation on Dashboard    Company Manager    FilterByCompany
    #validation for load factor
    And I Create Post Request Navigation on Dashboard    Company Manager    SearchBuildings
    And I Create Post Request Navigation on Dashboard    Company Manager    SpecialCharacter
    And I Create Post Request Navigation on Dashboard    Company Manager    ReportView
    And I Create Post Request Navigation on Dashboard    Company Manager    ViewAllOrders
    And I Create Post Request Navigation on Dashboard    Company Manager    Property Summary
    And I Create Post Request Navigation on Dashboard    Company Manager    Tenant Details
    And I Create Post Request Navigation on Dashboard    Company Manager    Stacking Plan
    And I Create Post Request Navigation on Dashboard    Company Manager    Drawing vault

Property Invite User
    And I Create Post Request For Invite User And Verify Response For Company Manager

Property Add Property
    And I Create Post Request For Add Property And Verify
    And I Create Post Request Navigation on Dashboard    Company Manager     CreateOrder





