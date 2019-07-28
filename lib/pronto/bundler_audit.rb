# frozen_string_literal: true

require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Updates the Ruby Advisory Database,
  # 2. Runs bundle-audit to scan the Gemfile.lock, and then
  # 4. Returns an Array of Pronto::Message objects if any issues or advisories
  # are found.

  Line = Struct.new(:line_number) do
    alias :new_lineno :line_number
  end

  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock"

    # @return [Array<Pronto::Message>] per Pronto expectation
    def run
      results = Auditor.new.call

      return [] unless results && results.size > 0

      #require 'pry'
      #binding.pry
      results.map do |result|
        Message.new(GEMFILE_LOCK_FILENAME,
                    Line.new(line_number: result.line),
                    result.level,
                    result.message,
                    @patches.commit,
                    self.class)
      end
    end
  end
end

require "pronto/bundler_audit/version"
require "pronto/bundler_audit/auditor"
