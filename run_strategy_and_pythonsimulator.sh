#!/bin/bash

cd ~/catkin_ws_unball
rossource='source /opt/ros/kinetic/setup.bash; source ~/catkin_ws_unball/devel/setup.bash'
rosbridge='bash -c "rossubs; roslaunch rosbridge_server rosbridge_websocket.launch; bash"'
simulator='bash -c "rossubs; rosrun python_simulator main.py; bash"'
system='bash -c "rossubs; rosrun system main.py; bash"'


gnome-terminal \
    --tab -e "${rosbridge//rossubs/$rossource}" \
    --tab -e "${simulator//rossubs/$rossource}" \
    --tab -e "${system//rossubs/$rossource}" \
