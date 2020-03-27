const url = 'https://picsum.photos/200/300/?random';
const loadingNode = document.querySelector('#loading');
let divs = [];
let test
function loadMorePic() {
    'use strict';

    let imgs = document.querySelectorAll('#output .img-post');
    if(imgs.length != 0)
        for (let i = 0; i < imgs.length ; i++){
            console.log(imgs[i]);
            test = imgs[i];
            imgs[i].parentNode.removeChild(imgs[i]);
        }

    loadingNode.style.display = 'block';
    divs = [];
    let promises = [];
    for(let i in [1,2,3,4,5]){
        promises.push(fetch(url));
    }


    Promise.all(promises).then(res=>{
        loadingNode.style.display = 'none';
        for(let i in [0,1,2,3,4]){
            let newUrl = res[i].url;
            console.log(url);
            let date = new Date()
            let div = document.createElement('div');
            div.className = 'img-post';
            let img = document.createElement('img');
            img.src = newUrl;
            let p = document.createElement('p');
            p.innerText = 'Fetched at ' + date.getHours() + ':' + date.getMinutes();
            div.appendChild(img);
            div.appendChild(p);
            divs.push(div);

        }

        let outputNode = document.querySelector('#output');
        for(let i in [0,1,2,3,4]) {
            outputNode.appendChild(divs[i]);
        }
    })


}


document.querySelector('#more').addEventListener('click',loadMorePic);

