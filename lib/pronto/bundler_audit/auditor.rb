# frozen_string_literal: true

require_relative "results"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Auditor:
    # 1. updates the local ruby security database, and then
    # 2. runs {Pronto::Bundler::Audit::Scanner}.
    # 3. returns results converted to the appropriate format
    class Auditor
      def call
        Bundler::Audit::Database.update!(quiet: true)
        scan.map { |result| match_result(result).call } || []
      end

      private

      def scan
        Bundler::Audit::Scanner.new.scan
      end

      def match_result(scan_result)
        case scan_result
        when Bundler::Audit::Scanner::InsecureSource
          Results::InsecureSource.new(scan_result)
        when Bundler::Audit::Scanner::UnpatchedGem
          Results::UnpatchedGem.new(scan_result)
        else
          raise ArgumentError, "Unexpected type: #{scan_result.class}"
        end
      end
    end
  end
end
