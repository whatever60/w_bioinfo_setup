get_binary_from_github() {
    local group_name=$1
    local project_name=$2
    local path=$3
    # folder_name is an optional keyword argument --folder_name
    local folder_name=$4
    echo $try
    
    release_url="https://github.com/${group_name}/${project_name}/releases/download/${path}"
    filename=$(basename "$path")

    # check if release_url ends with .tar.gz or .zip
    # Download the release archive and extract it
    if [[ $filename == *.zip ]]; then
        # if folder_name is not provided, use the filename without extension
        if [[ -z $folder_name ]]; then
            folder_name=$(basename "$filename" .zip)
        fi
        wget $release_url
        unzip -q $filename
        rm $filename
    elif [[ $filename == *.tar.gz ]]; then
        if [[ -z $folder_name ]]; then
            folder_name=$(basename "$filename" .tar.gz)
        fi
        wget -qO- $release_url | tar xz
    elif [[ $filename == *.tar.bz2 ]]; then
        folder_name=$(basename "$filename" .tar.bz2)
        wget -qO- $release_url | tar xj
    else
        echo "Unknown file extension"
        exit 1
    fi

    # Rename the extracted directory to the project name
    mv $folder_name $project_name

    # Add the project's executable directory to the PATH environment variable
    export PATH="$PATH:$PWD/$project_name"
}

# use `wget -qO-` or `curl -L`
get_binary_from_github "gmarcais" "Jellyfish" "v2.3.0/jellyfish-2.3.0.tar.gz"
