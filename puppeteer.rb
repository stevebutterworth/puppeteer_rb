

class Puppeteer

  def initialize
    @port = RandomPort.acquire
    @pid = spawn "node puppeteer_server.js #{@port}"
    ObjectSpace.define_finalizer(self, self.class.finalize(@pid) )
  end

  # Finalizers are bad practice apparently but how else can we stop zombie processes?
  def self.finalize(pid)
    proc { Process.kill("HUP", pid) }
  end

  # Puppeteer class just has a single class method to launch the browser
  def launch(opts = {})
    @node = JSONSocket::Client.new(host: "localhost", port: @port)
    res = @node.send({
      method:'main.launch',
      return: true,
      args: [{headless: false, defaultViewport: nil}.merge(opts)]
    });
    return Browser.new(@node, res['result'])
  end

  class Browser

    def initialize(node, page_ids)
      @node = node
      @pages = page_ids.map{|page_id| Page.new(page_id, self)}
    end

    def new_page
      page_id = @js.send({method:'main.newPage', return: true});
      Page.new(page_id, browser)
    end

    def pages
      @pages
    end

    def node
      @node
    end

  end

  class Page

    def initialize(page_id, browser)
      @page_id = page_id
      @browser = browser
      @node = @browser.node
    end

    def method_missing(m, *args, &block)
      method = m.to_s.split('_').map(&:capitalize).join
      puts "Sending method #{m} to page with args #{args.inspect}"
      @node.send({page_id: @page_id, method:"page.#{m}", args: args});
    end

    def page_id
      @page_id
    end
  end

end

