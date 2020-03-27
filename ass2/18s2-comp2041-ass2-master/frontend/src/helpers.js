/* returns an empty array of size max */
export const range = (max) => Array(max).fill(null);

/* returns a randomInteger */
export const randomInteger = (max = 1) => Math.floor(Math.random()*max);

/* returns a randomHexString */
const randomHex = () => randomInteger(256).toString(16);

/* returns a randomColor */
export const randomColor = () => '#'+range(3).map(randomHex).join('');

/**
 * You don't have to use this but it may or may not simplify element creation
 * 
 * @param {string}  tag     The HTML element desired
 * @param {any}     data    Any textContent, data associated with the element
 * @param {object}  options Any further HTML attributes specified
 */
export function createElement(tag, data, options = {}) {
    const el = document.createElement(tag);
    el.textContent = data;
   
    // Sets the attributes in the options object to the element
    return Object.entries(options).reduce(
        (element, [field, value]) => {
            element.setAttribute(field, value);
            return element;
        }, el);
}

/**
 * Given a post, return a tile with the relevant data
 * @param   {object}        post 
 * @returns {HTMLElement}
 */
export function createPostTile(post) {
    const section = createElement('section', null, { class: 'post' });

    section.appendChild(createElement('h2', post.meta.author, { class: 'post-title' }));

    section.appendChild(createElement('img', null, 
        { src: '/images/'+post.src, alt: post.meta.description_text, class: 'post-image' }));

    return section;
}

//Display pictures have been liked.
function likedPicture(id) {
    let token = window.localStorage.getItem('AUTH_KEY');
    fetch('http://127.0.0.1:5000/user', {
        headers:{
            'Authorization': 'Token ' + token
        },
        method:"GET"
    }).then(response=>{
        if(response.ok){
            response.json().then((data) =>{
               var user_id = data.id;
               //Find picture liked by current user.
                fetch('http://127.0.0.1:5000/post?id='+id, {
                    headers:{
                        'Authorization': 'Token ' + token
                    },
                    method:"GET"
                }).then(res=>{
                    res.json().then((data)=>{
                       var likes = data.meta.likes;
                       if(likes.includes(user_id)){
                           document.getElementById(id).src = "/images/liked.jpg";
                       }
                    });
                });
            });
        }
    });
}

export function createNewPostTile(post) {
    const div = createElement('div', null, { class: 'post' });
    let div_html = `<div id="div${post.id}">`
        +`<h2 class="post-title">${post.meta.author}</h2>`
    +`<img src="data:image/png;base64,${post.src}"  alt="${post.meta.description_text}" class="post-image"/>`
    +`</div>`
        +`<img id=${post.id} src="/images/like.png" class="like-image"/>`
    +`<img id="remark${post.id}" src="/images/remark.png" class="remark-image"/>`
    +`<div  id="likes${post.id}" class='likes_style'>`
    +`<img src="/images/liked.jpg" class="liked-image">`
    +`</div>`
    +`<div id="comments${post.id}" class='likes_style'>`
    +`<img src="/images/remark_fill.png" class="liked-image">`
    +`</div>`
    +`<div id="comment${post.id}" class='comment_style'>`
    +`<textarea id="comment_content${post.id}" style="width: 95%"></textarea>`
    +`<input id="submit_comment${post.id}" type="button" value="Submit" style="margin-left: 557px">`
    +`</div>`;
    div.innerHTML = div_html;
    likedPicture(post.id);
    return div;
}

export function createUserPostTile(post) {
    const div = createElement('div', null, { class: 'post' });
    let div_html = `<div id="div${post.id}">`
        +`<h2 class="post-title">${post.meta.author}</h2>`
        +`<img id="image${post.id}" src="data:image/png;base64,${post.src}"  alt="${post.meta.description_text}" class="post-image"/>`
        +`</div>`
        +`<img id=${post.id} src="/images/like.png" class="like-image"/>`
        +`<img id="remark${post.id}" src="/images/remark.png" class="remark-image"/>`
        +`<img id="delete${post.id}" src="/images/delete.png" class="remark-image"/>`
        +`<img id="edit${post.id}" src="/images/edit.png" class="remark-image"/>`
        +`<div  id="likes${post.id}" class='likes_style'>`
        +`<img src="/images/liked.jpg" class="liked-image">`
        +`</div>`
        +`<div id="comments${post.id}" class='likes_style'>`
        +`<img src="/images/remark_fill.png" class="liked-image">`
        +`</div>`
        +`<div id="comment${post.id}" class='comment_style'>`
        +`<textarea id="comment_content${post.id}" style="width: 95%"></textarea>`
        +`<input id="submit_comment${post.id}" type="button" value="Submit" style="margin-left: 557px">`
        +`</div>`;
    div.innerHTML = div_html;
    likedPicture(post.id);
    return div;
}

export function createHomeTile(post) {
    const section = createElement('section', null, { class: 'post' });
    section.appendChild(createElement('h2', post.meta.author, { class: 'post-title' }));

    section.appendChild(createElement('img', null,
        { src: '/images/'+post.src, alt: post.meta.description_text, class: 'post-image' }));

    return section;
}

// Given an input element of type=file, grab the data uploaded for use
export function uploadImage(event) {
    const [ file ] = event.target.files;

    const validFileTypes = [ 'image/jpeg', 'image/png', 'image/jpg' ]
    const valid = validFileTypes.find(type => type === file.type);

    // bad data, let's walk away
    if (!valid)
        return false;
    
    // if we get here we have a valid image
    const reader = new FileReader();
    
    reader.onload = (e) => {
        // do something with the data result
        const dataURL = e.target.result;
        const image = createElement('img', null, { src: dataURL });
        document.body.appendChild(image);
    };

    // this returns a base64 image
    reader.readAsDataURL(file);
}

/* 
    Reminder about localStorage
    window.localStorage.setItem('AUTH_KEY', someKey);
    window.localStorage.getItem('AUTH_KEY');
    localStorage.clear()
*/
export function checkStore(key) {
    if (window.localStorage)
        return window.localStorage.getItem(key)
    else
        return null

}

//Router used for user pages function
function Router(path) {
    this.routes = {};
    this.curURL = "";
    this.route = function (path, callback) {
        this.routes[path] = callback || function () {
            
        };
        console.log('routes[path]' + this.routes[path]);
    };

    this.refresh = function(){
        this.curURL = location.hash.slice(1) || '/';
        this.routes[this.curURL]();
        console.log('location hash: ' + location.hash);
        console.log('curURL: ' + this.curURL);
        console.log('this.routesp[this.curURL]: ' + this.routes[this.curURL]);
    };

    this.init = function () {
        window.addEventListener('load', this.refresh.bind(this), false);
        window.addEventListener('hashchange', this.refresh.bind(this), false);
    }
    var R = new Router();
    R.init();
    var res = document.getElementById("sub-feed");

    R.route(path, function () {
        res.style.background = 'blue';
        res.innerHTML=path;
    });
}