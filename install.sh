#!/usr/bin/bash
# Author: pwnlog

RED=$(printf '\e[1;31m')
NUL=$(printf '\e[0m')

##############################################################################
##############################################################################
##############################################################################
# Requirements Section
##############################################################################
##############################################################################
##############################################################################

if [ "${UID}" -eq 0 ]
then
    echo "$RED[-] Warning: Running as root$NUL"
    echo "[i] Exiting"
    exit 1
else
    echo "[+] Elevating to EUID 0"
    sudo test
fi

echo "[+] Updating APT"
sudo apt-get update > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: apt failed to update$NUL"
    exit 1
fi

echo "[+] Installing essentials"
sudo apt-get install -y git wget curl rename findutils > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: essentials failed to install$NUL"
    exit 1
fi

echo "[+] Installing zsh"
sudo apt-get install -y zsh > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: zsh failed to install$NUL"
    exit 1
fi
sudo chsh -s $(which zsh) $(whoami)
export SHELL=$(which zsh)

echo "[+] Installing language dependencies"
sudo apt-get install -y python2 virtualenv unzip sudo make gcc libpcap-dev build-essential libcurl4-openssl-dev libldns-dev libssl-dev libffi-dev libxml2 jq libxml2-dev libxslt1-dev build-essential ruby-dev ruby-full libgmp-dev zlib1g-dev > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: language dependencies failed to install$NUL"
    exit 1
fi

echo "[+] Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: rust failed to install$NUL"
    exit 1
fi

echo "[+] Installing golang"
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O go1.21.5.linux-amd64.tar.gz > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: golang failed to download$NUL"
    exit 1
fi
sudo rm -rf /usr/local/go > /dev/null 2>&1
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
export GOROOT=/usr/local/go 
export GOPATH=$HOME/go 
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
rm -rf go1.21.5.linux-amd64.tar.gz 2>/dev/null

echo "[+] Verifying environment variables"
grep GOROOT ~/.zsh_profile > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "[+] Adding environment variables"
    echo 'export GOROOT=/usr/local/go' >> ~/.zsh_profile
    echo 'export GOPATH=$HOME/go' >> ~/.zsh_profile
    echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.zsh_profile
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
fi

echo "[+] Sourcing zsh profile"
source ~/.zsh_profile

echo "[+] Installing pipx"
pip install --upgrade pip > /dev/null 2>&1
sudo apt install -y pipx > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: pipx failed to install$NUL"
fi

echo "[+] Creating pentest directories"
sudo mkdir -p /opt/PenTest/{Recon,MiTM,Vulnerability-Analysis,Exploitation,Web,Post-Exploitaiton/{PrivEsc,Lateral-Movement,Persistence},Wordlists} 2>/dev/null

echo "[+] Creating temporary directory"
mkdir tmp 2>/dev/null
cd tmp 

##############################################################################
##############################################################################
##############################################################################
# Network Scanners
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing nmap"
sudo apt-get install -y nmap > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: nmap failed to install$NUL"
fi

echo "[+] Installing masscan"
git clone https://github.com/robertdavidgraham/masscan > /dev/null 2>&1 
sudo make -C masscan/ > /dev/null 2>&1 
sudo make -C masscan/ install > /dev/null 2>&1 
sudo mv masscan/bin/masscan /usr/local/bin/ > /dev/null 2>&1 
if [ $? != 0 ]; then
    echo "$RED[-] Error: masscan failed to install$NUL"
fi

echo "[+] Installing naabu"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/naabu /usr/local/bin/naabu
if [ $? != 0 ]; then
    echo "$RED[-] Error: naabu failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Network Monitoring
##############################################################################
##############################################################################
##############################################################################

sudo apt-get install -y wireshark > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: wireshark failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Vulnerability Scanners
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing nuclei"
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/nuclei /usr/local/bin/nuclei
if [ $? != 0 ]; then
    echo "$RED[-] Error: nuclei failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# SWISS Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing netexec"
pipx install git+https://github.com/Pennyw0rth/NetExec --force > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: NetExec failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Wordlists
##############################################################################
##############################################################################
##############################################################################

