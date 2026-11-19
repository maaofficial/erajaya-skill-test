*** Settings ***
Documentation      Test Suite for Scenario 2: Make Appointment functionality on CURA Healthcare Service.
Resource           ../resources/pages/pages.robot
Test Setup         Open CURA Application
Test Teardown      Close CURA Application

*** Variables ***
${TEST_FACILITY}       Hongkong CURA Healthcare Center
${TEST_READMISSION}    ${True}
${TEST_PROGRAM}        Medicaid
${TEST_VISIT_DATE}     30/11/2026
${TEST_COMMENT}        Testing Make Success Appointment.

*** Test Cases ***
TC 2.1: Make Appointment - without input mandatory field
    [Documentation]    Verify error validation when booking an appointment without filling the mandatory Visit Date field.
    [Tags]             appointment    negative
    Given Login To Application With Valid Credentials
    When Fill Appointment Form Without Date    facility=${TEST_FACILITY}    readmission=${TEST_READMISSION}    program=${TEST_PROGRAM}    comment=${TEST_COMMENT}
    And Click Book Appointment Button
    Then Verify Mandatory Date Validation Message Displayed

TC 2.2: Make Appointment - Success
    [Documentation]    Verify successfully booking an appointment when all required and optional data are filled.
    [Tags]             appointment    positive
    Given Login To Application With Valid Credentials
    When Fill Complete Appointment Form    facility=${TEST_FACILITY}    readmission=${TEST_READMISSION}    program=${TEST_PROGRAM}    visit_date=${TEST_VISIT_DATE}    comment=${TEST_COMMENT}
    And Click Book Appointment Button
    Then Verify Appointment Confirmation Details    facility=${TEST_FACILITY}    readmission=${TEST_READMISSION}    program=${TEST_PROGRAM}    visit_date=${TEST_VISIT_DATE}    comment=${TEST_COMMENT}
