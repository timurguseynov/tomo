module Jam
  class Framework
    class SettingsRegistry
      def initialize
        @settings = {}
      end

      def define_settings(definitions)
        settings.merge!(symbolize(definitions)) { |_, existing, _| existing }
      end

      def assign_settings(assignments)
        settings.merge!(symbolize(assignments))
      end

      def to_hash
        hash = Hash[settings.keys.map { |name| [name, fetch(name)] }]
        dump_settings(hash) if Jam.debug?
        hash
      end

      private

      attr_reader :settings

      def symbolize(hash)
        hash.transform_keys(&:to_sym)
      end

      def fetch(name, stack=[])
        raise_circular_dependency_error(name, stack) if stack.include?(name)
        value = settings.fetch(name)
        return value unless value.is_a?(String)

        value.gsub(/%<(\w+)>/) do
          fetch(Regexp.last_match[1].to_sym, stack + [name])
        end
      end

      def raise_circular_dependency_error(name, stack)
        dependencies = [*stack, name].join(" -> ")
        raise "Circular dependency detected in settings: #{dependencies}"
      end

      def dump_settings(hash)
        key_len = hash.keys.map(&:to_s).map(&:length).max
        dump = "Settings: {\n"
        hash.to_a.sort_by(&:first).each do |key, value|
          justified_key = "#{key}:".ljust(key_len + 1)
          dump << "  #{justified_key} #{value.inspect},\n"
        end
        dump << "}"
        Jam.logger.debug(dump)
      end
    end
  end
end
