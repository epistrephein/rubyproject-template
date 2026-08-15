# frozen_string_literal: true

require "rake"

RSpec.describe "Rake tasks" do
  before(:all) do
    ENV["SUPPRESS_LOG"] = "true"

    Rake::Task.define_task(:environment)
  end

  describe "main" do
    let(:task_file) { "tasks/main" }
    let(:task_name) { "main" }

    before do
      Rake.application.rake_require task_file
      Rake::Task[task_name].reenable
    end

    it "successfully invokes the task" do
      expect { Rake.application.invoke_task task_name }.not_to raise_error
    end

    it "handles task errors by notifying and exiting" do
      error = RuntimeError.new("boom")
      stdout_logger = instance_double(Logger)
      stderr_logger = instance_double(Logger)

      allow(Log).to receive(:stdout).and_return(stdout_logger)
      allow(Log).to receive(:stderr).and_return(stderr_logger)
      allow(stdout_logger).to receive(:info).and_raise(error)
      allow(stderr_logger).to receive(:error)
      allow(Telegram).to receive(:exception)

      expect { Rake.application.invoke_task task_name }.to raise_error(SystemExit)

      expect(Telegram).to have_received(:exception).with(error)
      expect(stderr_logger).to have_received(:error).with(error.class)
    end
  end
end
