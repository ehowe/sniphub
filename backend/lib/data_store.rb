module DataStore
  NotImplementedError = Class.new(RuntimeError)

  module ClassMethods
    #def get(id)
      #raise DataStore::NotImplementedError
    #end

    #def where(params={})
      #raise DataStore::NotImplementedError
    #end

    def table
      @table
    end

    protected

    def table=(table)
      @table = table
    end
  end

  module InstanceMethods
    #def save(params={})
      #raise DataStore::NotImplementedError
    #end
  end

  def self.for(adapter)
    require_relative "data_stores/#{adapter}"

    Object.const_get("DataStore::#{adapter.capitalize}")
  end
end
