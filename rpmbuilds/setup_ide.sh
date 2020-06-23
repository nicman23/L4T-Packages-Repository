#!/bin/bash

CONTAINER_NAME="fedora-rpmbuilds-ide"
WORKSPACE_DIRECTORY="//root/workspace"
GIT_REPO_TO_CLONE="https://github.com/Azkali/L4T-Packages-Repository.git"
IDE_PORT="9092"

START_COMMAND="code-server --auth none --bind-addr 0.0.0.0:$IDE_PORT \"$WORKSPACE_DIRECTORY\" || tail -f /dev/null"

function bashCommand()
{
    COMMAND="$1"
    docker exec -it $CONTAINER_NAME bash -c "$COMMAND"
}

function installDependency()
{
    DEPENDENCY="$1"
    bashCommand "command -v $DEPENDENCY || dnf install -y $DEPENDENCY"
}

function doSetup()
{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME

    echo "Do you want to add the current Jet-Factory folder as a Volume to persist changes ?"
    select persist in yes no; do
        case $persist in
            yes)
            docker run -d -p $IDE_PORT:$IDE_PORT \
                        --volume //var/run/docker.sock:/var/run/docker.sock \
                        --volume $(dirname $(readlink -fm $0)):/root/workspace \
                        --user root \
                        --workdir //root \
                        --name $CONTAINER_NAME \
                        fedora:32 \
                        bash -c "$START_COMMAND"
            ;;
            no)
            docker run -d -p $IDE_PORT:$IDE_PORT \
                        --volume //var/run/docker.sock:/var/run/docker.sock \
                        --user root \
                        --workdir //root \
                        --name $CONTAINER_NAME \
                        fedora:32 \
                        bash -c "$START_COMMAND"
            ;;
            *)
            echo "Invalid entry."
            exit
            ;;
        esac
        break
    done

    bashCommand "dnf update -y"
    installDependency "git"
    installDependency "curl"
    installDependency "docker.ce"
 
    #Install IDE - Code Server
    bashCommand "curl -fsSL https://code-server.dev/install.sh | sh"

    if [[ ${persist} == no ]]; then
        #Clone Repo Down
        bashCommand "git clone \"$GIT_REPO_TO_CLONE\" \"$WORKSPACE_DIRECTORY\""        
    fi
    #Start IDE
    bashCommand "code-server --install-extension ms-azuretools.vscode-docker"
    bashCommand "code-server --install-extension laurenttreguier.rpm-spec"

    docker restart $CONTAINER_NAME
}

if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    #Setup the Code Environment
    doSetup
else
    #Start the Code Environment (If it already exists)
    docker start $CONTAINER_NAME
fi
