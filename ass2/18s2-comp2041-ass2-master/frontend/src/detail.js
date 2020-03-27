function update() {
    document.getElementById('update_box').classList.remove('hide');
    document.getElementById('sub_update').classList.remove('hide');
}

function Hide() {
    document.getElementById('update_box').classList.add('hide');
    document.getElementById('sub_update').classList.add('hide');
}

let username = window.localStorage.getItem("user");
document.getElementById("user_title").innerHTML = username;

let token = window.localStorage.getItem('AUTH_KEY');
var sum = 0;
//Get likes number of all the posts.
function getLikes(arr){
    for(let i=0;i<arr.length;i++){
        fetch('http://127.0.0.1:5000/post?id='+arr[i], {
            headers:{
                'Authorization': 'Token ' + token
            },
            method: 'GET'
        }).then(response=>{
            if(response.ok){
                response.json().then((data)=>{
                    let subarr = data.meta.likes;
                    sum += subarr.length;
                    document.getElementById("likes").innerHTML = sum;
                });
            }
        });
    }
}

//Collect personal information.
fetch('http://127.0.0.1:5000/user', {
    headers:{
        'Authorization': 'Token ' + token
    },
    method: 'GET'
}).then(response=>{
    response.json().then((data)=>{
        document.getElementById("username").innerHTML = data.username;
        document.getElementById("upd_name").value = data.username;
        let arrs = data.posts;
        let len = arrs.length;
        document.getElementById("num_of_posts").innerHTML = len;
        getLikes(arrs);
        document.getElementById("email").innerHTML = data.email;
        document.getElementById("upd_email").value = data.email;
        document.getElementById("followed").innerHTML = data.followed_num;
        document.getElementById("following").innerHTML = data.following.length;
    });
});

//Update user information
document.getElementById("up_button").addEventListener('click', e=>{
    let token = window.localStorage.getItem('AUTH_KEY');
    let username = document.getElementById("upd_name").value;
    let email = document.getElementById("upd_email").value;
    let data = {
        "name": username,
        "email": email
    };
    fetch('http://127.0.0.1:5000/user', {
        body: JSON.stringify(data),
        headers:{
            'Accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method:'PUT'
    }).then(response=>{
        if(response.ok){
            window.alert("Succeed in updating.");
            document.getElementById("username").innerHTML = username;
            document.getElementById("email").innerHTML = email;
            document.getElementById('update_box').classList.add('hide');
            document.getElementById('sub_update').classList.add('hide');
        }
    });
});

//Modify password
document.getElementById("up_password").addEventListener('click', e=>{
    let token = window.localStorage.getItem('AUTH_KEY');
    let pass = document.getElementById("mPassword").value;
    let apass = document.getElementById("aPassword").value;
    if(pass != apass){
        document.getElementById('password_box').classList.add('hide');
        document.getElementById('sub_password').classList.add('hide');
        window.alert("Password is not accord.");
    }else{
        let data = {
            "password": pass
        };
        fetch('http://127.0.0.1:5000/user', {
            body: JSON.stringify(data),
            headers:{
                'Accept': 'application/json',
                'content-type': 'application/json',
                'Authorization': 'Token ' + token
            },
            method:'PUT'
        }).then(response=>{
            if(response.ok){
                window.alert("Succeed in modifying password.");
                document.getElementById('password_box').classList.add('hide');
                document.getElementById('sub_password').classList.add('hide');
            }
        });
    }
    document.getElementById("mPassword").value = "";
    document.getElementById("aPassword").value= "";
});