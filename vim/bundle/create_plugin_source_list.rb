
get_repo = -> { `git config --get remote.origin.url` }

dirs = Dir.glob('*').select { |f| File.directory?(f) }

parent_repo = get_repo.call

File.open('plugins_list.txt', 'w') do |file|
  dirs.each do |dir|
    Dir.chdir(dir) do
      current_repo = get_repo.call
      file.write("git clone #{current_repo.chomp} && ") if parent_repo != current_repo
    end
  end
  file.write "echo 'done';"
end
