# -*- encoding : utf-8 -*-"
#
# @author Andi Altendorfer <andreas@altendorfer.at>
#

# = BootstrapHelper
# provides some methods to map bootstrap-specific logics.
module BootstrapHelper

  # @param [Symbol] icon - eg: :home, :back, :next, :quit, .... will be mapped with [bootstrap_icon]
  # @return String - HTML-string to 'draw' an icon
  def icon(icon)
    "<i class='#{bootstrap_icon(icon)}'></i>".html_safe
  end

  # Draw link as a bootstrap button
  def button_to(options={}, &block)
    if options[:classes].present?
      options[:classes] += " btn-primary-link" if options[:classes] =~ /(btn-primary)|(btn-danger)/
    end
    content_tag :button, class: "btn #{options[:classes]}" do
      yield
    end
  end


  def caret
    "<b class='caret'></b>".html_safe
  end

  private

  # @param [Symbol] icon - see [icon()]
  # @return String - the icon-class for twitter bootstrap
  def bootstrap_icon(icon)
    case icon.to_s
      when 'home'
        'icon-home'
      else
        'icon-certificate'
    end
  end

end