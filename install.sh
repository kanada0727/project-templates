#!/bin/bash -xe

git clone https://github.com/kanada0727/project-templates ~/.generate-templates --depth 1
rm -rf ~/.generate-templates/.git
echo "export PATH=\"\$PATH:~/.generate-templates/\"" >> ~/.bashrc
