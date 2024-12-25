*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
Library           SeleniumLibrary
Resource            ../Global/Resource.robot
Test Setup       I Create Post Request For Login And Verify Response        SSIEmployee


*** Test Cases ***
Dashboard Widgets for SSIEmployee Admin
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    Then I Create Get Request For Dashboard And Verify Response      SSIEmployee
    And I Create Get Request For Get User Id Value For        SSIEmployee


Edit Dashboard for SSIEmployee Admin
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    #Then I Create Get Request For Dashboard And Verify Response      SSIEmployee
    When I Create Post Request Navigation on Dashboard      SSIEmployee     Edit
    Then I Create Get Request For Get User Widget For verification      SSIEmployee
    And I Create Post Request Arrange Widgets       SSIEmployee

Refresh Dashboard for SSIEmployee Admin
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    #Then I Create Get Request For Dashboard And Verify Response      SSIEmployee
    Then I Create Post Request Navigation on Dashboard      SSIEmployee      Refresh

Property Invite User
    And I Create Post Request For Invite User And Verify Response For SSIEmployee

Property Create Order
    And I Create Post Request Navigation on Dashboard    SSIEmployee     CreateOrder
    And I Create Post Request For Save Create Order     SSIEmployee
Property Add Property
    And I Create Post Request For Add Property And Verify

Property Listing
    And I Create Post Request Navigation on Dashboard    SSIEmployee    Properties
    And I Create Post Request Navigation on Dashboard    SSIEmployee    FilterByCompany
    #validation for load factor
    And I Create Post Request Navigation on Dashboard    SSIEmployee    SearchBuildings
    And I Create Post Request Navigation on Dashboard    SSIEmployee    SpecialCharacter
    And I Create Post Request Navigation on Dashboard    SSIEmployee    ReportView
    And I Create Post Request Navigation on Dashboard    SSIEmployee    ViewAllOrders
    And I Create Post Request To View Report Statuses And Verify Response
    And I Create Post Request To View Report Update features And Verify Response
    And I Create Post Request Navigation on Dashboard    SSIEmployee    Property Summary
    And I Create Post Request Navigation on Dashboard    SSIEmployee    Tenant Details
    And I Create Post Request Navigation on Dashboard    SSIEmployee    Stacking Plan

#Orders
    #And SSI Admin should be able to click plus sign to add new order




