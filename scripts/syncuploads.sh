#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Prod SSH credentials
source $DIR/env/prod-ssh.sh

# Select target for rsync over SSH
case "$1" in
    "dev")
        echo "Remote shared dev environment selected as target"
        echo "First we will sync to your local environment, then to the dev server"
        target="dev"
        source $DIR/env/dev-ssh.sh
        ;;
    "")
        echo "Local environment selected as target"
        target="local"
        ;;
    "*")
        echo "Invalid input"
        exit 1
        ;;
esac

# Check for rsync
if ! [ -x "$(command -v rsync)" ]; then
    echo 'Error: rsync is not installed.' >&2
    exit 1
fi

# Pull uploads from production server
echo "Pulling assets from production server..."
rsync --rsh="ssh -p $src_port" -avz $src_user@$src_host:$src_path/assets/images/voteShare/ $DIR/../app/assets/images/voteShare/
rsync --rsh="ssh -p $src_port" -avz $src_user@$src_host:$src_path/candidatesurvey/assets/uploads/ $DIR/../app/candidatesurvey/assets/uploads/
rsync --rsh="ssh -p $src_port" -avz $src_user@$src_host:$src_path/candidatesearch/assets/images/userchoices/ $DIR/../app/candidatesearch/assets/images/userchoices/
rsync --rsh="ssh -p $src_port" -avz $src_user@$src_host:$src_path/tvgadmin/assets/uploads/ $DIR/../app/tvgadmin/assets/uploads/

# Push to dev server, if specified
if [ "$target" == "dev" ]; then
    echo "Pushing assets to dev server..."
    rsync --rsh="ssh -p $dest_port" -avz $DIR/../app/assets/images/voteShare/ $dest_user@$dest_host:$dest_path/assets/images/voteShare/
    rsync --rsh="ssh -p $dest_port" -avz $DIR/../app/candidatesurvey/assets/uploads/ $dest_user@$dest_host:$dest_path/candidatesurvey/assets/uploads/
    rsync --rsh="ssh -p $dest_port" -avz $DIR/../app/candidatesearch/assets/images/userchoices/ $dest_user@$dest_host:$dest_path/candidatesearch/assets/images/userchoices/
    rsync --rsh="ssh -p $dest_port" -avz $DIR/../app/tvgadmin/assets/uploads/ $dest_user@$dest_host:$dest_path/tvgadmin/assets/uploads/
fi

echo "DONE!! Probably..."
