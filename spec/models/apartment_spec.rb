require 'rails_helper'

RSpec.describe Apartment, type: :model do
  # Set reusable user for tests
  let (:user) {User.create email: 'elyse@test.com', password: 'test123', password_confirmation: 'test123'}

  it "should validate street" do
    apartment = Apartment.create(city: "Little Whinging",state: "Surrey",
    manager: "Mr. Potter",
    email: "potter@example.com",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:street]).to include "can't be blank"
  end

  it "should validate city" do
    apartment = Apartment.create(street: "4 Privet Drive", state: "Surrey",
    manager: "Mr. Potter",
    email: "potter@example.com",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:city]).to include "can't be blank"
  end

  it "should validate state" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", 
    manager: "Mr. Potter",
    email: "potter@example.com",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:state]).to include "can't be blank"
  end

  it "should validate manager" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",
    email: "potter@example.com",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:manager]).to include "can't be blank"
  end

  it "should validate email" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:email]).to include "can't be blank"
  end  
  
  it "should validate price" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter", email: "potter@example.com",
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:price]).to include "can't be blank"
  end  

  it "should validate bedrooms" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter", email: "potter@example.com",price: 2000,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:bedrooms]).to include "can't be blank"
  end  

  it "should validate bathrooms" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter", email: "potter@example.com",price: 2000, bedrooms: 3,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:bathrooms]).to include "can't be blank"
  end  

  it "should validate pets" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter", email: "potter@example.com",price: 2000, bedrooms: 3, bathrooms: 2,
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg", user_id: user.id)

      expect(apartment.errors[:pets]).to include "can't be blank"
  end  

  it "should validate image" do
    apartment = Apartment.create(city: "Little Whinging", street: "4 Privet Drive", state: "Surrey",manager: "Mr. Potter", email: "potter@example.com",price: 2000, bedrooms: 3, bathrooms: 2, pets: "yes", user_id: user.id)

    expect(apartment.errors[:image]).to include "can't be blank"
  end 

  it "should validate user_id" do
    apartment = Apartment.create(street: "4 Privet Drive",
    city: "Little Whinging",
    state: "Surrey",
    manager: "Mr. Potter",
    email: "potter@example.com",
    price: 2000,
    bedrooms: 3,
    bathrooms: 2,
    pets: "yes",
    image:
      "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg")

      expect(apartment.errors[:user_id]).to include "can't be blank"
  end
end

