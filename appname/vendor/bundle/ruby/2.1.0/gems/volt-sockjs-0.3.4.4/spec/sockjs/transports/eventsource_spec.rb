#!/usr/bin/env bundle exec rspec
# encoding: utf-8

require "spec_helper"

require "sockjs"
require "sockjs/transports/eventsource"

describe SockJS::Transports::EventSource, :type => :transport, :em => true do
  transport_handler_eql "/eventsource", "GET"

  describe "#handle(request)" do
    let(:request) do
      @request ||= begin
        request = FakeRequest.new
        request.path_info = "/echo/a/b/eventsource"
        request
      end
    end

    let(:response) do
      def transport.try_timer_if_valid(*)
      end

      transport.handle(request)
    end

    it "should respond with HTTP 200" do
      response.status.should eql(200)
    end

    it "should respond with event stream MIME type" do
      response.headers["Content-Type"].should match("text/event-stream")
    end

    it "should disable caching" do
      response.headers["Cache-Control"].should eql("no-store, no-cache, must-revalidate, max-age=0")
    end

    it "should write two empty lines for Opera" do
      response # Run the handler.

      pending 'We do split("\r\n"), remember?' do
        response.chunks[0].should eql("")
      end
    end
  end

  describe "#format_frame(payload)" do
    it "should format payload"
  end

  describe "#escape_selected(*args)" do
    it "should escape given payload"
  end
end
