def main
  dotfiles.each { |file| try_linking(file) }
end

def dotfiles
  [
    "rgignore",
    "bash_profile",
    "bashrc",
    "config/nvim/init.vim",
    "config/alacritty/alacritty.yml",
    "gitconfig",
    "gitignore",
    "gitmessage",
    "config/sway/config",
    "config/sway/status",
    "ssh/config",
    "tmux.conf",
    "Xresources",
  ]
end

def try_linking(file)
  if File.exist?(target(file))
    puts "skipping #{ target(file) }: #{ skip_reason(target(file)) }"
  elsif File.symlink?(target(file))
    puts "rewriting #{ target(file) }"
    File.delete(target(file))
    File.symlink(source(file), target(file))
  else
    puts "linking #{ target(file) }"
    File.symlink(source(file), target(file))
  end
end

def source(file)
  File.expand_path("~/etc/#{ file }")
end

def target(file)
  File.expand_path("~/.#{ file }")
end

def skip_reason(file)
  if File.symlink?(file)
    "already linked"
  else
    "file already exists. delete or move before reinstalling."
  end
end

def path_for(file)
  File.expand_path(file)
end

main
