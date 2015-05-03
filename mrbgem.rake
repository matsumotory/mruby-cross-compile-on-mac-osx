MRuby::Gem::Specification.new('mruby-cross-compile-on-mac-osx') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.version = '0.0.1'
  spec.summary = 'Cross compiled osx, linux, or win32 binary on Max OSX'
end

# TODO: support arm arch
support_arch = %w[386 amd64]

if ENV['MRUBY_CROSS_OS']
  conf_name = ENV['MRUBY_CROSS_OS']
  if ENV['MRUBY_CROSS_ARCH']
    unless support_arch.include? ENV['MRUBY_CROSS_ARCH']
      fail "Don't support archtecture: #{ENV['MRUBY_CROSS_ARCH']}
        Support architecture for linux: #{support_arch.to_s}"
    end
    conf_name += '-' + ENV['MRUBY_CROSS_ARCH']
  end
end

# for OSX
if ENV['MRUBY_CROSS_OS'] == "osx"
  MRuby::CrossBuild.new('osx') do |conf|

    toolchain :gcc

    MRuby.targets["host"].gems.each do |mrbgem|
      conf.gem mrbgem.dir
    end

  end
end

# for linux amd64 by default
if ENV['MRUBY_CROSS_OS'] == "linux"

  MRuby::CrossBuild.new(conf_name) do |conf|

    toolchain :gcc

    url = 'http://crossgcc.rts-software.org/doku.php?id=compiling_for_linux'

    # for amr64 by default
    cgcc = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc"
    car = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ar"

    if ENV['MRUBY_CROSS_ARCH'] == "386"
      cgcc = "/usr/local/gcc-4.8.1-for-linux32/bin/i586-pc-linux-gcc"
      car = "/usr/local/gcc-4.8.1-for-linux32/bin/i586-pc-linux-ar"
    elsif ENV['MRUBY_CROSS_ARCH'] == "amd64"
      cgcc = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-gcc"
      car = "/usr/local/gcc-4.8.1-for-linux64/bin/x86_64-pc-linux-ar"
    end

    fail "Can't find #{cgcc}. Please download compiler from #{url}" unless File.exist? cgcc
    fail "Can't find #{car}. Please download compiler from #{url}" unless File.exist? car

    MRuby.targets["host"].gems.each do |mrbgem|
      conf.gem mrbgem.dir
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

    MRuby.targets["host"].gems.each do |mrbgem|
      conf.gem mrbgem.dir
    end

    conf.cc.command = cgcc
    conf.linker.command = cgcc
    conf.archiver.command = car
    conf.exts.executable = ".exe"

  end
end
