#!/bin/sh
# Gradle wrapper shell script for POSIX-compatible shells

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`
APP_HOME=`dirname "$0"`
APP_HOME=`cd "$APP_HOME" && pwd`

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

MAX_FD="maximum"
warn () { echo "$*"; }
die () { echo; echo "$*"; echo; exit 1; }

case "`uname`" in
  CYGWIN* )
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
    ;;
  Darwin* )
    darwin=true
    ;;
esac

if [ -z "$JAVA_HOME" ] ; then
    if $darwin ; then
        JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    fi
fi

if [ -z "$JAVA_HOME" ]; then
    JAVACMD=`which java 2>/dev/null`
    [ -z "$JAVACMD" ] && die "ERROR: JAVA_HOME is not set and no 'java' command found in PATH."
else
    JAVACMD="$JAVA_HOME/bin/java"
    [ -f "$JAVACMD" ] || die "ERROR: JAVA_HOME ($JAVA_HOME) does not contain a valid Java installation."
fi

exec "$JAVACMD" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
