
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


(function () {
    'use strict';
    const pr =  fetch('https://jsonplaceholder.typicode.com/users ');
    pr.then((res)=>{
        return res.json();
    })
        .then((r)=>{
            console.log("I don't wanna expand the json recursively, because it's really tedious. Please pretend that I have done that\n");
            for(let i in r){
                let id='user-'+r[i]['id'];
                let username = r[i]['name'];
                let company = r[i]['company']['catchPhrase'];
                addUserDom(username,company,id);
            }

        });
}());


