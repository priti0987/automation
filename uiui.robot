*** Settings ***
Library         SeleniumLibrary


*** Variables ***
${URL}      https://vasundhara.io/
${Browser}      Chrome

*** Test Cases ***
Demo
    Get Element and click on it


*** Keywords ***
Get Element and click on it
    open browser        ${URL}      ${Browser}
    maximize browser window
    sleep       2
    @{Services}=    Get WebElements     xpath://a[@class='learn-more']
    ${L}=    Get Length      ${Services}
