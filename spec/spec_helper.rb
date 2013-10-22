require 'simplecov'
SimpleCov.start

require 'rspec'
require 'bm-rpm-repo'

RSpec.configure do |config|
    config.color_enabled    = true
    config.formatter        = 'documentation'
    config.before(:all, &:silence_output)
    config.after(:all, &:enable_output)
end

public
def silence_output
    @originalStderr = $stderr
    @originalStdout = $stdout

    $stderr = File.new(File.join(File.dirname(__FILE__), 'null.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'null.txt'), 'w')
end

def enable_output
    $stderr = @originalStderr
    $stdout = @originalStdout
    @originalStderr = nil
    @originalStdout = nil
end
