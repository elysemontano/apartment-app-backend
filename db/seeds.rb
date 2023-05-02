user1 = User.where(email: "test@test.com").first_or_create(password: "testing123", password_confirmation: "testing123")
user2 = User.where(email: "testing@test.com").first_or_create(password: "testing1234", password_confirmation: "testing1234")

user1Apartments = [
    {
        street: "ABC Sesame Street",
        city: "Sesame",
        state: "Isle",
        manager: "Cookie Monster",
        email: "monstermanager@cookies.com",
        price: 15000,
        bedrooms: 1,
        bathrooms: 1,
        pets: "puppets only",
        image: "https://upload.wikimedia.org/wikipedia/commons/0/00/Sesame_Street_buildings_%28193090534%29.jpg"
    }
]

user2Apartments = [
    {
        street: "Wallaby Way",
        city: "Sydney",
        state: "Australia",
        manager: "Shermin",
        email: "pshermin@dentist.com",
        price: 25000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "Fish",
        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWBSF2x6QbX697RXfV7WdOtqCxF9glLOlF_37xL7pvvea_bWK8JkWHu1llBVz8k9LmFbY&usqp=CAU"
    }
]

user1Apartments.each do |apartment|
    user1.apartments.create(apartment)
    p "created: #{apartment}"
end

user2Apartments.each do |apartment|
    user2.apartments.create(apartment)
    p "created: #{apartment}"
end