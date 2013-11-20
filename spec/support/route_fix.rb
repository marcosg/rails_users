# workaround, to set default locale for ALL spec
# https://github.com/rspec/rspec-rails/issues/255

# class ActionView::TestCase::TestController
#   def default_url_options(options={})
#     { :locale => I18n.default_locale }
#   end
# end

class ActionDispatch::Routing::RouteSet::NamedRouteCollection::UrlHelper
  def call(t, args)
#  	locale = { locale: I18n.default_locale }.merge( { locale: I18n.locale } )
  	locale = { locale: I18n.default_locale } 
    t.url_for(handle_positional_args(t, args, locale.merge( @options ), @segment_keys))
#   t.url_for(handle_positional_args(t, args, { locale: I18n.default_locale }.merge( @options ), @segment_keys))

  end
end

