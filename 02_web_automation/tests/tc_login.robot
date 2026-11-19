*** Settings ***
Documentation      Test Suite for Scenario 1: Login functionality on CURA Healthcare Service.
Resource           ../resources/pages/pages.robot
Test Setup         Open CURA Application
Test Teardown      Close CURA Application

*** Test Cases ***
TC 1.1: Login with invalid data
    [Documentation]    Verify login failure when submitting invalid username and password.
    [Tags]             login    negative
    Given Navigate To Login Page
    When Input Login Credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    And Click Login Button
    Then Verify Login Error Message Displayed

TC 1.2: Login with valid data
    [Documentation]    Verify successful login and redirection to Make Appointment homepage using valid credentials.
    [Tags]             login    positive    smoke
    Given Navigate To Login Page
    When Input Login Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    And Click Login Button
    Then Verify Redirected To Appointment Page
