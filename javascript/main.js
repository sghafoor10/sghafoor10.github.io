function urlExists(url, callback) {
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function() {
		if (xhr.readyState === 4) {
			callback(xhr.status < 400);
		}   
	};  
	xhr.open("HEAD", url);
	xhr.send();
}

function checkURLs() {
	let collection = document.querySelectorAll("a.bibtexVar");
	collection.forEach((element, index) => {
		let href = element.getAttribute("href");
		if(href != null) {
			url = new URL(href ,"https://localhost:8080/").href;
			urlExists(url, function(exists) {
				if(!exists) {
					let message = document.createElement("span");
					message.classList.add("w3-red");
					message.appendChild(document.createTextNode(" (PDF MISSING)"));
					element.appendChild(message);
				}   
			}); 
		}   
	}); 
}
