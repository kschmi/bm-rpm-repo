require 'spec_helper'
require 'fileutils'

describe RepositoryHost do
    before :all do
        @host = 'localhost'
        @user = 'root'
        @path = '/tmp/bm-test'
        @repositoryHost = RepositoryHost.new(
            :host => @host,
            :user => @user,
            :path => @path
        )
    end

    describe '#new' do
        it 'takes a host, user, and path and returns a RepositoryHost object.' do
            @repositoryHost.should be_an_instance_of RepositoryHost
        end
    end

    describe '#host' do
        it 'returns the correct host.' do
            @repositoryHost.host.should eql @host
        end
    end

    describe '#user' do
        it 'returns the correct user.' do
            @repositoryHost.user.should eql @user
        end
    end

    describe '#path' do
        it 'returns the correct path.' do
            @repositoryHost.path.should eql @path
        end
    end

    describe '#canConnect?' do
        it'returns true if self.cmd exits with 0.' do
            allow(@repositoryHost).to receive(:cmd).and_return(%x{(exit 0)})
            expect(@repositoryHost.canConnect?).to be_true
        end
        it'returns false if self.cmd exists with 1.' do
            allow(@repositoryHost).to receive(:cmd).and_return(%x{(exit 1)})
            expect(@repositoryHost.canConnect?).to be_false
        end
    end

    describe '#checkConnection' do
        context '#canConnect? returns true.' do
            it 'does not exit.' do
                allow(@repositoryHost).to receive(:canConnect?).and_return(true)
                result = true
                begin
                    @repositoryHost.checkConnection
                rescue SystemExit
                    result = false
                end
                expect(result).to be_true
            end
        end
        context '#canConnect? returns false.' do
            it 'exits the program.' do
                allow(@repositoryHost).to receive(:canConnect?).and_return(false)
                result = false
                begin
                    @repositoryHost.checkConnection
                rescue SystemExit
                    result = true
                end
                expect(result).to be_true
            end
        end
    end

    describe '#listRepositories' do
        before(:all) do
            FileUtils.rm_r(@path) if Dir.exists?(@path)
            Dir.mkdir(@path)
            @repositories = ['adi-stable','adi-testing','adi-unstable']
            @repositories.each { |repository| Dir.mkdir("#{@path}/#{repository}") }
        end

        after(:all) do
           FileUtils.rm_r(@path)
        end

        it 'returns the expected repsitories' do
            allow(@repositoryHost).to receive(:sshCmd) do |arg|
                puts "Executing command '#{arg}' localy."
                %x{#{arg}}
            end
            @repositoryHost.listRepositories.should eql @repositories
        end
    end
end

describe 'Repository' do
    before :all do
        @host = 'localhost'
        @user = 'root'
        @path = '/tmp/bm-test'
        @repositoryHost = RepositoryHost.new(
            :host => @host,
            :user => @user,
            :path => @path
        )
        @name = 'adi-unstable'
        @repository = Repository.new(
            :host => @repositoryHost,
            :name => @name,
        )
    end

    describe '#new' do
        it 'takes a host and name and returns a Repository object.' do
            @repository.should be_an_instance_of Repository
        end
    end

    describe '#host' do
        it 'returns the correct host object.' do
            @repository.host.should equal @repositoryHost
        end
    end

    describe '#name' do
        it 'returns the correct name.' do
            @repository.name.should eql @name
        end
    end

    describe '#repositoryPath' do
        it 'returns the host path with its name attached.' do
            @repository.repositoryPath.should eql @path + '/' + @name
        end
    end

    describe '#rpmPath' do
        it 'returns the host path with its name and "RPMS" attached.' do
            @repository.rpmPath.should eql @path + '/' + @name + '/RPMS'
        end
    end

    describe '#listRpms' do
        before(:all) do
            FileUtils.rm_r(@path) if Dir.exists?(@path)
            FileUtils.mkdir_p("#{@path}/adi-unstable/RPMS")
            @rpms = [ 'important-1.0.0-1.rpm', 'loveme-1.0.0-1.rpm', 'test-1.0.0-1.rpm' ]
            @rpms.each { |rpm| File.new("#{@path}/adi-unstable/RPMS/#{rpm}", 'w+') }
        end

        after(:all) do
           FileUtils.rm_r(@path)
        end

        it 'returns the expected RPMs.' do
            allow(@repositoryHost).to receive(:sshCmd) do |arg|
                puts "Executing command '#{arg}' localy."
                %x{#{arg}}
            end
            @repository.listRpms.should eql @rpms
        end
    end

    describe '#create' do
        context 'the repository already exists.' do
        end

        context 'the repository does not yet exist.' do
        end
    end
end
