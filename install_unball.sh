#!/bin/bash

ROS_FOLDER=/opt/ros/melodic/

configld(){
    sudo echo "$ROS_FOLDER"lib > /etc/ld.so.conf.d/ros.conf
    sudo ldconfig -v
}

program_is_installed () {
  type "$1" &> /dev/null ;
}

# display a message in red with a cross by it
# example
# echo echo_fail "No"
echo_fail(){
  # echo first argument in red
  printf "\e[31m✘ ${1}"
  # reset colours back to normal
  printf "\033[0m"
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
echo_pass(){
  # echo first argument in green
  printf "\e[32m✔ ${1}"
  # reset colours back to normal
  printf "\033[0m"
}

echo_if(){
  if [ $1 == 1 ]; then
    echo_pass $2
  else
    echo_fail $2
  fi
}

install_dependency() {
  declare -a argAry=("${!2}")

  for i in "${argAry[@]}"
  do
    if dpkg-query -W "$i"; then
      printf "\e[32m----------------Package $i already installed----------------"
      printf "\033[0m \n"
    else
      printf "\e[93m\e[1m[WARNING]\e[21m Package not found"
      printf "\e[0m\n"
      printf "\e[1m Installing"
      printf "\e[0m\n"
      sudo apt-get -y install "$i"
      echo "Done installing $i!"
    fi
  done
}

install_python_pckts() {
  declare -a argAry=("${!2}")

  for i in "${argAry[@]}"
  do
      printf "\e[1m Installing"
      printf "\e[0m\n"
      pip3 install "$i"
      echo "Done installing $i!"
  done
}

install_ros(){
  sudo apt-get update
  echo "Starting ROS-melodic installation"
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

  sudo apt-get update
  sudo apt-get -y install ros-melodic-desktop-full
  sudo rosdep init
  rosdep update
  echo "# Sourcing ROS environment variables" >> /home/$user_/.bashrc
  echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
  
  echo "Finished"
  sudo apt-get update
}

configure_catkin(){
  sudo apt-get update
  echo "$user_"
  . /opt/ros/melodic/setup.bash
  mkdir -p /home/$user_/catkin_ws_unball/src; cd /home/$user_/catkin_ws_unball/src
  catkin_init_workspace
  cd /home/$user_/catkin_ws_unball/; catkin_make;
  . ~/catkin_ws_unball/devel/setup.bash
  echo "# Sourcing catkin environment variables" >> /home/$user_/.bashrc
  echo "source ~/catkin_ws_unball/devel/setup.bash" >> /home/$user_/.bashrc
  . /home/$user_/.bashrc
}


devtools=(
  "build-essential"
  "cmake"
  "pkg-config"
  "git"
)

gtk=(
  "libgtk2.0-dev"
)

video_iopack=(
  "libavcodec-dev"
  "libavformat-dev"
  "libswscale-dev"
  "libv4l-dev"
)

python_dev=(
    "python3-pip"
    "python3-dev"
    "python3-numpy"
    "python3-opencv"
    "python3-qt*"
)

python_libs=(
    "rospkg"
    "matplotlib"
    "control"
    "pygame"
    "box2d-py"
    "pygame-menu"
    "dubins"
    "opencv-python"
)
rosversion="ros-melodic"

ros_tools=(
    sudo apt-get update
    $rosversion"-joy"
    $rosversion"-rosbridge-server"
    $rosversion"-rosserial"
    $rosversion"-rosserial-arduino"
)

user_=$(whoami)

. /home/$user_/.bashrc
install_dependency "Developer tools and packages" devtools[@]
install_dependency "GTK development library" gtk[@]
install_dependency "Video I/O packages" video_iopack[@]
install_dependency "Python3 dev tools" python_dev[@]
install_python_pckts "Python3 libs" python_libs[@]

if [[ -x "$(command -v roscore)" ]];then
  echo $(echo_pass 'ros')
else
  install_ros
  configure_catkin
fi

# sudo easy_install numpy scipy Sphinx numpydoc nose pykalman
install_dependency "ROS Dependencies" ros_tools[@]
sudo apt-get update
. ~/.bashrc
configld


