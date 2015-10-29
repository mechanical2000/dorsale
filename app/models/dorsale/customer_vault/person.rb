module Dorsale
  module CustomerVault
    class Person < ActiveRecord::Base
      self.abstract_class = true

      after_destroy :destroy_links

      acts_as_taggable

      def tags_on(*args)
        super(*args).order(:name)
      end

      has_many :comments, -> { order("id DESC") }, class_name: ::Dorsale::Comment, as: :commentable
      has_one :address, class_name: ::Dorsale::Address, as: :addressable, inverse_of: :addressable, dependent: :destroy
      has_many :tasks, class_name: ::Dorsale::Flyboy::Task, as: :taskable, dependent: :destroy
      accepts_nested_attributes_for :address, allow_destroy: true

      def links
        a = Link.where(alice_id: self.id, alice_type: self.class).map {|l| {title: l.title, person: l.bob, origin: l}}
        b = Link.where(bob_id: self.id, bob_type: self.class).map {|l| {title: l.title, person: l.alice, origin: l}}
        return a + b
      end

      def destroy_links
        links.map{ |l| l[:origin].destroy! }
      end

    end
  end
end
