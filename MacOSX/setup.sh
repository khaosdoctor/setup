#!/bin/bash

TITLE_START="\033]0;"
TITLE_END="\007"

#Color pallete
RED='\033[0;031m'
CYAN='\033[0;036m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=> Beginning installation process${NC}"
echo -e "${YELLOW}--THIS MAY REQUIRE YOUR PASSWORD--${NC}"

echo "${TITLE_START}Installing brew${TITLE_END}"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
