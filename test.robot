*** Settings ***
Library     SeleniumLibrary
Library           ../excel_1.py
Library         OperatingSystem
Library         String


*** Variables ***

${ok}      https://uat-myaccess.stevensonsystems.com
*** Test Cases ***
Login Validation cookies
    #open browser    https://www.icicibank.com     headlesschrome
    #input text          //input[@id='m_login_email']        fusepratap@gmail.com
    #click element       //button[@id='btnEmailContinue']

    #${c}=       get cookies         as_dict=True
    #${c1}       convert to string   ${c}
    #log     ${c1}
    #close browser
    #${workbook}    Open Workbook    TestData/TestData.xlsx
    #Write Data      ${workbook}     Sheet1      10   1      ${c1}
    #save excel      ${workbook}     TestData/TestData.xlsx
    ${File}=    Get File    C:/Users/Dell/Downloads/Sabre_wy_asr_txt.txt
    @{list}=    Split to lines    ${File}
    FOR    ${line}  IN   @{list}
           Log     ${line}
           ${Value}=   Get Variable Value  ${line}
           Log     ${Value}
    END