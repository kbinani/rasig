module As
  class RoomConnection
    def initialize(as_client, name, gateway, polling_interval)
      @client = as_client
      @name = name
      @room_id = @client.get_room_id_by_name(@name)
      @gateway = gateway
      @user_list = []
      @part_requested = false

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
              screen_name = message["screen_name"]
              name = message["name"]
              id = message["id"]
              message_body = message["body"]
              message_body = "" if message_body.nil?

              message["attachment"].each { |file|
                disk_filename = file["disk_filename"]
                url = @client.root_url + "/upload/" + URI.encode(disk_filename)
                message_body = message_body + "\n" + url
              }

              @gateway.post_message(@name, screen_name, name, message_body, id)
              since_id = id
            }
          rescue
            p "exception"
          end
          sleep polling_interval
        end
      }
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
