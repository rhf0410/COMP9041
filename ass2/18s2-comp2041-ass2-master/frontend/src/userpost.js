import {createUserPostTile, createElement} from "./helpers.js";

//Change display
function changeDisplay(id, token) {
    fetch('http://127.0.0.1:5000/post?id='+id, {
        headers:{
            'Authorization': 'Token ' + token
        },
        method: 'GET',
    }).then(response=>{
        if(response.ok){
            response.json().then((data)=>{
                var arr = data.meta.likes;
                var n = arr.length;
                let url = "http://127.0.0.1:5000/user?id=";
                let inHtml = `<img src="/images/liked.jpg" class="liked-image">`;
                let likes_id = "likes" + id;
                let subdiv = document.getElementById(likes_id);
                for(let i=0;i<n;i++){
                    let newurl = url + arr[i];
                    let token = window.localStorage.getItem('AUTH_KEY');
                    fetch(newurl, {
                        headers:{
                            'Accept': 'application/json',
                            'content-type': 'application/json',
                            'Authorization': 'Token ' + token
                        },
                        method: 'GET'
                    })
                        .then(response=>{
                            if(response.ok){
                                response.json().then((data) =>{
                                    inHtml += `<label> ${data.username}</label>`;
                                    subdiv.innerHTML = inHtml;
                                })
                            }
                        });
                }
            });
        }
    });
}

//Change comment
function changeComment(id, token){
    fetch('http://127.0.0.1:5000/post?id='+id, {
        headers:{
            'Authorization': 'Token ' + token
        },
        method: 'GET',
    }).then(response=>{
        if(response.ok){
            response.json().then((data)=>{
                var arr = data.comments;
                if(arr.length != 0){
                    let inHtml = `<img src="/images/remark_fill.png" class="liked-image">`;
                    let subdiv = document.getElementById("comments"+id);
                    subdiv.style.display = "block";
                    for(var i=0;i<arr.length;i++){
                        let author = arr[i].author;
                        let content = arr[i].comment;
                        let timestamp = arr[i].published;
                        let time = new Date(timestamp * 1000);
                        let time_div = createElement('div', time.toDateString());
                        let comment = author + " : " + content;
                        inHtml += `<br><label> ${comment}</label>`;
                        inHtml += `<div style="float: right">${time_div.innerHTML}</div>`;
                    }
                    subdiv.innerHTML = inHtml;
                    document.getElementById("remark"+id).src = "/images/remark.png";
                    document.getElementById("comment_content"+id).value="";
                    document.getElementById("comment"+id).style.display="none";
                }
            });
        }
    });
}

//Succeed in liking the picture.
function likedit(id, token){
    fetch('http://127.0.0.1:5000/post/like?id='+id, {
        headers:{
            'Authorization': 'Token ' + token
        },
        method: 'PUT',
    }).then(response=>{
        if(response.ok){
            changeDisplay(id, token);
        }else{
            window.alert("Fail to like this picture.");
        }
    });
}

//Unbind the like from the picture.
function unbindLike(id, token) {
    fetch('http://127.0.0.1:5000/post/unlike?id='+id, {
        headers:{
            'Authorization': 'Token ' + token
        },
        method: 'PUT',
    }).then(response=>{
        if(response.ok){
            changeDisplay(id, token);
        }else{
            window.alert("Fail to unlike this picture.");
        }
    });
}

//Like a picture.
function likeit(post, token){
    let id = post.id;
    document.getElementById(id).addEventListener('click', e=>{
        if(document.getElementById(id).src.endsWith("like.png")){
            document.getElementById(id).src = "/images/liked.jpg";
            likedit(id, token);
        }else{
            document.getElementById(id).src = "/images/like.png";
            unbindLike(id, token);
        }
    });
}

