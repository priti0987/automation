*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
Library             SeleniumLibrary
Resource            ../Global/Resource.robot
Test Setup        I Create Post Request For Login And Verify Response      User

*** Test Cases ***
DashBoardEditUser
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    And I Create Get Request For Get User Id Value For        User
    Then I Create Get Request For Dashboard And Verify Response      User
    And I Create Post Request Navigation on Dashboard    User    SearchBuildings
    When I Create Post Request Navigation on Dashboard       User       Edit
    Then I Create Get Request For Get User Widget For verification      User
    And I Create Post Request Arrange Widgets       User

Property Add Property
    And I Create Post Request For Add Property And Verify

Property Listing1
    And I Create Post Request Navigation on Dashboard    User    Properties
    And I Create Post Request Navigation on Dashboard    User    FilterByCompany
    #validation for load factor
    And I Create Post Request Navigation on Dashboard    User    SearchBuildings
    And I Create Post Request Navigation on Dashboard    User    SpecialCharacter
    And I Create Post Request Navigation on Dashboard    User    ReportView
    And I Create Post Request Navigation on Dashboard    User    ViewAllOrders
    And I Create Post Request To View Report Statuses And Verify Response
    And I Create Post Request To View Report Update features And Verify Response
    And I Create Post Request Navigation on Dashboard    User    Property Summary
    And I Create Post Request Navigation on Dashboard    User    Tenant Details
    And I Create Post Request Navigation on Dashboard    User    Stacking Plan
    And I create Get Request for View Notification
    And I Create Post Request Navigation on Dashboard    User    Drawing vault

