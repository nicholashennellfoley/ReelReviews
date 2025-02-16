# frozen_string_literal: true

require 'aws-sdk-s3'

# S3Manager is a class responsible for managing S3 operations
# such as listing all S3 buckets in the current AWS account.
class S3Manager
  def initialize(client)
    @client = client
    @logger = Logger.new($stdout)
  end

  def list_objects(bucket)
    @logger.info('Here are the objects in the bucket:')

    response = @client.list_objects_v2({
      bucket: bucket
    })
    if response.contents.empty?
      @logger.info("You don't have any objects in the bucket.")
    else
      response.contents
    end
  rescue Aws::Errors::ServiceError => e
    @logger.error("Encountered an error while listing objects: #{e.message}")
  end
end