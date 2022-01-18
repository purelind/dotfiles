# Some OSes like Ubuntu/Mac expect bash_profile
# Redirect to bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/mori/.sdkman"
[[ -s "/Users/mori/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/mori/.sdkman/bin/sdkman-init.sh"
