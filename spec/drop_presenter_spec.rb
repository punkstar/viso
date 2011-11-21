require 'drop_presenter'

describe DropPresenter do
  describe '#render_html' do
    let(:template) { stub }
    subject { DropPresenter.new drop, template }

    describe 'a bookmark drop' do
      let(:template) { stub request: stub(path: '/slug') }
      let(:drop) { stub bookmark?: true, image?: false, text?: false }

      it 'redirects to the api' do
        template.
          should_receive(:redirect_to_api).
          with(no_args)

        subject.render_html
      end
    end

    describe 'an image drop' do
      let(:drop) { stub bookmark?: false, image?: true, text?: false }

      it 'renders the erb template' do
        template.
          should_receive(:erb).
          with(:image, locals: { drop: drop, body_id: 'image' }).
          and_return('test')

        subject.render_html.should == 'test'
      end
    end

    describe 'a text drop' do
      let(:drop) { stub bookmark?: false, image?: false, text?: true }
      subject { DropPresenter.new drop, template }

      it 'renders the erb template' do
        template.
          should_receive(:erb).
          with(:text, locals: { drop: drop, body_id: 'text' }).
          and_return('test')

        subject.render_html.should == 'test'
      end
    end

    describe 'an unknown drop' do
      let(:drop) { stub bookmark?: false, image?: false, text?: false }

      it 'renders the erb template' do
        template.
          should_receive(:erb).
          with(:other, locals: { drop: drop, body_id: 'other' }).
          and_return('test')

        subject.render_html.should == 'test'
      end
    end
  end
end
