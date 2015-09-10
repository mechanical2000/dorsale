class Dorsale::UserScope
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Common

  def colleagues(context = nil)
    raise NotImplementedError
  end

  def comments
    raise NotImplementedError
  end

  # Flyboy

  def folders
    raise NotImplementedError
  end

  def tasks
    raise NotImplementedError
  end

  def new_folder
    raise NotImplementedError
  end

  def new_task
    raise NotImplementedError
  end

  # Customer Vault

  def individuals
    raise NotImplementedError
  end

  def new_individual
    raise NotImplementedError
  end

  def corporations
    raise NotImplementedError
  end

  def new_corporation
    raise NotImplementedError
  end

  def people
    raise NotImplementedError
  end

end
