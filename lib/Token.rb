class Token
  attr_reader :token, :discord_id, :code

  def initialize(token, code, discord_id)
    @token = token
    @code = code
    @discord_id = discord_id
  end

  # Private as in Redis-facing
  def as_private_hash
    { token: @token, code: @code, discord_id: @discord_id }
  end

  # Public as in API-facing
  def as_public_hash
    { token: @token, discord_id: @discord_id }
  end

  def to_json_public
    as_public_hash.to_json
  end

  def to_json_private
    as_private_hash.to_json
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
