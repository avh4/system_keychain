require 'highline'
require 'colorize'

module SystemKeychain
  module Input
    module ColorConsole
      def self.print_important(s)
        puts s.blue
      end

      def self.print(s)
        puts s
      end

      def self.print_error(s)
        puts s.red
      end

      def self.ask(prompt)
        @highline ||= HighLine.new
        @highline.ask(prompt.blue)
      end

      def self.ask_secret(prompt)
        @highline ||= HighLine.new
        @highline.ask("Password: ".blue) { |q| q.echo = '*'*(1+rand(3)) }
      end
    end
  end
end
