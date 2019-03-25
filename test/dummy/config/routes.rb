Rails.application.routes.draw do
  mount Falcon::Tools::Engine => "/falcon-tools"
end
