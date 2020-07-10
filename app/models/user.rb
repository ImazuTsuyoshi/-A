class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true   
  validates :affiliation, length: { in: 2..50 }, allow_blank: true
  validates :basic_work_time, presence: true
  validates :designated_work_start_time, presence: true
  validates :designated_work_end_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
 

  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil? 
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.search(search) #ここでのself.はuser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
    else
      all #全て表示。User.は省略
    end
  end
  
 def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      user = new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save!
    end
 end

  
  def self.updatable_attributes
    ["name", "email", "affiliation", "employee_number",  "uid", "basic_work_time", "basic_work_time", "designated_work_start_time", "designated_work_end_time","password"]
  end
end  