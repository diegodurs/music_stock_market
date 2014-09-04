class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_reader :remember_me
end
