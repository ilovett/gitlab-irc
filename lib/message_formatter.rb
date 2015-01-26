require 'multi_json'
require 'googl'

class MessageFormatter
  def self.messages(json)
    p json
    data = MultiJson.load(json)
    if data['object_kind']
      if data['object_kind'] == "issue"
        return self.parse_issue(data)
      end
    else
      return self.parse_commit(data)
    end
  end

  def self.parse_issue(data)
    msgs = []
    msg = "Issue \##{data['object_attributes']['iid']} (#{data['object_attributes']['state']}) \"#{data['object_attributes']['title']}\" has been updated."
    msgs << msg
    return msgs
  end

  def self.parse_commit(data)
    msgs = []
    branch = data['ref'].split('/').last
    data['commits'].each do |ci|
      url = self.short_url(ci['url'])
      # url = ci['url']
      author = ci['author']['name']
      ci_title = ci['message'].lines.first.chomp
      msg = "#{data['repository']['name']} (#{branch}) | #{url} | #{ci_title}"
      # msg = "#{data['repository']['name']} (#{branch}) | #{ci_title} | #{ci['author']['name']} | #{url}"
      msgs << msg
    end
    return msgs
  end

  def self.short_url(url)
    Googl.shorten(url).short_url
  end

end
