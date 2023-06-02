#!/usr/bin/env bash

set -e

if [ "$(uname)" == "Darwin" ]; then
    sed=gsed
fi

find . -name 'pom.xml' -type f -exec $sed -i'' -e '
    /<artifactId>jenkins-test-harness-htmlunit<\/artifactId>/{
        N
        /<version>[^<]*<\/version>/{
            s/<version>[^<]*<\/version>/<version>143.v8979204b_fc0c<\/version>/
        }
    }
    /<artifactId>jenkins-test-harness<\/artifactId>/{
        N
        /<version>[^<]*<\/version>/{
            s/<version>[^<]*<\/version>/<version>2011.vf7edf4d6253d<\/version>/
        }
    }
' {} +

# Iterate over all files in the current directory recursively
find . -type f -name '*.java' -exec $sed -i'' -e '
    /net\.sourceforge\.htmlunit/{
        s/net\.sourceforge\.htmlunit/org.htmlunit/g
    }
    /com\.gargoylesoftware\.htmlunit/{
        s/com\.gargoylesoftware\.htmlunit/org.htmlunit/g
    }
    /getValueAttribute/{
        s/getValueAttribute/getValue/g
    }
    /setAttribute("value", /{
        s/setAttribute("value", /setValue(/g
    }
    /setAttribute("value",/{
        s/setAttribute("value",/setValue(/g
    }
    /setValueAttribute/{
        s/setValueAttribute/setValue/g
    }
    /<artifactId>jenkins-test-harness<\/artifactId>.*<version>[^<]*<\/version>/{
        s/<version>[^<]*<\/version>/<version>2011.vf7edf4d6253d<\/version>/
    }
' {} +

if git diff --exit-code > /dev/null
then
    echo "No replacements required"
    exit
fi

if grep -q '<artifactId>plugin</artifactId>' pom.xml
then
    mvn versions:update-parent -DparentVersion=4.64
    rm -f pom.xml.versionsBackup
fi

spotless_disabled=$(mvn help:evaluate -Dexpression=spotless.check.skip -q -DforceStdout)
if ! $spotless_disabled; then
    mvn spotless:apply
fi

git status
echo "Replacement completed."

