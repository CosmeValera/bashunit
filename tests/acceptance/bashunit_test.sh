#!/bin/bash

function test_bash_unit_when_a_test_passes() {
  local test_file=./tests/acceptance/fake_success_test.sh
  fixture=$(printf "Running ./tests/acceptance/fake_success_test.sh
\e[32m✓ Passed\e[0m: Succeed

\e[2mTests:     \e[0m \e[32m1 passed\e[0m, 1 total
\e[2mAssertions:\e[0m \e[32m1 passed\e[0m, 1 total
\e[42mAll tests passed\e[0m")

  echo "
#!/bin/bash
function test_succeed() { assert_equals \"1\" \"1\" ; }" > $test_file

  assert_contains\
   "$fixture"\
    "$(./bashunit "$test_file")"

  assert_successful_code "$(./bashunit "$test_file")"

  rm $test_file
}

function test_bash_unit_when_a_test_fail() {
  local test_file=./tests/acceptance/fake_fail_test.sh
  fixture=$(printf "Running ./tests/acceptance/fake_fail_test.sh
\e[31m✗ Failed\e[0m: Fail
    \e[2mExpected\e[0m \e[1m\'1\'\e[0m
    \e[2mbut got\e[0m \e[1m\'0\'\e[0m

\e[2mTests:     \e[0m \e[31m1 failed\e[0m, 1 total
\e[2mAssertions:\e[0m \e[31m1 failed\e[0m, 1 total")

  echo "
#!/bin/bash
function test_fail() { assert_equals \"1\" \"0\" ; }" > $test_file

  assert_contains\
   "$fixture"\
    "$(./bashunit "$test_file")"

  assert_general_error "$(./bashunit "$test_file")"

  rm $test_file
}
