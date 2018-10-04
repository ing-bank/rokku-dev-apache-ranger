#!/bin/bash

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10
while netstat -lnt | awk '$4 ~ /:6080$/ {exit 1}'; do
    echo "waiting for ranger to be ready"
    sleep $step;
    count=$(expr $count + $step)
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if [ "$start_timeout_exceeded" = "false" ]; then
    # Setup ranger users/groups
    printf "Creating user and group definition... \n"
    curl -u admin:admin -d "@/tmp/resources/user-group/testgroup.json" -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:6080/service/xusers/secure/groups
    curl -u admin:admin -d "@/tmp/resources/user-group/testuser.json" -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:6080/service/xusers/secure/users
    printf "\nUser and group created\n"

    # Setup ranger servicedefs
    printf "Creating service definition... \n"
    curl -u admin:admin -d "@/tmp/resources/servicedef/ranger-servicedef-s3.json" -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:6080/service/public/v2/api/servicedef
    printf "\nService definition created\n"

    # Setup ranger services
    printf "Creating service... \n"
    curl -u admin:admin -d "@/tmp/resources/service/ranger-service-s3.json" -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:6080/service/public/v2/api/service
    printf "\nService created\n"

    # Setup ranger policies
    printf "Creating policy... \n"
    curl -u admin:admin -d "@/tmp/resources/policy/ranger-policy-s3.json" -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:6080/service/public/v2/api/policy
    printf "\nPolicy created\n"

    echo "Done setting up Ranger for s3"
else
    echo "Waited too long for Ranger to start, skipping setup..."
fi
