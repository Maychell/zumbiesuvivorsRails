class Update < Create
	action :update

	contract do
		property :name, writeable: false
		property :age, writeable: false
		property :gender, writeable: false

		if :infected
			property :items, writeable: false
		end
	end

end