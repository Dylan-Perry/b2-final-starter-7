Rails.application.routes.draw do
  root 'welcome#index'

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :coupon_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
    resources :coupons, only: [:index, :show, :new, :create]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end
end
