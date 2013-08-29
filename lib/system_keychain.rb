require 'system_keychain/store/mac'
require 'system_keychain/input/color_console'

module Keychain
  @engine = SystemKeychain::Store::Mac
  raise "No valid Keychain engines found (currently only Mac OSX is supported)" unless @engine.is_valid

  @input = SystemKeychain::Input::ColorConsole

  def self.get(url)
    @engine.get(url)
  end

  def self.remove(url)
    @engine.remove(url)
  end

  def self.save(url, user, pass, description = url)
    @engine.save(url, user, pass, description)
  end

  def self.ask(url, description = nil)
    @input.print_important("Enter credentials for #{description} #{url}")
    @input.print("(These will be saved in your Mac OSX keychain)")
    user = @input.ask("Username: ")
    pass = @input.ask_secret("Password: ")
    self.save(url, user, pass, description)
    return [user, pass]
  end

  def self.authorize(description, url, &block)
    authorized = false
    while !authorized
      user, pass = self.get(url)
      user, pass = self.ask(url, description) unless user
      begin
        value = yield user, pass
        authorized = true
      rescue StandardError => e
        @input.print_error("Authorization failed: #{e.inspect}")
        self.remove(url)
      end
    end
    return value
  end

  def self.authorize_url(description, url, &block)
    self.authorize(description, url) do |user, pass|
      auth_url = url.sub(/([^:]*:\/\/)/,"\\1#{user}:#{pass}@")
      yield auth_url
    end
  end
end