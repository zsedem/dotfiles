set -e
cd ~/.config/sublime-text-3/Packages

stack install happy alex # for compiling
stack install aeson haskell-src-exts ghc-mod hdevtools haddock
echo "By the time I write this, the haskell-docs package have to installed from source."

cat > ~/.config/sublime-text-3/Packages/User/SublimeHaskell.sublime-settings <<EOF
{
    "enable_hdevtools": true,
    "add_to_PATH": ["~/.local/bin", "~/.stack/programs/x86_64-linux/ghc-7.10.2/bin"]
}
EOF
git clone git@github.com:Bodigrim/SublimeHaskell.git

cd SublimeHaskell
stack init

