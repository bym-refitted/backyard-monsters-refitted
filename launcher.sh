SWF_CHANNEL="bymr-stable"
SWF_FILE="bymr-stable.swf"

FLASHPLAYER_URL='https://archive.org/download/flashplayer32_0r0_363_win_sa/flashplayer32_0r0_363_linux_sa.x86_64.tar.gz'
REQUEST_URL="https://api.github.com/repos/bym-refitted/backyard-monsters-refitted/releases/latest"
DOWNLOAD_URL="https://github.com/bym-refitted/backyard-monsters-refitted/releases/download/"

# Downloads Flash Player if its missing
if [ ! -f "flashplayer" ] ; then
    echo "Flash Player not found! Downloading Flash Player..."
    
    wget -O /tmp/flashplayer.tar.gz $FLASHPLAYER_URL
    tar -xzf /tmp/flashplayer.tar.gz
fi

# Creates version file
if [ ! -f "version" ]; then echo '0.0.0' > version
fi

# Fetches the latest SWF info
# Caches the request in /tmp to prevent GitHub from getting mad
echo "Checking for updates..."

if [ ! -f "/tmp/bym_request_cache" ] ; then
    curl --silent $REQUEST_URL > "/tmp/bym_request_cache"
fi

# Retrieves the download url from the request cache
# Also removes double quotes using parameter expansion
DOWNLOAD_URL=$(grep "browser_download_url.*" "/tmp/bym_request_cache" | grep bymr-stable)
DOWNLOAD_URL=${DOWNLOAD_URL:3}
DOWNLOAD_URL=${DOWNLOAD_URL//\"/}

# Retrieves the Latest Version from the Url and compares it to the local version file
# If the latest version is higher than the local one download it
LATEST_VERSION=$(grep -oP '"tag_name":\s*"v\K[^"]+' "/tmp/bym_request_cache")
LATEST_VERSION=${LATEST_VERSION:0:5}

CURRENT_VERSION=$(cat version)

if [[ $LATEST_VERSION > $CURRENT_VERSION ]]; then
    echo "New SWF version found! Downloading..."
    wget -O $SWF_FILE $DOWNLOAD_URL
    echo $LATEST_VERSION > version

else
    echo "Game is up to date!"
fi

echo "Launching Game..."
chmod +x flashplayer
./flashplayer $SWF_FILE