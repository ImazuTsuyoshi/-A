class Attendance < ApplicationRecord
  belongs_to :user
  require 'csv'

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
   enum decision: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }

  
  validate :finished_at_is_invalid_without_a_started_at
  
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end 
    
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
end