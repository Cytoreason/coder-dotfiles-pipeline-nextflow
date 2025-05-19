#!/usr/bin/env bash
#
PROJECT_DIR_NAME=pipeline-nextflow
pushd .
if [ ! -d "~/$PROJECT_DIR_NAME" ]; then
    cd
    
    sudo apt-get update && sudo apt-get install tree tldr -y
    source ~/.bashrc
    echo "Installing Java"
    curl -s https://get.sdkman.io | bash 
    source "/home/coder/.sdkman/bin/sdkman-init.sh"
    sdk install java 17.0.10-tem
    source ~/.bashrc
    echo "Installing Nextflow"
    curl -s https://get.nextflow.io | bash
    chmod +x nextflow
    mkdir -p $HOME/.local/bin/
    mv nextflow $HOME/.local/bin/
    nextflow info

    git clone https://github.com/Cytoreason/$PROJECT_DIR_NAME.git
    cd $PROJECT_DIR_NAME
    git pull 


    source ~/.bashrc
    echo "Installing VS Code Server Python extensions..."
    /tmp/code-server/bin/code-server --install-extension nextflow.nextflow
    /tmp/code-server/bin/code-server --install-extension ms-python.debugpy
    echo "Python extensions for VS Code Server have been installed successfully!"

    VSCODE_DOT_DIR=.vscode
    mkdir -p "$VSCODE_DOT_DIR"

    VSCODE_SETTINGS_JSON="$VSCODE_DOT_DIR"/settings.json

    if [ ! -f "$VSCODE_SETTINGS_JSON" ]; then
        echo "Creating $VSCODE_SETTINGS_JSON ..."
        cat <<EOF > "$VSCODE_SETTINGS_JSON"
{
    "python.envFile": "\${workspaceFolder}/.env",
    "python.defaultInterpreterPath": "$(poetry env info --path)/bin/python",
    "python.terminal.activateEnvironment": true,
}

EOF
    fi
fi
export LAKECTL_CREDENTIALS_ACCESS_KEY_ID=`gcloud secrets versions access latest --secret=LAKEFS_ACCESS_KEY_ID`
export LAKECTL_CREDENTIALS_SECRET_ACCESS_KEY=`gcloud secrets versions access latest --secret=LAKEFS_SECRET_ACCESS_KEY`
export TOWER_ACCESS_TOKEN=`gcloud secrets versions access latest --secret=TOWER_ACCESS_TOKEN`
export client_id_secret_name="CLIENT_ID_M2M_PUBLIC_SCOPE"
export client_secret_secret_name="CLIENT_SECRET_M2M_PUBLIC"
export CLIENT_ID=`gcloud secrets versions access latest --secret=${client_id_secret_name}`
export CLIENT_SECRET=`gcloud secrets versions access latest --secret=${client_secret_secret_name}`
popd
