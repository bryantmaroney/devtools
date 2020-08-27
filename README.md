# Dev Tools for Texas2020.org Project

## Prequisites
These instructions assume you already have the following tools installed and configured:
- bash
- git
- Docker
- mysql CLI client
- mysqldump
- rsync

If you don't have all that stuff, you need to get it before you proceed.

You also need to have:
- your IP whitelisted for database access
- your ssh key added to the server
- database credentials
- GitHub project access

Talk to the dev team lead to get this stuff arranged if you don't already have it.

## Dev Setup Instructions
1. Checkout this dev tools repo: `git clone WHATEVER {YOUR PROJECT ROOT DIR}`
2. Open project directory: `cd {YOUR PROJECT ROOT DIR}`
3. Checkout the application code: `git clone git@github.com:texas2020org/texas2020.git ./app`
4. Move into docker dir: `cd docker`
5. Spin up Docker dev environment: `docker-compose up -d`
6. Back to project root: `cd ..`
7. Add site config files.  We need to document this process better.  For now, just ask.
8. Add script config files: `cp scripts/env/dist/* scripts/env/`
9. Edit config files and add correct server credentials.  AGain, if you don't have these already, just ask.
10. Grab db snapshot: `bash scripts/dbsnapshot.sh`
11. Grab latest image uploads: `bash scripts/syncuploads.sh`
12. Edit your hosts file, and add the following line: `127.0.0.1	texas2020.test`
13. Open a browser to: <http://texas2020.test/>

NOTE: If you need to access the local MySQL server, you will find the username and password in `docker/docker-compose.yml`.  The container forwards port 8885 from to MySQL, so you would connect to localhost:8885 to access the server.


