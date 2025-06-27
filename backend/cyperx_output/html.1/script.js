const BASE_URL = 'http://localhost:8080';

// --- Utility Functions ---
function getHeaders(token = null) {
    const headers = {
        'Content-Type': 'application/json'
    };
    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
}

async function handleResponse(response) {
    if (response.ok) {
        try {
            const data = await response.json();
            return { success: true, data: data };
        } catch (error) {
            // Some successful responses might not have JSON (e.g., plain text success messages)
            const text = await response.text();
            return { success: true, message: text };
        }
    } else {
        try {
            const errorData = await response.json();
            return { success: false, message: errorData.message || 'An error occurred' };
        } catch (error) {
            const text = await response.text();
            return { success: false, message: text || 'An error occurred' };
        }
    }
}

// --- Authentication Functions ---
async function loginUser(email, password) {
    const response = await fetch(`${BASE_URL}/auth/signin`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify({ email, password })
    });
    const result = await handleResponse(response);
    if (result.success) {
        localStorage.setItem('jwtToken', result.data.accessToken);
        localStorage.setItem('userId', result.data.id);
        localStorage.setItem('userName', result.data.name);
    }
    return result;
}

async function registerUser(name, email, password) {
    const response = await fetch(`${BASE_URL}/user/create`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify({ name, email, password })
    });
    return await handleResponse(response);
}

function logout() {
    localStorage.removeItem('jwtToken');
    localStorage.removeItem('userId');
    localStorage.removeItem('userName');
    window.location.href = 'index.html'; // Redirect to home after logout
}

function updateAuthLinks() {
    const token = localStorage.getItem('jwtToken');
    const userName = localStorage.getItem('userName');
    const authLinks = document.getElementById('auth-links');
    const userGreeting = document.getElementById('user-greeting');
    const userNameSpan = document.getElementById('user-name');
    const logoutBtn = document.getElementById('logout-btn');

    if (token && userName) {
        authLinks.style.display = 'none';
        userGreeting.style.display = 'block';
        userNameSpan.textContent = userName;
        logoutBtn.addEventListener('click', logout);
    } else {
        authLinks.style.display = 'block';
        userGreeting.style.display = 'none';
    }
}

// --- Product Functions ---
async function getAllProducts(token) {
    const response = await fetch(`${BASE_URL}/product/readall`, {
        method: 'GET',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function getProductById(id, token) {
    const response = await fetch(`${BASE_URL}/product/read/${id}`, {
        method: 'GET',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function loadProducts(containerElement) {
    containerElement.innerHTML = '<p>Loading products...</p>';
    const token = localStorage.getItem('jwtToken'); // Products can be read without auth, but better to use if available
    const productsResponse = await getAllProducts(token);

    if (productsResponse.success) {
        const products = productsResponse.data;
        if (products.length > 0) {
            containerElement.innerHTML = ''; // Clear loading message
            products.forEach(product => {
                const productCard = document.createElement('div');
                productCard.classList.add('product-card');
                productCard.innerHTML = `
                    <img src="${product.image ? BASE_URL + '/' + product.image : 'placeholder.png'}" alt="${product.name}">
                    <h3><a href="product-detail.html?id=${product.id}">${product.name}</a></h3>
                    <p>${product.description.substring(0, 70)}...</p>
                    <p><strong>$${product.price}</strong></p>
                    <p>Rating: ${product.averageRating ? product.averageRating.toFixed(1) : '0.0'}/5</p>
                    <button class="add-to-cart-btn" data-product-id="${product.id}">Add to Cart</button>
                `;
                containerElement.appendChild(productCard);
            });

            document.querySelectorAll('.add-to-cart-btn').forEach(button => {
                button.addEventListener('click', async (e) => {
                    const productId = e.target.dataset.productId;
                    const quantity = 1; // Default to adding 1 item
                    const token = localStorage.getItem('jwtToken');
                    const userId = localStorage.getItem('userId');

                    if (!token || !userId) {
                        alert('Please login to add items to cart.');
                        return;
                    }

                    const response = await addProductToCart(userId, productId, quantity, token);
                    if (response.success) {
                        alert('Product added to cart!');
                    } else {
                        alert(`Failed to add to cart: ${response.message}`);
                    }
                });
            });

        } else {
            containerElement.innerHTML = '<p>No products available.</p>';
        }
    } else {
        containerElement.innerHTML = `<p>Error loading products: ${productsResponse.message}</p>`;
    }
}

// --- Category Functions ---
async function getAllCategories(token) {
    const response = await fetch(`${BASE_URL}/category/readall`, {
        method: 'GET',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function loadCategories() {
    const categoryListContainer = document.getElementById('category-list-container');
    categoryListContainer.innerHTML = '<p>Loading categories...</p>';
    const token = localStorage.getItem('jwtToken'); // Categories can be read without auth
    const categoriesResponse = await getAllCategories(token);

    if (categoriesResponse.success) {
        const categories = categoriesResponse.data;
        if (categories.length > 0) {
            categoryListContainer.innerHTML = ''; // Clear loading message
            categories.forEach(category => {
                const categoryCard = document.createElement('div');
                categoryCard.classList.add('category-card');
                categoryCard.innerHTML = `
                    <h3>${category.name}</h3>
                    <p>Products: ${category.productsIdList ? category.productsIdList.length : 0}</p>
                    <a href="products.html?category=${category.id}">View Products</a>
                `;
                categoryListContainer.appendChild(categoryCard);
            });
        } else {
            categoryListContainer.innerHTML = '<p>No categories available.</p>';
        }
    } else {
        categoryListContainer.innerHTML = `<p>Error loading categories: ${categoriesResponse.message}</p>`;
    }
}

// --- Cart Functions ---
async function getCart(userId, token) {
    const response = await fetch(`${BASE_URL}/cart/${userId}`, {
        method: 'GET',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function addProductToCart(userId, productId, quantity, token) {
    const response = await fetch(`${BASE_URL}/cart/add/${userId}/${productId}/${quantity}`, {
        method: 'POST',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function updateProductQuantityInCart(userId, productId, newQuantity, token) {
    const response = await fetch(`${BASE_URL}/cart/update/${userId}/${productId}/${newQuantity}`, {
        method: 'PUT',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function removeProductFromCart(userId, productId, token) {
    const response = await fetch(`${BASE_URL}/cart/remove/${userId}/${productId}`, {
        method: 'DELETE',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

async function clearUserCart(userId, token) {
    const response = await fetch(`${BASE_URL}/cart/clear/${userId}`, {
        method: 'DELETE',
        headers: getHeaders(token)
    });
    return await handleResponse(response);
}

// --- Review Functions (for Product Detail page) ---
async function createReview(reviewDto, token) {
    const response = await fetch(`${BASE_URL}/reviews/create`, {
        method: 'POST',
        headers: getHeaders(token),
        body: JSON.stringify(reviewDto)
    });
    return await handleResponse(response);
}
