class RepositoryHost
    attr_reader :host, :user, :path
    def initialize(args)
        @host   = args[:host]
        @user   = args[:user]
        @path   = args[:path]
    end

    def sshCmd(command)
        %x{ssh #{self.user}@#{self.host} #{command}}
    end

    def cmd(command)
        %x{#{command}}
    end

    def canConnect?
        self.cmd "ping -c 1 #{self.host}"
        $?.exitstatus == 0 ? true : false
    end

    def checkConnection
        if ! self.canConnect?
            puts "Can't connect to '#{self.host}'."
            exit
        end
    end

    def listRepositories
        self.sshCmd("ls #{self.path}").split
    end
end

class Repository
    attr_reader :host, :name, :path
    def initialize(args)
        @host   = args[:host]
        @name   = args[:name]
    end

    def repositoryPath
        @host.path + '/' + @name
    end

    def rpmPath
        self.repositoryPath + '/' + 'RPMS'
    end

    def listRpms
        @host.sshCmd("ls #{rpmPath}").split
    end

    def create
        puts "Creating repository in '#{host.path}/#{name}'."
        host.sshCmd "createrepo -d #{host.path}/#{name}"
    end
end

class Repositories
    attr_reader :host
    def initialize(args)
        @host = args[:host]
    end

    def list
        @host.listRepositories.each do |repositoryName|
            repository = Repository.new(:host => @host, :name => repositoryName)
            puts repository.name
            repository.listRpms.each { |rpm| puts '    ' + rpm }
        end

    end
end
