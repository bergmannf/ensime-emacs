#!/bin/bash

# NOTE: check the .drone.yml file for the cask commands that are
# needed to initialise your environment.

# TODO: it would be good to rewrite all our tests using standard
# ert-runner (and lose our custom test start scripts), but that is
# very tricky because of our async testing. We could turn each of our
# tests into an ert-deftest but that requires some macro expertise.

# tests must be run from the parent of the test directory
cd "`dirname $0`/../"

if [ -z "$SCALA_VERSION" ] ; then
    export SCALA_VERSION=2.11.7
fi

if [ -z "$EMACS" ] ; then
    export EMACS=`which emacs`
fi

if [ -z "$JDK_HOME" ] ; then
    if [ -n "$JAVA_HOME" ] ; then
       export JDK_HOME="$JAVA_HOME"
    elif [ -x "/usr/libexec/java_home" ] ; then
        export JDK_HOME=`/usr/libexec/java_home`
    else
        JAVAC=`which javac`
        export JDK_HOME=$(readlink -f $JAVAC | sed "s:bin/javac::")
    fi
fi
export JAVA_HOME="$JDK_HOME/jre"

if [ $# -ge 1 ]; then
  exec "$EMACS" --no-site-file --no-init-file --load test/dotemacs_test.el --eval "(ensime-run-one-test \"${*}\")"
else
  exec "$EMACS" -batch --no-site-file --no-init-file --load test/dotemacs_test.el --funcall ensime-run-all-tests
fi
