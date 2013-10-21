class RepositoryHost
    attr_reader :host, :path
    def initialize(args)
        @host   = args[:host]
        @path   = args[:path]
        self.checkConnection
    end

    def sshCmd(command)
        puts "#{host}: #{command}"
    end
    
    def canConnect?
        true
    end

    def checkConnection
        if canConnect?
            puts "Connection to '#{host}' established."
        else
            puts "Can't connect to '#{host}'."
            exit
        end
    end

    def listRepositoryNames
        ['adi-stable','adi-unstable', 'adi-testing']
    end
end

class Repositories
    attr_reader :host
    def initialize(args)
        @host = args[:host]
    end

    def list
        @host.listRepositoryNames.each do |repositoryName|
            repository = Repository.new(:host => @host, :name => repositoryName)
            puts repository.name
            repository.listRpms.each { |rpm| puts '    ' + rpm }
        end

    end
end

class Repository
    attr_reader :host, :name
    def initialize(args)
        @host   = args[:host]
        @name   = args[:name]
    end

    def create
        puts "Creating repository in '#{host.path}/#{name}'."
        host.sshCmd "createrepo -d #{host.path}/#{name}"
    end

    def listRpms
        ['websphere-1.0-1.rpm','balancesuite-1.0-1.rpm', 'birt-customizing-1.0-1.rpm']
    end
end

bmrepo = RepositoryHost.new(:host => 'bm-repo.lan.tarent.de', :path => '/var/www/RH6')

puts 'Repo Creation'
Repository.new(:host => bmrepo, :name => 'adi-unstable').create

puts "\nRepo listing"
puts bmrepo.listRepositoryNames

puts "\nRPM listing"
Repositories.new(:host => bmrepo).list

while true
end
