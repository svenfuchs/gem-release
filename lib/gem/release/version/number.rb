module Gem
  module Release
    module Version
      class Number < Struct.new(:number, :target)
        EPOCH_NUMBER = /^(?<epoch>\d+)\.(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)(?<stage_delim>\-|\.)?(?<stage>\w+)?\.?(?<stage_num>\d+)?$/
        NUMBER = /^(?<major>\d+)\.?(?<minor>\d+)?\.?(?<patch>\d+)?(?<stage_delim>\-|\.)?(?<stage>\w+)?\.?(?<stage_num>\d+)?$/
        PRE_RELEASE  = /^(\d+)\.(\d+)\.(\d+)\.?(.*)(\d+)$/

        STAGES = %i(alpha beta pre rc)

        def bump
          return target if specific?
          validate_stage
          parts = [[epoch, major, minor, patch].compact.join('.')]
          parts << [stage, num].join('.') if stage
          parts.join(stage_delim)
        end

        def pre?
          !!parts[:stage] || !!parts[:stage_num]
        end

        private

          def specific?
            target =~ NUMBER || target =~ PRE_RELEASE
          end

          def epoch
            part = parts[:epoch] || return
            part += 1 if to?(:epoch)
            part
          end

          def major
            part = parts[:major]
            part = 0 if to?(:epoch)
            part += 1 if to?(:major)
            part
          end

          def minor
            part = parts[:minor].to_i
            part = 0 if to?(:epoch, :major)
            part += 1 if to?(:minor) || fresh_pre_release?
            part
          end

          def patch
            part = parts[:patch].to_i
            part = 0 if to?(:epoch, :major, :minor) || fresh_pre_release?
            part += 1 if to?(:patch) && from_release?
            part
          end

          def stage
            target unless to_release?
          end

          def stage_delim
            # Use what's being used or default to dot (`.`)
            # dot is preferred due to rubygems issue
            # https://github.com/rubygems/rubygems/issues/592
            parts[:stage_delim] || '.'
          end

          def num
            return if to_release?
            same_stage? ? parts[:stage_num] + 1 : 1
          end

          def to?(*targets)
            targets.include?(target)
          end

          def to_release?
            to?(:epoch, :major, :minor, :patch)
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
            parts[:stage]
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
            @parts ||= {
              epoch: (matches[:epoch]&.to_i if matches.names.include?('epoch')),
              major: matches[:major].to_i,
              minor: matches[:minor]&.to_i,
              patch: matches[:patch]&.to_i,
              stage_delim: matches[:stage_delim],
              stage: matches[:stage]&.to_sym,
              stage_num: matches[:stage_num]&.to_i,
            }.compact
        end

        def matches
            @matches = begin
              @matches = number.match(EPOCH_NUMBER) || number.match(NUMBER)
              raise Abort, "Cannot parse version number #{number}" unless @matches
              @matches
            end
          end
      end
    end
  end
end
