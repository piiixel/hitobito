module JublaJubla
  class Wagon < Rails::Engine
    include Wagons::Wagon
    
    # Set the required application version.
    app_requirement '>= 0'

    # Add a load path for this specific wagon
    # config.autoload_paths += %W( #{config.root}/lib )

    config.to_prepare do
      # extend application classes here
      Person.send :include, Jubla::Person
      Group.send  :include, Jubla::Group
      Role.send   :include, Jubla::Role
    end 


    private

    def seed_fixtures
      fixtures = root.join('db', 'seeds')
      ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end
  end
end