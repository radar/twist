module ResqueHelpers
  def run_resque_job!
    worker = Resque::Worker.new("normal")
    job = worker.reserve
    worker.perform(job)
  end
end

RSpec.configure do |config|
  config.include ResqueHelpers
end
