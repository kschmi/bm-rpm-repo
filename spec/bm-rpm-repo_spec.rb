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
            it 'it does not exit.' do
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
            Dir.mkdir(File.join(@path,'adi-testing'))
            Dir.mkdir(File.join(@path,'adi-unstable'))
            Dir.mkdir(File.join(@path,'adi-stable'))
        end

        after(:all) do
           FileUtils.rm_r(@path) 
        end

        it 'returns the expected repsitories' do
            allow(@repositoryHost).to receive(:sshCmd) do |arg|
                puts "Executing command '#{arg}' localy."
                %x{#{arg}}
            end
            @repositoryHost.listRepositories.should eql ['adi-stable','adi-testing','adi-unstable']
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
end
