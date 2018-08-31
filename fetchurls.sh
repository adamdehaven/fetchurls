#!/bin/bash

# Ensure you have wget installed and added to environment variable PATH
# Example source: https://eternallybored.org/misc/wget/

# -----------  SET DEFAULT SAVE LOCATION  -----------
savelocation=~/Desktop

# -----------  SET COLORS  -----------
COLOR_RED=$'\e[31m'
COLOR_CYAN=$'\e[36m'
COLOR_YELLOW=$'\e[93m'
COLOR_GREEN=$'\e[32m'
COLOR_RESET=$'\e[0m'

displaySpinner()
{
  local pid=$!
  local delay=0.3
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
      local temp=${spinstr#?}
      printf "${COLOR_RESET}#    ${COLOR_YELLOW}Please wait... [%c]  " "$spinstr${COLOR_RESET}" # Count number of backspaces needed (A = 25)
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of backspaces from (A)
  done
  printf "                         \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of spaces, then backspaces from (A)
} # // displaySpinner()

fetchSiteUrls() {
  cd $savelocation && wget --spider -r -nd --max-redirect=30 $DOMAIN 2>&1 \
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
  > $savelocation/$1.txt
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

echo "${COLOR_RESET}#    "
read -e -p "#    Save txt file as: ${COLOR_CYAN}" -i "${filename}" SAVEFILENAME
savefilename=$SAVEFILENAME

echo "${COLOR_RESET}#    "
echo "#    ${COLOR_YELLOW}Fetching URLs for ${displaydomain} ${COLOR_RESET}"

# Start process
fetchSiteUrls $savefilename & displaySpinner

# Process is complete

# Count number of results
RESULT_COUNT="$(cat ${savelocation}/$savefilename.txt | sed '/^\s*$/d' | wc -l)"
if [ "$RESULT_COUNT" = 1 ]; then
  RESULT_MESSAGE="${RESULT_COUNT} Result"
else
  RESULT_MESSAGE="${RESULT_COUNT} Results"
fi

# Output message
echo "${COLOR_RESET}#    "
echo "#    ${COLOR_GREEN}Finished with ${RESULT_MESSAGE}!${COLOR_RESET}"
echo "#    "
echo "#    ${COLOR_GREEN}File Location:${COLOR_RESET}"
echo "#    ${COLOR_GREEN}${savelocation}/$savefilename.txt${COLOR_RESET}"
echo "#    "
