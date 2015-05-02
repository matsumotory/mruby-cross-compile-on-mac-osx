MRuby::Gem::Specification.new('mruby-cross-compile-for-mac-osx') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.version = '0.0.1'
  spec.summary = 'Cross compiled osx, linux, or win32 binary on Max OSX'
end

# get mrbgems from build_config.rb
def get_mrbgems
  mrbgems = []
  MRuby.each_target do |target|
    @gems.map do |gem|
      mrbgems << gem.dir
    end
  end
  mrbgems
end

# for OSX
if ENV['MRUBY_CROSS_OS'] == "osx"
  MRuby::CrossBuild.new('osx') do |conf|

    toolchain :gcc

    get_mrbgems.each do |mrbgem|
      conf.gem mrbgem
    end

  end
end

# for linux x86_64
if ENV['MRUBY_CROSS_OS'] == "linux"
  MRuby::CrossBuild.new('linux') do |conf|

    toolchain :gcc

    url = 'http://crossgcc.rts-software.org/doku.php?id=compiling_for_linux'
    cgcc = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc"
    car = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ar"

    fail "Can't find #{cgcc}. Please download compiler from #{url}" unless File.exist? cgcc
    fail "Can't find #{car}. Please download compiler from #{url}" unless File.exist? car

    get_mrbgems.each do |mrbgem|
      conf.gem mrbgem
    end

    conf.cc.command = cgcc
    conf.cc.flags << "-static"
    conf.linker.command = cgcc
    conf.archiver.command = car

  end
end

# for win32
if ENV['MRUBY_CROSS_OS'] == "win32"
  MRuby::CrossBuild.new('win32') do |conf|

    toolchain :gcc

    url = 'http://crossgcc.rts-software.org/doku.php?id=compiling_for_win32'
    cgcc = "/usr/local/gcc-4.8.0-qt-4.8.4-for-mingw32/win32-gcc/bin/i586-mingw32-gcc"
    car = "/usr/local/gcc-4.8.0-qt-4.8.4-for-mingw32/win32-gcc/bin/i586-mingw32-ar"

    fail "Can't find #{cgcc}. Please download compiler from #{url}" unless File.exist? cgcc
    fail "Can't find #{car}. Please download compiler from #{url}" unless File.exist? car

    get_mrbgems.each do |mrbgem|
      conf.gem mrbgem
    end

    conf.cc.command = cgcc
    conf.linker.command = cgcc
    conf.archiver.command = car
    conf.exts.executable = ".exe"

  end
end

