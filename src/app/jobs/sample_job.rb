class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "=====サンプルジョブです======"
  end
end
