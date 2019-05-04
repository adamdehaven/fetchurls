#!/bin/bash

# Ensure you have wget installed and added to environment variable PATH
# Example source: https://eternallybored.org/misc/wget/

# -----------  SET DEFAULT SAVE LOCATION  -----------
DEFAULTSAVEFILEDIRECTORY=~/Desktop

# -----------  SET COLORS  -----------
COLOR_RED=$'\e[31m'
COLOR_CYAN=$'\e[36m'
COLOR_YELLOW=$'\e[33m'
COLOR_GREEN=$'\e[32m'
COLOR_RESET=$'\e[0m'

# Cleanup before exit
beforeExit()
{
    # Delete generated file if it exists and is empty
    if [ -f $SAVEFILEDIRECTORY/$SAVEFILENAME.txt ] && [ ! -s $SAVEFILEDIRECTORY/$SAVEFILENAME.txt ]; then
        printf "                         \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of backspaces from (A) to remove spinner
        echo "${COLOR_RESET}#    "
        echo "#    Cleaning up..."
        rm $SAVEFILEDIRECTORY/$SAVEFILENAME.txt
    else
        echo "${COLOR_RESET}"
    fi
    echo "#    "
    echo "#    Aborted"
    # Exit process
    exit 0
}
trap beforeExit INT

displaySpinner()
{
  local pid=$!
  local delay=0.3
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
      local temp=${spinstr#?}
      printf "${COLOR_RESET}#    ${COLOR_GREEN}Please wait... [%c]  " "$spinstr${COLOR_RESET}" # Count number of backspaces needed (A = 25)
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of backspaces from (A)
  done
  printf "                         \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of spaces, then backspaces from (A)
} # // displaySpinner()

fetchSiteUrls() {
  cd $SAVEFILEDIRECTORY && wget --spider -r -nd --max-redirect=30 $DOMAIN 2>&1 \
  | grep '^--' \
  | awk '{ print $3 }' \
  | grep -E -v '\.(css|js|map|xml|png|gif|jpg|JPG|bmp|txt|pdf)(\?.*)?$' \
  | grep -E -v '\?(p|replytocom)=' \
  | grep -E -v '\/wp-content\/uploads\/' \
  | grep -E -v '\/feed\/' \
  | grep -E -v '\/category\/' \
  | grep -E -v '\/tag\/' \
  | grep -E -v '\/page\/' \
  | grep -E -v '\/widgets.php$' \
  | grep -E -v '\/wp-json\/' \
  | grep -E -v '\/xmlrpc' \
  | sort -u \
  > $SAVEFILEDIRECTORY/$1.txt
} # // fetchSiteUrls()

# Prompt user for domain
echo "#    "
echo "#    Fetch a list of unique URLs for a domain."
echo "#    "
echo "#    Enter the full URL ( http://example.com )"
read -e -p "#    URL: ${COLOR_CYAN}" DOMAIN
DOMAIN="${DOMAIN%/}"
displaydomain=$(echo ${DOMAIN} | grep -oP "^http(s)?://(www\.)?\K.*")
filename=$(echo ${DOMAIN} | grep -oP "^http(s)?://(www\.)?\K.*" | tr "." "-")

# Check if URL is valid and returns 200 status
URLSTATUS=$(wget --spider -q --server-response $DOMAIN 2>&1 | grep --max-count=1 "HTTP/" | awk '{print $2}')
# If response is 301, follow redirect
if [ "$URLSTATUS" = "301" ]; then
    # Get redirect URL
    FORWARDEDLOCATION=$(wget --spider -q --server-response $DOMAIN 2>&1 | grep --max-count=1 "Location" | awk '{print $2}')
    echo "${COLOR_RESET}#    "
    echo "#    ${COLOR_YELLOW}Note:${COLOR_RESET}"
    echo "#    ${COLOR_YELLOW}${DOMAIN} is permanently forwarded to ${FORWARDEDLOCATION}${COLOR_RESET}"
    DOMAIN=$FORWARDEDLOCATION
    echo "#    "
    echo "#    Script will fetch ${COLOR_CYAN}${DOMAIN}${COLOR_RESET} instead"
    echo "#    "
elif [ "$URLSTATUS" != "200" ] || [ -z "$URLSTATUS" ]; then
    echo "${COLOR_RESET}#    "
    echo "#    ${COLOR_RED}'${DOMAIN}' is unresponsive or is not a valid URL.${COLOR_RESET}"
    echo "#    ${COLOR_RED}Ensure the site is up by checking in your browser, then try again.${COLOR_RESET}"
    echo "#    "
    # Kill process
    kill $$
fi

# Prompt user for save directory
echo "${COLOR_RESET}#    "
echo "#    Save file to location"
read -e -p "#    Directory: ${COLOR_CYAN}" -i "${DEFAULTSAVEFILEDIRECTORY}" SAVEFILEDIRECTORY
# Create directory if it does not exist
mkdir -p $SAVEFILEDIRECTORY

# Promt user for filename
echo "${COLOR_RESET}#    "
echo "#    Save file as"
read -e -p "#    Filename (no extension): ${COLOR_CYAN}" -i "${filename}" SAVEFILENAME
savefilename=$SAVEFILENAME

echo "${COLOR_RESET}#    "
echo "#    Fetching URLs for ${displaydomain}"
echo "#    "

# Start process
fetchSiteUrls $savefilename & displaySpinner

# Process is complete

# Count number of results if file exists
if [ -f $SAVEFILEDIRECTORY/$SAVEFILENAME.txt ]; then
    RESULT_COUNT="$(cat ${SAVEFILEDIRECTORY}/$savefilename.txt | sed '/^\s*$/d' | wc -l)"
    if [ "$RESULT_COUNT" = 1 ]; then
        RESULT_MESSAGE="${RESULT_COUNT} result"
    else
        RESULT_MESSAGE="${RESULT_COUNT} results"
    fi

    # Output message
    echo "${COLOR_RESET}#    "
    echo "#    ${COLOR_GREEN}Finished with ${RESULT_MESSAGE}!${COLOR_RESET}"
    echo "#    "
    echo "#    ${COLOR_RESET}File Location:${COLOR_RESET}"
    echo "#    ${COLOR_GREEN}${SAVEFILEDIRECTORY}/$savefilename.txt${COLOR_RESET}"
    echo "#    "
fi
