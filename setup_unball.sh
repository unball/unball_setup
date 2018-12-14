RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

repos=(
    ieee-very-small
    vision
    communication
    control
    measurement_system
    strategy
    system
    strategy2018
    python_simulator
    new_vision
)

check_repos(){
    printf "\n${BLUE} Checking for packages existence${NO_COLOR}"
    declare -a argAry=("${!1}")
    clonestr='git clone https://github.com/unball/'
    for i in "${argAry[@]}"
    do
        if [[ ! -d "$i" ]] ; then
            printf "${GREEN} Cloning repo $i${NO_COLOR}\n"
            $clonestr$i.git
        else
            printf "${BLUE} $i already cloned ${NO_COLOR}\n"
        fi
    done
}

download_simulator(){
    printf "\n${BLUE}Downloading the unball simulator${NO_COLOR}\n\n"
    mkdir ~/unball/simulator
    cd ~/unball/simulator
    # Download latest version from Google Drive
    wget -O "unball_simulator.tar.gz" "https://drive.google.com/uc?export=download&id=0BwlvQGynHcxZTTdPUnF3dGR0MlE"
    # Extract downloaded version, overwriting files
    tar -xzf "unball_simulator.tar.gz" --overwrite
}

configure_catkin(){
    declare -a argAry=("${!1}")

    printf "\n${BLUE}Setting up catkin workspace at catkin_ws_unball${NO_COLOR}\n\n"
    mkdir -p ~/catkin_ws_unball
    cd ~/catkin_ws_unball
    mkdir -p src
    catkin_make
    for i in "${argAry[@]}"
    do
        if [[ ! -e "src/"$i ]]; then
            ln -s ~/unball/$i ~/catkin_ws_unball/src/$i
        fi
    done
    if [[ ! -e "src/simulator" ]]; then
        ln -s ~/unball/simulator ~/catkin_ws_unball/src/simulator
    fi
    cp ${ORIGINAL_DIRECTORY}/run_system.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/run_strategy_and_simulator.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/run_strategy_and_pythonsimulator.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/update_all_repos.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/status_all_repos.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/hard_reset_all_repos.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/plot_from_simulator.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/plot.py ~/catkin_ws_unball/

    chmod 777 ${ORIGINAL_DIRECTORY}/run_strategy_and_simulator.sh
    if [[ -e /usr/bin/run_strategy_and_simulator ]]; then
        sudo rm /usr/bin/run_strategy_and_simulator
    fi

    sudo ln -s ~/catkin_ws_unball/run_strategy_and_simulator.sh /usr/bin/run_strategy_and_simulator

    chmod 777 ${ORIGINAL_DIRECTORY}/run_strategy_and_pythonsimulator.sh
    if [[ -e /usr/bin/run_strategy_and_pythonsimulator ]]; then
        sudo rm /usr/bin/run_strategy_and_pythonsimulator
    fi

    sudo ln -s ~/catkin_ws_unball/run_strategy_and_pythonsimulator.sh /usr/bin/run_strategy_and_pythonsimulator

    printf "${GREEN}Copying desktop entry\n${NO_COLOR}"
    sudo cp ${ORIGINAL_DIRECTORY}/unball.png /usr/local/etc
    sudo cp ${ORIGINAL_DIRECTORY}/unball.desktop ~/.local/share/applications/
    sudo cp ${ORIGINAL_DIRECTORY}/unball.desktop /usr/share/applications/

    catkin_make

    printf "\n${BLUE}Setup complete! This folder may now be deleted if you wish.${NO_COLOR}\n"
}

ORIGINAL_DIRECTORY=$PWD
cd ~

if [[ ! -d "~/unball" ]]; then
    mkdir -p ~/unball
fi

cd ~/unball
check_repos repos[@]

if [[ $1 != "-y" ]]; then
    printf "Do you want to download simulator?[y/N] "
    read choice
    if [[($choice == "y") || ($choice == "Y") ]]; then
        download_simulator
    fi
else
    download_simulator
fi

configure_catkin repos[@]


