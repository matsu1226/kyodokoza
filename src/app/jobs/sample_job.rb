class SampleJob < ApplicationJob
  queue_as :default

  def perform
    puts "=====サンプルジョブです======"
  end
end
