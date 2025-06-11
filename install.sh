#!/usr/bin/env bash
#
PROJECT_DIR_NAME=pipeline-nextflow
pushd .
if [ ! -d "~/$PROJECT_DIR_NAME" ]; then
    cd
    
    sudo apt-get update && sudo apt-get install tree tldr -y

    # Add NXF_PLUGINS_DIR export to the top of ~/.bashrc if not already present
grep -qxF 'export NXF_PLUGINS_DIR="/home/coder/pipeline-nextflow/plugins/plugins"' /home/coder/.bashrc || sed -i '1i export NXF_PLUGINS_DIR="/home/coder/pipeline-nextflow/plugins/plugins"' /home/coder/.bashrc

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
popd
