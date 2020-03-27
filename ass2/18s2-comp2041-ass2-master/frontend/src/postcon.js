//Put comment to server.
function postContent(text, picture) {
    let token = window.localStorage.getItem('AUTH_KEY');
    let data = {
        "description_text": text,
        "src": picture
    };
    fetch('http://127.0.0.1:5000/post', {
        body: JSON.stringify(data),
        cache: 'no-cache',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: 'POST',
        mode: 'cors',
        redirect: 'follow',
        referrer: 'np-referrer',
    }).then(response =>{
        if(response.ok){
            window.alert("Succeed in posting.");
        }else{
            window.alert("Fail to comment.");
        }
    });
}

//Post new content
document.getElementById("post_submit").addEventListener('click', e=>{
    let text = document.getElementById("post_content").value;
    let file = document.getElementById("post_file").files[0];
    let reader = new FileReader();
    reader.onload = (e) =>{
        const dataURL = e.target.result;
        let index = dataURL.indexOf(',');
        let data_src = dataURL.substring(index+1);
        postContent(text, data_src);
        Hide();
    };
    reader.readAsDataURL(file);
});