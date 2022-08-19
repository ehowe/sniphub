class Sniphub
  class Presenter
    attr_reader :object, :options

    def self.display(object, options = {})
      new(object, options).attributes
    end

    def initialize(object, options)
      @object  = object
      @options = options
    end
  end
end
