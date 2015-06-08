require_relative './git_evolution/initialize.rb'

module GitEvolution
  def self.run(args)
    start_line = args[0]
    end_line = args[1]
    file = args[2]

    repo = Repository.new(File.dirname(File.expand_path(file)))
    commits = repo.line_commits(start_line, end_line, file)

    ownership = Hash.new(0)

    puts 'Commits:'
    commits.each do |commit|
      puts "#{commit.author} (#{Time.at(commit.date.to_i)}) - #{commit.sha}"
      puts "#{commit.title}"
      puts

      ownership[commit.author] = ownership[commit.author] + 1
    end

    puts '-' * 80

    puts
    puts 'Ownership:'
    ownership.each do |author, count|
      puts "#{author} - #{count}/#{commits.size} (#{(count.to_f / commits.size * 100).round(2)}%)"
    end
  end
end
