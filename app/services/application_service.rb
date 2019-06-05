class ApplicationService
  extend Dry::Initializer

  class << self
    def call(*args, &block)
      new(*args).call(&block)
    end

    def new(*args)
      args << args.pop.symbolize_keys if args.last.is_a?(Hash)
      super(*args)
    end
  end
end
