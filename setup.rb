class Package < Struct.new(:command, :name, :opts)
  def install!
    if not_installed?
      system("#{command} install #{name} #{opts.join(" ")}")
    end
  end

  def not_installed?
    !exists?
  end

  def exists?
    system("#{command} info | grep #{name}")
  end
end

def Bin(name, opts = [])
  Package.new("brew", name, opts)
end

def App(name, opts = [])
  Package.new("brew cask", name, opts)
end


APPS = [
  App("hyper"),
  App("google-chrome"),
  App("1password"),
  App("elm-platform"),
  App("macdown"),
  App("atom"),
  App("slack"),
  App("dropbox"),
  App("kap"),
  App("sip")
]

BINS = [
  Bin(:openssl),
  Bin(:git, ["--with-brewed-openssl"]),
  Bin(:node, ["--with-openssl"]),
  Bin(:phantomjs),
  Bin(:rust),
  Bin(:sqlite),
  Bin(:tmux),
  Bin(:tree),
  Bin(:ack),
  Bin(:elixir),
  Bin(:ffmpeg),
  Bin(:hub),
  Bin(:heroku),
  Bin(:vim, [
    "--HEAD",
    "--with-custom-ruby",
    "--with-python3",
    "--with-lua",
    "--with-client-server"
  ])
]

BINS.each(&:install!)
APPS.each(&:install!)

