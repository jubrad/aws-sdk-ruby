# WARNING ABOUT GENERATED CODE
#
# This file is generated. See the contributing for info on making contributions:
# https://github.com/aws/aws-sdk-ruby/blob/master/CONTRIBUTING.md
#
# WARNING ABOUT GENERATED CODE

module Aws
  module OpsWorks
    class Layer

      extend Aws::Deprecations

      # @overload def initialize(id, options = {})
      #   @param [String] id
      #   @option options [Client] :client
      # @overload def initialize(options = {})
      #   @option options [required, String] :id
      #   @option options [Client] :client
      def initialize(*args)
        options = Hash === args.last ? args.pop.dup : {}
        @id = extract_id(args, options)
        @data = options.delete(:data)
        @client = options.delete(:client) || Client.new(options)
      end

      # @!group Read-Only Attributes

      # @return [String]
      def id
        @id
      end

      # The layer stack ID.
      # @return [String]
      def stack_id
        data.stack_id
      end

      # The layer ID.
      # @return [String]
      def layer_id
        data.layer_id
      end

      # The layer type.
      # @return [String]
      def type
        data.type
      end

      # The layer name.
      # @return [String]
      def name
        data.name
      end

      # The layer short name.
      # @return [String]
      def shortname
        data.shortname
      end

      # The layer attributes.
      #
      # For the `HaproxyStatsPassword`, `MysqlRootPassword`, and
      # `GangliaPassword` attributes, AWS OpsWorks returns
      # `*****FILTERED*****` instead of the actual value
      #
      # For an ECS Cluster layer, AWS OpsWorks the `EcsClusterArn` attribute
      # is set to the cluster\'s ARN.
      # @return [Hash<String,String>]
      def attributes
        data.attributes
      end

      # The ARN of the default IAM profile to be used for the layer\'s EC2
      # instances. For more information about IAM ARNs, see [Using
      # Identifiers][1].
      #
      #
      #
      # [1]: http://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html
      # @return [String]
      def custom_instance_profile_arn
        data.custom_instance_profile_arn
      end

      # A JSON formatted string containing the layer\'s custom stack
      # configuration and deployment attributes.
      # @return [String]
      def custom_json
        data.custom_json
      end

      # An array containing the layer\'s custom security group IDs.
      # @return [Array<String>]
      def custom_security_group_ids
        data.custom_security_group_ids
      end

      # An array containing the layer\'s security group names.
      # @return [Array<String>]
      def default_security_group_names
        data.default_security_group_names
      end

      # An array of `Package` objects that describe the layer\'s packages.
      # @return [Array<String>]
      def packages
        data.packages
      end

      # A `VolumeConfigurations` object that describes the layer\'s Amazon EBS
      # volumes.
      # @return [Array<Types::VolumeConfiguration>]
      def volume_configurations
        data.volume_configurations
      end

      # Whether auto healing is disabled for the layer.
      # @return [Boolean]
      def enable_auto_healing
        data.enable_auto_healing
      end

      # Whether to automatically assign an [Elastic IP address][1] to the
      # layer\'s instances. For more information, see [How to Edit a
      # Layer][2].
      #
      #
      #
      # [1]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
      # [2]: http://docs.aws.amazon.com/opsworks/latest/userguide/workinglayers-basics-edit.html
      # @return [Boolean]
      def auto_assign_elastic_ips
        data.auto_assign_elastic_ips
      end

      # For stacks that are running in a VPC, whether to automatically assign
      # a public IP address to the layer\'s instances. For more information,
      # see [How to Edit a Layer][1].
      #
      #
      #
      # [1]: http://docs.aws.amazon.com/opsworks/latest/userguide/workinglayers-basics-edit.html
      # @return [Boolean]
      def auto_assign_public_ips
        data.auto_assign_public_ips
      end

      # AWS OpsWorks supports five lifecycle events: **setup**,
      # **configuration**, **deploy**, **undeploy**, and **shutdown**. For
      # each layer, AWS OpsWorks runs a set of standard recipes for each
      # event. In addition, you can provide custom recipes for any or all
      # layers and events. AWS OpsWorks runs custom event recipes after the
      # standard recipes. `LayerCustomRecipes` specifies the custom recipes
      # for a particular layer to be run in response to each of the five
      # events.
      #
      # To specify a recipe, use the cookbook\'s directory name in the
      # repository followed by two colons and the recipe name, which is the
      # recipe\'s file name without the .rb extension. For example:
      # phpapp2::dbsetup specifies the dbsetup.rb recipe in the repository\'s
      # phpapp2 folder.
      # @return [Types::Recipes]
      def default_recipes
        data.default_recipes
      end

      # A `LayerCustomRecipes` object that specifies the layer\'s custom
      # recipes.
      # @return [Types::Recipes]
      def custom_recipes
        data.custom_recipes
      end

      # Date when the layer was created.
      # @return [String]
      def created_at
        data.created_at
      end

      # Whether to install operating system and package updates when the
      # instance boots. The default value is `true`. If this value is set to
      # `false`, you must then update your instances manually by using
      # CreateDeployment to run the `update_dependencies` stack command or
      # manually running `yum` (Amazon Linux) or `apt-get` (Ubuntu) on the
      # instances.
      #
      # <note markdown="1"> We strongly recommend using the default value of `true`, to ensure
      # that your instances have the latest security updates.
      #
      #  </note>
      # @return [Boolean]
      def install_updates_on_boot
        data.install_updates_on_boot
      end

      # Whether the layer uses Amazon EBS-optimized instances.
      # @return [Boolean]
      def use_ebs_optimized_instances
        data.use_ebs_optimized_instances
      end

      # A `LifeCycleEventConfiguration` object that specifies the Shutdown
      # event configuration.
      # @return [Types::LifecycleEventConfiguration]
      def lifecycle_event_configuration
        data.lifecycle_event_configuration
      end

      # @!endgroup

      # @return [Client]
      def client
        @client
      end

      # Loads, or reloads {#data} for the current {Layer}.
      # Returns `self` making it possible to chain methods.
      #
      #     layer.reload.data
      #
      # @return [self]
      def load
        resp = @client.describe_layers(layer_ids: [@id])
        @data = resp.layers[0]
        self
      end
      alias :reload :load

      # @return [Types::Layer]
      #   Returns the data for this {Layer}. Calls
      #   {Client#describe_layers} if {#data_loaded?} is `false`.
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
      # @return [EmptyStructure]
      def delete(options = {})
        options = options.merge(layer_id: @id)
        resp = @client.delete_layer(options)
        resp.data
      end

      # @!group Associations

      # @return [Stack, nil]
      def stack
        if data.stack_id
          Stack.new(
            id: data.stack_id,
            client: @client
          )
        else
          nil
        end
      end

      # @deprecated
      # @api private
      def identifiers
        { id: @id }
      end
      deprecated(:identifiers)

      private

      def extract_id(args, options)
        value = args[0] || options.delete(:id)
        case value
        when String then value
        when nil then raise ArgumentError, "missing required option :id"
        else
          msg = "expected :id to be a String, got #{value.class}"
          raise ArgumentError, msg
        end
      end

      class Collection

        include Aws::Resources::Collection

        # @return [Enumerator<Layer>]
        def each(&block)
          enum = super
          enum.each(&block) if block
          enum
        end

      end
    end
  end
end
