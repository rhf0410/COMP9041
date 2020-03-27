const planetIndex = {
    "Saturn": 0,
    "Earth": 1,
    "Jupiter": 2,
    "Mercury": 3,
    "Uranus": 4,
    "Venus": 5,
    "Mars": 6,
    "Neptune": 7
}
function newLi(title,content,node){
    let li = document.createElement('li');
    li.innerHTML='<b>'+title+'</b>'+'"' +content+ '"';
    node.appendChild(li);
}
function switchTab(e) {
    let current = document.querySelector('.active') //.classList.remove('active');
    e = e || window.event;
    let target = e.target || e.srcElement;
    if (target.tagName != 'A' || current.id == target.id)
        return;

    current.classList.remove('active');
    target.classList.add("active");

    let planetName = target.innerText;
    let index = planetIndex[planetName];
    let url = window.location.href + 'planets.json'
    console.log(url)
    fetch(url)
        .then((res) => res.json())
        .then((json) => {
            let planet = json[index];
            document.querySelector('#information h2').innerText = planet['name'];
            document.querySelector('#information p').innerText = planet['details'];
            let node = document.querySelector('#information ul');
            node.innerHTML = '';
            for(let key in json[index]['summary']){
                console.log(key);
                console.log(json[index]['summary'][key]);
                newLi(key,json[index]['summary'][key], node );
            }
        });
}

let test = document.querySelector('.nav').addEventListener('click', switchTab)




