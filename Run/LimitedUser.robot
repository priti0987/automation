*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
Library             SeleniumLibrary
Resource            ../Global/Resource.robot
Test Setup         I Create Post Request For Login And Verify Response      Limited User

*** Test Cases ***
DashBoardEditLimitedUser
    When I create put request
    #When I Create Post Request For Send Sms And Verify Response
    #And I Create Post Request For Verification Of 2FA Code And Verify Reponse
    #Then I Create Get Request For Dashboard With GetUserNewAssignedCompany And Verify Response

#Property Listing
    #And I Create Get Request For Get User Id        Limited User
    #And I Create Get Request For Get User Id Value For        Limited User
    #And I Create Post Request Navigation on Dashboard    Limited User    Properties
    #validation for load factor
    #And I Create Post Request Navigation on Dashboard    Limited User    SearchBuildings
    #And I Create Post Request Navigation on Dashboard    Limited User    SpecialCharacter
    #And I Create Post Request Navigation on Dashboard    Limited User    Property Summary
    #And I create Get Request for View Notification

