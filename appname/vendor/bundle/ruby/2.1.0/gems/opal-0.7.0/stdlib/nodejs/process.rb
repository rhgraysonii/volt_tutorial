module Kernel
  def exit(status = true)
    $__at_exit__.reverse.each(&:call) if $__at_exit__
    `process.exit(status === true ? 0 : status)`
  end

  def caller
    %x{
      var stack;
      try {
        var err = Error("my error");
        throw err;
      } catch(e) {
        stack = e.stack;
      }
      return stack.$split("\n").slice(3);
    }
  end
end

ARGV = `process.argv.slice(2)`

ENV = Object.new
def ENV.[]= name, value
  `process.env[#{name.to_s}] = #{value.to_s}`
end

def ENV.[] name
  `process.env[#{name}] || nil`
end
