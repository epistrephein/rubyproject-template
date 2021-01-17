# frozen_string_literal: true

# Retry block with custom linear delay
def with_retries(retries: 3, rescue_ex: [StandardError], swallow_ex: false, delay: 0)
  yield
rescue *rescue_ex => e
  attempts ||= retries
  delay_for  = (retries - attempts + 1) * delay

  if (attempts -= 1).positive?
    sleep delay_for
    retry
  end

  raise e unless swallow_ex
end
