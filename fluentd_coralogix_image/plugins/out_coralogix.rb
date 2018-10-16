require 'fluent/output'
require 'centralized_ruby_logger'
require 'date'

include Coralogix

module Fluent

  DEFAULT_appname = "FAILED_APP_NAME"
  DEFAULT_subsystemname = "FAILED_SUBSYSTEM_NAME"

  class SomeOutput < Output
    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_output('coralogix', self)
    config_param :log_key_name, :string, :default => nil
    config_param :privatekey, :string, :default => nil
    config_param :appname, :string
    config_param :subsystemname, :string
    config_param :is_json, :bool, :default => false
    config_param :timestamp_key_name, :default => nil
    config_param :force_compression, :bool, :default => false
    config_param :debug, :bool, :default => false
    @configured = false


    # This method is called before starting.
    def configure(conf)
      super
      begin
        @loggers = {}
        #If config parameters doesn't start with $ then we can configure Coralogix logger now.
        if !appname.start_with?("$") && !subsystemname.start_with?("$")
		@logger = CoralogixLogger.new privatekey, appname, subsystemname, debug, "FluentD", force_compression
          @configured = true
        end
      rescue Exception => e
        $log.error "Failed to configure: #{e}"
      end
    end

    def extract record, key, default
      begin
        res = record
        return key unless key.start_with?("$")
        key[1..-1].split(".").each do |k|
          res = res.fetch(k,nil)
          return default if res == nil
        end
        return res
      rescue Exception => e
        $log.error "Failed to extract #{key}: #{e}"
        return default
      end
    end


    def get_app_sub_name(record)
      app_name = extract(record, appname, DEFAULT_appname)
      sub_name = extract(record, subsystemname, DEFAULT_subsystemname)
      return app_name, sub_name
    end

    def get_logger(record)

      return @logger if @configured
      
      app_name, sub_name = get_app_sub_name(record)
      
      if !@loggers.key?("#{app_name}.#{sub_name}")
        @loggers["#{app_name}.#{sub_name}"] = CoralogixLogger.new privatekey, app_name, sub_name
      end

      return @loggers["#{app_name}.#{sub_name}"]
    end


    # This method is called when starting.
    def start
      super
    end

    # This method is called when shutting down.
    def shutdown
      super
    end

    # This method is called when an event reaches Fluentd.
    # 'es' is a Fluent::EventStream object that includes multiple events.
    # You can use 'es.each {|time,record| ... }' to retrieve events.
    # 'chain' is an object that manages transactions. Call 'chain.next' at
    # appropriate points and rollback if it raises an exception.
    #
    # NOTE! This method is called by Fluentd's main thread so you should not write slow routine here. It causes Fluentd's performance degression.
    def emit(tag, es, chain)
      chain.next
      es.each {|time,record|
        logger = get_logger(record)

        log_record = log_key_name != nil ? record.fetch(log_key_name, record) : record
        log_record = is_json ? log_record.to_json : log_record
        log_record = log_record.to_s.empty? ? record : log_record

        timestamp = record.fetch(timestamp_key_name, nil)
        if(timestamp.nil?)
          logger.debug log_record
        else
          begin
            float_timestamp = DateTime.parse(timestamp.to_s).to_time.to_f * 1000
            logger.debug log_record, nil, timestamp:float_timestamp
          rescue Exception => e  
            logger.debug log_record
          end          
        end
      }
    end
  end
end
