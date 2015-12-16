class Dorsale::UserScope
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Common

  def colleagues(context = nil)
    User.all
  end

  def comments
    Dorsale::Comment.all
  end

  # Flyboy

  def folders
    Dorsale::Flyboy::Folder.all
  end

  def new_folder(*args)
    folders.new(*args)
  end

  def tasks
    Dorsale::Flyboy::Task.all
  end

  def new_task(*args)
    tasks.new(*args)
  end

  # CustomerVault

  def individuals
    Dorsale::CustomerVault::Individual.all
  end

  def new_individual(*args)
    individuals.new(*args)
  end

  def corporations
    Dorsale::CustomerVault::Corporation.all
  end

  def new_corporation(*args)
    corporations.new(*args)
  end

  def people
    (individuals + corporations).sort_by { |e| e.name.downcase }
  end

end
