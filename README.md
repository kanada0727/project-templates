# generate-templates
install:
```
curl -L https://raw.githubusercontent.com/kanada0727/project-templates/master/install.sh | bash -xe
source ~/.bashrc
```

uninstall:
* remove `~/.project-templates` directory and `$PATH` settings from `~/.bashrc` 
```
rm -rf ~/.project-templates
awk '!/export PATH="\$PATH:~\/.generate-templates\//' ~/.bashrc > ~/.bashrc
```


usage:
```
generate-template <template-name> <project-name>
```
