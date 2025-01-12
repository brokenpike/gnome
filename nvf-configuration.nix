{pkgs, lib, ...}:
{
 vim={ 
  theme.enable =true;
  theme.name = "gruvbox";
  theme.style = "dark";
  #languages.nix.enable =  true;
  statusline.lualine.enable = true;
  autocomplete.nvim-cmp.enable = true;
  languages ={
    enableLSP = true;
    enableTreesitter = true;
    nix.enable =true;
    ts.enable = true;

  };
 };
}