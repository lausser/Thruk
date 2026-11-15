#!/bin/bash
#
# usage:
#
# html2pdf.sh <html inputfile> <pdf outputfile> [<logfile>]
#

# read rc files if exist
[ -e /etc/thruk/thruk.env  ] && . /etc/thruk/thruk.env
[ -e ~/etc/thruk/thruk.env ] && . ~/etc/thruk/thruk.env
[ -e ~/.thruk              ] && . ~/.thruk
[ -e ~/.profile            ] && . ~/.profile

DIR=$(dirname "$BASH_SOURCE")
export PATH=$PATH:$DIR

export THRUK_BROWSER THRUK_BROWSER_NO_SANDBOX WAIT_TIMEOUT START_TIMEOUT THRUK_COOKIE_AUTH_DOMAIN
if [ "$1" = "--find-browser" ] || [ "$1" = "--selftest" ]; then
    perl "$DIR/render_url.pl" "$1"
    exit $?
fi

LOGFILE="$3";
if [ "$LOGFILE" != "" ]; then
    exec >>$LOGFILE 2>&1
fi

INPUT=$1
OUTPUT=$2
IS_REPORT=$4


if [ -d "$OUTPUT" ]; then
    echo "ERROR: $OUTPUT is a directory"
    exit 1
fi

# the output is only put in place after the renderer succeeded
rm -f "${OUTPUT}.pdf"
perl "$DIR/render_url.pl" "$INPUT" "${OUTPUT}.pdf" "1600" "1200" "$THRUK_SESSION_ID" $IS_REPORT 2>&1
rc=$?
if [ $rc -eq 0 ]; then
    mv "${OUTPUT}.pdf" "${OUTPUT}" || rc=1
fi
rm -f "${OUTPUT}.pdf"
exit $rc
