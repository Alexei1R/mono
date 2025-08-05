
#!/bin/bash

BASE_DIR="/home/toor/mono"

[[ "$BASE_DIR" != */ ]] && BASE_DIR="${BASE_DIR}/"

command -v tree -I node_modules >/dev/null 2>&1 || exit 1
command -v wl-copy >/dev/null 2>&1 || exit 1

temp_file=$(mktemp) || exit 1
trap 'rm -f "$temp_file"' EXIT

{
    echo "Directory Structure of ${BASE_DIR} as of $(date '+%Y-%m-%d %H:%M:%S')"
    echo "==================================="
    # Added -I web to exclude the web folder from tree output
    [ -d "$BASE_DIR" ] && tree -L 5 -I "node_modules|web" "$BASE_DIR" || echo "Directory not found: $BASE_DIR"
} > "$temp_file"

files=(



"/home/toor/mono/README.md"
"/home/toor/mono/configs/.zshrc"
"/home/toor/mono/configs/dunst/dunstrc"
"/home/toor/mono/configs/hypr/hyprlock.conf"
"/home/toor/mono/configs/hypr/hyprpaper.conf"
"/home/toor/mono/configs/hypr/img/life.jpg"
"/home/toor/mono/configs/hypr/keybind.conf"
"/home/toor/mono/configs/hypr/window.conf"
"/home/toor/mono/configs/hypr/hyprland.conf"
"/home/toor/mono/configs/waybar/config.jsonc"
"/home/toor/mono/configs/waybar/scripts/battery.sh"
"/home/toor/mono/configs/waybar/style.css"
"/home/toor/mono/configs/wlogout/layout"
"/home/toor/mono/configs/wlogout/style.css"
"/home/toor/mono/configs/wofi/colors.css"
"/home/toor/mono/configs/wofi/config/config"
"/home/toor/mono/configs/eww/eww.yuck"
"/home/toor/mono/configs/eww/err.scss"
"/home/toor/mono/install.sh"
"/home/toor/mono/pkg.list"
"/home/toor/mono/postinstall.sh"
"/home/toor/mono/scripts/brightnesscontrol.sh"
"/home/toor/mono/scripts/clipboard.sh"
"/home/toor/mono/scripts/pipfolow.sh"
"/home/toor/mono/scripts/scaffold.sh"
"/home/toor/mono/scripts/screenshot.sh"
"/home/toor/mono/scripts/volumecontrol.sh"
"/home/toor/mono/scripts/waybar.sh"
"/home/toor/mono/scripts/wofi.sh"
"/home/toor/mono/setup.sh"




    )




output_list=()

for path_spec in "${files[@]}"; do
    # Skip files in the web folder
    if [[ "$path_spec" == *"/web/"* ]]; then
        continue
    fi

    file_path_part="$path_spec"
    limit_spec=""

    [[ $path_spec == *\** ]] && {
        file_path_part=$(echo "$path_spec" | sed -E 's/\*([0-9]*)?$//')
        limit_spec="$path_spec"
    }

    [[ "$file_path_part" == /* ]] && full_path="$file_path_part" || full_path="${BASE_DIR}${file_path_part}"

    if [ ! -f "$full_path" ]; then
        output_list+=("❌ $full_path")
        continue
    fi

    output_list+=("✅ $full_path")

    echo "FILE: $full_path" >> "$temp_file"
    
    if [[ -n "$limit_spec" ]]; then
        if [[ $limit_spec =~ \*([0-9]+)$ ]]; then
            head -n "${BASH_REMATCH[1]}" "$full_path" | grep -v '^\s*$' >> "$temp_file"
        elif [[ $limit_spec == *\* ]]; then
            grep -E '^\s*(pub\s+)?(async\s+)?fn\s+[a-zA-Z0-9_]+\s*\(' "$full_path" | grep -v '^\s*$' >> "$temp_file"
        fi
    else
        # Filter out empty lines with grep
        grep -v '^\s*$' "$full_path" >> "$temp_file"
    fi
    
    # Add a single separator line instead of double newlines
    echo "---" >> "$temp_file"
done

wl-copy < "$temp_file"

# Print the list of processed files without newlines between them
for entry in "${output_list[@]}"; do
    printf "%s " "$entry"
done
echo


