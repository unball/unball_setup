RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

ORIGINAL_DIRECTORY=$PWD
cd ~
if [ -d "unball" ]
then
    printf "${RED}~/unball folder already exists, nothing done.${NO_COLOR}\n"
else
    printf "\n${BLUE}Cloning unball repositories in folder ~/unball${NO_COLOR}\n\n"
    mkdir ~/unball
    cd ~/unball
    git clone https://github.com/unball/ieee-very-small.git
    git clone https://github.com/unball/vision.git
    git clone https://github.com/unball/communication.git
    git clone https://github.com/unball/strategy.git
    git clone https://github.com/unball/control.git

    printf "\n${BLUE}Downloading the unball simulator${NO_COLOR}\n\n"
    mkdir ~/unball/simulator
    cd ~/unball/simulator
    # Download latest version from Google Drive
    wget -O "unball_simulator.tar.gz" "https://drive.google.com/uc?export=download&id=0BwlvQGynHcxZTTdPUnF3dGR0MlE"
    # Extract downloaded version, overwriting files
    tar -xzf "unball_simulator.tar.gz" --overwrite

    printf "\n${BLUE}Setting up catkin workspace at catkin_ws_unball${NO_COLOR}\n\n"
    mkdir ~/catkin_ws_unball
    cd ~/catkin_ws_unball
    mkdir src
    catkin_make
    ln -s ~/unball/ieee-very-small ~/catkin_ws_unball/src/ieee-very-small
    ln -s ~/unball/vision ~/catkin_ws_unball/src/vision
    ln -s ~/unball/strategy ~/catkin_ws_unball/src/strategy
    ln -s ~/unball/communication ~/catkin_ws_unball/src/communication
    ln -s ~/unball/simulator ~/catkin_ws_unball/src/simulator
    ln -s ~/unball/control ~/catkin_ws_unball/src/control
    cp ${ORIGINAL_DIRECTORY}/run_strategy_and_simulator.sh ~/catkin_ws_unball/
    cp ${ORIGINAL_DIRECTORY}/update_all_repos.sh ~/catkin_ws_unball/

    catkin_make;

    printf "\n${BLUE}Setup complete! This folder may now be deleted if you wish.${NO_COLOR}\n"
fi
