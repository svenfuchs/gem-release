module Gem
  module Release
    module Version
      class Number < Struct.new(:number, :target)
        NUMBER = /^(\d+)\.(\d+).(\d+).?(\w+)?.?(\d+)?$/

        STAGES = %i(alpha beta pre rc)

        def bump
          return target if specific?
          validate_stage
          [major, minor, patch, stage, num].compact.join('.')
        end

        private

          def specific?
            target =~ NUMBER
          end

          def major
            part = parts[0]
            part += 1 if to?(:major)
            part
          end

          def minor
            part = parts[1]
            part = 0 if to?(:major)
            part += 1 if to?(:minor) || fresh_pre_release?
            part
          end

          def patch
            part = parts[2]
            part = 0 if to?(:major, :minor) || fresh_pre_release?
            part += 1 if to?(:patch) && from_release?
            part
          end

          def stage
            target unless to_release?
          end

          def num
            return if to_release?
            part = parts[4].to_i
            part += 1 if from_release? || same_stage?
            part
          end

          def to?(*targets)
            targets.include?(target)
          end

          def to_release?
            to?(:major, :minor, :patch)
          end

          def fresh_pre_release?
            from_release? && to?(:pre, :rc)
          end

          def from_release?
            !from_pre_release?
          end

          def from_pre_release?
            !!from_stage
          end

          def same_stage?
            from_stage == target
          end

          def from_stage
            parts[3]
          end

          def target
            super || (from_pre_release? ? from_stage : :patch)
          end

          def validate_stage
            from, to = STAGES.index(from_stage), STAGES.index(target)
            return unless from && to && from > to
            raise Abort, "Cannot go from an #{from_stage} version to a #{target} version"
          end

          def parts
            @parts ||= matches.compact.map(&:to_i).tap do |parts|
              parts[3] = matches[3] && matches[3].to_sym
            end
          end

          def matches
            @matches ||= number.match(NUMBER).to_a[1..-1]
          end
      end
    end
  end
end
