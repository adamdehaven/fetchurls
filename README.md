# Fetch Urls
Bash script to spider a site, follow links, and fetch urls -- with some filtering. A list of URLs will be generated and saved to a text file.

[![GitHub release](https://img.shields.io/github/release/adamdehaven/fetchurls.svg?maxAge=3600)](https://github.com/adamdehaven/fetchurls/archive/master.zip)
[![GitHub commits](https://img.shields.io/github/commits-since/adamdehaven/fetchurls/v2.0.svg?maxAge=3600)](https://github.com/adamdehaven/fetchurls/compare/v2.0...master)
[![GitHub issues](https://img.shields.io/github/issues/adamdehaven/fetchurls.svg?maxAge=3600)](https://github.com/adamdehaven/fetchurls/issues)
[![license](https://img.shields.io/github/license/adamdehaven/fetchurls.svg?maxAge=3600)](https://raw.githubusercontent.com/adamdehaven/fetchurls/master/LICENSE)

## How To Use

1. Download the script and save to the desired location on your machine.
2. You'll need `wget` installed on your machine in order to continue. To check if it's already installed (if you're on Linux or a Mac, chances are you already have it) open Git Bash, Terminal, etc. and run the command: `$ wget`. If you receive an error message or command not found, you're probably on Windows. Here's the <b>Windows</b> installation instructions:
    1. Download the lastest wget binary for windows from [https://eternallybored.org/misc/wget/](https://eternallybored.org/misc/wget/) (they are available as a zip with documentation, or just an exe. I'd recommend just the exe.)
    2. If you downloaded the zip, extract all (if windows built in zip utility gives an error, use 7-zip). If you downloaded the 64-bit version, rename the `wget64.exe` file to `wget.exe`
    3. Move `wget.exe` to `C:\Windows\System32\`
3. Open Git Bash, Terminal, etc. and run the `fetchurls.sh` script:
    ```shell
    $ bash /path/to/script/fetchurls.sh
    ```
4. You will be prompted to enter the full URL (including HTTPS/HTTP protocol) of the site you would like to crawl:
    ```shell
    #
    #    Fetch a list of unique URLs for a domain.
    #
    #    Enter the full URL ( http://example.com )
    #    URL:
    ```
5. You will be prompted to enter the location (directory) of where you would like the generated results to be saved (defaults to Desktop on Windows):
    ```shell
    #
    #    Save file to location
    #    Directory: /c/Users/username/Desktop
    ```
6. You will then be prompted to change/accept the name of the outputted file (simply press enter to accept the default filename):
    ```shell
    #
    #    Save file as
    #    Filename (no extension): example-com
    ```
7. When complete, the script will show a message and the location of your outputted file:
    ```shell
    #
    #    Fetching URLs for example.com
    #
    #
    #    Finished with 1 result!
    #
    #    File Location:
    #    /c/Users/username/Desktop/example-com.txt
    #
    ```

The script will crawl the site and compile a list of valid URLs into a text file that will be placed on your Desktop.

## Extra Info

* To change the default file output location, edit line #7 (or simply use the interactive prompt). **Default**: `~/Desktop`

* Ensure that you enter the correct protocol and subdomain for the URL or the outputted file may be empty or incomplete, however the script will attempt to follow the first HTTP redirect, if found. For example, entering the incorrect HTTP, protocol for [https://adamdehaven.com](https://adamdehaven.com) will automatically fetch the URLs for the HTTPS version.

* The script will successfully run as long as the target URL returns status `HTTP 200 OK`

* The script, by default, filters out the following file extensions:
    * `.css`
    * `.js`
    * `.map`
    * `.xml`
    * `.png`
    * `.gif`
    * `.jpg`
    * `.JPG`
    * `.bmp`
    * `.txt`
    * `.pdf`

* The script filters out several common WordPress files and directories such as:
    * `/wp-content/uploads/`
    * `/feed/`
    * `/category/`
    * `/tag/`
    * `/page/`
    * `/widgets.php/`
    * `/wp-json/`
    * `xmlrpc`

* To change or edit the regular expressions that filter out some pages, directories, and file types, you may edit lines #54 through #63. **Caution**: If you're not familiar with grep and regular expressions, you can easily break the script.