echo "[+] Downloading SecLists"
sudo git clone https://github.com/danielmiessler/SecLists /opt/PenTest/Wordlists/ > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: SecLists failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# MiTM Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing responder"
sudo git clone https://github.com/lgandx/Responder /opt/PenTest/MiTM/Responder > /dev/null 2>&1
sudo ln -sf /opt/PenTest/MiTM/Responder/Responder.py /usr/local/bin/responder > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: responder failed to install$NUL"
fi

echo "[+] Installing pretender"
git clone https://github.com/RedTeamPentesting/pretender > /dev/null 2>&1
sudo /usr/local/go/bin/go build -C pretender/ -o /usr/local/bin/ > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: pretender failed to install$NUL"
fi

echo "[+] Installing bettercap"
sudo apt-get install -y bettercap > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: bettercap failed to install$NUL"
fi

echo "[+] Installing mitmproxy"
pipx install mitmproxy --force > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: mitmproxy failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# AD Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing impacket"
pipx install impacket --force > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: impacket failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Cracking Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing hashcat"
sudo apt-get install -y hashcat > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: hashcat failed to install$NUL"
fi

echo "[+] Installing john"
sudo apt-get install -y john > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: john failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# DNS Scanners / Domain Enumeration Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing massdns"
git clone https://github.com/blechschmidt/massdns.git > /dev/null 2>&1
sudo make -C massdns/ > /dev/null 2>&1
sudo make -C massdns/ install > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: massdns failed to install$NUL"
fi

echo "[+] Installing dnsrecon"
sudo apt-get install -y dnsrecon > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: dnsrecon failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Domain Names Discovery Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing subfinder"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/subfinder /usr/local/bin/subfinder
if [ $? != 0 ]; then
    echo "$RED[-] Error: subfinder failed to install$NUL"
fi

echo "[+] Installing knockpy"
git clone https://github.com/guelfoweb/knock.git > /dev/null 2>&1
cd knock
sudo python3 setup.py install > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: knock failed to install$NUL"
fi
cd ../

echo "[+] Installing dnsx"
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/dnsx /usr/local/bin/dnsx
if [ $? != 0 ]; then
    echo "$RED[-] Error: dnsx failed to install$NUL"
fi

echo "[+] Installing dnsgen"
pipx install dnsgen --force > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: dnsgen failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Web Fuzzing Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing ffuf"
go install github.com/ffuf/ffuf/v2@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/ffuf /usr/local/bin/ffuf
if [ $? != 0 ]; then
    echo "$RED[-] Error: ffuf failed to install$NUL"
fi

echo "[+] Installing feroxbuster"
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | sudo bash -s /usr/local/bin/ > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: feroxbuster failed to install$NUL"
fi

echo "[+] Installing dirsearch"
sudo git clone https://github.com/maurosoria/dirsearch.git /opt/PenTest/Web/dirsearch/ > /dev/null 2>&1
pip3 install -r dirsearch/requirements.txt > /dev/null 2>&1
sudo ln -sf /opt/PenTest/Web/dirsearch/dirsearch.py /usr/local/bin/dirsearch
sudo chmod o+x /opt/PenTest/Web/dirsearch/dirsearch.py 2>/dev/null
if [ $? != 0 ]; then
    echo "$RED[-] Error: dirsearch failed to install$NUL"
fi

echo "[+] Installing gobuster"
go install github.com/OJ/gobuster/v3@latest > /dev/null 2>&1
sudo ln -sf $HOME/go/bin/gobuster /usr/local/bin/gobuster
if [ $? != 0 ]; then
    echo "$RED[-] Error: gobuster failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# CMS Scanners
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing wpscan"
sudo gem install wpscan > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: wpscan failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# SQL Injection
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing sqlmap"
sudo apt-get install -y sqlmap > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: sqlmap failed to install$NUL"
fi

echo "[+] Installing jeeves"
go install github.com/ferreiraklet/Jeeves@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/Jeeves /usr/local/bin/jeeves
if [ $? != 0 ]; then
    echo "$RED[-] Error: Jeeves failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Secret Information Discovery
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing secretfinder"
sudo git clone https://github.com/m4ll0k/SecretFinder.git /opt/PenTest/Web/SecretFinder > /dev/null 2>&1
pip3 install -r /opt/PenTest/Web/SecretFinder/requirements.txt > /dev/null 2>&1
if [ -f "/usr/local/bin/secretfinder" ]; then
    echo "[i] Found: secretfinder is already installed"
