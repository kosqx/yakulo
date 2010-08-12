# yakulo

Yakuake session loader (yakulo = YAKUake LOader)


## Installation

    git clone git://github.com/kosqx/yakulo.git
    sudo cp yakulo/yakulo /usr/bin


## Quick Start

Create file named ~/.yakulo/foo with content like:

    # this is comment
    :tab First tab name
      ls
    :tab Second tab name
      echo this is second tab

Then run script:

    yakulo foo

