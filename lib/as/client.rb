module As
  class Client
    def initialize(root_url, api_key)
      @root_url = root_url
      @api_entry = @root_url + "/api/v1"
      @api_key = api_key
      @uri = URI(@api_entry)
    end

    def message_list(room_id, since_id)
      begin
        query = "room_id=#{room_id}&api_key=#{@api_key}" + (since_id.nil? ? "" : "&since_id=#{since_id}")
        response = Net::HTTP.start(@uri.host, @uri.port) { |http|
          http.get(@uri.path + "/message/list.json?" + query)
        }
        return JSON.parse(response.body)
      rescue
        return []
      end
    end

    def room_list
      begin
        response = Net::HTTP.start(@uri.host, @uri.port) { |http|
          http.get(@uri.path + "/room/list.json?api_key=#{@api_key}")
        }
        return JSON.parse(response.body)
      rescue
        return []
      end
    end

    def post_message(room_id, message)
      response = Net::HTTP.start(@uri.host, @uri.port) { |http|
        http.post(@uri.path + "/message.json",
                  "room_id=#{room_id}&message=#{message}&api_key=#{@api_key}")
      }
      result = JSON.parse(response.body)
      result["message_id"]
    end

    def get_screen_name(name)
      response = Net::HTTP.start(@uri.host, @uri.port) { |http|
        http.get(@uri.path + "/user.json?api_key=#{@api_key}")
      }
      result = JSON.parse(response.body)
      result["screen_name"]
    end

    def get_room_id_by_name(channel)
      room_list.select { |room|
        sanitize_room_name(room["name"]) == channel
      }.map { |room|
        room["id"]
      }.first
    end

    def channel_exists?(channel)
      not get_room_id_by_name(channel).nil?
    end

    def get_room_name_by_id(room_id)
      room_list.select { |room|
        room["id"] == room_id
      }.map { |room|
        sanitize_room_name(room["name"])
      }.first
    end

    def sanitize_room_name(room_name)
      room_name.gsub(/ /, "_")
    end

    def root_url
      @root_url
    end
  end
end
