echo "Starting node"
cd ~/node-oauth
nohup node app.js &
sleep 1
open 'http:localhost:3000/login?node'
