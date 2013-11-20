# yakulo

Yakuake session loader (yakulo = YAKUake LOader)


## Installation

    git clone git://github.com/kosqx/yakulo.git
    sudo cp yakulo/yakulo /usr/bin


## Quick Start

Create file `~/.config/yakulo/foo` with content:

    # this is comment
    :tab First tab name
      ls
    :tab Second tab name
      echo this is second tab

Then run script:

    yakulo foo

## Troubleshooting

If you are running new versions of Kubuntu and you are getting message "No Yakuake is running" then you encounter the problem with `qdbus`. You can fix it by issuing command:

    sudo apt-get install qt4-default