else
    sudo ln -sf /opt/PenTest/Web/SecretFinder/SecretFinder.py /usr/local/bin/secretfinder
    sudo chmod o+x /opt/PenTest/Web/SecretFinder/SecretFinder.py 2>/dev/null
    if [ $? != 0 ]; then
        echo "$RED[-] Error: secretfinder failed to install$NUL"
    fi
fi

echo "[+] Installing httprobe"
go install github.com/tomnomnom/httprobe@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/httprobe /usr/local/bin/httprobe
if [ $? != 0 ]; then
    echo "$RED[-] Error: httprobe failed to install$NUL"
fi

echo "[+] Installing httpx"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/httpx /usr/local/bin/httpx
if [ $? != 0 ]; then
    echo "$RED[-] Error: httpx failed to install$NUL"
fi

echo "[+] Installing waybackurls"
go install github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/waybackurls /usr/local/bin/waybackurls
if [ $? != 0 ]; then
    echo "$RED[-] Error: waybackurls failed to install$NUL"
fi

echo "[+] Installing gau"
go install github.com/lc/gau/v2/cmd/gau@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/gau /usr/local/bin/gau
if [ $? != 0 ]; then
    echo "$RED[-] Error: gau failed to install$NUL"
fi

echo "[+] Installing qsreplace"
go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/qsreplace /usr/local/bin/qsreplace
if [ $? != 0 ]; then
    echo "$RED[-] Error: qsreplace failed to install$NUL"
fi

echo "[+] Installing arjun"
pipx install arjun --force > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: arjun failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Crawlers / Spiders
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing gospider"
GO111MODULE=on go install github.com/jaeles-project/gospider@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/gospider /usr/local/bin/gospider
if [ $? != 0 ]; then
    echo "$RED[-] Error: GoSpider failed to install$NUL"
fi

echo "[+] Installing hakrawler"
go install github.com/hakluke/hakrawler@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/hakrawler /usr/local/bin/hakrawler
if [ $? != 0 ]; then
    echo "$RED[-] Error: hakrawler failed to install$NUL"
fi

echo "[+] Installing katana"
go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/katana /usr/local/bin/katana
if [ $? != 0 ]; then
    echo "$RED[-] Error: katana failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# XSS
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing freq"
go install github.com/takshal/freq@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/freq /usr/local/bin/freq
if [ $? != 0 ]; then
    echo "$RED[-] Error: freq failed to install$NUL"
fi

echo "[+] Installing gxss"
go install github.com/KathanP19/Gxss@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/Gxss /usr/local/bin/gxss
if [ $? != 0 ]; then
    echo "$RED[-] Error: Gxss failed to install$NUL"
fi

echo "[+] Installing dalfox"
go install github.com/hahwul/dalfox/v2@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/dalfox /usr/local/bin/dalfox
if [ $? != 0 ]; then
    echo "$RED[-] Error: dalfox failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# SSRF
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing ssrfmap"
sudo git clone https://github.com/swisskyrepo/SSRFmap /opt/PenTest/Web/SSRFmap > /dev/null 2>&1 
pip3 install -r /opt/PenTest/Web/SSRFmap/requirements.txt > /dev/null 2>&1
sudo ln -sf /opt/PenTest/Web/SSRFmap/ssrfmap.py /usr/local/bin/ssrfmap
sudo chmod o+x /opt/PenTest/Web/SSRFmap/ssrfmap.py 2>/dev/null
if [ $? != 0 ]; then
    echo "$RED[-] Error: SSRFmap failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Formatting Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing anew"
go install -v github.com/tomnomnom/anew@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/anew /usr/local/bin/anew
if [ $? != 0 ]; then
    echo "$RED[-] Error: anew failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Social Media Hunting
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing socialhunter"
go install github.com/utkusen/socialhunter@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/socialhunter /usr/local/bin/socialhunter
if [ $? != 0 ]; then
    echo "$RED[-] Error: socialhunter failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# Cloud Services Tools
##############################################################################
##############################################################################
##############################################################################

echo "[+] Installing roadrecon and roadrecon-gui"
git clone https://github.com/dirkjanm/roadtools.git > /dev/null 2>&1 
pip install -e roadtools/roadlib/ > /dev/null 2>&1 
pip install -e roadtools/roadrecon/ > /dev/null 2>&1 
pip install roadrecon > /dev/null 2>&1 
if [ $? != 0 ]; then
    echo "$RED[-] Error: roadrecon failed to install$NUL"
