# -*- encoding : utf-8 -*-
module ApplicationHelper
  # kaminari view 原来不提供 total count，覆盖一下
  def paginate(scope, options = {}, &block)
    paginator = Kaminari::Helpers::Paginator.new self, options.reverse_merge(
        :current_page => scope.current_page, :total_pages => scope.total_pages, :per_page => scope.limit_value,
        :param_name => Kaminari.config.param_name, :remote => false, :scope => scope)
    paginator.to_s
  end
end
