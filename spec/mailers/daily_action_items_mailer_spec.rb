# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyActionItemsMailer, type: :mailer do
  describe '#send_action_items' do
    let_it_be(:user) { create(:user, email: 'test_user@mail.com') }
    let_it_be(:another_user) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:action_item) { create(:action_item, assignee: user, board: board) }
    let_it_be(:mail) { DailyActionItemsMailer.send_action_items(user, board) }
    let_it_be(:another_mail) { DailyActionItemsMailer.send_action_items(another_user, board) }

    context 'when user has a new action items' do
      it 'renders the headers' do
        expect(mail.subject).to eq("It's your new action items!")
        expect(mail.to).to eq(['test_user@mail.com'])
        expect(mail.from).to eq(['test@mailer.com'])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(user.nickname)
        expect(mail.body.encoded).to match(action_item.body)
        expect(mail.body.encoded).to match(board.title)
      end
    end

    context 'when user does not have new action items' do
      it 'email not sending to user' do
        expect(another_mail.subject).to eq nil
      end
    end
  end
end