fi

echo "[+] Installing s3scanner"
go install -v github.com/sa7mon/s3scanner@latest > /dev/null 2>&1 
sudo ln -sf $HOME/go/bin/s3scanner /usr/local/bin/s3scanner
if [ $? != 0 ]; then
    echo "$RED[-] Error: s3scanner failed to install$NUL"
fi

echo "[+] Installing pacu"
sudo git clone https://github.com/RhinoSecurityLabs/pacu.git /opt/PenTest/Cloud/pacu > /dev/null 2>&1 
pip install -r /opt/PenTest/Cloud/pacu/requirements.txt > /dev/null 2>&1 
sudo ln -sf /opt/PenTest/Cloud/pacu/cli.py /usr/local/bin/pacu
sudo chmod o+x /opt/PenTest/Cloud/pacu/cli.py > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: pacu failed to install$NUL"
fi

echo "[+] Installing gitoops"
sudo curl -Lso /usr/local/bin/gitoops "https://github.com/ovotech/gitoops/releases/latest/download/gitoops-linux" > /dev/null 2>&1 
sudo chmod +x /usr/local/bin/gitoops > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: gitoops failed to install$NUL"
fi

echo "[+] Installing scoutsuite"
sudo git clone https://github.com/nccgroup/ScoutSuite /opt/PenTest/Cloud/ScoutSuite > /dev/null 2>&1 
sleep 1.5
cd /opt/PenTest/Cloud/ScoutSuite/
pip install -r requirements.txt > /dev/null 2>&1
sudo ln -sf /opt/PenTest/Cloud/ScoutSuite/scout.py /usr/local/bin/scout
sudo chmod o+x /opt/PenTest/Cloud/ScoutSuite/scout.py > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$RED[-] Error: scoutsuite failed to install$NUL"
fi

##############################################################################
##############################################################################
##############################################################################
# PIPX Venvs for Sudo
##############################################################################
##############################################################################
##############################################################################

cd /usr/local/bin/
if ( uname -a | grep -io ubuntu > /dev/null 2>&1 ); then
    sudo ln -sf $HOME/.local/pipx/venvs/impacket/bin/*.py .
    sudo ln -sf $HOME/.local/pipx/venvs/netexec/bin/netexec .
    sudo ln -sf $HOME/.local/pipx/venvs/arjun/bin/arjun .
    sudo ln -sf $HOME/.local/pipx/venvs/dnsgen/bin/dnsgen .
    sudo ln -sf $HOME/.local/pipx/venvs/mitmproxy/bin/mitmdump .
    sudo ln -sf $HOME/.local/pipx/venvs/mitmproxy/bin/mitmproxy .
    sudo ln -sf $HOME/.local/pipx/venvs/mitmproxy/bin/mitmweb .
else
    sudo ln -sf $HOME/.local/share/pipx/venvs/impacket/bin/*.py .
    sudo ln -sf $HOME/.local/share/pipx/venvs/netexec/bin/netexec .
    sudo ln -sf $HOME/.local/share/pipx/venvs/arjun/bin/arjun .
    sudo ln -sf $HOME/.local/share/pipx/venvs/dnsgen/bin/dnsgen .
    sudo ln -sf $HOME/.local/share/pipx/venvs/mitmproxy/bin/mitmdump .
    sudo ln -sf $HOME/.local/share/pipx/venvs/mitmproxy/bin/mitmproxy .
    sudo ln -sf $HOME/.local/share/pipx/venvs/mitmproxy/bin/mitmweb .
fi
cd $HOME/Scriba/ 2>/dev/null

##############################################################################
##############################################################################
##############################################################################
# Permissions (symlinks have dummy permssions)
##############################################################################
##############################################################################
##############################################################################

sudo chmod 755 /usr/local/bin/* 2>/dev/null

##############################################################################
##############################################################################
##############################################################################
# Clean
##############################################################################
##############################################################################
##############################################################################

echo "[+] Cleaning Up"
sudo rm -rf tools

##############################################################################
##############################################################################
##############################################################################
# End
##############################################################################
##############################################################################
##############################################################################

echo "[+] Completed"