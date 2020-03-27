function Show_register() {
    document.getElementById('register_box').classList.remove('hide');
    document.getElementById('sub_register').classList.remove('hide');
}

function Hide_register() {
    document.getElementById('register_box').classList.add('hide');
    document.getElementById('sub_register').classList.add('hide');
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
        .then(response=>response.json())
}

function Registration(){
    let user = document.getElementById("registerusername").value;
    let pass = document.getElementById("registerpass").value;
    let email = document.getElementById("registeremail").value;
    let name = document.getElementById("registername").value;

    let data = {
        "username": user,
        "password": pass,
        "email": email,
        "name": name
    };
    postData('http://127.0.0.1:5000/auth/signup', data)
        .then(x=>{
            window.localStorage.setItem('AUTH_KEY', x.token);
        });
    Hide_register();
}