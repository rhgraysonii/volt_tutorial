# By default Volt generates this controller for your Main component
class MainController < Volt::ModelController
  model :store
  def index
  end

  def about
  end

  def add_link
    _links << { description: page._new_description,
                url: page._new_url }
    go '/links'
  end

  private

  # The main template contains a #template binding that shows another
  # template.  This is the path to that template.  It may change based
  # on the params._controller and params._action values.
  def main_path
    params._controller.or('main') + '/' + params._action.or('index')
  end

  # Determine if the current nav component is the active one by looking
  # at the first part of the url against the href attribute.
  def active_tab?
    url.path.split('/')[1] == attrs.href.split('/')[1]
  end
end
