*** Settings ***
Resource          codechallenge.resource
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           String
Library           BuiltIn
Library           Process


*** Test Cases ***
Find Fake Gold Bar
    Open Browser    ${URL}    chrome
    ${fake_bar_found}=    Run Keyword And Return Status    Repeat Until Fake Bar Found    10
    Close Browser