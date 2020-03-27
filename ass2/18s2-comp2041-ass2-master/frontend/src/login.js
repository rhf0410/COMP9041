function Show() {
    document.getElementById('login_box').classList.remove('hide');
    document.getElementById('sub_login').classList.remove('hide');
}

function Hide() {
    document.getElementById('login_box').classList.add('hide');
    document.getElementById('sub_login').classList.add('hide');
}

function Reset() {
    document.getElementById("username").value = "";
    document.getElementById("password").value = "";
}

function postData(url, data) {
    return fetch(url, {
        body: JSON.stringify(data),
        cache: 'no-cache',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'content-type': 'application/json'
        },
        method: 'POST',
        mode: 'cors',
        redirect: 'follow',
        referrer: 'np-referrer',
    })
        .then(response=>{
            response.json();
        });
}

function Login() {
    let user = document.getElementById("username").value;
    let pass = document.getElementById("password").value;
    let data = {
        "username": user,
        "password": pass
    };
    postData('http://127.0.0.1:5000/auth/login', data)
        .then(x=>{
            window.localStorage.setItem('AUTH_KEY', x.token);
            window.localStorage.setItem('user', user);
            window.location.href = "success.html";
        });
    Hide();
}