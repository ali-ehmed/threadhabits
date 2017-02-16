module ActiveAdmin
  class Footer < ActiveAdmin::Views::Footer
    def build(arg = nil)
      super
      render("layouts/admin_footer")
    end
  end
end
