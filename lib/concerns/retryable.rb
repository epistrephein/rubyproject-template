# frozen_string_literal: true

module Retryable
  # Retry block with customizable exponential backoff and jitter.
  def with_retries(retries: 3, rescue_ex: [StandardError], swallow_ex: false, backoff: 2, jitter: 2)
    yield
  rescue *rescue_ex => e
    attempts ||= 1

    if attempts <= retries
      delay = [backoff**attempts, 60].min + rand(0.0..jitter)
      sleep delay

      attempts += 1
      retry
    end

    raise e unless swallow_ex
  end
end
