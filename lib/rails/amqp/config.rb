module Rails
  module AMQP
    class Config
      class <<self
        def data
          @data ||= YAML.load_file(
            Rails.root.join('config', 'amqp.yml')
          ).with_indifferent_access
        end

        def connect
          ENV['RABBITMQ_URL'] || data[:connect]
        end

        def binding_exchange_id(id)
          data.dig(:binding, id, :exchange)
        end
    
        def binding_exchange(id)
          eid = binding_exchange_id(id)
          eid && exchange(eid)
        end
    
        def binding_queue(id)
          queue data.dig(:binding, id, :queue)
        end
    
        def binding_worker(id)
          "#{id}_worker".camelize.constantize.new
        end
    
        def routing_keys(id)
          data.dig(:binding, id, :keys) || [binding_queue(id).first]
        end
    
        def topics(id)
          data.dig(:binding, id, :topics)&.split(',')
        end
    
        def channel(id)
          data.dig(:channel, id) || {}
        end
    
        def queue(id)
          name = data.dig(:queue, id, :name)
          settings = { durable: data.dig(:queue, id, :durable) }
    
          [name, settings]
        end
    
        def exchange(id)
          type = data.dig(:exchange, id, :type)
          name = data.dig(:exchange, id, :name)
          [type, name]
        end            
      end
    end
  end
end
