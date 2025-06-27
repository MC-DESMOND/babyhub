import requests
import json
import random
import time

BASE_URL = "http://localhost:8080"

def create_and_login_user(email, password, name):
    print(f"Creating user: {email}")
    user_data = {
        "name": name,
        "email": email,
        "password": password
    }
    try:
        user_create_response = requests.post(f"{BASE_URL}/user/create", json=user_data)
        if user_create_response.status_code == 200:
            print(f"User creation successful: {user_create_response.text}")
        elif user_create_response.status_code == 400 and "already exists" in user_create_response.text:
            print(f"User {email} already exists.")
        else:
            print(f"User creation failed: {user_create_response.status_code} - {user_create_response.text}")
            return None

        print(f"Logging in user: {email}")
        login_data = {
            "email": email,
            "password": password
        }
        login_response = requests.post(f"{BASE_URL}/auth/signin", json=login_data)
        login_response.raise_for_status() # Raise HTTPError for bad responses (4xx or 5xx)
        jwt_token = login_response.json().get('accessToken')
        user_id = login_response.json().get('id')
        print(f"Login successful. User ID: {user_id}, Token: {jwt_token[:30]}...") # Print first 30 chars of token
        return jwt_token, user_id
    except requests.exceptions.RequestException as e:
        print(f"Error during user creation or login: {e}")
        return None, None

def create_categories(jwt_token):
    print("Creating categories...")
    headers = {"Authorization": f"Bearer {jwt_token}", "Content-Type": "application/json"}
    category_names = ["Baby Toys", "Baby Clothes", "Feeding Supplies", "Diapers", "Strollers", "Nursery Decor"]
    created_category_ids = []

    for name in category_names:
        description = f"Essential items for {name.lower()}.";
        category_data = {
            "name": name,
            "description": description
        }
        try:
            response = requests.post(f"{BASE_URL}/category/create", json=category_data, headers=headers)
            if response.status_code == 200:
                print(f"Category '{name}' creation successful: {response.text}")
                time.sleep(0.1) # Small delay to ensure DB transaction commits if needed
            elif response.status_code == 400 and "already exists" in response.text:
                print(f"Category '{name}' already exists.")
            else:
                print(f"Category '{name}' creation failed: {response.status_code} - {response.text}")
        except requests.exceptions.RequestException as e:
            print(f"Error creating category '{name}': {e}")

    # Fetch all categories to get their IDs
    try:
        response = requests.get(f"{BASE_URL}/category/readall", headers=headers)
        response.raise_for_status()
        categories = response.json()
        if categories:
            print("Successfully fetched categories:")
            for cat in categories:
                print(f"  ID: {cat['id']}, Name: {cat['name']}")
                created_category_ids.append(cat['id'])
        else:
            print("No categories found after creation. Product flooding might fail.")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching categories: {e}")

    return created_category_ids

def flood_products(jwt_token, category_ids, num_products=100):
    if not category_ids:
        print("No categories available to associate with products. Aborting product flooding.")
        return

    print(f"\nFlooding database with {num_products} products...")
    headers = {"Authorization": f"Bearer {jwt_token}"} # Content-Type is set by requests for multipart

    for i in range(1, num_products + 1):
        product_name = f"Baby Product {i:04d}"
        description = f"A high-quality and safe baby product for all your needs. This is product number {i}.";
        price = random.randint(1000, 10000) # Prices in cents
        sales = random.randint(0, 500)
        stock = random.randint(10, 1000)
        category_id = random.choice(category_ids)

        product_data = {
            "name": product_name,
            "description": description,
            "price": price,
            "sales": sales,
            "stock": stock,
            "category": {"id": category_id}
        }

        files = {
            'product': (None, json.dumps(product_data), 'application/json')
        }

        try:
            response = requests.post(f"{BASE_URL}/product/create", files=files, headers=headers)
            if response.status_code == 200:
                print(f"Product '{product_name}' created successfully. Response: {response.text}")
            elif response.status_code == 400 and "already exists" in response.text:
                print(f"Product '{product_name}' already exists. Skipping.")
            else:
                print(f"Failed to create product '{product_name}': {response.status_code} - {response.text}")
            time.sleep(0.05) # Small delay to avoid overwhelming the server
        except requests.exceptions.RequestException as e:
            print(f"Network error creating product '{product_name}': {e}")
        except json.JSONDecodeError:
            print(f"Failed to decode JSON from response for product '{product_name}'. Response: {response.text}")

def main():
    user_email = "flood_user@example.com"
    user_password = "verysecurepassword"
    user_name = "Database Flooder"

    jwt_token, user_id = create_and_login_user(user_email, user_password, user_name)

    if jwt_token and user_id:
        category_ids = create_categories(jwt_token)

        if category_ids:
            flood_products(jwt_token, category_ids, num_products=500) # Adjust num_products as needed
        else:
            print("Could not retrieve category IDs. Product flooding cancelled.")
    else:
        print("Failed to get JWT token. Cannot proceed with flooding.")

if __name__ == "__main__":
    main()