//Post comment
function postComment(id, text) {
    let token = window.localStorage.getItem('AUTH_KEY');
    let author = window.localStorage.getItem("user");
    let timestamp = new Date().getTime() / 1000;
    let data={
        "author": author,
        "published": timestamp,
        "comment": text
    };
    fetch('http://127.0.0.1:5000/post/comment?id='+id, {
        body: JSON.stringify(data),
        headers:{
            'Accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: 'PUT',
    }).then(response=>{
        if(response.ok){
            changeComment(id, token);
        }
    });
}

//Comment the picture and put comment to server.
function commentContent(post) {
    let id = post.id;
    let submit = "submit_comment"+id;
    let content = "comment_content"+id;
    document.getElementById(submit).addEventListener('click', e=>{
        let text = document.getElementById(content).value;
        //Post comment to the server.
        postComment(id, text);
    });
}

//Comment a picture.
function comment(post){
    let id = post.id;
    document.getElementById("remark"+id).addEventListener('click', e=>{
        if(document.getElementById("remark"+id).src.endsWith("images/remark.png")){
            document.getElementById("remark"+id).src = "/images/remark_fill.png";
            document.getElementById("comment"+id).style.display="block";
        }else{
            document.getElementById("remark"+id).src = "/images/remark.png";
            document.getElementById("comment"+id).style.display="none";
        }
    });
}

//Show likes of the picture.
function showLikes(post) {
    let id = post.id;
    var arr = post.meta.likes;
    let n = arr.length;
    if(n != 0){
        let url = "http://127.0.0.1:5000/user?id=";
        let inHtml = `<img src="/images/liked.jpg" class="liked-image">`;
        let likes_id = "likes" + id;
        let subdiv = document.getElementById(likes_id);
        subdiv.style.display = "block";
        for(let i=0;i<n;i++){
            let newurl = url + arr[i];
            let token = window.localStorage.getItem('AUTH_KEY');
            fetch(newurl, {
                headers:{
                    'Accept': 'application/json',
                    'content-type': 'application/json',
                    'Authorization': 'Token ' + token
                },
                method: 'GET'
            })
                .then(response=>{
                    if(response.ok){
                        response.json().then((data) =>{
                            inHtml += `<label> ${data.username}</label>`;
                            subdiv.innerHTML = inHtml;
                        })
                    }
                });
        }
    }
}

//Display comments.
function showComments(post) {
    let id = post.id;
    var arr = post.comments;
    let n = arr.length;
    if(n != 0){
        let inHtml = `<img src="/images/remark_fill.png" class="liked-image">`;
        let subdiv = document.getElementById("comments"+id);
        subdiv.style.display = "block";
        for(let i=0;i<n;i++){
            let author = arr[i].author;
            let content = arr[i].comment;
            let timestamp = arr[i].published;
            let time = new Date(timestamp * 1000);
            let time_div = createElement('div', time.toDateString());
            let comment = author + " : " + content;
            inHtml += `<br><label> ${comment}</label>`;
            inHtml += `<div style="float: right">${time_div.innerHTML}</div>`;
        }
        subdiv.innerHTML = inHtml;
    }
}

//Delete post
function deletePost(post, token) {
    let id = post.id;
    document.getElementById("delete"+id).addEventListener('click', e=>{
        fetch('http://127.0.0.1:5000/post?id='+id, {
            headers:{
                'Accept': 'application/json',
                'content-type': 'application/json',
                'Authorization': 'Token ' + token
            },
            method: 'DELETE',
        }).then(response=>{
            if(response.ok){
                window.alert("Succeed in deleting post.");
                var node = document.getElementById(id).parentNode;
                node.parentNode.removeChild(node);
            }
        });
    });
}

//Update post
function updatePost(post, token){
    let id = post.id;
    document.getElementById("edit"+id).addEventListener('click', e=>{
        document.getElementById("post_box").classList.remove('hide');
        document.getElementById("sub_post").classList.remove('hide');
        window.localStorage.setItem('post_id', id);
    });
}

//Upload picture
function uploadPicture(id, token, parent){
    fetch('http://127.0.0.1:5000/post?id='+id, {
        headers:{
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: 'GET',
    }).then(response=>{
        if(response.ok){
            response.json().then((data)=>{
                let div = createUserPostTile(data);
                window.localStorage.setItem(data.id, div);
                parent.appendChild(div);
                likeit(data, token);
                showLikes(data);
                //Display comment
                showComments(data);
                //Comment
                comment(data, token);
                commentContent(data);
                //Delete post
                deletePost(data, token);
                //Update post
                updatePost(data, token);
            });
        }
    });
}

let token = window.localStorage.getItem('AUTH_KEY');
let username = window.localStorage.getItem('user');

document.getElementById("user_name").innerHTML = username;
fetch('http://127.0.0.1:5000/user?username='+username, {
    headers:{
        'Content-Type': 'application/json',
        'Authorization': 'Token ' + token
    },
    method: 'GET',
}).then(res => res.json())
    .then(posts => {
        posts.posts.reduce((parent, post) => {
            let id = post;
            uploadPicture(id, token, parent);
            return parent;
        }, document.getElementById('user-post-feed'))
    });