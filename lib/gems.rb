module Gems
    extend self

    def defang!
        Kernel.module_eval do
            alias :old_gem :gem
            def gem(*args)
                raise LoadError if args.first == 'mongrel_experimental'
                raise Gem::LoadError if args.first == 'i18n'
            end
        end
    end

    def refang!
        Kernel.module_eval do
            alias :gem :old_gem
        end
    end

    def fanged(&block)
        refang!
        block.call
        defang!
    end
end

Gems.defang!
