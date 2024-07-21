# rFactor 2 Dedicated Server Manager

## Disclaimer

As there are PowerShell scripts available only, handling with care is advised.

## General information

### Script status

|Scriptname|Status|Comment|TODO / Nice2have|
|---|:---:|---|---|
|rf2srv_csv_files|files|||
|rf2srv_csv_generator|working|||
|rf2srv_download_ui|working|CSV file input||
|rf2srv_install|working|||
|rf2srv_installed_content_updater||||
|rf2srv_mod_auto_updater||||
|rf2srv_mod_builder||||
|rf2srv_mod_files|files|||
|rf2srv_mod_rebuilder||||
|rf2srv_rfcmp_extractor|working|||

## Requirements

**ATTENTION:** 
+ it is currently a *must* that git repo files are installed to $HOME/rf2srvmgr :-/ 
+ \program files (x86)\ is currently not supported as an rFactor 2 installation path

+ open ports for dedicated server in Windows Firewall `
UDP+TCP 54297
TCP 64297
UDP 64298
UDP 64299
`
+ get data as CSV export with SteamId from support.fidgrove.com (site has been shut down)
+ otherwise stated by Studio 397 you still need to put a valid `serverunlock.bin` file in rFactor 2 Dedicated Server userdata folder to run dedicated server with paid content - the file will be created by rFactor 2 Client / Game while starting. Have a look at:
  + https://forum.studio-397.com/index.php?threads/dedicated-server-creates-no-serverkeys-bin.73781/
  + https://forum.studio-397.com/index.php?threads/how-to-hosting-with-steamcmd-and-paid-content.57209/

## Installation

### rFactor 2 Dedicated Server

1. get repository files

- Get the latest release from https://github.com/GITStone-tech/rf2srvmgr/archive/refs/tags/ and extract it to your user folder ($HOME) - rename the folder to **rf2srvmgr** (this is currently a *must*).

2. adjust variables.ps1 (or take it as it is)

3. open powershell and run installscript

```shell
cd $HOME\rf2srvmgr
rf2srv_install\rf2srv_install_dedicated_server.ps1
```

4. install runtime libraries (admin rights / password needed)

5. install dummy track and car with modmgr.exe (pops up)

6. wait until dedicated server is started for the first time with dummy mod and shut it down after starting

## Modules

### rf2srv_download_ui (download content)

Description: this will download content from Steam to $STEAMINSTALLDIR\common\workshop\365960

Open PowerShell and execute 

```shell
cd $HOME\rf2srvmgr
rf2srv_download_ui\rf2srv_download_ui.ps1
```

### rf2srv_rfcmp_extractor (install content)

Description: this will install *all* content found in $STEAMINSTALLDIR\common\workshop\365960

Open PowerShell and execute 

```shell
cd $HOME\rf2srvmgr
rf2srv_rfcmp_extractor\rf2srv_rfcmp_extractor.ps1
```

## Issues / TODO

### rf2srvmgr_download_ui

+ handle more than cars and tracks
+ CSV file input needed
+ how to handle double SteamIDs (multiple SteamIDs for one track e.g.)
