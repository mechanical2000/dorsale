Dorsale::Engine.routes.draw do
  # Comments

  resources :comments, only: [:create, :edit, :update, :destroy]

  # Users

  resources :users, except: [:destroy]

  # Alexandrie / Attachments

  namespace :alexandrie do
    resources :attachments, only: [:index, :create, :edit, :update, :destroy]
  end

  # Flyboy

  namespace :flyboy do
    resources :tasks do
      get :summary, on: :collection
      member do
        patch :complete
        patch :snooze
        patch :copy
      end
    end

    resources :task_comments, only: [:create]
  end

  # Billing Machine

  namespace :billing_machine do
    resources :payment_terms, except: [:destroy, :show]

    resources :invoices, except: [:destroy] do
      member do
        get :copy
        patch :pay
        match :email, via: [:get, :post]
      end
    end

    resources :quotations do
      member do
        post :copy
        get :create_invoice
        match :email, via: [:get, :post]
      end
    end
  end

  # Customer Vault

  get "customer_vault/corporations" => "customer_vault/people#corporations"
  get "customer_vault/individuals"  => "customer_vault/people#individuals"

  namespace :customer_vault do
    resources :activity_types, except: [:destroy, :show]
    resources :origins, except: [:destroy, :show]

    resources :events, only: [:index, :create, :edit, :update, :destroy]

    resources :people do
      resources :links

      member do
        get :tasks
        get :invoices
      end
    end

    resources :corporations, path: "people", except: [:new] do
      resources :links, except: [:index]
    end

    resources :individuals,  path: "people", except: [:new] do
      resources :links, except: [:index]
    end

    resources :corporations, only: [:new, :create], controller: :people
    resources :individuals,  only: [:new, :create], controller: :people
  end

  # Expense Gun

  namespace :expense_gun do
    resources :categories, except: [:destroy, :show]

    resources :expenses, except: [:destroy] do
      member do
        get :copy
        patch :submit
        patch :accept
        patch :refuse
        patch :cancel
      end
    end

    get "/" => redirect{ ExpenseGun::Engine.routes.url_helpers.expenses_path }
  end
end
