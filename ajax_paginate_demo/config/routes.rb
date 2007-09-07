ActionController::Routing::Routes.draw do |map|
    map.resources :users
    map.connect '', :controller => "users"
end
