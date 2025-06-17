#! /bin/zsh

# Get current user
CURRENT_USER=$(whoami)
BIN_DIR="$HOME/bin"
ICONS_DIR="$HOME/.local/share/icons"
APPS_DIR="$HOME/.local/share/applications"

# Create necessary directories
mkdir -p "$APPS_DIR"
mkdir -p "$ICONS_DIR"
mkdir -p "$BIN_DIR"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install an application
install_app() {
    local app_name=$1
    local install_cmd=$2

    if ! command_exists "$app_name"; then
        echo "Attempting to install $app_name..."
        if ! eval "$install_cmd"; then
            echo "Warning: Failed to install $app_name, but continuing..."
        fi
    else
        echo "$app_name is already installed"
    fi
}

# Function to copy icon
copy_icon() {
    local app_name=$1
    local icon_dir="$(dirname "$0")/icons/${app_name}"
    local target_dir="$ICONS_DIR/${app_name}"

    if [ -d "$icon_dir" ]; then
        mkdir -p "$target_dir"
        cp -r "$icon_dir"/* "$target_dir/" 2>/dev/null || echo "Warning: Failed to copy icons for $app_name"
    else
        echo "Warning: No icons found for $app_name"
    fi
}

# Function to create desktop file
create_desktop_file() {
    local name=$1
    local comment=$2
    local exec_path=$3
    local icon_path=$4
    local categories=$5

    cat > "$APPS_DIR/${name}.desktop" << EOF
[Desktop Entry]
Name=${name}
Comment=${comment}
Exec=${exec_path}
Icon=${icon_path}
Terminal=false
Type=Application
Categories=${categories}
EOF
}

# Install applications if they don't exist
install_app "meshsense" "curl -L https://github.com/meshsense/meshsense/releases/latest/download/meshsense -o $BIN_DIR/meshsense && chmod +x $BIN_DIR/meshsense"
install_app "lmstudio" "curl -L https://github.com/lmstudio/lmstudio/releases/latest/download/lmstudio -o $BIN_DIR/lmstudio && chmod +x $BIN_DIR/lmstudio"
install_app "hyper" "curl -L https://github.com/vercel/hyper/releases/latest/download/hyper -o $BIN_DIR/hyper && chmod +x $BIN_DIR/hyper"
install_app "cursor" "curl -L https://github.com/getcursor/cursor/releases/latest/download/cursor -o $BIN_DIR/cursor && chmod +x $BIN_DIR/cursor"
install_app "tutanota" "curl -L https://github.com/tutao/tutanota/releases/latest/download/tutanota -o $BIN_DIR/tutanota && chmod +x $BIN_DIR/tutanota"

# Copy icons for each application
copy_icon "meshsense"
copy_icon "lmstudio"
copy_icon "hyper"
copy_icon "cursor"
copy_icon "tutanota"

# Create desktop files for each application
create_desktop_file "Meshsense" "LoRa nerdery" "$BIN_DIR/meshsense" "$ICONS_DIR/meshsense/meshsense.ico" "Radio"

create_desktop_file "LMStudio" "Run LLMs locally" "$BIN_DIR/lmstudio" "$ICONS_DIR/lmstudio/lmstudio.ico" "Development"

create_desktop_file "Hyper" "Element based terminal" "$BIN_DIR/hyper" "$ICONS_DIR/hyper/hyper.ico" "Development"

create_desktop_file "Cursor" "Forked version of VSCode with AI-assistance" "$BIN_DIR/cursor" "$ICONS_DIR/cursor/cursor.ico" "Development"

create_desktop_file "Tutanota" "Secure email client" "$BIN_DIR/tutanota" "$ICONS_DIR/tutanota/tutanota.ico" "Network;Email"

echo "Desktop files have been created in $APPS_DIR"

# Update desktop database
echo "Updating desktop database..."
sudo update-desktop-database "$APPS_DIR"



