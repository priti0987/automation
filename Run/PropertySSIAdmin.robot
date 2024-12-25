*** Settings ***
Documentation       This Document include Automation script scenarios for Login of stevensons website through API
#Library             SeleniumLibrary
Resource            ../Global/Resource.robot
Resource            ../Global/NewResource.robot

Test Setup       I Create Post Request For Login And Verify Response        SSI


*** Test Cases ***
Filter property listing by Company
    I Create Post Request Navigation on Dashboard    SSI    FilterByCompany

Filter property listing by searched Property
    #SSI Admin to view correct values on the Property Listing columns
    I Create Get Request For Validation Of SearchBuildings In SSI

Filter property using special characters
    I Create Post Request Navigation on Dashboard    SSI    SpecialCharacter
#
As a SSI Admin I can invite
    I Create Post Request For Invite User With AddPropertyList And Verify Response
#
SSI Admin can Create Order
    I Create Post Request Navigation on Dashboard    SSI     CreateOrder
#
SSI Admin can view All Orders
    I Create Post Request Navigation on Dashboard    SSI    ViewAllOrders
#
SSI Admin can view reports open in a new window
    I Create Get Request For Validation In SSI For      reportstatuses
#
SSI Admin should be able to view Property Tenant Log
    I Create Post Request Navigation on Dashboard    SSI    Tenant Details
#
SSI Admin to view correct fields for Property Summary
    I Create Post Request Navigation on Dashboard    SSI    Property Summary
    #And I Create Get Request For Validation In SSI For      propertyDetail

As a SSI Admin, I can view Tenant Listing
    I Create Post Request Navigation on Dashboard    SSI    Tenant Details
#
As a SSI Admin I can create new Property
    I Create Post Request For Add Property And Verify
#
As a SSI Admin Can Update
    I Create Post Request For Update Report Changes

SSI Admin should be able to create order successfully
    I Create Post Request For Save Create Order         SSI
SSI Admin to cancel an order
    I Create Post Request For merge Order
    I Create Post Request For Cancel Order
    #I Create Post Request For Send Message To Client In Order Details
    #I Create Post Request For Send Message To Client In Order Details Communicate Without Files

SSI Admin to assign Order to a resource
    I Create Get Request For assign Order to a resource
    I Create Request For complete an order


SSI Admin To Start An order And Set Status To Pending
    I Create Get Request Start An order And Set Status To Pending
SSI Admin To Start An Order And Set Status To Paused
    I Create Get Request Start An Order And Set Status To Paused
SSI Admin To Edit Order Details
    I Create POST Request To Edit Order Details
SSI Admin To Attached Client Uploads
    I Create POST Request To Attached Client Uploads
SSI Admin to remove an order
    I Create POST Request To Remove Order

SSI Admin to remove attached Client Uploads
   I Create POST Request To Remove Attached Client Uploads
SSI Admin to download Active Orders
    I Create POST Request To download Active Orders
#SSI Admin to download All Orders


