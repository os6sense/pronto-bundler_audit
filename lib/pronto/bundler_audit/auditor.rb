# frozen_string_literal: true

require "pronto/bundler_audit/scanner"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Auditor:
    # 1. updates the local ruby security database, and then
    # 2. runs {Pronto::BundlerAudit::Scanner#call}.
    class Auditor
      # @return (see: #run_scan)
      def call
        Bundler::Audit::Database.update!(quiet: true)
        Scanner.new.call
      end
    end
  end
end
