#!/bin/bash

displaySpinner()
{
  local pid=$!
  local delay=0.3
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
      local temp=${spinstr#?}
      printf "#    Please wait... [%c]  " "$spinstr" # Count number of backspaces needed (A = 25)
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of backspaces from (A)
  done
  printf "                         \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Number of spaces, then backspaces from (A)
} # // displaySpinner()

savelocation=~/Desktop

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
read -e -p "#    URL: " DOMAIN
DOMAIN=$DOMAIN
displaydomain=$(echo ${DOMAIN} | grep -oP "^http(s)?://(www\.)?\K.*")
filename=$(echo ${DOMAIN} | grep -oP "^http(s)?://(www\.)?\K.*" | tr "." "-")
echo "#    "
echo "#    Fetching URLs for ${displaydomain} "

# Start process
fetchSiteUrls $filename & displaySpinner

# Process is complete, output message
echo "#    Finished!"
echo "#    "
echo "#    File Location: ${savelocation}/$filename.txt"
echo "#    "