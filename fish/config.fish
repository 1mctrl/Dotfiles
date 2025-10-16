if status is-interactive
set fish_greeting
test -e ~/.nix-profile/etc/profile.d/nix.fish
source ~/.nix-profile/etc/profile.d/nix.fish
end

starship init fish | source
