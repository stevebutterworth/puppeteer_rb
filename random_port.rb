class RandomPort

  def self.acquire
    loop do
      random_port = rand(1024..49150)
      free = is_port_free?(random_port)
      return random_port if free
    end
  end

  def self.is_port_free?(port)
    begin
      s = TCPServer.new('127.0.0.1', port)
      s.close
    rescue Errno::EADDRINUSE
      return false
    end
    return true
  end

end