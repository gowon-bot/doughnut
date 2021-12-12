class HTTPError < StandardError
  attr_reader :code, :message

  def initialize(code, message)
    @code = code
    @message = message

    super('There was a problem responding to a request!')
  end
end

class BaseController
  protected

  def json_params(request)
    JSON.parse(request.body.read)
  rescue StandardError
    halt 400, { message: 'Invalid JSON' }
  end

  def parse_json(response)
    JSON.parse response.body
  end

  def halt(code, message)
    raise HTTPError.new(code, message)
  end

  def request_header(header)
    "HTTP_#{header.upcase}"
  end
end
