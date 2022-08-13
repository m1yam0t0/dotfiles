#!/usr/bin/env zsh

# Create Font Directory
font_dir="${HOME}/Library/Fonts"
mkdir -p ${font_dir}

# Download Font
base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
for style in Regular Bold Italic 'Bold Italic'; do
    file="MesloLGS NF ${style}.ttf"

    echo "${file} Downloading..."
    curl -fsSL -o ${font_dir}/${file}.tmp "${base_url}/${file// /%20}"
    mv -f -- ${font_dir}/${file}{.tmp,}
done

