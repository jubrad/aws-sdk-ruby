# WARNING ABOUT GENERATED CODE
#
# This file is generated. See the contributing for info on making contributions:
# https://github.com/aws/aws-sdk-ruby/blob/master/CONTRIBUTING.md
#
# WARNING ABOUT GENERATED CODE

module Aws
  module RDS
    class DBParameterGroup

      extend Aws::Deprecations

      # @overload def initialize(name, options = {})
      #   @param [String] name
      #   @option options [Client] :client
      # @overload def initialize(options = {})
      #   @option options [required, String] :name
      #   @option options [Client] :client
      def initialize(*args)
        options = Hash === args.last ? args.pop.dup : {}
        @name = extract_name(args, options)
        @data = options.delete(:data)
        @client = options.delete(:client) || Client.new(options)
      end

      # @!group Read-Only Attributes

      # @return [String]
      def name
        @name
      end
      alias :db_parameter_group_name :name

      # Provides the name of the DB parameter group family that this DB
      # parameter group is compatible with.
      # @return [String]
      def db_parameter_group_family
        data.db_parameter_group_family
      end

      # Provides the customer-specified description for this DB parameter
      # group.
      # @return [String]
      def description
        data.description
      end

      # The Amazon Resource Name (ARN) for the DB parameter group.
      # @return [String]
      def db_parameter_group_arn
        data.db_parameter_group_arn
      end

      # @!endgroup

      # @return [Client]
      def client
        @client
      end

      # Loads, or reloads {#data} for the current {DBParameterGroup}.
      # Returns `self` making it possible to chain methods.
      #
      #     db_parameter_group.reload.data
      #
      # @return [self]
      def load
        resp = @client.describe_db_parameter_groups(db_parameter_group_name: @name)
        @data = resp.dbparametergroups[0]
        self
      end
      alias :reload :load

      # @return [Types::DBParameterGroup]
      #   Returns the data for this {DBParameterGroup}. Calls
      #   {Client#describe_db_parameter_groups} if {#data_loaded?} is `false`.
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
      # @option options [required, String] :db_parameter_group_family
      #   The DB parameter group family name. A DB parameter group can be
      #   associated with one and only one DB parameter group family, and can be
      #   applied only to a DB instance running a database engine and engine
      #   version compatible with that DB parameter group family.
      # @option options [required, String] :description
      #   The description for the DB parameter group.
      # @option options [Array<Types::Tag>] :tags
      #   A list of tags.
      # @return [DBParameterGroup]
      def create(options = {})
        options = options.merge(db_parameter_group_name: @name)
        resp = @client.create_db_parameter_group(options)
        DBParameterGroup.new(
          name: resp.data.db_parameter_group.db_parameter_group_name,
          data: resp.data.db_parameter_group,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [required, String] :target_db_parameter_group_identifier
      #   The identifier for the copied DB parameter group.
      #
      #   Constraints:
      #
      #   * Cannot be null, empty, or blank
      #
      #   * Must contain from 1 to 255 alphanumeric characters or hyphens
      #
      #   * First character must be a letter
      #
      #   * Cannot end with a hyphen or contain two consecutive hyphens
      #
      #   Example: `my-db-parameter-group`
      # @option options [required, String] :target_db_parameter_group_description
      #   A description for the copied DB parameter group.
      # @option options [Array<Types::Tag>] :tags
      #   A list of tags.
      # @return [DBParameterGroup]
      def copy(options = {})
        options = options.merge(source_db_parameter_group_identifier: @name)
        resp = @client.copy_db_parameter_group(options)
        DBParameterGroup.new(
          name: resp.data.db_parameter_group.db_parameter_group_name,
          data: resp.data.db_parameter_group,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @return [EmptyStructure]
      def delete(options = {})
        options = options.merge(db_parameter_group_name: @name)
        resp = @client.delete_db_parameter_group(options)
        resp.data
      end

      # @param [Hash] options ({})
      # @option options [required, Array<Types::Parameter>] :parameters
      #   An array of parameter names, values, and the apply method for the
      #   parameter update. At least one parameter name, value, and apply method
      #   must be supplied; subsequent arguments are optional. A maximum of 20
      #   parameters can be modified in a single request.
      #
      #   Valid Values (for the application method): `immediate |
      #   pending-reboot`
      #
      #   <note markdown="1"> You can use the immediate value with dynamic parameters only. You can
      #   use the pending-reboot value for both dynamic and static parameters,
      #   and changes are applied when you reboot the DB instance without
      #   failover.
      #
      #    </note>
      # @return [DBParameterGroup]
      def modify(options = {})
        options = options.merge(db_parameter_group_name: @name)
        resp = @client.modify_db_parameter_group(options)
        DBParameterGroup.new(
          name: resp.data.db_parameter_group_name,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [Boolean] :reset_all_parameters
      #   Specifies whether (`true`) or not (`false`) to reset all parameters in
      #   the DB parameter group to default values.
      #
      #   Default: `true`
      # @option options [Array<Types::Parameter>] :parameters
      #   An array of parameter names, values, and the apply method for the
      #   parameter update. At least one parameter name, value, and apply method
      #   must be supplied; subsequent arguments are optional. A maximum of 20
      #   parameters can be modified in a single request.
      #
      #   **MySQL**
      #
      #   Valid Values (for Apply method): `immediate` \| `pending-reboot`
      #
      #   You can use the immediate value with dynamic parameters only. You can
      #   use the `pending-reboot` value for both dynamic and static parameters,
      #   and changes are applied when DB instance reboots.
      #
      #   **MariaDB**
      #
      #   Valid Values (for Apply method): `immediate` \| `pending-reboot`
      #
      #   You can use the immediate value with dynamic parameters only. You can
      #   use the `pending-reboot` value for both dynamic and static parameters,
      #   and changes are applied when DB instance reboots.
      #
      #   **Oracle**
      #
      #   Valid Values (for Apply method): `pending-reboot`
      # @return [DBParameterGroup]
      def reset(options = {})
        options = options.merge(db_parameter_group_name: @name)
        resp = @client.reset_db_parameter_group(options)
        DBParameterGroup.new(
          name: resp.data.db_parameter_group_name,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [required, String] :subscription_name
      #   The name of the RDS event notification subscription you want to add a
      #   source identifier to.
      # @return [EventSubscription]
      def subscribe_to(options = {})
        options = options.merge(source_identifier: @name)
        resp = @client.add_source_identifier_to_subscription(options)
        EventSubscription.new(
          name: resp.data.event_subscription.cust_subscription_id,
          data: resp.data.event_subscription,
          client: @client
        )
      end

      # @param [Hash] options ({})
      # @option options [required, String] :subscription_name
      #   The name of the RDS event notification subscription you want to remove
      #   a source identifier from.
      # @return [EventSubscription]
      def unsubscribe_from(options = {})
        options = options.merge(source_identifier: @name)
        resp = @client.remove_source_identifier_from_subscription(options)
        EventSubscription.new(
          name: resp.data.event_subscription.cust_subscription_id,
          data: resp.data.event_subscription,
          client: @client
        )
      end

      # @!group Associations

      # @param [Hash] options ({})
      # @option options [Time,DateTime,Date,Integer,String] :start_time
      #   The beginning of the time interval to retrieve events for, specified
      #   in ISO 8601 format. For more information about ISO 8601, go to the
      #   [ISO8601 Wikipedia page.][1]
      #
      #   Example: 2009-07-08T18:00Z
      #
      #
      #
      #   [1]: http://en.wikipedia.org/wiki/ISO_8601
      # @option options [Time,DateTime,Date,Integer,String] :end_time
      #   The end of the time interval for which to retrieve events, specified
      #   in ISO 8601 format. For more information about ISO 8601, go to the
      #   [ISO8601 Wikipedia page.][1]
      #
      #   Example: 2009-07-08T18:00Z
      #
      #
      #
      #   [1]: http://en.wikipedia.org/wiki/ISO_8601
      # @option options [Integer] :duration
      #   The number of minutes to retrieve events for.
      #
      #   Default: 60
      # @option options [Array<String>] :event_categories
      #   A list of event categories that trigger notifications for a event
      #   notification subscription.
      # @option options [Array<Types::Filter>] :filters
      #   This parameter is not currently supported.
      # @return [Event::Collection]
      def events(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(
            source_type: "db-parameter-group",
            source_identifier: @name
          )
          resp = @client.describe_events(options)
          resp.each_page do |page|
            batch = []
            page.data.events.each do |e|
              batch << Event.new(
                source_id: e.source_identifier,
                date: e.date,
                data: e,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Event::Collection.new(batches)
      end

      # @param [Hash] options ({})
      # @option options [String] :source
      #   The parameter types to return.
      #
      #   Default: All parameter types returned
      #
      #   Valid Values: `user | system | engine-default`
      # @option options [Array<Types::Filter>] :filters
      #   This parameter is not currently supported.
      # @return [Parameter::Collection]
      def parameters(options = {})
        batches = Enumerator.new do |y|
          options = options.merge(db_parameter_group_name: @name)
          resp = @client.describe_db_parameters(options)
          resp.each_page do |page|
            batch = []
            page.data.parameters.each do |p|
              batch << Parameter.new(
                name: p.parameter_name,
                data: p,
                client: @client
              )
            end
            y.yield(batch)
          end
        end
        Parameter::Collection.new(batches)
      end

      # @deprecated
      # @api private
      def identifiers
        { name: @name }
      end
      deprecated(:identifiers)

      private

      def extract_name(args, options)
        value = args[0] || options.delete(:name)
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

        # @return [Enumerator<DBParameterGroup>]
        def each(&block)
          enum = super
          enum.each(&block) if block
          enum
        end

      end
    end
  end
end
