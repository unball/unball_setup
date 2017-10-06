#!/bin/bash

cd ~/catkin_ws_unball
rossource='source /opt/ros/kinetic/setup.bash; source ~/catkin_ws_unball/devel/setup.bash'
rosbridge='bash -c "rossubs; roslaunch rosbridge_server rosbridge_websocket.launch; bash"'
simulator='bash -c "./src/simulator/unball_simulator.x86_64; bash"'
start_strategy='bash -c "rossubs; rosrun strategy start_strategy.py; bash"'
measurement='bash -c "rossubs; rosrun measurement_system kalman.py; bash"'
relative_position_converter='bash -c "rossubs; rosrun strategy relative_position_converter.py; bash"' 
position_control='bash -c "rossubs; python2 ./src/control/position_control.py; bash"'

gnome-terminal \
    --tab -e "${rosbridge//rossubs/$rossource}" \
    --tab -e "${simulator}" \
    --tab -e "${start_strategy//rossubs/$rossource}"\
    --tab -e "${relative_position_converter//rossubs/$rossource}"\
    --tab -e "${position_control//rossubs/$rossource}" \
