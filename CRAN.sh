# 备份您的配置文件为 ~/.Rprofile.bak 
# Your pypi configuration is backed up to ~/.Rprofile.bak 

[ -f ~/.Rprofile ] && cp ~/.Rprofile ~/.Rprofile.bak && sed -i '/"repos"/d' ~/.Rprofile
echo "options(\"repos\" = c(CRAN=\"$MIRROR_SITE/CRAN/\"))" >> ~/.Rprofile