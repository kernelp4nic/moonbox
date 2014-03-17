# MoonBox
[![Build Status](https://travis-ci.org/kernelp4nic/moonbox.png?branch=master)](https://travis-ci.org/kernelp4nic/moonbox)

##### Where your moon rocks live.

moonbox will help you manage specific versions of lua rocks for a 
project. It heavily relies on [luarocks](http://luarocks.org/).

![alt text](http://upload.wikimedia.org/wikipedia/commons/2/25/Y12_moon_box_for_apollo_11.jpg "Apollo 11 Moon Box")

[Image reference](http://commons.wikimedia.org/wiki/File:Y12_moon_box_for_apollo_11.jpg)


## Name

The name comes from the Apollo 11 sample boxes to store moon rocks. 

> One of the proud accomplishments in Y-12 history was to develop and manufacture "moon boxes" for the historic Apollo 11 mission in July 1969. Astronauts used the boxes to collect and bring back to Earth nearly 50 pounds of moon rocks and soil, and the Y-12-made boxes were also used in subsequent Apollo missions. 
> Each of the boxes was machined from a single piece of aluminum, "seamless except for the lid opening, which had a metalized gasket that firmly sealed when closed." Metal straps secured the lid while in transit. The boxes are on display in multiple places, including the Smithsonian Air & Space Museum in Washington, D.C., and in the Y-12 History Center. 

(click [here](http://blogs.knoxnews.com/munger/2012/03/three-men-and-a-moonbox.html) for more info)


## Installing

```bash
➯ git clone https://github.com/kernelp4nic/moonbox
➯ cd moonbox
➯ ./configure      # supports --prefix as parameter (default is /usr/local)
➯ make install
```

## Usage

### BoxFile

moonbox needs a configuration file to work with. If you do not have one,
you can create a sample one with `moonbox init`. Otherwise, just follow this convention:

```bash
penlight                                                     # without version, will install the latest
redis-lua 2.0.4-1                                            # provide a rock version
gin 0.1.4-1 http://gin.io/repo                               # you can also provide a custom server
http://luarocks.org/repositories/rocks/uuid-0.2-1.rockspec   # you can provide a rockspec url too

```

### Installing rocks

```bash
➯ cd your_project_dir
➯ moonbox init #creates a sample BoxFile inside your project, edit with your rocks and versions
➯ moonbox install
>> starting to install rocks at 'your_project_dir/.moonbox'

Installing http://www.luarocks.org/repositories/rocks/penlight-1.3.1-1.src.rock...
Using http://www.luarocks.org/repositories/rocks/penlight-1.3.1-1.src.rock... switching to 'build' mode
Updating manifest for your_project_dir/.moonbox/lib/luarocks/rocks

penlight 1.3.1-1 is now built and installed in your_project_dir/.moonbox (license: MIT/X11)

>> installation complete!
```

### Environments

moonbox comes handy when you need to have an isolated directory with
all your rocks dependencies. You can run `source moonbox env enter` and this
will update your LUA_PATH/LUA_CPATH environment variables to work with your current directory.

As you may have noticed, environment commands are sourced. This means that
every moonbox change will impact your current shell process.

#### Environment show

```bash
➯ source moonbox env show
>> env at 'your_project_dir/.moonbox'
```

#### Entering an Environment

```bash
➯ source moonbox env enter
>> env setted up at 'your_project_dir/.moonbox'
➯ lua
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
> require 'pl.lapp'
>
```

#### Leaving an Environment

```bash
➯ source moonbox env leave
>> env at 'your_project_dir/.moonbox' has been removed.
➯ lua
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
> require 'pl.lapp'
stdin:1: module 'pl.lapp' not found:
	no field package.preload['pl.lapp']
stack traceback:
	[C]: in function 'require'
	stdin:1: in main chunk
	[C]: ?
>
```

### Need more help?

```bash
➯ moonbox help
```

## Lua versions supported (5.1, 5.2)
If you have installed [luarocks](http://luarocks.org/) 2.1.2 or later,
moonbox will support both versions of Lua.

## Tests
moonbox uses [bats](https://github.com/sstephenson/bats) to run tests.
You can install it following [this guide](https://github.com/sstephenson/bats#installing-bats-from-source).

Once installed, run from the command line:

```bash
➯ cd moonbox_sources
➯ make test
bats test/test_suite.bats
 ✓ install/uninstall moonbox
 ✓ 'moonbox help' command
 ✓ 'moonbox version' command
 ✓ 'moonbox install' command without BoxFile
 ✓ 'moonbox init' check BoxFile creation
 ✓ 'moonbox install' with empty BoxFile
 ✓ 'moonbox install' with populated BoxFile - rockname
 ✓ 'moonbox install' with populated BoxFile - rockname && version
 ✓ 'moonbox install' with populated BoxFile - rockname && version && repo
 ✓ 'moonbox install' with populated BoxFile - rockspec
 ✓ 'source moonbox env show' command without previous moonbox env setup
 ✓ 'source moonbox env show' command with previous moonbox env setup
 ✓ 'source moonbox env enter' command without moonbox install
 ✓ 'source moonbox env enter' command
 ✓ 'source moonbox env leave' command

15 tests, 0 failures
```

## License

Released under MIT License, check LICENSE file for details.

## Thanks

Guys from [luarocks](http://luarocks.org/), they rock (literally)! and 
moonbox could not live without it!

To the awesome time lord [@pote](https://github.com/pote) for [gpm](https://github.com/pote/gpm).
I took several ideas from his work.

[@ignacio](https://github.com/ignacio) to point me out several tips and changes. Also he is my jedi Lua master.