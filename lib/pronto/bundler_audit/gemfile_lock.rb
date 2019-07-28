# frozen_string_literal: true

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::GemfileLock scans the given `path` for
    # the given `gem_name` and returns a `Pronto::Git::Line` with relevant
    # info (supplied by Pronto::Git::Line and Pronto::Git::Patch stand-in
    # objects).
    #
    class GemfileLock
      def initialize(gem_name:, path: GEMFILE_LOCK_FILENAME)
        unless File.exist?(path)
          raise ArgumentError, "Gemfile.lock path not found"
        end

        @gem_name = gem_name
        @path = path
      end

      def call
        return unless (found_line_number = determine_line_number)
        found_line_number
      end

      private

      def determine_line_number
        File.foreach(@path).with_index do |line, index|
          break index.next if line.include?(@gem_name)
        end
      end
    end
  end
end
