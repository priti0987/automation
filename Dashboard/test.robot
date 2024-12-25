*** Settings ***
Library   OperatingSystem
Library   String

Resource    ../testAPI.robot

*** Variables ***
${pathoftextfile}=          C:\JairoJobs\TenantEncoded.txt
*** Test Cases ***
TC001
    ${contents}=    Get File      C:\\JairoJobs\\TenantEncoded.txt
    @{lines}=       Split to lines   ${contents}
    #FOR            ${line}      IN      @{lines}
    #log         ${line}
    #END
    log    @{lines}



*** Keywords ***