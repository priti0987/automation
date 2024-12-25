*** Settings ***
Library           ../use_1.py

*** Test Cases ***
Open an Excel File
    ${workbook}    Open Excel File    TestData/HelloWorldWorkbook.xlsx
    Log    ${workbook}

Get Cell Value by Sheet Name
    ${workbook}    Open Excel File    TestData/HelloWorldWorkbook.xlsx
    ${cellA1}    Get Cell Value by Sheet Name    ${workbook}    Sheet1    1     2
    Should Be Equal As Strings    Hello World    ${cellA1}

Get Cell Value of Active Sheet
    ${workbook}    Open Excel File    TestData/HelloWorldWorkbook.xlsx
    ${cellA1}    Get Cell Value of Active Sheet    ${workbook}    A1
    Should Be Equal As Strings    Hello World    ${cellA1}

Get Sheet Names
    ${workbook}    Open Excel File    TestData/HelloWorldWorkbook.xlsx
    ${sheet_names}    Get Sheet Names    ${workbook}
    Log     ${sheet_names}
    Should Be Equal As Strings    Sheet1    ${sheet_names[0]}
    Should Be Equal As Strings    Sheet2    ${sheet_names[1]}
    Should Be Equal As Strings    Third Sheet    ${sheet_names[2]}

