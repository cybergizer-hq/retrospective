# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyActionItemsJob, type: :job do
  let_it_be(:service) { double('DailyActionItemsService') }
  let_it_be(:board) { create(:board) }

  ActiveJob::Base.queue_adapter = :test

  before do
    allow(DailyActionItemsService).to receive(:new).and_return(service)
  end

  it 'calls DailyActionItemsService#send_mails' do
    expect(service).to receive(:send_mails).with board
    DailyActionItemsJob.perform_now(board)
  end

  it 'job is created' do
    expect do
      described_class.perform_later
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
