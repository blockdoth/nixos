{pkgs, ...}: {
  home.packages = with pkgs; [

  ];
  programs.fish = {
  	enable = true;
  	shellAliases = {
  		nswitch = "sudo nixos-rebuild switch --flake /home/pepijn/nixconfig/main#default"; 
  		hswitch = "home-manager switch"; 
  		cls = "clear"; 
  		nixhome = "cd /home/pepijn/nixconfig/main";
  	};
  };
}



