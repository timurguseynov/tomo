module Jam
  autoload :DSL, "jam/dsl"
  autoload :Error, "jam/errors"
  autoload :Framework, "jam/framework"
  autoload :Remote, "jam/remote"
  autoload :Result, "jam/result"
  autoload :ShellCommand, "jam/shell_command"
  autoload :SSH, "jam/ssh"
  autoload :Version, "jam/version"

  class << self
    def load!
      @framework ||= Framework.new
    end

    def framework
      @framework || raise("Jam has not been loaded. Call `Jam.load!` first.")
    end
  end
end
