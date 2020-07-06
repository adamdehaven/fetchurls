# fetchurls

A bash script to spider a site, follow links, and fetch urls (with built-in filtering) into a generated text file.

## Usage

1. [Download the script](https://github.com/adamdehaven/fetchurls/archive/master.zip) and save to the desired location on your machine.
2. You'll need `wget` installed on your machine.

    To check if it is already installed, try running the command `wget` by itself.

    If you are on a Mac or running Linux, chances are you already have wget installed; however, if the `wget` command is not working, it may not be properly added to your PATH variable.

    If you are running Windows:

    1. Download the lastest `wget` binary for windows from [https://eternallybored.org/misc/wget/](https://eternallybored.org/misc/wget/)

        The download is available as a zip with documentation, or just an exe. I'd recommend just the exe.
    2. If you downloaded the zip, extract all (if windows built in zip utility gives an error, use 7-zip). In addition, if you downloaded the 64-bit version, rename the `wget64.exe` file to `wget.exe`
    3. Move `wget.exe` to `C:\Windows\System32\`

3. Open Git Bash, Terminal, etc. and set execute permissions for the `fetchurls.sh` script:

    ```shell
    chmod +x /path/to/script/fetchurls.sh
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

## Options

You may pass options (as flags) directly to the script, or pass nothing to run the script [in interactive mode](#interactive-mode).

### domain

- Usage: `-d`, `--domain`
- Example: `https://example.com`

The fully qualified domain URL (with protocol) you would like to crawl.

Ensure that you enter the correct protocol (e.g. `https`) and subdomain for the URL or the outputted file may be empty or incomplete. The script will automatically attempt to follow the first HTTP redirect, if found. For example, if you enter the incorrect protocol (`http://...`) for `https://adamdehaven.com`, the script will automatically follow the redirect and fetch all URLs for the correct HTTPS protocol.

The domain's URLs will be successfully spidered as long as the target URL (or the first redirect) returns a status of `HTTP 200 OK`.

### location

- Usage: `-l`, `--location`
- Default: `~/Desktop`
- Example: `/c/Users/username/Desktop`

The location (directory) where you would like to save the generated results.

If the directory does not exist at the specified location, as long as the rest of the path is valid, the new directory will automatically be created.

### filename

- Usage: `-f`, `--filename`
- Default: `domain-topleveldomain`
- Example: `example-com`

The desired name of the generated file, without spaces or file extension.

### non-interactive

- Usage: `-n`, `--non-interactive`

Allows the script to run successfully in a non-interactive shell.

The script will utilize the default [`--location`](#l-location) and [`--filename`](#f-filename) configurations unless the respective flags are explicitely set. This flag also disables the progress indicator.

### wget

- Usage: `-w`, `--wget`

Show wget install instructions. The installation instructions may vary depending on your computer's configuration.

### version

- Usage: `-v`, `-V`, `--version`

Show version information.

### troubleshooting

- Usage: `-t`, `--troubleshooting`

Outputs received option flags with their associated values at runtime for troubleshooting.

### help

- Usage: `-h`, `-?`, `--help`

Show the help content.

## Interactive Mode

If any of the required flags are not passed, a portion of the script will run interactively and you will be prompted for the unset options.

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

## Excluded Files and Directories

The script, by default, filters out many file extensions that are commonly not needed as a reference. In addition, common WordPress files and directories are also ignored.

### Excluded Files

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

### Excluded Directories

- `/wp-content/uploads/`
- `/feed/`
- `/category/`
- `/tag/`
- `/page/`
- `/widgets.php/`
- `/wp-json/`
- `xmlrpc`

## Advanced Usage

The script should filter out most unwanted file types and directories; however, you can edit the regular expressions that filter out certain pages, directories, and file types by editing the `fetchSiteUrls()` function within the `fetchurls.sh` file.

If you're not familiar with [grep](https://man7.org/linux/man-pages//man1/grep.1.html) or regular expressions, you can easily break the script.
