class Sniphub
  module Operations
    class Result
      attr_reader :status, :result

      def initialize(status, result)
        @status, @result = status, result
      end

      def success?
        status == :ok
      end
    end
  end
end
