*** Settings ***
Documentation      Mobile Automation Test Suite for Eraspace Application (Soal 3).
...                Verifies Scenario 1: Login functionality (Invalid & Valid credentials).
Resource           ../resources/pages/pages.robot
Variables          ../config/env_loader.py
Test Setup         Open Eraspace Application
Test Teardown      Close Eraspace Application

*** Test Cases ***
TC 1.1: Login with invalid data
    [Documentation]    Verify login failure when entering invalid username and password.
    ...                Expected: Login fails and error message is displayed.
    [Tags]             login    negative    mobile
    Given Navigate To Login Screen
    When Input Login Credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    And Click Login Button
    Then Verify Login Error Message Displayed

TC 1.2: Login with valid data
    [Documentation]    Verify login success when entering valid credentials.
    ...                Expected:
    ...                1. Login success
    ...                2. Redirected to homepage
    ...                3. Displays menu list
    ...                4. Displays user account name
    ...                5. Displays point balance list
    [Tags]             login    positive    smoke    mobile
    Given Navigate To Login Screen
    When Input Login Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    And Click Login Button
    Then Verify Redirected To Homepage
    And Verify Navigation Menu List Displayed
    And Verify Point Balance List Displayed
    And Verify User Account Name Displayed
