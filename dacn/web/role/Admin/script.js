document.getElementById('login-form').addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!email || !password) {
        return alert('Please enter both email and password!');
    }

    try {
        const response = await fetch('http://192.168.1.7:8080/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password }),
        });

        if (!response.ok) {
            const errorData = await response.json();
            return alert(errorData.message || 'Đăng nhập thất bại!'); 
        }

        const data = await response.json();
        localStorage.setItem('loggedIn', 'true');
        localStorage.setItem('authToken', data.token);

        if (data.user.role === 'admin') {
            alert('Đăng nhập thành công!');
            document.getElementById('login-container').style.display = 'none';
            document.getElementById('head-table').style.display = 'block';

        } else {
            alert('Không đủ quyền truy cập!');
        }
    } catch (error) {
        console.error('Error during login:', error);
        alert('An error occurred. Please try again later.');
    }
});

document.addEventListener("DOMContentLoaded", () => {
    const userTableBody = document.querySelector(".user-table tbody");
    
    async function fetchUsers() {
        const userToken = localStorage.getItem('authToken');

        if (!userToken) {
            alert('You are not logged in. Please log in again.');
            window.location.href = "http://127.0.0.1:5500/dacn/web/role/Login/Login_Role.html";
            return;
        }

        try {
            const response = await fetch('http://192.168.1.7:8080/api/users', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${userToken}`,
                },
            });

            if (!response.ok) {
                throw new Error('Error fetching users: ' + response.statusText);
            }

            const responseData = await response.json();
            renderUsers(responseData.data);
        } catch (error) {
            console.error('Fetch error:', error);
            alert('Could not fetch users. Please try again later.');
        }
    }

    function renderUsers(users) {
        userTableBody.innerHTML = ''; 
        if (users.length === 0) {
            userTableBody.innerHTML = '<tr><td colspan="5">No users found.</td></tr>';
            return;
        }
        users.forEach((user, index) => {
            const newRow = document.createElement("tr");
            newRow.innerHTML = `
                <td>${index + 1}</td>
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td>${user.role}</td>
                <td>
                    <button class="delete-btn" data-id="${user._id}">Delete</button>
                </td>
            `;
            userTableBody.appendChild(newRow);
        });
    }

    fetchUsers();

    userTableBody.addEventListener("click", async (event) => {
        const userId = event.target.dataset.id;

        if (event.target.classList.contains("delete-btn")) {
            if (confirm("Are you sure you want to delete this user?")) {
                await deleteUser(userId);
            }
        }
    });

    async function deleteUser(userId) {
        const userToken = localStorage.getItem('authToken');
        try {
            const response = await fetch(`http://192.168.1.7:8080/api/users/${userId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${userToken}`,
                },
            });

            if (!response.ok) {
                throw new Error('Error deleting user: ' + response.statusText);
            }

            fetchUsers();
        } catch (error) {
            console.error('Delete error:', error);
            alert('Could not delete user. Please try again later.');
        }
    }
});
