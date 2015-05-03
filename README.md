# Cross Compile on Mac OSX for mruby
Cross compile osx, linux or win32 binary of mruby on Mac OSX.

## Donwload and install by mrbgems
### Donwload mrbgem
```
git clone https://github.com/matsumoto-r/mruby-cross-compile-on-mac-osx.git
```

### add conf.gem line to `build_config.rb`
```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  # the last line of conf.gem
  load '/path/to/mruby-cross-compile-on-mac-osx/mrbgem.rake'
end
```

### Download and Install Cross Compiler on Mac OSX
- [Cross Compiling for Win32 on MacOS X](http://crossgcc.rts-software.org/doku.php?id=compiling_for_win32)
- [Cross Compiling for Linux 32 and Linux 64 on MacOS X](http://crossgcc.rts-software.org/doku.php?id=compiling_for_linux)

### Cross Compile with MRUBY_CROSS_OS Env
#### for linux
```
rake MRUBY_CROSS_OS=linux
```
#### for osx
```
rake MRUBY_CROSS_OS=osx
```
#### for win32
```
rake MRUBY_CROSS_OS=win32
```

then, generate mruby binaries into `mruby/build/{linux,osx,win32}/`


# License
under the MIT License:

* http://www.opensource.org/licenses/mit-license.php

