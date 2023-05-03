require 'rails_helper'

RSpec.describe "Apartments", type: :request do
  let (:user) {User.create email: 'elyse@test.com', password: 'test123', password_confirmation: 'test123'}

  # ---- Endpoint Request Specs ----
  describe "GET /index" do
    it "gets a list of apartments" do
      user.apartments.create(street: "4 Privet Drive",
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

        get '/apartments'

        apartment = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(apartment.length).to eq 1
    end
  end

  describe "POST/create" do
    it "creates an apartment" do
      apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post '/apartments', params: apartment_params

      expect(response).to have_http_status(200)
      apartment = Apartment.first
      expect(apartment.street).to eq "4 Privet Drive"
      expect(apartment.city).to eq "Little Whinging"
      expect(apartment.state).to eq "Surrey"
      expect(apartment.manager).to eq "Mr. Potter"
      expect(apartment.email).to eq "potter@example.com"
      expect(apartment.price).to eq "2000"
      expect(apartment.bedrooms).to eq 3
      expect(apartment.bathrooms).to eq 2
      expect(apartment.pets).to eq "yes"
      expect(apartment.image).to eq "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg"
    end
  end

  describe "PATCH/update" do
    it "updates an apartment" do
      apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      apartment = Apartment.first

      updated_apartment_params = {
        apartment: {
          street: "4 Privet Drive",
          city: "Little Whinging",
          state: "Surrey",
          manager: "Mr. Potter",
          email: "potter@example.com",
          price: "2500",
          bedrooms: 3,
          bathrooms: 2,
          pets: "yes",
          image:
            "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
          user_id: user.id
          }
      }

      patch "/apartments/#{apartment.id}", params: updated_apartment_params

      updated_apartment = Apartment.find(apartment.id)
      expect(response).to have_http_status(200)
      expect(updated_apartment.price).to eq "2500"
    end
  end


  describe "DELETE/destroy" do 
    it "deletes an apartment" do
      apartment_params = {
        apartment: {
          street: "4 Privet Drive",
          city: "Little Whinging",
          state: "Surrey",
          manager: "Mr. Potter",
          email: "potter@example.com",
          price: 2000,
          bedrooms: 3,
          bathrooms: 2,
          pets: "yes",
          image:
            "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
          user_id: user.id
          }
      }

      post "/apartments", params: apartment_params
      apartment = Apartment.first
      delete "/apartments/#{apartment.id}"
      expect(response).to have_http_status(200)
      apartments = Apartment.all
      expect(apartments).to be_empty
    end
  end


  # ---- Validation Request Specs ----

  it "does not create an apartment without a street" do
    apartment_params = {
        apartment: {
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['street']).to include "can't be blank"
  end

  it "does not create an apartment without a city" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['city']).to include "can't be blank"
  end

  it "does not create an apartment without a state" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['state']).to include "can't be blank"
  end
  it "does not create an apartment without a manager" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['manager']).to include "can't be blank"
  end
  it "does not create an apartment without a email" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['email']).to include "can't be blank"
  end

  it "does not create an apartment without a price" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['price']).to include "can't be blank"
  end

  it "does not create an apartment without a bedrooms" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['bedrooms']).to include "can't be blank"
  end

  it "does not create an apartment without a bathrooms" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['bathrooms']).to include "can't be blank"
  end

  it "does not create an apartment without a pets" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['pets']).to include "can't be blank"
  end

  it "does not create an apartment without a image" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        user_id: user.id
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['image']).to include "can't be blank"
  end

  it "does not create an apartment without a user" do
    apartment_params = {
        apartment: {
        street: "4 Privet Drive",
        city: "Little Whinging",
        state: "Surrey",
        manager: "Mr. Potter",
        email: "potter@example.com",
        price: 2000,
        bedrooms: 3,
        bathrooms: 2,
        pets: "yes",
        image:
          "https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg",
        }
      }

      post "/apartments", params: apartment_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['user_id']).to include "can't be blank"
  end
end