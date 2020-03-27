//Get following list.
let token = window.localStorage.getItem('AUTH_KEY');
let username = window.localStorage.getItem("user");
fetch('http://127.0.0.1:5000/user?username='+username, {
    headers:{
        'Authorization': 'Token ' + token
    },
    method: 'GET'
}).then(response=>{
    if(response.ok){
        response.json().then((data)=>{
            let arr = data.following;
            for(var i=0;i<arr.length;i++){
                fetch('http://127.0.0.1:5000/user?id='+arr[i], {
                    headers:{
                        'Authorization': 'Token ' + token
                    },
                    method: 'GET'
                }).then(res=>{
                    if(res.ok){
                        res.json().then((data)=>{
                            let username = data.name;
                            username += " ";
                            document.getElementById("follow_list").innerHTML += username;
                        });
                    }
                });
            }
        });
    }
});