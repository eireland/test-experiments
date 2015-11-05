#! /bin/bash

    RESULT_FILE="testruntest.csv"
    TRIALNUM=5
    CASESNUM=6
    TESTNUM=2
    BROWSER=("firefox" "chrome")
    CODAP_ROOT="codap.concord.org/releases/"
    CODAP_VERSION="latest"
    i=0
    printf "Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
    tLen=${#BROWSER[@]}
    echo "$tLen number of browsers"
    while [ $i -lt $TESTNUM ]
    do
        echo "begin i = $i"
        b=0
        while [ $b -lt $tLen ]
            do
                echo "begin b = $b"
                START=$(date)
                START_SEC=$(date +"%s")
                echo "Call testPerformanceHarness.rb"
                ruby testPerformanceHarness.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]} -r $CODAP_ROOT -v $CODAP_VERSION
                echo "End testPerformanceHarness.rb"
                END=$(date)
                END_SEC=$(date +"%s")
                DURATION=$(($END_SEC-$START_SEC))
                echo "$BROWSER Test $i Time end: $END    TrialNum: $TRIALNUM CasesNum: $CASESNUM Duration: $(($DURATION / 60))m $(($DURATION % 60))s $DURATION s"
                printf "$BROWSER[$b]\t $i\t $TRIALNUM\t $CASESNUM\t  $(($DURATION / 60))m $(($DURATION % 60))s\t $DURATION\n" >> $RESULT_FILE
                if [ $b -lt $tLen ]; then
                    b=$(($b+1))
                fi
                echo "end b = $b"
            done
        START=$(date)
        START_SEC=$(date +"%s")

        i=$(($i+1))
        echo "end i = $i"
    done