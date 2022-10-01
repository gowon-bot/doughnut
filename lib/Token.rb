class Token
  attr_reader :token, :discord_id, :refresh_token, :expires_at

  def self.from_auth_header(redis, header)
    return nil if header.nil?

    auth = header.split(/ /)

    return nil unless auth[0] == 'Bearer' && !auth[1].nil?

    token = redis.get_token(auth[1])

    return nil if !token || token.expired?

    token
  end

  def initialize(token, discord_id, refresh_token, expires_at)
    @token = token
    @discord_id = discord_id
    @refresh_token = refresh_token
    @expires_at = expires_at
  end

  # Private as in Redis-facing
  def as_private_hash
    { token: @token, discord_id: @discord_id, refresh_token: @refresh_token,
      expires_at: @expires_at.to_i }
  end

  # Public as in API-facing
  def as_public_hash
    { token: @token, discord_id: @discord_id, expires_at: @expires_at.to_i }
  end

  def as_hash_with_discord_user(discord_user)
    as_public_hash.merge({ discord_user: discord_user })
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
    Time.now > @expires_at
  end
end
