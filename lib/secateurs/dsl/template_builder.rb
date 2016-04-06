require "jbuilder"

module Secateurs
  class DSL
    class TemplateBuilder < Jbuilder
      def partial!(func, *args)
        instance_exec(*args, &func)
      end
    end
  end
end
