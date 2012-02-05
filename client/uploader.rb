require 'java'

path = File.expand_path(File.dirname(__FILE__))
$CLASSPATH << "#{path}/lib"

require 'httpclient-4.1.2.jar'
require 'httpcore-4.1.2.jar'
require 'httpmime-4.1.2.jar'
require 'httpclient-cache-4.1.2.jar'
require 'commons-codec-1.4.jar'
require 'commons-logging-1.1.1.jar'

module JavaLang
  include_package "java.lang"
end

module HttpClient
  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  HttpPost = org.apache.http.client.methods.HttpPost
  MultipartEntity = org.apache.http.entity.mime.MultipartEntity
  FileBody = org.apache.http.entity.mime.content.FileBody

  class Uploader
    include JavaLang::Runnable

    attr_accessor :file_name, :upload_to

    def initialize(file_name, upload_to)
      @file_name = file_name
      @upload_to = upload_to
    end

    def run
      client = HttpClient::DefaultHttpClient.new
      post = HttpClient::HttpPost.new(@upload_to)
      entity = HttpClient::MultipartEntity.new

      file = java.io.File.new @file_name
      entity.addPart("file", HttpClient::FileBody.new(file));
      post.setEntity(entity);

      response = client.execute(post);
    end
    
  end
end

upload_from = "./bin"
upload_to = "http://localhost:8080/upload"

Dir.glob("#{upload_from}/*").select do |file_name|

  JavaLang::Thread.new(HttpClient::Uploader.new(file_name, upload_to)).start

end

