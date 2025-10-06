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
    end

    it "successfully invokes the task" do
      expect { Rake.application.invoke_task task_name }.not_to raise_error
    end
  end
end
