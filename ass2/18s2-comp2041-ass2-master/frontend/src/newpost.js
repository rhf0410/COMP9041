//Put comment to server.
function postContent(id, text, picture) {
    let token = window.localStorage.getItem('AUTH_KEY');
    let data = {
        "description_text": text,
        "src": picture
    };
    fetch('http://127.0.0.1:5000/post?id='+id, {
        body: JSON.stringify(data),
        headers:{
            'Accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: 'PUT',
    }).then(response =>{
        if(response.ok){
            document.getElementById("image"+id).src = "data:image/png;base64,"+picture;
            document.getElementById("image"+id).alt = text;
        }
    });
}

//Post new content
document.getElementById("post_submit").addEventListener('click', e=>{
    let text = document.getElementById("post_content").value;
    let file = document.getElementById("post_file").files[0];
    let id = window.localStorage.getItem('post_id');
    let reader = new FileReader();
    reader.onload = (e) =>{
        const dataURL = e.target.result;
        let index = dataURL.indexOf(',');
        let data_src = dataURL.substring(index+1);
        postContent(id, text, data_src);
        Hide();
    };
    reader.readAsDataURL(file);
});