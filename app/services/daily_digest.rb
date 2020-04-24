# frozen_string_literal: true

class DailyDigest
  def send_digest
    return if Question.after_date(1.day.ago).count.zero?

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
