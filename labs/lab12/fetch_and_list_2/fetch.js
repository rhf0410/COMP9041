
const outputNode = document.querySelector('#output');

function addUserDom(username, company, id){
    let div = document.createElement('div');
    div.id = id;
    div.className = 'user';
    let h2 = document.createElement('h2');
    h2.innerText = username;
    let p = document.createElement('p');
    p.innerText = company;
    div.appendChild(h2);
    div.appendChild(p);
    outputNode.appendChild(div);
}

function addPost(id, posts) {
    let ul = document.createElement('ul');
    ul.className = 'posts';
    for(let i in posts){
        let li = document.createElement('li');
        li.className = 'post';
        li.innerText = posts[i];
        ul.appendChild(li)
    }
    console.log(ul);
    document.querySelector('#'+id).appendChild(ul);
}

(function () {
    'use strict';
    const pr =  fetch('https://jsonplaceholder.typicode.com/users');
    pr.then((res)=>{
        return res.json();
    })
        .then((r)=>{
            const posts = []
            for(let i in r){
                let id=r[i]['id'];
                let username = r[i]['name'];
                let company = r[i]['company']['catchPhrase'];
                fetch("https://jsonplaceholder.typicode.com/posts?userId="+id)
                    .then((resp)=>{return(resp.json())})
                    .then((respjson)=>{
                        let posts=[]
                        for(let ii in respjson){
                            posts.push(respjson[ii]['title']);
                        }

                        console.log(posts);
                        addUserDom(username,company,'user-'+id);
                        addPost('user-'+id,posts);

                    })

            }

        });
}());


