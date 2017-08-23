gnome-terminal \
    --tab -e 'bash -c "roslaunch rosbridge_server rosbridge_websocket.launch; bash"' \
    --tab -e 'bash -c "./src/simulator/unball_simulator.x86_64; bash"' \
    --tab -e 'bash -c "rosrun strategy go_to_ball.py; bash"' \
    --tab -e 'bash -c "rosrun strategy relative_position_converter.py; bash"' \
    --tab -e 'bash -c "python2 src/control/position_control.py; bash"' \
