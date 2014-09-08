require 'google/api_client'
# oauth/oauth_util is not part of the official Ruby client library.
# Get it at http://samples.google-api-ruby-client.googlecode.com/git/oauth/oauth_util.rb
require_relative 'oauth_util'
require 'trollop'

# This code assumes that there's a client_secrets.json file in your current directory,
# which contains OAuth 2.0 information for this application, including client_id and
# client_secret. You can acquire an ID/secret pair from the API Access tab on the
# Google APIs Console
#   <http://code.google.com/apis/console#access>
# For more information about using OAuth2 to access Google APIs, please visit:
#   <https://developers.google.com/accounts/docs/OAuth2>
# For more information about the client_secrets.json file format, please visit:
#   <https://developers.google.com/api-client-library/python/guide/aaa_client_secrets>
# Please ensure that you have enabled the YouTube Data & Analytics APIs for your project.

YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
YOUTUBE_ANALYTICS_API_SERVICE_NAME = 'youtubeAnalytics'
YOUTUBE_ANALYTICS_API_VERSION = 'v3'
YOUTUBE_DATA_API_SERVICE_NAME = 'youtubeData'
YOUTUBE_DATA_API_SERVICE_VERSION = 'v3'

client = Google::APIClient.new(
  key: '',
  authorization: nil,
  application_name:    'Music Stock Market',
  application_version: '0.0.1'
)

youtube           = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
youtube_analytics = client.discovered_api(YOUTUBE_ANALYTICS_API_SERVICE_NAME, YOUTUBE_ANALYTICS_API_VERSION)
youtube_data      = client.discovered_api(YOUTUBE_DATA_API_SERVICE_NAME, YOUTUBE_DATA_API_SERVICE_VERSION)

# Search
opts = Trollop::options do
  opt :q, 'David Guetta',           type: String, default: 'Google'
  opt :max_results, 'Max results', type: :int,   default: 25
  opt :part, 'snippet', type: String
end

channels_response = client.execute!(
  api_method: youtube.search.list,
  parameters: opts
)


opts = Trollop::options do
  opt :metrics,      'Report metrics',                   type: String, default: 'views,comments,favoritesAdded,favoritesRemoved,likes,dislikes,shares'
  opt :dimensions,   'Report dimensions',                type: String, default: 'video'
  opt 'start-date',  'Start date, in YYYY-MM-DD format', type: String, default: 1.week.ago.strftime('%Y-%m-%d')
  opt 'end-date',    'Start date, in YYYY-MM-DD format', type: String, default: 1.day.ago.strftime('%Y-%m-%d')
  opt 'start-index', 'Start index',                      type: :int,   default: 1
  opt 'max-results', 'Max results',                      type: :int,   default: 10
  opt :sort,         'Sort order',                       type: String, default: '-views'
end


channels_response.data.items.each do |channel|
  opts[:ids] = "channel==#{channel.id}"

  analytics_response = client.execute!(
    api_method: youtube_analytics.reports.query,
    parameters: opts
  )

  puts "Analytics Data for Channel #{channel.id}"

  analytics_response.data.columnHeaders.each do |column_header|
    printf '%-20s', column_header.name
  end
  puts

  analytics_response.data.rows.each do |row|
    row.each do |value|
      printf '%-20s', value
    end
    puts
  end
end