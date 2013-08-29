require 'shellwords'

module SystemKeychain
  module Store
    module Mac
      def self.is_valid
        `which security` == "/usr/bin/security\n"
      end

      def self.get(url)
        match = `security find-generic-password -s #{Shellwords.escape(url)} -g 2>&1`.match(/password: "([^"]*)".*acct"<blob>="([^"]*)"/m)
        return nil unless match
        pass, user = match.captures
        return [user, pass]
      end

      def self.remove(url)
        `security delete-generic-password -s #{Shellwords.escape(url)}`
      end

      def self.save(url, user, pass, description = url)
        `security add-generic-password -l #{Shellwords.escape(description)} -s #{Shellwords.escape(url)} -a #{Shellwords.escape(user)} -p #{Shellwords.escape(pass)}`
      end
    end
  end
end