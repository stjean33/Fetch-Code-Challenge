*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn
Library    String
Library    Screenshot
Library    Collections

*** Variables ***
${URL}              http://sdetchallenge.fetch.com
${LEFT_BOWL}        xpath=//input[@id="left_0"]  
${RIGHT_BOWL}       xpath=//input[@id="right_0"] 
${RESET_BUTTON}     xpath=//button[@id="reset"]
${WEIGH_BUTTON}     xpath=//button[@id="weigh"]
${RESULT_VIEW}      xpath=//button[@id="reset"]


*** Keywords ***
Repeat Until Fake Bar Found
    [Arguments]    ${max_attempts}
    FOR    ${i}    IN RANGE    ${max_attempts}
        Log    Attempt ${i} of ${max_attempts}
        ${random_num1}=    Evaluate    random.randint(0, 8)    modules=random
        ${random_num2}=    Evaluate    random.randint(0, 8)    modules=random
        Input Random Number Into Bowls    ${random_num1}    ${random_num2}
        Click Weigh Button
        @{elements}=    Get WebElements    xpath=//div[@id="root"]/div/div[1]/div[5]/ol/li
        ${found_fake_bar}=    Create List
        FOR    ${element}    IN    @{elements}
            ${text}=    Get Text    ${element}
            Log    Weighing result element text: ${text}
            Append To List    ${found_fake_bar}    ${text}
        END
        ${expected_text}=    Set Variable    [${random_num1}] > [${random_num2}]
        Log    Expected text: ${expected_text}
        FOR    ${text}    IN    @{found_fake_bar}
            Log    Checking text: ${text}
            IF    '${expected_text}' == '${text}'
                Log    Found Fake Gold Bar: ${text}
                ${num_in_left_bowl}=    Get Text    ${LEFT_BOWL}
                Click Element    xpath=//button[@id="coin_${num_in_left_bowl}"]
                Return From Keyword    True
            END
        END
        Clear Results
    END
    Take Screenshot
    Log    Fake bar not found within ${max_attempts} attempts.
    Return From Keyword    False

Input Random Number Into Bowls
    [Arguments]    ${random_num1}    ${random_num2}
    Input Text    ${LEFT_BOWL}    ${random_num1}
    Input Text    ${RIGHT_BOWL}    ${random_num2}

Clear Results
    Click Element    ${RESET_BUTTON}

Click Weigh Button
    Click Element    ${WEIGH_BUTTON}