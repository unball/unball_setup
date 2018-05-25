# sleep is used here to wait for the first instance of roscore to open

gnome-terminal \
    --tab -e 'bash -c "roscore; bash"' \
    --tab -e 'bash -c "sleep 2; roslaunch vision run_vision.launch; bash"' \
    --tab -e 'bash -c "sleep 2; rosrun vision pixel_to_metric_conversion; bash"' \
    --tab -e 'bash -c "sleep 2; rosrun rosbridge_server rosbridge_websocket; bash"' \
    --tab -e 'bash -c "sleep 2; ./src/simulator/unball_simulator.x86_64; bash"' \
    --tab -e 'bash -c "sleep 2; rosrun system main.py; bash"' \
    --tab -e 'bash -c "sleep 2; roslaunch communication run_communication.launch; bash"' \
