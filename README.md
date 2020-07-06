# fetchurls

A bash script to spider a site, follow links, and fetch urls (with built-in filtering) into a generated text file.

## Usage

1. Download the script and save to the desired location on your machine.
2. You'll need `wget` installed on your machine.

    To check if it is already installed, try running the command `wget` by itself.

    If you are on a Mac or running Linux, chances are you already have wget installed; however, if the `wget` command is not working, it may not be properly added to your PATH variable.

    If you are running Windows:

    1. Download the lastest `wget` binary for windows from [https://eternallybored.org/misc/wget/](https://eternallybored.org/misc/wget/) The download is available as a zip with documentation, or just an exe. I'd recommend just the exe.
    2. If you downloaded the zip, extract all (if windows built in zip utility gives an error, use 7-zip). In addition, if you downloaded the 64-bit version, rename the `wget64.exe` file to `wget.exe`
    3. Move `wget.exe` to `C:\Windows\System32\`

3. Open Git Bash, Terminal, etc. and set execute permissions for the `fetchurls.sh` script:

    ```shell
    chmod +x ./fetchurls.sh
    ```

4. Enter the following to run the script:

    ```shell
    ./fetchurls.sh [OPTIONS]...
    ```

    If you do not pass any options, the script will run interactively.

Alternatively, you may execute with either of the following:

```shell
sh ./fetchurls.sh [OPTIONS]...

# -- OR -- #

bash ./fetchurls.sh [OPTIONS]...
```

## Interactive

If running the script interactively, you will be prompted for the same options that are available via the [flag options](#options).

First, you will be prompted to enter the full URL (including HTTPS/HTTP protocol) of the site you would like to crawl:

```shell
#
#    Fetch a list of unique URLs for a domain.
#
#    Enter the full domain URL ( http://example.com )
#    Domain URL:
```

You will then be prompted to enter the location (directory) of where you would like the generated results to be saved (defaults to Desktop on Windows):

```shell
#
#    Save file to directory
#    Directory: /c/Users/username/Desktop
```

Next, you will be prompted to change/accept the name of the outputted file (simply press enter to accept the default filename):

```shell
#
#    Save file as
#    Filename (no file extension, and no spaces): example-com
```

When complete, the script will show a message and the location of your outputted file:

```shell
#
#    Fetching URLs for example.com
#
#    Finished with 1 result!
#
#    File Location:
#    /c/Users/username/Desktop/example-com.txt
#
```

The script will crawl the site and compile a list of valid URLs into a text file that will be placed on your Desktop.

## Options

TODO.

## Extra Info

- To change the default file output location, edit line #7 (or simply use the interactive prompt). **Default**: `~/Desktop`

- Ensure that you enter the correct protocol and subdomain for the URL or the outputted file may be empty or incomplete, however the script will attempt to follow the first HTTP redirect, if found. For example, entering the incorrect HTTP, protocol for [https://adamdehaven.com](https://adamdehaven.com) will automatically fetch the URLs for the HTTPS version.

- The script will successfully run as long as the target URL returns status `HTTP 200 OK`

- The script, by default, filters out the following file extensions:
  - `.bmp`
  - `.css`
  - `.doc`
  - `.docx`
  - `.gif`
  - `.jpeg`
  - `.jpg`
  - `.JPG`
  - `.js`
  - `.map`
  - `.pdf`
  - `.PDF`
  - `.png`
  - `.ppt`
  - `.pptx`
  - `.svg`
  - `.ts`
  - `.txt`
  - `.xls`
  - `.xlsx`
  - `.xml`

- The script filters out several common WordPress files and directories such as:
  - `/wp-content/uploads/`
  - `/feed/`
  - `/category/`
  - `/tag/`
  - `/page/`
  - `/widgets.php/`
  - `/wp-json/`
  - `xmlrpc`

- To change or edit the regular expressions that filter out some pages, directories, and file types, you may edit lines #54 through #63. **Caution**: If you're not familiar with grep and regular expressions, you can easily break the script.
