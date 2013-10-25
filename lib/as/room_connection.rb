#!/usr/bin/env ruby
# coding: utf-8

require 'date'

module As
  class RoomConnection
    def initialize(as_client, name, polling_interval)
      @client = as_client
      @name = name
      @polling_interval = polling_interval
      @room_id = @client.get_room_id_by_name(@name)
      @user_list = []
      @part_requested = false
    end

    def observe(&block)
      @thread = Thread.new {
        since_id = nil
        start_time = Time.now
        while not @part_requested do
          begin
            message_list = @client.message_list(@room_id, since_id)
            message_list.select { |message|
              message["id"] != since_id
            }.each.select { |message|
              # 過去の発言を拾わないように、起動時刻以降のメッセージのみを対象にする。
              created_datetime = DateTime.parse(message["created_at"])
              created_time = Time.local(created_datetime.year, created_datetime.month, created_datetime.day,
                                        created_datetime.hour, created_datetime.min, created_datetime.sec)
              (created_time - start_time) >= 0
            }.each { |message|
              block.call(message) if block_given?
              since_id = message["id"]
            }
          rescue => e
            p e
          end
          sleep @polling_interval
        end
      }
    end

    def join
      @thread.join
    end

    def post_message(message)
      @client.post_message(@room_id, message)
    end

    def user_exists?(user)
      @user_list.include?(user)
    end

    def user_add(user)
      @user_list << user unless @user_list.include?(user)
    end

    def part
      @part_requested = true
      @thread.join
    end
  end
end
