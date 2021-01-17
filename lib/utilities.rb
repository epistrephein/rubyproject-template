# frozen_string_literal: true

# Retry block with custom linear delay
def with_retries(retries: 3, rescue_ex: [StandardError], swallow_ex: false, delay: 0)
  yield
rescue *rescue_ex => e
  attempts ||= 1

  if attempts <= retries
    sleep (attempts * delay)
    attempts += 1
    retry
  end

  raise e unless swallow_ex
end
