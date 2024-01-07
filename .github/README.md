# Scriba

Script that automates the installation of a few common tools that are used on an attacker host.

# Compatibility

Known compatible systems:
- Kali Linux 2023.4
- Ubuntu 22.04.3 LTS (jammy)

# Install

Clone the repository:

```sh
git clone https://github.com/pwnlog/Scriba $HOME/Scriba
```

Navigate to the directory:

```sh
cd Scriba
```

Ensure the installer has execution permissions:

```sh
chmod +x install.sh && chmod +x pyenv.sh
```

If the host doesn't have pyenv then it can be installed with the following script:

```sh
./pyenv.sh
```

Run the installer:

```sh
./install.sh
```

> [!NOTE]
> The script must be executed from the `Scriba` directory.

> [!IMPORTANT]
> The user running the script must be a member of the `sudo/wheel` group.

> [!CAUTION]
> Is not recommended to run this script as the `root` user.

# After Install

After the installation is complete, it's recommended to edit the following files (optional):

```sh
.zshrc
.zsh_profile
```

# Tools 

This section contains a list of the tools that are installed by the script.

## Cloud

Azure:

[ROADtools](https://github.com/dirkjanm/ROADtools)

```sh
roadrecon
```

```sh
roadrecon-gui
```

AWS:

[s3scanner](https://github.com/sa7mon/S3Scanner)

```sh
s3scanner
```

[pacu](https://github.com/RhinoSecurityLabs/pacu)

```sh
pacu -h
```

Git CI/CD:

[gitoops](https://github.com/ovotech/gitoops)

```sh
gitoops
```

Multiple Clouds:

[scoutsuite](https://github.com/nccgroup/ScoutSuite)

```sh
scout -h
```

## Network

Network Scanners:

[nmap](https://nmap.org/)

```sh
nmap
```

[masscan](https://github.com/robertdavidgraham/masscan)

```sh
masscan
```

[naabu](https://github.com/projectdiscovery/naabu)

```sh
naabu
```

Network Monitoring:

[wireshark](https://github.com/wireshark/wireshark)

```sh
wireshark
```

Vulnerability Scanners:

[nuclei](https://github.com/projectdiscovery/nuclei)

```sh
nuclei
```

SWISS Army Knife:

[netexec](https://github.com/Pennyw0rth/NetExec)

```sh
sudo netexec
```

MiTM:

[responder](https://github.com/lgandx/Responder)

```sh
sudo responder
```

[pretender](https://github.com/RedTeamPentesting/pretender)

```sh
sudo pretender
```

[bettercap](https://github.com/bettercap/bettercap)

```sh
sudo bettercap
```

[mitmproxy](https://mitmproxy.org/)

```sh
sudo mitmproxy
```

DNS:

[massdns](https://github.com/blechschmidt/massdns)

```sh
massdns
```

[dnsrecon](https://github.com/darkoperator/dnsrecon)

```sh
dnsrecon
```

Protocols:

[impacket](https://github.com/fortra/impacket)

```sh
DumpNTLMInfo.py
Get-GPPPassword.py
GetADUsers.py
GetNPUsers.py
GetUserSPNs.py
addcomputer.py
atexec.py
changepasswd.py
dcomexec.py
dpapi.py
esentutl.py
exchanger.py
findDelegation.py
getArch.py
getPac.py
getST.py
getTGT.py
goldenPac.py
karmaSMB.py
keylistattack.py
kintercept.py
lookupsid.py
machine_role.py
mimikatz.py
mqtt_check.py
mssqlclient.py
mssqlinstance.py
net.py
netview.py
nmapAnswerMachine.py
ntfs-read.py
ntlmrelayx.py
ping.py
ping6.py
psexec.py
raiseChild.py
rbcd.py
rdp_check.py
reg.py
registry-read.py
rpcdump.py
rpcmap.py
sambaPipe.py
samrdump.py
secretsdump.py
services.py
smbclient.py
smbexec.py
smbpasswd.py
smbrelayx.py
smbserver.py
sniff.py
sniffer.py
split.py
ticketConverter.py
ticketer.py
tstool.py
wmiexec.py
wmipersist.py
wmiquery.py
```

# Password Recovery

Password:

[hashcat](https://github.com/hashcat/hashcat)

```sh
haschat -h
```

[john](https://github.com/openwall/john)

```sh
john -h
```

## Web

Domain Discovery:

[subfinder](https://github.com/projectdiscovery/subfinder)

```sh
subfinder
```

[knock](https://github.com/guelfoweb/knock)

```sh
knockpy -h
```

[dnsx](https://github.com/projectdiscovery/dnsx)

```sh
dnsx -h
```

[dnsgen](https://github.com/ProjectAnte/dnsgen)

```sh
dnsgen
```

Crawlers / Spiders:

[gospider](https://github.com/jaeles-project/gospider)

```sh
gospider -h
```

[hakrawler](https://github.com/hakluke/hakrawler)

```sh
hakrawler -h
```

[katana](https://github.com/projectdiscovery/katana)

```sh
katana
```

Information Discovery:

[secretfinder](https://github.com/m4ll0k/SecretFinder)

```sh
secretfinder -h
```

[httprobe](https://github.com/tomnomnom/httprobe)

```sh
httprobe -h
```

[httpx](https://github.com/projectdiscovery/httpx)

```sh
httpx -h
```

[waybackurls](https://github.com/tomnomnom/waybackurls)

```sh
waybackurls -h
```

[gau](https://github.com/lc/gau)

```sh
gau -h
```

[qsreplace](https://github.com/tomnomnom/qsreplace)

```sh
qsreplace -h
```

[arjun](https://github.com/s0md3v/Arjun)

```sh
arjun
```

Web Fuzzing:

[ffuf](https://github.com/ffuf/ffuf)

```sh
ffuf
```

[feroxbuster](https://github.com/epi052/feroxbuster)

```sh
feroxbuster
```

[dirsearch](https://github.com/maurosoria/dirsearch)

```sh
dirsearch
```

[gobuster](https://github.com/OJ/gobuster)

```sh
gobuster
```

CMS Scanners:

[wpscan](https://github.com/wpscanteam/wpscan)

```sh
wpscan
```

SQL Vulnerabilities:

[sqlmap](https://github.com/sqlmapproject/sqlmap)

```sh
sqlmap -h
```

[jeeves](https://github.com/jeanqasaur/jeeves)

```sh
jeeves -h
```

XSS Vulnerabilties:

[freq](https://github.com/takshal/freq)

```sh
freq -h
```

[gxss](https://github.com/KathanP19/Gxss)

```sh
gxss -h
```

[dalfox](https://github.com/hahwul/dalfox)

```sh
dalfox -h
```

SSRF Vulnerabilities:

[ssrfmap](https://github.com/swisskyrepo/SSRFmap)

```sh
ssrfmap
```

Social Media:

[socialhunter](https://github.com/utkusen/socialhunter)

```sh
socialhunter
```

## Misc

Formatting:

[anew](https://github.com/tomnomnom/anew)

```sh
anew -h
```

# Extra

Configurations that complement well with this installation:
- Minima: https://github.com/pwnlog/Minima
- Pencri: https://github.com/pwnlog/Pencri