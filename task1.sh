#/bin/bash

#
function foobar_foo_gte_10() {
file="/tmp/foobar"
#oprava konf. souboru, ulozeni do /tmp/foobar1
sed s/' '*=' '*/=/g $file > /tmp/foobar1
# cesta k opravenemu konf souboru
. /tmp/foobar1
opt="Foo"
expected_value="10"
assert_msg="Option '$opt' is greater than or equal to '$expected_value' in '$file'"

if [ $Foo -ge $expected_value ]; then
  echo "PASS - $assert_msg"
  return 0
else
  echo "FAIL - $assert_msg"
  return 1
fi
}
