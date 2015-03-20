#!/bin/bash
# apply-preambles - put comments atop many files, like perhaps legal language
# Based on <https://github.com/afseo/cmits>.
# Copyright (C) 2015 Jared Jennings, jjennings@fastmail.fm.
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

run_test () {
    local test=$1
    pushd tests >& /dev/null
    PREAMBLE=${PREAMBLE:-../preamble}
    if [ ! -d $test\-expected ]; then
        echo test $test FAILED: no expected values to compare with >&2
        return 1
    fi
    rm -rf $test\-actual
    cp -R pristine $test\-actual
    set -e
    test_$test
    set +e
    local retval=0
    local outfile=$(mktemp)
    if ! diff -ru -x .svn $test\-actual $test\-expected > $outfile; then
        echo FAILED: differences found >&2
        cat $outfile
        retval=1
    fi
    rm -f $outfile
    popd >& /dev/null
    return $retval
}

test_lorem () {
    $PREAMBLE apply LOREM lorem-actual
}

test_lorem_remove () {
    $PREAMBLE apply LOREM lorem_remove-actual
    $PREAMBLE remove LOREM lorem_remove-actual
}

test_atsign () {
    $PREAMBLE apply ATSIGN atsign-actual
}

test_lorem_blank_lines () {
    $PREAMBLE apply LOREM_BLANK_LINES lorem_blank_lines-actual
}

# Grab all functions whose name starts with test_.
TESTS=( $(declare -F -p | cut -d' ' -f3 | grep '^test_' | sed 's/^test_//g') )

# We want to execute all the tests, but still return an error value if any of
# them fail.
aggregate_retval=0
for test in ${TESTS[*]}; do
    echo -n "$test ... "
    if run_test $test; then
        echo "ok"
    else
        # run_test already echoed FAILED for us, above.
        aggregate_retval=1
    fi
done

if [ $aggregate_retval = 0 ]; then
    echo All tests succeeded.
fi

exit $aggregate_retval
