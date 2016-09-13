# WARNING ABOUT GENERATED CODE
#
# This file is generated. See the contributing for info on making contributions:
# https://github.com/aws/aws-sdk-ruby/blob/master/CONTRIBUTING.md
#
# WARNING ABOUT GENERATED CODE

module Aws
  module Glacier
    class Vault

      extend Aws::Deprecations

      # @overload def initialize(account_id, name, options = {})
      #   @param [String] account_id
      #   @param [String] name
      #   @option options [Client] :client
      # @overload def initialize(options = {})
      #   @option options [required, String] :account_id
      #   @option options [required, String] :name
      #   @option options [Client] :client
      def initialize(*args)
        options = Hash === args.last ? args.pop.dup : {}
        @account_id = extract_account_id(args, options)
        @name = extract_name(args, options)
        @data = options.delete(:data)
        @client = options.delete(:client) || Client.new(options)
      end

      # @!group Read-Only Attributes

      # @return [String]
      def account_id
        @account_id
      end

      # @return [String]
      def name
        @name
      end
      alias :vault_name :name

      # The Amazon Resource Name (ARN) of the vault.
      # @return [String]
      def vault_arn
        data.vault_arn
      end

      # The UTC date when the vault was created. A string representation of
      # ISO 8601 date format, for example, \"2012-03-20T17:03:43.221Z\".
      # @return [Time]
      def creation_date
        data.creation_date
      end

      # The UTC date when Amazon Glacier completed the last vault inventory. A
      # string representation of ISO 8601 date format, for example,
      # \"2012-03-20T17:03:43.221Z\".
      # @return [Time]
      def last_inventory_date
        data.last_inventory_date
      end

      # The number of archives in the vault as of the last inventory date.
      # This field will return `null` if an inventory has not yet run on the
      # vault, for example, if you just created the vault.
      # @return [Integer]
      def number_of_archives
        data.number_of_archives
      end

      # Total size, in bytes, of the archives in the vault as of the last
      # inventory date. This field will return null if an inventory has not
      # yet run on the vault, for example, if you just created the vault.
      # @return [Integer]
      def size_in_bytes
        data.size_in_bytes
      end

      # @!endgroup

      # @return [Client]
      def client
        @client
      end

      # Loads, or reloads {#data} for the current {Vault}.
      # Returns `self` making it possible to chain methods.
      #
      #     vault.reload.data
      #
      # @return [self]
      def load
        resp = @client.describe_vault(
          vault_name: @name,
          account_id: @account_id
        )
        @data = resp.data
        self
      end
      alias :reload :load

      # @return [Types::DescribeVaultOutput]
      #   Returns the data for this {Vault}. Calls
      #   {Client#describe_vault} if {#data_loaded?} is `false`.
      def data
        load unless @data
        @data
      end

      # @return [Boolean]
      #   Returns `true` if this resource is loaded.  Accessing attributes or
      #   {#data} on an unloaded resource will trigger a call to {#load}.
      def data_loaded?
        !!@data
      end

      # @!group Actions

      # @param [Hash] options ({})
      # @return [Types::CreateVaultOutput]
      def create(options = {})
        options = options.merge(
          vault_name: @name,
          account_id: @account_id
        )
        resp = @client.create_vault(options)
        resp.data
      end

      # @param [Hash] options ({})
      # @return [EmptyStructure]
      def delete(options = {})
        options = options.merge(
          vault_name: @name,
          account_id: @account_id
        )
        resp = @client.delete_vault(options)
        resp.data
      end

      # @param [Hash] options ({})
      # @return [Job]
      def initiate_inventory_retrieval(options = {})
        options = Aws::Util.deep_merge(options,
          vault_name: @name,
          account_id: @account_id,
          job_parameters: {
            type: "inventory-retrieval"
          }
        )
        resp = @client.initiate_job(options)
        Job.new(
          id: resp.data.job_id,
          account_id: @account_id,
          vault_name: @name,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [String] :archive_description
      #   The archive description that you are uploading in parts.
      #
      #   The part size must be a megabyte (1024 KB) multiplied by a power of 2,
      #   for example 1048576 (1 MB), 2097152 (2 MB), 4194304 (4 MB), 8388608 (8
      #   MB), and so on. The minimum allowable part size is 1 MB, and the
      #   maximum is 4 GB (4096 MB).
      # @option options [Integer] :part_size
      #   The size of each part except the last, in bytes. The last part can be
      #   smaller than this part size.
      # @return [MultipartUpload]
      def initiate_multipart_upload(options = {})
        options = options.merge(
          vault_name: @name,
          account_id: @account_id
        )
        resp = @client.initiate_multipart_upload(options)
        MultipartUpload.new(
          id: resp.data.upload_id,
          account_id: @account_id,
          vault_name: @name,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [String] :archive_description
      #   The optional description of the archive you are uploading.
      # @option options [String] :checksum
      #   The SHA256 tree hash of the data being uploaded.
      # @option options [String, IO] :body
      #   The data to upload.
      # @return [Archive]
      def upload_archive(options = {})
        options = options.merge(
          vault_name: @name,
          account_id: @account_id
        )
        resp = @client.upload_archive(options)
        Archive.new(
          id: resp.data.archive_id,
          account_id: @account_id,
          vault_name: @name,
          client: @client
        )
      end

      # @!group Associations

      # @return [Account]
      def account
        Account.new(
          id: @account_id,
          client: @client
        )
      end

      # @param [String] id
      # @return [Archive]
      def archive(id)
        Archive.new(
          account_id: @account_id,
          vault_name: @name,
          id: id,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [String] :statuscode
      #   Specifies the type of job status to return. You can specify the
      #   following values: \"InProgress\", \"Succeeded\", or \"Failed\".
      # @return [Job::Collection]
      def completed_jobs(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            account_id: @account_id,
            vault_name: @name,
            completed: "true"
          )
          resp = @client.list_jobs(options)
          resp.each_page do |page|
            batch = []
            page.data.job_list.each do |j|
              batch << Job.new(
                account_id: @account_id,
                vault_name: @name,
                id: j.job_id,
                data: j,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Job::Collection.new(batches)
      end

      # @param [Hash] options ({})
      # @option options [String] :completed
      #   Specifies the state of the jobs to return. You can specify `true` or
      #   `false`.
      # @return [Job::Collection]
      def failed_jobs(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            account_id: @account_id,
            vault_name: @name,
            statuscode: "Failed"
          )
          resp = @client.list_jobs(options)
          resp.each_page do |page|
            batch = []
            page.data.job_list.each do |j|
              batch << Job.new(
                account_id: @account_id,
                vault_name: @name,
                id: j.job_id,
                data: j,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Job::Collection.new(batches)
      end

      # @param [String] id
      # @return [Job]
      def job(id)
        Job.new(
          account_id: @account_id,
          vault_name: @name,
          id: id,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [String] :statuscode
      #   Specifies the type of job status to return. You can specify the
      #   following values: \"InProgress\", \"Succeeded\", or \"Failed\".
      # @option options [String] :completed
      #   Specifies the state of the jobs to return. You can specify `true` or
      #   `false`.
      # @return [Job::Collection]
      def jobs(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            account_id: @account_id,
            vault_name: @name
          )
          resp = @client.list_jobs(options)
          resp.each_page do |page|
            batch = []
            page.data.job_list.each do |j|
              batch << Job.new(
                account_id: @account_id,
                vault_name: @name,
                id: j.job_id,
                data: j,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Job::Collection.new(batches)
      end

      # @param [Hash] options ({})
      # @option options [String] :completed
      #   Specifies the state of the jobs to return. You can specify `true` or
      #   `false`.
      # @return [Job::Collection]
      def jobs_in_progress(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            account_id: @account_id,
            vault_name: @name,
            statuscode: "InProgress"
          )
          resp = @client.list_jobs(options)
          resp.each_page do |page|
            batch = []
            page.data.job_list.each do |j|
              batch << Job.new(
                account_id: @account_id,
                vault_name: @name,
                id: j.job_id,
                data: j,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Job::Collection.new(batches)
      end

      # @param [Hash] options ({})
      # @return [MultipartUpload::Collection]
      def multipart_uplaods(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            vault_name: @name,
            account_id: @account_id
          )
          resp = @client.list_multipart_uploads(options)
          resp.each_page do |page|
            batch = []
            page.data.uploads_list.each do |u|
              batch << MultipartUpload.new(
                account_id: @account_id,
                vault_name: @name,
                id: u.multipart_upload_id,
                data: u,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        MultipartUpload::Collection.new(batches)
      end

      # @param [String] id
      # @return [MultipartUpload]
      def multipart_upload(id)
        MultipartUpload.new(
          account_id: @account_id,
          vault_name: @name,
          id: id,
          client: @client
        )
      end

      # @return [Notification]
      def notification
        Notification.new(
          account_id: @account_id,
          vault_name: @name,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [String] :completed
      #   Specifies the state of the jobs to return. You can specify `true` or
      #   `false`.
      # @return [Job::Collection]
      def succeeded_jobs(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            account_id: @account_id,
            vault_name: @name,
            statuscode: "Succeeded"
          )
          resp = @client.list_jobs(options)
          resp.each_page do |page|
            batch = []
            page.data.job_list.each do |j|
              batch << Job.new(
                account_id: @account_id,
                vault_name: @name,
                id: j.job_id,
                data: j,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Job::Collection.new(batches)
      end

      # @deprecated
      # @api private
      def identifiers
        {
          account_id: @account_id,
          name: @name
        }
      end
      deprecated(:identifiers)

      private

      def extract_account_id(args, options)
        value = args[0] || options.delete(:account_id)
        case value
        when String then value
        when nil then raise ArgumentError, "missing required option :account_id"
        else
          msg = "expected :account_id to be a String, got #{value.class}"
          raise ArgumentError, msg
        end
      end

      def extract_name(args, options)
        value = args[1] || options.delete(:name)
        case value
        when String then value
        when nil then raise ArgumentError, "missing required option :name"
        else
          msg = "expected :name to be a String, got #{value.class}"
          raise ArgumentError, msg
        end
      end

      class Collection

        include Aws::Resources::Collection

        # @return [Enumerator<Vault>]
        def each(&block)
          enum = super
          enum.each(&block) if block
          enum
        end

      end
    end
  end
end
