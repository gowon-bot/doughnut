class Token
  attr_reader :token, :discord_id, :code

  def initialize(token, code, discord_id)
    @token = token
    @code = code
    @discord_id = discord_id
  end

  def as_hash
    { token: @token, code: @code, discord_id: @discord_id }
  end

  def to_json(*args)
    as_hash.to_json(args)
  end

  def save_to_redis
    redis = DoughnutRedis.new

    redis.save_token(self)
  end

  def expired?
    # to be implemented

    false
  end
end
