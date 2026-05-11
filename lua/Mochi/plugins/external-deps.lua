return {
    'nhattVim/check-deps.nvim',
    lazy = false,
    cmd = 'DepsCheck',
    opts = {
        auto_check = true,
        list = {
            {
                name = 'make',
                cmd = 'make',
                install = {
                    linux = { 'sudo apt install build-essential', 'sudo pacman -S make' },
                    mac = { 'brew install make' },
                    windows = { 'scoop install make', 'choco install make' },
                },
            },
            {
                name = 'cmake',
                cmd = 'cmake',
                install = {
                    linux = { 'sudo apt install cmake', 'sudo pacman -S cmake' },
                    mac = { 'brew install cmake' },
                    windows = { 'scoop install cmake', 'choco install cmake' },
                },
            },
            {
                name = 'lazygit',
                cmd = 'lazygit',
                install = {
                    linux = {
                        'sudo add-apt-repository ppa:lazygit-team/release && sudo apt install lazygit',
                        'sudo pacman -S lazygit',
                    },
                    mac = { 'brew install lazygit' },
                    windows = {
                        'scoop install lazygit',
                        'choco install lazygit',
                        'winget install JesseDuffield.lazygit',
                    },
                },
            },
            {
                name = 'fd',
                cmd = { 'fd', 'fdfind' },
                install = {
                    linux = { 'sudo apt install fd-find', 'sudo pacman -S fd' },
                    mac = { 'brew install fd' },
                    windows = {
                        'scoop install fd',
                        'choco install fd',
                        'winget install sharkdp.fd',
                    },
                },
            },
        },
    },
}
