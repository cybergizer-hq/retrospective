# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyActionItemsDigestJob, type: :job do
  let_it_be(:service) { double('DailyActionItemsDigestService') }

  before do
    allow(DailyActionItemsDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyActionItemsDigestService#send_digest' do
    expect(service).to receive(:send_digest)
    DailyActionItemsDigestJob.perform_now
  end

  it 'job is created' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      described_class.perform_later
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
