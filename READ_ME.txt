# READ_ME.txt

Please note, this playbook is designed to configure OpenSim on a Ubuntu 20.04 LTS server.

Ansible 2.9.2 was used on the controller.

Currently, you will need to restart the Robust service manually via monit before Diva Wifi can be installed. You can connect to monit by using your web browser to goto your server ip address at port 2812 (i.e. http://server_ip_address:2812). This may take a minute or two, so please be patient. Select the Robust URL at the left of the monit web page, then use the Stop Service and Start Service buttons at the bottom of the page to stop and start Robust. Complete the Diva Wifi install by using your web browser to goto your server ip address at port 8002 (i.e. http://server_ip_address:8002/wifi). Select the Install Wifi button and input a password for the Wifi Admin account. Then create an avatar account, using the Create Account button.

Passwords for access to services such as monit, phpmyadmin and icecast2 are in the root directory.

There are some helper scripts in the /home/opensim/grid directory. Please ensure you dont run these as root, use "su - opensim" to become the opensim user, and run them from within /home/opensim/grid directory.

The create_simulator.sh file will allow you to create a simulator and add it into monit, it prompts for the directory name to store the opensim config files in, the name of the simulator, the sim size, the X and Y co-ords of the simulator and the http_listener port. You will need to use "su - opensim" to become the opensim user and then "screen -ls" to see the running screen sessions. Use "screen -r SIM_SCREEN_NAME" to attach to the running screen session, to create the estate group and add an owner to the sim. To detach from a running screen session type CTRL +A then hit the D key.

The firewall has UDP and TCP ports 9000 to 9100, TCP 8002, TCP 80, TCP 2812, TCP 22 open to allow opensim logins, web, monit and SSH access.

Should you wish to install opensim unstable you'll need to adjust the playbook.yml accordingly, as well as amending the configure_GridCommon_ini.yml play, as the db connection string regex will need changing, see GridCommon.ini.example inside opensim/bin/config-include for the correct format, once opensim unstable is installed.

Aside from the above, the code in the playbook and plays *IS* the documentation, use at your own risk! :)



