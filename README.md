# QuickIP
Quickly get your machine's public and private IP addresses.

## Install

1. Verify `curl` and `jq` are installed.
  * Ubuntu

    ```
    sudo apt install curl jq
    ```

2. Download `quickip.sh` and place it somewhere you can leave it indefinitely *(ex ~/.local/bin/quickip.sh)*.
3. Add the following line to your `.bashrc`(found at `~/.bashrc`). Make sure to modify the path to where you put the script.

    ```
    source ~/.local/bin/quicksh.ip
    ```

4. Resource your `.bashrc` by either quitting and reopening your terminal or with the command `source ~/.bashrc`.
5. The script should now be ready to use.

## Usage

QuickIP has 3 functions, each with their own name:

`pubip` to get your public IP

`locip` to get all local interfaces that have an IP assigned

`allip` to get both public and private IPs.

```sh
Usage: pubip [ OPTION ]
  -m    Minimal - Don\'t show IP address location.
  -M    Extra Minimal - Only show IP address.
```

```sh
Usage: locip [ OPTION ]
  -d    Down - Only show interfaces that are currently down.
  -m    Minimal - Only show interface name and address.
  -M    Extra Minimal - Only show interface address(es).
  -u    Up - Only show interfaces that are up.
```

```sh
Usage: allip [ OPTION ]
  -m    Minimal - Equivalent to `pubip -m && locip -m`.
  -M    Extra Minimal - Equivalent to `pubip -M && locip -M`.
```

## Examples

```sh
[user@computer: ~ ] pubip
Public IP Address:
	45.152.182.131	(United States)
```
```sh
[user@computer: ~ ] locip
Local IP Address(es):
	lo     	 127.0.0.1    	 UNKNOWN
	eth0   	 192.168.1.12  	 UP     
	wlan0  	 192.168.1.248	 DOWN   
	vpn0	 10.8.8.17    	 UNKNOWN
```
```sh
[user@computer: ~ ] allip
Public IP Address:
	45.152.182.131	(United States)

Local IP Address(es):
	lo     	 127.0.0.1    	 UNKNOWN
	eth0   	 192.168.1.12  	 UP     
	wlan0  	 192.168.1.248	 DOWN   
	vpn0	 10.8.8.17    	 UNKNOWN
```

## Issues

Please report any issues you encounter and include your operating system in the issue description.
