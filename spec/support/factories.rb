FactoryGirl.define do
  factory :survivor do
    name 'Fulano'
    age 15
    gender 0

    factory :survivor_joao do
    	name 'Joao'
    end

    factory :survivor_jose do
    	name 'Jose'
    end

    factory :survivor_chelimsky do
    	name 'Chelimsky'
    	gender 1

    	factory :survivor_maria do
	    	name 'Maria'
	    end
    end
  end
end
