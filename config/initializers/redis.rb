# config/initializers/redis.rb
$redis = Redis.new(url: 'redis://localhost:6380/0')
